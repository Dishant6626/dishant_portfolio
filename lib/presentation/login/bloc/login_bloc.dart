// ── vBloc template ────────────────────────────────────────────────────────────

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../../core/base/base_bloc.dart';
import '../../../core/base/screen_state.dart';
import '../../../core/base/view_action.dart';
import 'login_state.dart';

class LoginBloc extends BaseBloc<LoginEvent, LoginData> {
  LoginBloc() : super(initState) {
    on<InitLoginEvent>(_initLoginEvent);
    on<BackLoginEvent>(_backLoginEvent);
    on<UpdateLoginState>((event, emit) => emit(event.state));
    on<EmailChangedEvent>(_onEmailChanged);
    on<PasswordChangedEvent>(_onPasswordChanged);
    on<TogglePasswordVisibilityEvent>(_onToggleVisibility);
    on<SubmitLoginEvent>(_onSubmitLogin);
  }

  static LoginData get initState =>
      const LoginData(state: ScreenState.content, errorMessage: '');

  final _log = Logger();

  // ── Handlers ───────────────────────────────────────────────────────────────

  void _initLoginEvent(InitLoginEvent event, _) {
    // Already in content state — nothing to fetch
  }

  void _backLoginEvent(BackLoginEvent event, _) =>
      dispatchViewEvent(NavigateScreen(LoginTarget.back));

  void _onEmailChanged(EmailChangedEvent event, _) {
    add(UpdateLoginState(state.copyWith(email: event.email, errorMessage: '')));
  }

  void _onPasswordChanged(PasswordChangedEvent event, _) {
    add(
      UpdateLoginState(
        state.copyWith(password: event.password, errorMessage: ''),
      ),
    );
  }

  void _onToggleVisibility(TogglePasswordVisibilityEvent event, _) {
    add(
      UpdateLoginState(
        state.copyWith(isPasswordVisible: !state.isPasswordVisible),
      ),
    );
  }

  void _onSubmitLogin(SubmitLoginEvent event, _) async {
    if (state.email.trim().isEmpty || state.password.trim().isEmpty) {
      add(
        UpdateLoginState(
          state.copyWith(errorMessage: 'Please enter email and password'),
        ),
      );
      return;
    }

    add(UpdateLoginState(state.copyWith(isLoading: true, errorMessage: '')));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: state.email.trim(),
        password: state.password.trim(),
      );
      _log.i('Admin login successful: ${state.email}');
      add(UpdateLoginState(state.copyWith(isLoading: false)));
      dispatchViewEvent(NavigateScreen(LoginTarget.admin));
    } on FirebaseAuthException catch (e) {
      _log.e('Login error: ${e.code}');
      add(
        UpdateLoginState(
          state.copyWith(isLoading: false, errorMessage: _authError(e.code)),
        ),
      );
    } catch (e) {
      _log.e('Unexpected login error: $e');
      add(
        UpdateLoginState(
          state.copyWith(
            isLoading: false,
            errorMessage: 'An unexpected error occurred',
          ),
        ),
      );
    }
  }

  String _authError(String code) {
    switch (code) {
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Invalid email or password';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later';
      case 'user-disabled':
        return 'This account has been disabled';
      default:
        return 'Login failed. Please try again';
    }
  }
}
