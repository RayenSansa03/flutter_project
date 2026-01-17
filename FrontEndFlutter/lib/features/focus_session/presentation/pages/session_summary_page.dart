import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionSummaryPage extends StatelessWidget {
  final int durationMinutes;
  const SessionSummaryPage({super.key, this.durationMinutes = 45});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.grey),
            onPressed: () => context.go('/home'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check, size: 40, color: Colors.green),
            ),
            const SizedBox(height: 25),
            const Text(
              'Session terminée',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1A1C24)),
            ),
            const SizedBox(height: 10),
            const Text(
              'Vous avez maintenu un excellent flux.',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 40),
            _buildStatCard(),
            const SizedBox(height: 30),
            _buildStabilityChart(),
            const SizedBox(height: 30),
            _buildAiSuggestion(),
            const SizedBox(height: 40),
            _buildAvatars(),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.edit_note),
              label: const Text('Enregistrer un Instant Réel'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade500,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
            ),
            TextButton(
              onPressed: () => context.go('/home'),
              child: const Text('Retour à l\'accueil', style: TextStyle(color: Colors.grey)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFF),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        children: [
          const Text(
             'TEMPS DE CONCENTRATION',
             style: TextStyle(
               fontSize: 12,
               fontWeight: FontWeight.bold,
               color: Colors.blueGrey,
               letterSpacing: 1,
             ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$durationMinutes',
                style: const TextStyle(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'min',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStabilityChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Stabilité du focus',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                 Icon(Icons.trending_up, size: 16, color: Colors.blue),
                 SizedBox(width: 4),
                 Text('Flux régulier', style: TextStyle(color: Colors.blue, fontSize: 13)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 15),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: 0.85,
            minHeight: 12,
            backgroundColor: Colors.grey.shade100,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        const SizedBox(height: 8),
        const Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
           children: [
             Text('Détendu', style: TextStyle(color: Colors.grey, fontSize: 12)),
             Text('Profond', style: TextStyle(color: Colors.grey, fontSize: 12)),
           ],
        ),
      ],
    );
  }

  Widget _buildAiSuggestion() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade50.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.blue.shade50),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
             padding: const EdgeInsets.all(10),
             decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
             child: const Icon(Icons.auto_awesome, color: Colors.blue, size: 20),
          ),
          const SizedBox(width: 15),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggestion IA',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  'Basé sur votre fatigue, une pause de 5 minutes serait idéale pour recharger votre niveau d\'énergie.',
                  style: TextStyle(color: Color(0xFF5E6272), height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatars() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 80,
          child: Stack(
            children: [
              CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=10')),
              Positioned(
                 left: 20,
                 child: CircleAvatar(radius: 18, backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=11')),
              ),
              Positioned(
                 left: 40,
                 child: Container(
                   width: 36,
                   height: 36,
                   decoration: BoxDecoration(
                     color: Colors.blue.shade50,
                     shape: BoxShape.circle,
                     border: Border.all(color: Colors.white, width: 2),
                   ),
                   child: const Center(
                     child: Text('+2', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.blue)),
                   ),
                 ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        const Text('Session de groupe terminée', style: TextStyle(color: Colors.grey, fontSize: 13)),
      ],
    );
  }
}
