// ── vCtr template ─────────────────────────────────────────────────────────────
// Naming: ${NAME}Data for state, Init/Update/Back events, ${NAME}Target consts.
// Uses Equatable + copyWith (same immutability guarantee as built_value,
// no build_runner step required in the portfolio project).

import 'package:equatable/equatable.dart';

import '../../../core/base/screen_state.dart';

// ── State ──────────────────────────────────────────────────────────────────────

class LoginData extends Equatable {
  final ScreenState state;
  final String? errorMessage;
  final String email;
  final String password;
  final bool isPasswordVisible;
  final bool isLoading;

  const LoginData({
    required this.state,
    this.errorMessage,
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.isLoading = false,
  });

  LoginData copyWith({
    ScreenState? state,
    String? errorMessage,
    String? email,
    String? password,
    bool? isPasswordVisible,
    bool? isLoading,
  }) => LoginData(
    state: state ?? this.state,
    errorMessage: errorMessage ?? this.errorMessage,
    email: email ?? this.email,
    password: password ?? this.password,
    isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
    isLoading: isLoading ?? this.isLoading,
  );

  @override
  List<Object?> get props => [
    state,
    errorMessage,
    email,
    password,
    isPasswordVisible,
    isLoading,
  ];
}

// ── Events ─────────────────────────────────────────────────────────────────────

abstract class LoginEvent {}

class InitLoginEvent extends LoginEvent {}

class BackLoginEvent extends LoginEvent {}

class UpdateLoginState extends LoginEvent {
  final LoginData state;

  UpdateLoginState(this.state);
}

class EmailChangedEvent extends LoginEvent {
  final String email;

  EmailChangedEvent(this.email);
}

class PasswordChangedEvent extends LoginEvent {
  final String password;

  PasswordChangedEvent(this.password);
}

class TogglePasswordVisibilityEvent extends LoginEvent {}

class SubmitLoginEvent extends LoginEvent {}

// ── Target ─────────────────────────────────────────────────────────────────────

abstract class LoginTarget {
  static const String back = 'back';
  static const String admin = 'admin';
}
