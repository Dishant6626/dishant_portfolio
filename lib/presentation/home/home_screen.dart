// ── Generated from vFul live template ────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/base/base_state.dart';
import '../../core/base/screen_state.dart';
import '../../core/base/view_action.dart';
import '../../core/common/full_screen_error.dart';
import '../../core/common/full_screen_loading.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../login/login_screen.dart';
import '../widgets/common/nav_bar.dart';
import '../widgets/sections/about_section.dart';
import '../widgets/sections/contact_section.dart';
import '../widgets/sections/experience_section.dart';
import '../widgets/sections/footer_section.dart';
import '../widgets/sections/hero_section.dart';
import '../widgets/sections/projects_section.dart';
import '../widgets/sections/skills_section.dart';
import 'bloc/home_bloc.dart';
import 'bloc/home_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeBloc, HomeScreen> {
  // ── Keys for scroll-to-section ────────────────────────────────────────────
  final ScrollController _scrollController = ScrollController();
  late final Map<String, GlobalKey> _sectionKeys;

  @override
  HomeBloc createBloc() => HomeBloc();

  @override
  void initState() {
    _sectionKeys = {
      AppStrings.navAbout: GlobalKey(),
      AppStrings.navSkills: GlobalKey(),
      AppStrings.navExperience: GlobalKey(),
      AppStrings.navProjects: GlobalKey(),
      AppStrings.navContact: GlobalKey(),
    };
    super.initState(); // BaseState creates bloc and subscribes
    print("InitHomeEvent");
    bloc.add(InitHomeEvent());
  }

  void _scrollToSection(String section) {
    final key = _sectionKeys[section];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── vFul build ────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: BlocProvider<HomeBloc>(
        create: (_) => bloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (BuildContext context, HomeState data) {
            return _MainContent(
              data: data,
              bloc: bloc,
              scrollController: _scrollController,
              sectionKeys: _sectionKeys,
              onScrollToSection: _scrollToSection,
            );
          },
        ),
      ),
    );
  }

  // ── vFul onViewEvent ──────────────────────────────────────────────────────
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
      case HomeTarget.openAdmin:
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const LoginScreen()));
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
      ),
    );
  }
}

// ── _MainContent — vFul inner widget ─────────────────────────────────────────

class _MainContent extends StatelessWidget {
  const _MainContent({
    required this.data,
    required this.bloc,
    required this.scrollController,
    required this.sectionKeys,
    required this.onScrollToSection,
  });

  final HomeState data;
  final HomeBloc bloc;
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;
  final void Function(String) onScrollToSection;

  @override
  Widget build(BuildContext context) {
    switch (data.state) {
      case ScreenState.loading:
        return const FullScreenLoading(message: 'Loading portfolio...');

      case ScreenState.content:
        return _PortfolioContent(
          data: data,
          bloc: bloc,
          scrollController: scrollController,
          sectionKeys: sectionKeys,
          onScrollToSection: onScrollToSection,
        );

      default:
        return FullScreenError(
          message: data.errorMessage ?? 'An error occurred',
          onRetryTap: () => bloc.add(InitHomeEvent()),
        );
    }
  }
}

// ── Actual scrollable portfolio ───────────────────────────────────────────────

class _PortfolioContent extends StatelessWidget {
  const _PortfolioContent({
    required this.data,
    required this.bloc,
    required this.scrollController,
    required this.sectionKeys,
    required this.onScrollToSection,
  });

  final HomeState data;
  final HomeBloc bloc;
  final ScrollController scrollController;
  final Map<String, GlobalKey> sectionKeys;
  final void Function(String) onScrollToSection;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              HeroSection(
                about: data.about,
                onViewWork: () => onScrollToSection(AppStrings.navProjects),
                onContact: () => onScrollToSection(AppStrings.navContact),
              ),
              KeyedSubtree(
                key: sectionKeys[AppStrings.navAbout],
                child: AboutSection(
                  about: data.about,
                  achievements: data.achievements,
                ),
              ),
              KeyedSubtree(
                key: sectionKeys[AppStrings.navSkills],
                child: SkillsSection(skills: data.skills),
              ),
              KeyedSubtree(
                key: sectionKeys[AppStrings.navExperience],
                child: ExperienceSection(experiences: data.experiences),
              ),
              KeyedSubtree(
                key: sectionKeys[AppStrings.navProjects],
                child: ProjectsSection(projects: data.projects),
              ),
              KeyedSubtree(
                key: sectionKeys[AppStrings.navContact],
                child: ContactSection(about: data.about),
              ),
              const FooterSection(),
            ],
          ),
        ),
        // Sticky nav — long press on logo triggers login
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: PortfolioNavBar(
            scrollController: scrollController,
            sectionKeys: sectionKeys,
            onAdminLongPress: () =>
                bloc.dispatchViewEvent(NavigateScreen(HomeTarget.openAdmin)),
          ),
        ),
      ],
    );
  }
}
