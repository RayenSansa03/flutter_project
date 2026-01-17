import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/core/config/di_config.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_bloc.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_event.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_state.dart';
import 'package:go_router/go_router.dart';
import 'dart:math' as math;

class FocusTimerPage extends StatelessWidget {
  const FocusTimerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<FocusSessionBloc>()..add(const StartTimerEvent(25)),
      child: const FocusTimerView(),
    );
  }
}

class FocusTimerView extends StatelessWidget {
  const FocusTimerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F7),
      body: SafeArea(
        child: BlocConsumer<FocusSessionBloc, FocusSessionState>(
          listener: (context, state) {
            if (state is FocusSessionFinished) {
               context.pushReplacement('/session-summary', extra: state.actualDurationMinutes);
            }
          },
          builder: (context, state) {
            if (state is FocusSessionLoading || state is FocusSessionInitial) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FocusSessionError) {
              return Center(child: Text(state.message));
            }
            if (state is! FocusSessionInPogress) {
              return const SizedBox.shrink();
            }

            return Column(
              children: [
                _buildHeader(context, state),
                Expanded(
                  child: Center(
                    child: _buildTimerContent(context, state),
                  ),
                ),
                _buildBottomControls(context, state),
                const SizedBox(height: 20),
                _buildDailyGoal(context),
                const SizedBox(height: 10),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FocusSessionState state) {
    String title = 'SOLO FOCUS';
    if (state is FocusSessionInPogress && state.session?.isGroup == true) {
      title = 'SHARED FOCUS';
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, size: 20),
            onPressed: () => context.pop(),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
              color: Color(0xFF5D7FA3),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.music_note_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTimerContent(BuildContext context, FocusSessionInPogress state) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.session?.isGroup == true)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F1FF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(radius: 4, backgroundColor: Colors.blue),
                SizedBox(width: 8),
                const Text(
                  'FOCUS PARTAGÉ',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        const SizedBox(height: 30),
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 280,
              height: 280,
              child: CustomPaint(
                painter: TimerPainter(
                  progress: state.progress,
                  color: const Color(0xFF64B5F6),
                ),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(state.secondsRemaining),
                  style: const TextStyle(
                    fontSize: 64,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1C1E),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  state.currentMessage,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blueGrey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (state.session?.isGroup != true)
                  const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircleAvatar(radius: 2, backgroundColor: Colors.blue),
                      SizedBox(width: 4),
                      CircleAvatar(radius: 2, backgroundColor: Colors.blue),
                      SizedBox(width: 4),
                      CircleAvatar(radius: 2, backgroundColor: Colors.blue),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomControls(BuildContext context, FocusSessionInPogress state) {
    if (state.session?.isGroup == true) {
      return _buildSharedBottomControls(context, state);
    }
    
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildCircleButton(
            onPressed: () => context.read<FocusSessionBloc>().add(const StartTimerEvent(25)),
            icon: Icons.refresh,
            color: Colors.grey.shade200,
            iconColor: Colors.grey.shade600,
          ),
          const SizedBox(width: 30),
          GestureDetector(
             onTap: () {
               if (state.isPaused) {
                 context.read<FocusSessionBloc>().add(ResumeTimerEvent());
               } else {
                 context.read<FocusSessionBloc>().add(PauseTimerEvent());
               }
             },
             child: Container(
               width: 80,
               height: 80,
               decoration: BoxDecoration(
                 color: Colors.blue.shade500,
                 shape: BoxShape.circle,
                 boxShadow: [
                   BoxShadow(
                     color: Colors.blue.withOpacity(0.3),
                     blurRadius: 15,
                     offset: const Offset(0, 8),
                   ),
                 ],
               ),
               child: Icon(
                 state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                 size: 40,
                 color: Colors.white,
               ),
             ),
          ),
          const SizedBox(width: 30),
          _buildCircleButton(
            onPressed: () => context.read<FocusSessionBloc>().add(CompleteSessionEvent(state.session?.id ?? 'preview')),
            icon: Icons.stop_rounded,
            color: Colors.grey.shade200,
            iconColor: Colors.grey.shade600,
          ),
        ],
      );
  }

  Widget _buildSharedBottomControls(BuildContext context, FocusSessionInPogress state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCircleButton(
              onPressed: () {},
              icon: Icons.volume_up_outlined,
              color: Colors.blue.shade50,
              iconColor: Colors.blue.shade600,
            ),
            const SizedBox(width: 25),
            GestureDetector(
              onTap: () {
                 if (state.isPaused) {
                 context.read<FocusSessionBloc>().add(ResumeTimerEvent());
               } else {
                 context.read<FocusSessionBloc>().add(PauseTimerEvent());
               }
              },
              child: Container(
                width: 75,
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  state.isPaused ? Icons.play_arrow_rounded : Icons.pause_rounded,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 25),
            _buildCircleButton(
              onPressed: () {},
              icon: Icons.stop_rounded,
              color: Colors.blue.shade50,
              iconColor: Colors.blue.shade600,
            ),
          ],
        ),
        const SizedBox(height: 40),
        Row(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             _buildSmallChip('Courage ✨'),
             const SizedBox(width: 15),
             _buildSmallChip('Avec toi 💪'),
           ],
        ),
        const SizedBox(height: 30),
        _buildFriendsAvatars(),
      ],
    );
  }

  Widget _buildFriendsAvatars() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _avatar('https://i.pravatar.cc/150?u=1', online: true),
            const SizedBox(width: -10),
            _avatar('https://i.pravatar.cc/150?u=2', online: true),
            const SizedBox(width: -10),
            _avatar('https://i.pravatar.cc/150?u=3', online: true),
            const SizedBox(width: 10),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade100, width: 2),
              ),
              child: Icon(Icons.add, size: 20, color: Colors.grey.shade400),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '3 amis connectés',
          style: TextStyle(fontSize: 13, color: Colors.blueGrey.shade300),
        ),
      ],
    );
  }

  Widget _avatar(String url, {bool online = false}) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F7),
        shape: BoxShape.circle,
        border: online ? Border.all(color: Colors.green, width: 2) : null,
      ),
      child: CircleAvatar(
        radius: 18,
        backgroundImage: NetworkImage(url),
      ),
    );
  }

  Widget _buildSmallChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF2E3E5C)),
      ),
    );
  }

  Widget _buildCircleButton({
    required VoidCallback onPressed,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor),
      ),
    );
  }

  Widget _buildDailyGoal(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DAILY GOAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.blueGrey,
                ),
              ),
              Row(
                children: [
                  Text('3h', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(' / 4h', style: TextStyle(color: Colors.grey)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.75,
              minHeight: 8,
              backgroundColor: Colors.grey.shade100,
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF64B5F6)),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

class TimerPainter extends CustomPainter {
  final double progress;
  final Color color;

  TimerPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width / 2, size.height / 2);
    const strokeWidth = 10.0;

    // Background circle
    final bgPaint = Paint()
      ..color = Colors.blueGrey.shade50
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF64B5F6), Color(0xFF81C784)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );
    
    // Progress dot
    if (progress > 0) {
      final angle = (2 * math.pi * progress) - (math.pi / 2);
      final dotPos = Offset(
        center.dx + radius * math.cos(angle),
        center.dy + radius * math.sin(angle),
      );
      
      canvas.drawCircle(
        dotPos,
        6,
        Paint()..color = const Color(0xFF64B5F6),
      );
      canvas.drawCircle(
        dotPos,
        3,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(TimerPainter oldDelegate) => oldDelegate.progress != progress;
}
