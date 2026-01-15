import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projet_flutter/shared/widgets/custom_button.dart';

/// Popup de vérification email similaire à Labasni-IOS
/// mais avec les couleurs de l'app Flutter actuelle
class EmailVerificationSheet extends StatefulWidget {
  final String email;
  final String? errorMessage;
  final bool isLoading;
  final int resendSecondsRemaining;
  final bool canResend;
  final TextEditingController pinController;
  final VoidCallback onVerify;
  final VoidCallback onCancel;
  final VoidCallback? onResend;

  const EmailVerificationSheet({
    super.key,
    required this.email,
    this.errorMessage,
    this.isLoading = false,
    this.resendSecondsRemaining = 0,
    this.canResend = true,
    required this.pinController,
    required this.onVerify,
    required this.onCancel,
    this.onResend,
  });

  @override
  State<EmailVerificationSheet> createState() => _EmailVerificationSheetState();
}

class _EmailVerificationSheetState extends State<EmailVerificationSheet> {
  final FocusNode _pinFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Focus automatique sur le champ PIN
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pinFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _pinFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar (comme iOS)
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 50,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Titre
                const Text(
                  'Vérification requise',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A2B4C),
                  ),
                ),
                const SizedBox(height: 16),
                // Message avec email
                Column(
                  children: [
                    const Text(
                      'Un code à 6 chiffres a été envoyé à',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90E2).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.email,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF4A90E2),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Champ de saisie du code
                Container(
                  width: 220,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F7FA),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF4A90E2).withOpacity(0.7),
                      width: 1.8,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 6,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: widget.pinController,
                    focusNode: _pinFocusNode,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.tabularFigures()],
                      letterSpacing: 8,
                      color: Color(0xFF1A2B4C),
                    ),
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: '000000',
                      hintStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 8,
                        color: Colors.grey,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 16),
                // Message d'erreur
                if (widget.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.errorMessage!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 24),
                // Bouton de vérification
                CustomButton(
                  text: 'Vérifier le code',
                  onPressed: widget.pinController.text.length == 6 && !widget.isLoading
                      ? widget.onVerify
                      : null,
                  isLoading: widget.isLoading,
                ),
                const SizedBox(height: 16),
                // Bouton renvoyer le code
                if (widget.onResend != null)
                  TextButton(
                    onPressed: widget.canResend ? widget.onResend : null,
                    child: Text(
                      widget.canResend
                          ? 'Renvoyer le code'
                          : 'Renvoyer le code (${widget.resendSecondsRemaining}s)',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: widget.canResend
                            ? const Color(0xFF4A90E2)
                            : Colors.grey,
                      ),
                    ),
                  ),
                const SizedBox(height: 8),
                // Bouton annuler
                TextButton(
                  onPressed: widget.onCancel,
                  child: const Text(
                    'Annuler',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
