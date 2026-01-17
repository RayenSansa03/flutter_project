import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),
              const SizedBox(height: 32),
              _buildWelcomeSection(context),
              const SizedBox(height: 32),
              const Text(
                'Que voulez-vous faire ?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 20),
              _buildMainActions(context),
              const SizedBox(height: 32),
              _buildQuickStats(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ANTIGRAVITY',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Color(0xFF6C8EEF),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.push('/profile'),
          child: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final photoUrl = state is AuthAuthenticated ? state.user.image : null;
              return Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF6C8EEF), width: 2),
                ),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: photoUrl != null 
                    ? NetworkImage(photoUrl) 
                    : const NetworkImage('https://cdn-icons-png.flaticon.com/512/149/149071.png') as ImageProvider,
                  backgroundColor: Colors.grey.shade200,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final name = state is AuthAuthenticated ? (state.user.firstName ?? 'Ami') : 'Ami';
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bonjour, $name 👋',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C3E50),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Prêt pour une journée productive ?',
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF7F8C8D),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMainActions(BuildContext context) {
    return Column(
      children: [
        _buildActionCard(
          context,
          title: 'Mon Planning',
          subtitle: 'Gérez vos tâches avec l\'IA',
          icon: Icons.auto_awesome,
          color: const Color(0xFF6C8EEF),
          onTap: () => context.push('/daily-planner'),
        ),
        const SizedBox(height: 20),
        _buildActionCard(
          context,
          title: 'Session Focus',
          subtitle: 'Concentrez-vous seul ou à plusieurs',
          icon: Icons.timer_outlined,
          color: const Color(0xFF4ECDC4),
          onTap: () => context.push('/create-session'),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF7F8C8D),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildStatItem(
            'Focus Total',
            '3.5h',
            Icons.speed,
            const Color(0xFFFFB347),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _buildStatItem(
            'Tâches',
            '85%',
            Icons.check_circle_outline,
            const Color(0xFF6C8EEF),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF7F8C8D),
            ),
          ),
        ],
      ),
    );
  }
}
