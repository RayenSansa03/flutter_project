import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projet_flutter/features/focus_session/domain/usecases/focus_session_usecases.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_event.dart';
import 'package:projet_flutter/features/focus_session/presentation/bloc/focus_session_state.dart';
import 'package:projet_flutter/features/focus_session/domain/entities/focus_session.dart';

class FocusSessionBloc extends Bloc<FocusSessionEvent, FocusSessionState> {
  final GetFocusSessionsUseCase getFocusSessionsUseCase;
  final CreateFocusSessionUseCase createFocusSessionUseCase;
  final UpdateFocusSessionUseCase updateFocusSessionUseCase;
  final JoinFocusSessionUseCase joinFocusSessionUseCase;
  final LeaveFocusSessionUseCase leaveFocusSessionUseCase;

  Timer? _timer;
  final List<String> _messages = [
    'Deep Work...',
    'Concentration intense 🧠',
    'Presque là ! Continue ✨',
    'Le silence est d\'or 🤫',
    'Une tâche à la fois 🎯',
    'Respire... et avance 🧘',
    'Productivité maximale 🚀',
  ];

  FocusSessionBloc({
    required this.getFocusSessionsUseCase,
    required this.createFocusSessionUseCase,
    required this.updateFocusSessionUseCase,
    required this.joinFocusSessionUseCase,
    required this.leaveFocusSessionUseCase,
  }) : super(FocusSessionInitial()) {
    on<LoadSessionsEvent>(_onLoadSessions);
    on<CreateSessionEvent>(_onCreateSession);
    on<StartTimerEvent>(_onStartTimer);
    on<TimerTickEvent>(_onTimerTick);
    on<PauseTimerEvent>(_onPauseTimer);
    on<ResumeTimerEvent>(_onResumeTimer);
    on<CompleteSessionEvent>(_onCompleteSession);
    on<JoinSessionEvent>(_onJoinSession);
    on<LeaveSessionEvent>(_onLeaveSession);
  }

  Future<void> _onLoadSessions(LoadSessionsEvent event, Emitter<FocusSessionState> emit) async {
    emit(FocusSessionLoading());
    final result = await getFocusSessionsUseCase();
    result.fold(
      (failure) => emit(FocusSessionError(failure.message)),
      (sessions) => emit(FocusSessionLoaded(sessions)),
    );
  }

  Future<void> _onCreateSession(CreateSessionEvent event, Emitter<FocusSessionState> emit) async {
    emit(FocusSessionLoading());
    final result = await createFocusSessionUseCase(event.session, event.invitedUserIds);
    result.fold(
      (failure) => emit(FocusSessionError(failure.message)),
      (session) {
        // If it's a solo session and it's active (started now), start the timer
        if (!session.isGroup && session.status == FocusSessionStatus.active) {
           add(StartTimerEvent(session.durationMinutes));
        } else {
           add(LoadSessionsEvent());
        }
      },
    );
  }

  void _onStartTimer(StartTimerEvent event, Emitter<FocusSessionState> emit) {
    final totalSeconds = event.durationMinutes * 60;
    _timer?.cancel();
    
    emit(FocusSessionInPogress(
      secondsRemaining: totalSeconds,
      totalSeconds: totalSeconds,
      currentMessage: _getRandomMessage(),
    ));

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final currentState = state;
      if (currentState is FocusSessionInPogress && !currentState.isPaused) {
        if (currentState.secondsRemaining > 0) {
          add(TimerTickEvent(currentState.secondsRemaining - 1));
        } else {
          timer.cancel();
          // Auto complete if needed or wait for user
        }
      }
    });
  }

  void _onTimerTick(TimerTickEvent event, Emitter<FocusSessionState> emit) {
    final currentState = state;
    if (currentState is FocusSessionInPogress) {
      // Change message every 5 minutes (300 seconds)
      String message = currentState.currentMessage;
      if (event.secondsRemaining % 300 == 0) {
        message = _getRandomMessage();
      }

      emit(FocusSessionInPogress(
        session: currentState.session,
        secondsRemaining: event.secondsRemaining,
        totalSeconds: currentState.totalSeconds,
        isPaused: currentState.isPaused,
        currentMessage: message,
      ));
    }
  }

  void _onPauseTimer(PauseTimerEvent event, Emitter<FocusSessionState> emit) {
    final currentState = state;
    if (currentState is FocusSessionInPogress) {
      emit(FocusSessionInPogress(
        session: currentState.session,
        secondsRemaining: currentState.secondsRemaining,
        totalSeconds: currentState.totalSeconds,
        isPaused: true,
        currentMessage: 'Session en pause ☕',
      ));
    }
  }

  void _onResumeTimer(ResumeTimerEvent event, Emitter<FocusSessionState> emit) {
    final currentState = state;
    if (currentState is FocusSessionInPogress) {
      emit(FocusSessionInPogress(
        session: currentState.session,
        secondsRemaining: currentState.secondsRemaining,
        totalSeconds: currentState.totalSeconds,
        isPaused: false,
        currentMessage: _getRandomMessage(),
      ));
    }
  }

  Future<void> _onCompleteSession(CompleteSessionEvent event, Emitter<FocusSessionState> emit) async {
    final currentState = state;
    if (currentState is FocusSessionInPogress) {
      _timer?.cancel();
      emit(FocusSessionLoading());
      
      final actualMinutes = (currentState.totalSeconds - currentState.secondsRemaining) ~/ 60;
      
      // Update status in backend if it's a persisted session
      if (event.sessionId != 'preview') {
        await updateFocusSessionUseCase(event.sessionId, {'status': 'completed', 'endTime': DateTime.now().toIso8601String()});
      }

      // We should fetch the session object to emit FocusSessionFinished
      // For now, if it was solo instant, we might not have a full object
      // I'll emit a generic finish state or the loaded session if available
      if (currentState.session != null) {
        emit(FocusSessionFinished(currentState.session!, actualMinutes));
      } else {
        // Mock finish for instant solo
        emit(FocusSessionInitial());
      }
    }
  }

  Future<void> _onJoinSession(JoinSessionEvent event, Emitter<FocusSessionState> emit) async {
    final result = await joinFocusSessionUseCase(event.sessionId);
    result.fold(
      (failure) => emit(FocusSessionError(failure.message)),
      (session) {
        add(StartTimerEvent(session.durationMinutes));
      },
    );
  }

  Future<void> _onLeaveSession(LeaveSessionEvent event, Emitter<FocusSessionState> emit) async {
    _timer?.cancel();
    await leaveFocusSessionUseCase(event.sessionId);
    emit(FocusSessionInitial());
  }

  String _getRandomMessage() {
    return _messages[Random().nextInt(_messages.length)];
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
