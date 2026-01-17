import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/core/config/di_config.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_bloc.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_event.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_state.dart';
import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  bool isGroup = false;
  bool startNow = true;
  DateTime? scheduledTime;
  int durationMinutes = 25;
  final TextEditingController _titleController = TextEditingController(text: 'Ma Session d\'Étude');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Nouvelle Session', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Titre de la session', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.shade50,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
                hintText: 'Entrez un titre...',
              ),
            ),
            const SizedBox(height: 30),
            const Text('Mode de focus', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildModeCard(
                  title: 'Solo',
                  icon: Icons.person_outline,
                  isSelected: !isGroup,
                  onTap: () => setState(() => isGroup = false),
                ),
                const SizedBox(width: 15),
                _buildModeCard(
                  title: 'Groupe',
                  icon: Icons.groups_outlined,
                  isSelected: isGroup,
                  onTap: () => setState(() => isGroup = true),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Quand commencer ?', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 15),
            Row(
              children: [
                _buildTimeToggle(
                  label: 'Maintenant',
                  isSelected: startNow,
                  onTap: () => setState(() => startNow = true),
                ),
                const SizedBox(width: 15),
                _buildTimeToggle(
                  label: 'Planifier',
                  isSelected: !startNow,
                  onTap: () => setState(() => startNow = false),
                ),
              ],
            ),
            if (!startNow) ...[
              const SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                  if (time != null) {
                    final now = DateTime.now();
                    setState(() {
                      scheduledTime = DateTime(now.year, now.month, now.day, time.hour, time.minute);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.blue),
                      const SizedBox(width: 15),
                      Text(
                        scheduledTime != null 
                          ? DateFormat('HH:mm').format(scheduledTime!) 
                          : 'Choisir une heure',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 30),
            const Text('Durée (minutes)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 10),
            Slider(
              value: durationMinutes.toDouble(),
              min: 5,
              max: 120,
              divisions: 23,
              label: '$durationMinutes min',
              onChanged: (val) => setState(() => durationMinutes = val.toInt()),
            ),
            if (isGroup) ...[
              const SizedBox(height: 30),
              const Text('Inviter des amis', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 15),
              _buildFriendsPicker(),
            ],
            const SizedBox(height: 50),
            ElevatedButton(
              onPressed: () {
                final session = FocusSession(
                  id: '',
                  userId: '', // Set by backend
                  title: _titleController.text,
                  status: startNow ? FocusSessionStatus.active : FocusSessionStatus.planned,
                  isGroup: isGroup,
                  startTime: startNow ? DateTime.now() : scheduledTime,
                  durationMinutes: durationMinutes,
                );
                
                getIt<FocusSessionBloc>().add(CreateSessionEvent(session));
                
                if (startNow) {
                   context.pushReplacement('/focus');
                } else {
                   context.pop();
                   ScaffoldMessenger.of(context).showSnackBar(
                     const SnackBar(content: Text('Session planifiée avec succès !')),
                   );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: Text(startNow ? 'Démarrer la session' : 'Planifier la session'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard({required String title, required IconData icon, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade200, width: 2),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.blue : Colors.grey, size: 32),
              const SizedBox(height: 10),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? Colors.blue : Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimeToggle({required String label, required bool isSelected, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(color: isSelected ? Colors.white : Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsPicker() {
    // Mock friends list
    final friends = [
      {'name': 'Amine', 'photo': 'https://i.pravatar.cc/150?u=a'},
      {'name': 'Sarah', 'photo': 'https://i.pravatar.cc/150?u=b'},
      {'name': 'Mehdi', 'photo': 'https://i.pravatar.cc/150?u=c'},
    ];
    
    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Column(
              children: [
                Stack(
                  children: [
                    CircleAvatar(radius: 25, backgroundImage: NetworkImage(friends[index]['photo']!)),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const Icon(Icons.check_circle, color: Colors.blue, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(friends[index]['name']!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }
}
