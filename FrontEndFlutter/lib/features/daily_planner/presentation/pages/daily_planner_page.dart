import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:projet_flutter/core/config/di_config.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:projet_flutter/features/auth/presentation/bloc/auth_state.dart';
import 'package:projet_flutter/features/daily_planner/domain/entities/task.dart';
import 'package:projet_flutter/features/daily_planner/presentation/bloc/daily_planner_bloc.dart';
import 'package:projet_flutter/features/daily_planner/presentation/bloc/daily_planner_event.dart';
import 'package:projet_flutter/features/daily_planner/presentation/bloc/daily_planner_state.dart';
import 'package:projet_flutter/features/daily_planner/presentation/widgets/task_item_widget.dart';

class DailyPlannerPage extends StatelessWidget {
  const DailyPlannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<DailyPlannerBloc>()..add(LoadTasksEvent()),
      child: const _DailyPlannerView(),
    );
  }
}

class _DailyPlannerView extends StatefulWidget {
  const _DailyPlannerView();

  @override
  State<_DailyPlannerView> createState() => _DailyPlannerViewState();
}

class _DailyPlannerViewState extends State<_DailyPlannerView> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _newTaskController = TextEditingController();
  bool _isAddingTask = false;
  
  TimeOfDay? _selectedTime;
  Duration? _selectedDuration;

  @override
  void dispose() {
    _promptController.dispose();
    _newTaskController.dispose();
    super.dispose();
  }

  void _submitPrompt() {
    if (_promptController.text.isNotEmpty) {
      context.read<DailyPlannerBloc>().add(
            GenerateTasksEvent(_promptController.text),
          );
      _promptController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _saveNewTask() {
    if (_newTaskController.text.isNotEmpty) {
      final task = Task(
        id: DateTime.now().toString(),
        title: _newTaskController.text,
        description: _selectedTime != null 
            ? 'À ${_selectedTime!.format(context)}' 
            : 'Nouvelle tâche',
        isCompleted: false,
        time: _selectedTime != null 
            ? DateTime(2024, 1, 1, _selectedTime!.hour, _selectedTime!.minute) 
            : null,
        duration: _selectedDuration,
      );
      
      context.read<DailyPlannerBloc>().add(AddTaskEvent(task));
      
      setState(() {
        _isAddingTask = false;
        _newTaskController.clear();
        _selectedTime = null;
        _selectedDuration = null;
      });
    }
  }

  void _showEditTaskModal(Task task) {
    final titleController = TextEditingController(text: task.title);
    final descController = TextEditingController(text: task.description);
    TimeOfDay? editTime = task.time != null 
        ? TimeOfDay(hour: task.time!.hour, minute: task.time!.minute) 
        : null;
    Duration? editDuration = task.duration;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
            top: 24,
            left: 24,
            right: 24,
          ),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Text(
                    'Modifier l\'objectif',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C3E50),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: titleController,
                decoration: _buildInputDecoration('Titre', Icons.title),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descController,
                decoration: _buildInputDecoration('Description', Icons.description_outlined),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildActionChip(
                      icon: Icons.access_time,
                      label: editTime != null ? editTime!.format(context) : 'Heure',
                      isSelected: editTime != null,
                      onTap: () async {
                        final time = await showTimePicker(
                          context: context,
                          initialTime: editTime ?? TimeOfDay.now(),
                        );
                        if (time != null) setModalState(() => editTime = time);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildActionChip(
                      icon: Icons.timer_outlined,
                      label: editDuration != null ? '${editDuration!.inMinutes} min' : 'Durée',
                      isSelected: editDuration != null,
                      onTap: () {
                         setModalState(() => editDuration = const Duration(minutes: 30));
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  final updatedTask = task.copyWith(
                    title: titleController.text,
                    description: descController.text,
                    time: editTime != null 
                        ? DateTime(2024, 1, 1, editTime!.hour, editTime!.minute) 
                        : null,
                    duration: editDuration,
                  );
                  context.read<DailyPlannerBloc>().add(UpdateTaskEvent(updatedTask));
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C8EEF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 0,
                ),
                child: const Text('Enregistrer les modifications', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF6C8EEF)),
      labelStyle: const TextStyle(color: Color(0xFF7F8C8D)),
      filled: true,
      fillColor: const Color(0xFFF8FAFF),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Color(0xFF6C8EEF), width: 1.5),
      ),
    );
  }

  Widget _buildActionChip({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEAF2FF) : const Color(0xFFF8FAFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF6C8EEF) : Colors.transparent,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: isSelected ? const Color(0xFF6C8EEF) : Colors.grey),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF6C8EEF) : Colors.grey.shade700,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFBFF),
      body: SafeArea(
        child: BlocBuilder<DailyPlannerBloc, DailyPlannerState>(
          builder: (context, state) {
            List<Task> currentTasks = [];
            if (state is DailyPlannerLoaded) currentTasks = state.tasks;
            
            return Column(
              children: [
                _buildHeader(context, currentTasks),
                Expanded(
                  child: state is DailyPlannerLoading
                      ? const Center(child: CircularProgressIndicator())
                      : state is DailyPlannerError
                          ? Center(child: Text(state.message))
                          : _buildTaskList(currentTasks),
                ),
              ],
            );
          },
        ),
      ),
      bottomSheet: _buildBottomInputArea(),
    );
  }

  Widget _buildHeader(BuildContext context, List<Task> tasks) {
    final completedCount = tasks.where((t) => t.isCompleted).length;
    final progress = tasks.isEmpty ? 0.0 : completedCount / tasks.length;
    final progressPercent = (progress * 100).toInt();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, size: 20, color: Color(0xFF2C3E50)),
                    onPressed: () => context.go('/home'),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.calendar_today, 
                      size: 18, color: const Color(0xFF6C8EEF)),
                  const SizedBox(width: 8),
                  Text(
                    '12 OCTOBRE', 
                    style: TextStyle(
                      color: const Color(0xFF6C8EEF),
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                   InkWell(
                    onTap: () => context.push('/create-session'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6C8EEF).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.timer_outlined, color: Color(0xFF6C8EEF), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => context.go('/profile'),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.settings, color: Color(0xFF2C3E50)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final String firstName = state is AuthAuthenticated 
                  ? (state.user.firstName ?? 'Alex') 
                  : 'Alex';
              return Text(
                'Bonjour, $firstName',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              );
            },
          ),
          const SizedBox(height: 8),
          const Text(
            'Prêt pour une journée sereine ?',
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF7F8C8D),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Progression du jour',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF2C3E50),
                ),
              ),
              Text(
                '$progressPercent%',
                style: const TextStyle(
                  color: Color(0xFF6C8EEF),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress, 
              backgroundColor: const Color(0xFFEEF2F5),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6C8EEF)),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Task> tasks) {
    if (tasks.isEmpty && !_isAddingTask) {
       return Center(
         child: Column(
           mainAxisAlignment: MainAxisAlignment.center,
           children: [
             Icon(Icons.task_alt, size: 64, color: Colors.grey.shade200),
             const SizedBox(height: 16),
             Text(
               'Aucune tâche pour aujourd\'hui',
               style: TextStyle(color: Colors.grey.shade400, fontSize: 16),
             ),
             const SizedBox(height: 24),
             _buildAddObjectiveButton(),
           ],
         ),
       );
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
      itemCount: tasks.length + 1,
      itemBuilder: (context, index) {
        if (index == tasks.length) {
          if (_isAddingTask) return const SizedBox.shrink();
          return _buildAddObjectiveButton();
        }
        
        final task = tasks[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Dismissible(
            key: Key(task.id),
            background: _buildDismissBackground(
              alignment: Alignment.centerLeft,
              color: const Color(0xFF6C8EEF),
              icon: Icons.edit,
              label: 'Modifier',
            ),
            secondaryBackground: _buildDismissBackground(
              alignment: Alignment.centerRight,
              color: const Color(0xFFFF5252),
              icon: Icons.delete_outline,
              label: 'Supprimer',
            ),
            confirmDismiss: (direction) async {
              if (direction == DismissDirection.startToEnd) {
                _showEditTaskModal(task);
                return false; // Don't dismiss, just edit
              }
              return true; // Proceed with delete
            },
            onDismissed: (direction) {
              if (direction == DismissDirection.endToStart) {
                context.read<DailyPlannerBloc>().add(DeleteTaskEvent(task.id));
              }
            },
            child: TaskItemWidget(
              task: task,
              onToggle: () => context.read<DailyPlannerBloc>().add(ToggleTaskEvent(task)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDismissBackground({
    required Alignment alignment,
    required Color color,
    required IconData icon,
    required String label,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (alignment == Alignment.centerLeft) Icon(icon, color: Colors.white),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          if (alignment == Alignment.centerRight) ...[
            const SizedBox(width: 8),
            Icon(icon, color: Colors.white),
          ],
        ],
      ),
    );
  }

  Widget _buildAddObjectiveButton() {
     return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        child: InkWell(
          onTap: () => setState(() => _isAddingTask = true),
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFFE0E5EC)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.add, color: Color(0xFF6C8EEF)),
                SizedBox(width: 8),
                Text(
                  'Ajouter un objectif',
                  style: TextStyle(
                    color: Color(0xFF6C8EEF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomInputArea() {
    // Si on ajoute une tâche manuellement
    if (_isAddingTask) {
      return Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          top: 24,
          left: 24,
          right: 24,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Nouvel objectif',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _isAddingTask = false),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newTaskController,
              decoration: _buildInputDecoration('Ex: Lire 10 pages', Icons.edit_note),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionChip(
                    icon: Icons.access_time,
                    label: _selectedTime != null ? _selectedTime!.format(context) : 'Heure',
                    isSelected: _selectedTime != null,
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (time != null) setState(() => _selectedTime = time);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildActionChip(
                    icon: Icons.timer_outlined,
                    label: _selectedDuration != null ? '${_selectedDuration!.inMinutes} min' : 'Durée',
                    isSelected: _selectedDuration != null,
                    onTap: () {
                      setState(() => _selectedDuration = const Duration(minutes: 30));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _saveNewTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6C8EEF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 0,
              ),
              child: const Text('Ajouter l\'objectif', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    }

    // Zone de prompt RAG par défaut
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        top: 16,
        left: 24,
        right: 24,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade100)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _promptController,
              decoration: InputDecoration(
                hintText: 'Quel est votre programme ?',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                fillColor: const Color(0xFFF5F7FA),
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 14,
                ),
              ),
              onSubmitted: (_) => _submitPrompt(),
            ),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: _submitPrompt,
            borderRadius: BorderRadius.circular(30),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: Color(0xFF6C8EEF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}

