// ── vFul template ─────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/base/base_state.dart';
import '../../core/base/screen_state.dart';
import '../../core/base/view_action.dart';
import '../../core/common/full_screen_error.dart';
import '../../core/common/full_screen_loading.dart';
import '../../core/constants/app_colors.dart';
import 'bloc/admin_bloc.dart';
import 'bloc/admin_state.dart';
import 'widgets/about_edit_tab.dart';
import 'widgets/experience_edit_tab.dart';
import 'widgets/project_edit_tab.dart';
import 'widgets/skill_edit_tab.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends BaseState<AdminBloc, AdminScreen> {
  @override
  AdminBloc createBloc() => AdminBloc();

  @override
  void initState() {
    super.initState();
    bloc.add(InitAdminEvent());
  }

  // ── vFul build ─────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocProvider<AdminBloc>(
        create: (_) => bloc,
        child: BlocBuilder<AdminBloc, AdminData>(
          builder: (BuildContext context, AdminData data) {
            return _MainContent(data: data, bloc: bloc);
          },
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
      case AdminTarget.back:
        Navigator.of(context).pop();
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

  final AdminData data;
  final AdminBloc bloc;

  @override
  Widget build(BuildContext context) {
    switch (data.state) {
      case ScreenState.loading:
        return const FullScreenLoading(message: 'Loading admin panel...');
      case ScreenState.content:
        return _AdminBody(data: data, bloc: bloc);
      default:
        return FullScreenError(
          message: data.errorMessage ?? 'An error occurred',
          onRetryTap: () => bloc.add(InitAdminEvent()),
        );
    }
  }
}

// ── Admin Body ────────────────────────────────────────────────────────────────

class _AdminBody extends StatelessWidget {
  const _AdminBody({required this.data, required this.bloc});

  final AdminData data;
  final AdminBloc bloc;

  static const _tabs = ['About', 'Experience', 'Projects', 'Skills'];

  @override
  Widget build(BuildContext context) {
    // Show success/error banner if set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (data.successMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data.successMessage!),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      if (data.errorMessage != null && data.errorMessage!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data.errorMessage!),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    return Column(
      children: [
        _AdminAppBar(bloc: bloc, isSaving: data.isSaving),
        // Tabs
        Container(
          color: AppColors.bgSecondary,
          child: Row(
            children: _tabs.asMap().entries.map((e) {
              final isSelected = data.selectedTab == e.key;
              return GestureDetector(
                onTap: () => bloc.add(SelectTabEvent(e.key)),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isSelected
                            ? AppColors.accent
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    e.value,
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontWeight: isSelected
                          ? FontWeight.w700
                          : FontWeight.w400,
                      fontSize: 14,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const Divider(color: AppColors.border, height: 1),
        // Tab content
        Expanded(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _TabContent(
              key: ValueKey(data.selectedTab),
              tabIndex: data.selectedTab,
              data: data,
              bloc: bloc,
            ),
          ),
        ),
      ],
    );
  }
}

class _AdminAppBar extends StatelessWidget {
  final AdminBloc bloc;
  final bool isSaving;

  const _AdminAppBar({required this.bloc, required this.isSaving});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      color: AppColors.bgSecondary,
      child: Row(
        children: [
          // Logo
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Text(
                'DP',
                style: TextStyle(
                  color: AppColors.bgPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  fontFamily: 'Lato',
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Portfolio Admin',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    fontFamily: 'Lato',
                  ),
                ),
                Text(
                  'Manage your portfolio content',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
          if (isSaving) ...[
            const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                color: AppColors.accent,
                strokeWidth: 2,
              ),
            ),
            const SizedBox(width: 12),
          ],
          // Logout
          _LogoutButton(onTap: () => bloc.add(BackAdminEvent())),
        ],
      ),
    );
  }
}

class _LogoutButton extends StatefulWidget {
  final VoidCallback onTap;

  const _LogoutButton({required this.onTap});

  @override
  State<_LogoutButton> createState() => _LogoutButtonState();
}

class _LogoutButtonState extends State<_LogoutButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered
                ? Colors.redAccent.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered
                  ? Colors.redAccent.withOpacity(0.5)
                  : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.logout_rounded,
                size: 16,
                color: _hovered ? Colors.redAccent : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Logout',
                style: TextStyle(
                  color: _hovered ? Colors.redAccent : AppColors.textSecondary,
                  fontSize: 13,
                  fontFamily: 'Lato',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabContent extends StatelessWidget {
  final int tabIndex;
  final AdminData data;
  final AdminBloc bloc;

  const _TabContent({
    super.key,
    required this.tabIndex,
    required this.data,
    required this.bloc,
  });

  @override
  Widget build(BuildContext context) {
    switch (tabIndex) {
      case 0:
        return AboutEditTab(about: data.about, bloc: bloc);
      case 1:
        return ExperienceEditTab(experiences: data.experiences, bloc: bloc);
      case 2:
        return ProjectEditTab(projects: data.projects, bloc: bloc);
      case 3:
        return SkillEditTab(skills: data.skills, bloc: bloc);
      default:
        return const SizedBox.shrink();
    }
  }
}
