// ── vFul template ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/base/base_state.dart';
import '../../core/base/screen_state.dart';
import '../../core/base/view_action.dart';
import '../../core/common/full_screen_error.dart';
import '../../core/constants/app_colors.dart';
import '../admin/admin_screen.dart';
import 'bloc/login_bloc.dart';
import 'bloc/login_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginBloc, LoginScreen> {
  @override
  LoginBloc createBloc() => LoginBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(InitLoginEvent());
  }

  // ── vFul build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: BlocProvider<LoginBloc>(
          create: (_) => bloc,
          child: BlocBuilder<LoginBloc, LoginData>(
            builder: (BuildContext context, LoginData data) {
              return _MainContent(data: data, bloc: bloc);
            },
          ),
        ),
      ),
    );
  }

  // ── vFul onViewEvent ───────────────────────────────────────────────────────
  @override
  void onViewEvent(ViewAction event) async {
    switch (event.runtimeType) {
      case DisplayMessage:
        _buildHandleMessage(event);
        break;
      case NavigateScreen:
        _buildHandleActionEvent(event);
        break;
    }
  }

  void _buildHandleActionEvent(ViewAction event) {
    final screen = event as NavigateScreen;
    switch (screen.target) {
      case LoginTarget.back:
        Navigator.of(context).pop();
        break;
      case LoginTarget.admin:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const AdminScreen()),
        );
        break;
    }
  }

  void _buildHandleMessage(ViewAction event) {
    final msg = event as DisplayMessage;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg.message),
        backgroundColor: msg.type == MessageType.error
            ? Colors.redAccent
            : AppColors.accent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}

// ── _MainContent ───────────────────────────────────────────────────────────────

class _MainContent extends StatelessWidget {
  const _MainContent({required this.data, required this.bloc});

  final LoginData data;
  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (data.state) {
      case ScreenState.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.accent),
        );
      case ScreenState.content:
        return _LoginBody(data: data, bloc: bloc);
      default:
        return FullScreenError(
          message: data.errorMessage ?? 'An error occurred',
          onRetryTap: () => bloc.add(InitLoginEvent()),
        );
    }
  }
}

// ── Login UI ───────────────────────────────────────────────────────────────────

class _LoginBody extends StatelessWidget {
  const _LoginBody({required this.data, required this.bloc});

  final LoginData data;
  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Stack(
      children: [
        // Background grid
        Positioned.fill(child: CustomPaint(painter: _GridPainter())),
        // Glow
        Positioned(
          top: -150,
          left: -150,
          child: Container(
            width: 500,
            height: 500,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.accent.withOpacity(0.07),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        // Content
        Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isWide ? 440 : double.infinity,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _LoginHeader(),
                  const SizedBox(height: 48),
                  _LoginCard(data: data, bloc: bloc),
                ],
              ),
            ),
          ),
        ),
        // Back button
        Positioned(
          top: 16,
          left: 16,
          child: _BackButton(onTap: () => bloc.add(BackLoginEvent())),
        ),
      ],
    );
  }
}

class _LoginHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.accent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Center(
            child: Text(
              'DP',
              style: TextStyle(
                color: AppColors.bgPrimary,
                fontWeight: FontWeight.w700,
                fontSize: 22,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Text(
          'Admin Login',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            fontFamily: 'Lato',
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Sign in to manage portfolio content',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14,
            fontFamily: 'Lato',
          ),
        ),
      ],
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({required this.data, required this.bloc});

  final LoginData data;
  final LoginBloc bloc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Email field
          const Text(
            'Email',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 8),
          _EmailField(
            value: data.email,
            onChanged: (v) => bloc.add(EmailChangedEvent(v)),
          ),
          const SizedBox(height: 20),
          // Password field
          const Text(
            'Password',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontFamily: 'Lato',
            ),
          ),
          const SizedBox(height: 8),
          _PasswordField(
            value: data.password,
            isVisible: data.isPasswordVisible,
            onChanged: (v) => bloc.add(PasswordChangedEvent(v)),
            onToggle: () => bloc.add(TogglePasswordVisibilityEvent()),
            onSubmit: () => bloc.add(SubmitLoginEvent()),
          ),
          // Error message
          if (data.errorMessage != null && data.errorMessage!.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.redAccent.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      data.errorMessage!,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 28),
          // Login button
          _LoginButton(
            isLoading: data.isLoading,
            onTap: () => bloc.add(SubmitLoginEvent()),
          ),
          const SizedBox(height: 20),
          // Hint
          const Center(
            child: Text(
              'Only authorized administrators can access this panel.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final String value;
  final void Function(String) onChanged;

  const _EmailField({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      keyboardType: TextInputType.emailAddress,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontFamily: 'Lato',
      ),
      decoration: const InputDecoration(
        hintText: 'admin@example.com',
        prefixIcon: Icon(
          Icons.email_outlined,
          color: AppColors.textMuted,
          size: 18,
        ),
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final String value;
  final bool isVisible;
  final void Function(String) onChanged;
  final VoidCallback onToggle;
  final VoidCallback onSubmit;

  const _PasswordField({
    required this.value,
    required this.isVisible,
    required this.onChanged,
    required this.onToggle,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: value,
      onChanged: onChanged,
      onFieldSubmitted: (_) => onSubmit(),
      obscureText: !isVisible,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 14,
        fontFamily: 'Lato',
      ),
      decoration: InputDecoration(
        hintText: '••••••••',
        prefixIcon: const Icon(
          Icons.lock_outline_rounded,
          color: AppColors.textMuted,
          size: 18,
        ),
        suffixIcon: GestureDetector(
          onTap: onToggle,
          child: Icon(
            isVisible
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textMuted,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _LoginButton extends StatefulWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _LoginButton({required this.isLoading, required this.onTap});

  @override
  State<_LoginButton> createState() => _LoginButtonState();
}

class _LoginButtonState extends State<_LoginButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.isLoading ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 52,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _hovered
                  ? [AppColors.accentLight, AppColors.accent]
                  : [AppColors.accent, AppColors.accentDark],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Center(
            child: widget.isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      color: AppColors.bgPrimary,
                      strokeWidth: 2.5,
                    ),
                  )
                : const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Sign In',
                        style: TextStyle(
                          color: AppColors.bgPrimary,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          fontFamily: 'Lato',
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_rounded,
                        color: AppColors.bgPrimary,
                        size: 18,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BackButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.textSecondary,
          size: 20,
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 0.5;
    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
