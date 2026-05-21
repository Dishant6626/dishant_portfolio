// ── Generated from vCtr live template ─────────────────────────────────────────
// Note: Uses copyWith instead of built_value (no codegen required).
// Naming convention identical to template: InitHomeEvent, UpdateHomeState,
// HomeTarget.

import 'package:equatable/equatable.dart';

import '../../../core/base/screen_state.dart';
import '../../../data/models/portfolio_models.dart';

// ── State ─────────────────────────────────────────────────────────────────────

class HomeState extends Equatable {
  final ScreenState state;
  final String? errorMessage;
  final AboutModel? about;
  final List<ExperienceModel> experiences;
  final List<ProjectModel> projects;
  final List<SkillCategoryModel> skills;
  final List<AchievementModel> achievements;

  const HomeState({
    required this.state,
    this.errorMessage,
    this.about,
    this.experiences = const [],
    this.projects = const [],
    this.skills = const [],
    this.achievements = const [],
  });

  HomeState copyWith({
    ScreenState? state,
    String? errorMessage,
    AboutModel? about,
    List<ExperienceModel>? experiences,
    List<ProjectModel>? projects,
    List<SkillCategoryModel>? skills,
    List<AchievementModel>? achievements,
  }) => HomeState(
    state: state ?? this.state,
    errorMessage: errorMessage ?? this.errorMessage,
    about: about ?? this.about,
    experiences: experiences ?? this.experiences,
    projects: projects ?? this.projects,
    skills: skills ?? this.skills,
    achievements: achievements ?? this.achievements,
  );

  @override
  List<Object?> get props => [
    state,
    errorMessage,
    about,
    experiences,
    projects,
    skills,
    achievements,
  ];
}

// ── Events ────────────────────────────────────────────────────────────────────

abstract class HomeEvent {}

class InitHomeEvent extends HomeEvent {}

class UpdateHomeState extends HomeEvent {
  final HomeState state;

  UpdateHomeState(this.state);
}

// ── Target ────────────────────────────────────────────────────────────────────

abstract class HomeTarget {
  static const String openAdmin = 'openAdmin';
}
