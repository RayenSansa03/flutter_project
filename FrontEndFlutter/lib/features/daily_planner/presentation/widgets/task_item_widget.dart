import 'package:flutter/material.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';

class TaskItemWidget extends StatelessWidget {
  final Task task;
  final VoidCallback onToggle;

  const TaskItemWidget({
    super.key,
    required this.task,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onToggle,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Radio/Checkbox customizable
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: task.isCompleted
                            ? const Color(0xFF6C8EEF)
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      color: task.isCompleted ? const Color(0xFF6C8EEF) : null,
                    ),
                    child: task.isCompleted
                        ? const Icon(
                            Icons.check,
                            size: 14,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        task.title,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: task.isCompleted
                              ? Colors.grey.shade400
                              : const Color(0xFF1A1A1A),
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        task.description != null &&
                                task.description!.isNotEmpty
                            ? task.description!
                            : 'Aucune description disponible',
                        style: TextStyle(
                          fontSize: 14,
                          color: task.isCompleted
                              ? Colors.grey.shade300
                              : Colors.grey.shade500,
                          fontStyle: task.description == null ||
                                  task.description!.isEmpty
                              ? FontStyle.italic
                              : FontStyle.normal,
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      if(task.time != null || task.duration != null) ...[
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (task.time != null)
                              _buildInfoChip(
                                Icons.access_time_filled,
                                '${task.time!.hour.toString().padLeft(2, '0')}:${task.time!.minute.toString().padLeft(2, '0')}',
                                const Color(0xFFEAF2FF),
                                const Color(0xFF6C8EEF),
                                task.isCompleted,
                              ),
                            if (task.duration != null)
                              _buildInfoChip(
                                Icons.hourglass_bottom,
                                '${task.duration!.inMinutes} min',
                                const Color(0xFFFFF4E5),
                                const Color(0xFFFF9800),
                                task.isCompleted,
                              ),
                          ],
                        ),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color bgColor, Color iconColor, bool isCompleted) {
    if (isCompleted) {
      bgColor = Colors.grey.shade100;
      iconColor = Colors.grey.shade400;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: iconColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isCompleted ? Colors.grey.shade500 : const Color(0xFF455A64),
            ),
          ),
        ],
      ),
    );
  }
}
