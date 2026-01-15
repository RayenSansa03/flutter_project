import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_event.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  String? _currentImageUrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Charger le profil au démarrage avec un petit délai pour s'assurer que le contexte est prêt
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<AuthBloc>().add(const GetProfileEvent());
      }
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        if (!mounted) return;
        setState(() {
          _selectedImage = File(image.path);
        });
        // Upload immédiatement l'image
        if (!mounted) return;
        context.read<AuthBloc>().add(
              UploadProfileImageEvent(imagePath: image.path),
            );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la sélection de l\'image: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _updateProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            UpdateProfileEvent(
              firstName: _firstNameController.text.trim().isEmpty
                  ? null
                  : _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim().isEmpty
                  ? null
                  : _lastNameController.text.trim(),
            ),
          );
      // Ne pas désactiver l'édition ici, attendre la réponse du serveur
    }
  }

  void _cancelEdit() {
    setState(() {
      _isEditing = false;
    });
    // Recharger les données originales
    context.read<AuthBloc>().add(const GetProfileEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A2B4C)),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Profil',
          style: TextStyle(
            color: Color(0xFF1A2B4C),
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_isEditing)
            TextButton(
              onPressed: _cancelEdit,
              child: const Text(
                'Annuler',
                style: TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 16,
                ),
              ),
            )
          else
            TextButton(
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
              child: const Text(
                'Modifier',
                style: TextStyle(
                  color: Color(0xFF4A90E2),
                  fontSize: 16,
                ),
              ),
            ),
        ],
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Mettre à jour les champs avec les données utilisateur
            final wasEditing = _isEditing;
            
            // Toujours mettre à jour les champs si on n'est pas en mode édition
            // ou si c'est la première fois qu'on charge les données
            if (!_isEditing || _firstNameController.text.isEmpty) {
              _firstNameController.text = state.user.firstName ?? '';
              _lastNameController.text = state.user.lastName ?? '';
            }
            _currentImageUrl = state.user.image;
            _selectedImage = null; // Réinitialiser après upload réussi
            
            // Afficher un message de succès seulement après une action (pas au chargement initial)
            if (wasEditing) {
              setState(() {
                _isEditing = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profil mis à jour avec succès'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is AuthUnauthenticated) {
            context.go('/login');
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final user = state is AuthAuthenticated ? state.user : null;

          // Les champs sont mis à jour dans le listener BlocConsumer
          // Pas besoin de les initialiser ici pour éviter les conflits

          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 24),
                // Section Photo de profil
                _buildProfileImageSection(user),
                const SizedBox(height: 32),
                // Section Informations personnelles
                _buildPersonalInfoSection(user, isLoading),
                const SizedBox(height: 16),
                // Section Compte
                _buildAccountSection(user),
                const SizedBox(height: 16),
                // Section Actions
                _buildActionsSection(isLoading),
                const SizedBox(height: 16),
                // Section Déconnexion
                _buildLogoutSection(isLoading),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileImageSection(dynamic user) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isEditing ? _pickImage : () {
            // Afficher un message pour indiquer qu'il faut activer le mode édition
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Appuyez sur "Modifier" pour changer la photo'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4A90E2),
                      const Color(0xFF4A90E2).withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: _selectedImage != null
                      ? Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                        )
                      : _currentImageUrl != null
                          ? Image.network(
                              _currentImageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar();
                              },
                            )
                          : _buildDefaultAvatar(),
                ),
              ),
              if (_isEditing)
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90E2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        if (_isEditing)
          Text(
            'Appuyez pour changer la photo',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
      ],
    );
  }

  Widget _buildPersonalInfoSection(dynamic user, bool isLoading) {
    return _buildIOSSection(
      children: [
        if (_isEditing) ...[
          _buildIOSListTile(
            leading: Icons.person_outline,
            title: 'Prénom',
            child: TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Votre prénom',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A2B4C),
              ),
            ),
          ),
          _buildIOSDivider(),
          _buildIOSListTile(
            leading: Icons.person_outline,
            title: 'Nom',
            child: TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: 'Votre nom',
                hintStyle: TextStyle(color: Colors.grey),
              ),
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF1A2B4C),
              ),
            ),
          ),
        ] else ...[
          _buildIOSListTile(
            leading: Icons.person_outline,
            title: 'Prénom',
            trailing: Text(
              user?.firstName ?? 'Non renseigné',
              style: TextStyle(
                fontSize: 16,
                color: user?.firstName != null
                    ? const Color(0xFF1A2B4C)
                    : Colors.grey[400],
              ),
            ),
          ),
          _buildIOSDivider(),
          _buildIOSListTile(
            leading: Icons.person_outline,
            title: 'Nom',
            trailing: Text(
              user?.lastName ?? 'Non renseigné',
              style: TextStyle(
                fontSize: 16,
                color: user?.lastName != null
                    ? const Color(0xFF1A2B4C)
                    : Colors.grey[400],
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAccountSection(dynamic user) {
    return _buildIOSSection(
      children: [
        _buildIOSListTile(
          leading: Icons.email_outlined,
          title: 'Email',
          trailing: Text(
            user?.email ?? '',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
        _buildIOSDivider(),
        _buildIOSListTile(
          leading: Icons.calendar_today_outlined,
          title: 'Membre depuis',
          trailing: Text(
            user?.createdAt != null
                ? '${user!.createdAt.day}/${user.createdAt.month}/${user.createdAt.year}'
                : 'N/A',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
        _buildIOSDivider(),
        _buildIOSListTile(
          leading: Icons.update_outlined,
          title: 'Dernière mise à jour',
          trailing: Text(
            user?.updatedAt != null
                ? '${user!.updatedAt.day}/${user.updatedAt.month}/${user.updatedAt.year}'
                : 'N/A',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionsSection(bool isLoading) {
    return _buildIOSSection(
      children: [
        if (_isEditing)
          _buildIOSListTile(
            leading: Icons.save_outlined,
            title: 'Enregistrer les modifications',
            titleColor: const Color(0xFF4A90E2),
            onTap: isLoading ? null : _updateProfile,
            trailing: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4A90E2)),
                    ),
                  )
                : const Icon(
                    Icons.chevron_right,
                    color: Colors.grey,
                  ),
          )
        else
          _buildIOSListTile(
            leading: Icons.settings_outlined,
            title: 'Paramètres',
            onTap: () {
              // TODO: Naviguer vers les paramètres
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Paramètres - À venir')),
              );
            },
            trailing: const Icon(
              Icons.chevron_right,
              color: Colors.grey,
            ),
          ),
        _buildIOSDivider(),
        _buildIOSListTile(
          leading: Icons.help_outline,
          title: 'Aide et support',
          onTap: () {
            // TODO: Naviguer vers l'aide
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Aide - À venir')),
            );
          },
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ),
        _buildIOSDivider(),
        _buildIOSListTile(
          leading: Icons.info_outline,
          title: 'À propos',
          onTap: () {
            // TODO: Naviguer vers À propos
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('À propos - À venir')),
            );
          },
          trailing: const Icon(
            Icons.chevron_right,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(bool isLoading) {
    return _buildIOSSection(
      children: [
        _buildIOSListTile(
          leading: Icons.logout,
          title: 'Déconnexion',
          titleColor: Colors.red,
          onTap: isLoading
              ? null
              : () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Déconnexion'),
                      content: const Text(
                        'Êtes-vous sûr de vouloir vous déconnecter ?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Annuler'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<AuthBloc>().add(const LogoutEvent());
                          },
                          child: const Text(
                            'Déconnexion',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  );
                },
        ),
      ],
    );
  }

  Widget _buildIOSSection({required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: children,
      ),
    );
  }

  Widget _buildIOSListTile({
    required IconData leading,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
    Color? titleColor,
    Widget? child,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(
              leading,
              color: const Color(0xFF4A90E2),
              size: 22,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: child ??
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      color: titleColor ?? const Color(0xFF1A2B4C),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 12),
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIOSDivider() {
    return Padding(
      padding: const EdgeInsets.only(left: 48),
      child: Divider(
        height: 1,
        thickness: 0.5,
        color: Colors.grey[300],
      ),
    );
  }

  Widget _buildDefaultAvatar() {
    return Container(
      color: const Color(0xFF4A90E2),
      child: const Center(
        child: Icon(
          Icons.person,
          size: 60,
          color: Colors.white,
        ),
      ),
    );
  }
}
