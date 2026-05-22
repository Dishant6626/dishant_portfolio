// ── vCtr template ─────────────────────────────────────────────────────────────

import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../../../core/base/screen_state.dart';
import '../../../data/models/portfolio_models.dart';

// ── State ──────────────────────────────────────────────────────────────────────

class AdminData extends Equatable {
  final ScreenState state;
  final String? errorMessage;
  final int selectedTab;
  final bool isSaving;
  final String? successMessage;

  // Data sections
  final AboutModel? about;
  final List<ExperienceModel> experiences;
  final List<ProjectModel> projects;
  final List<SkillCategoryModel> skills;
  final List<AchievementModel> achievements;

  const AdminData({
    required this.state,
    this.errorMessage,
    this.selectedTab = 0,
    this.isSaving = false,
    this.successMessage,
    this.about,
    this.experiences = const [],
    this.projects = const [],
    this.skills = const [],
    this.achievements = const [],
  });

  AdminData copyWith({
    ScreenState? state,
    String? errorMessage,
    int? selectedTab,
    bool? isSaving,
    String? successMessage,
    AboutModel? about,
    List<ExperienceModel>? experiences,
    List<ProjectModel>? projects,
    List<SkillCategoryModel>? skills,
    List<AchievementModel>? achievements,
  }) => AdminData(
    state: state ?? this.state,
    errorMessage: errorMessage ?? this.errorMessage,
    selectedTab: selectedTab ?? this.selectedTab,
    isSaving: isSaving ?? this.isSaving,
    successMessage: successMessage,
    // explicitly nullable reset
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
    selectedTab,
    isSaving,
    successMessage,
    about,
    experiences,
    projects,
    skills,
    achievements,
  ];
}

// ── Events ─────────────────────────────────────────────────────────────────────

abstract class AdminEvent {}

class InitAdminEvent extends AdminEvent {}

class BackAdminEvent extends AdminEvent {}

class UpdateAdminState extends AdminEvent {
  final AdminData state;

  UpdateAdminState(this.state);
}

// Tab navigation
class SelectTabEvent extends AdminEvent {
  final int index;

  SelectTabEvent(this.index);
}

// ── About ──────────────────────────────────────────────────────────────────────

class SaveAboutEvent extends AdminEvent {
  final AboutModel about;

  SaveAboutEvent(this.about);
}

class SaveResumeEvent extends AdminEvent {
  final Uint8List fileBytes;
  final String fileName;

  SaveResumeEvent(this.fileBytes, this.fileName);
}

// ── Experience ─────────────────────────────────────────────────────────────────

class AddExperienceEvent extends AdminEvent {
  final ExperienceModel experience;

  AddExperienceEvent(this.experience);
}

class UpdateExperienceEvent extends AdminEvent {
  final ExperienceModel experience;

  UpdateExperienceEvent(this.experience);
}

class DeleteExperienceEvent extends AdminEvent {
  final String id;

  DeleteExperienceEvent(this.id);
}

// ── Projects ───────────────────────────────────────────────────────────────────

class AddProjectEvent extends AdminEvent {
  final ProjectModel project;

  AddProjectEvent(this.project);
}

class UpdateProjectEvent extends AdminEvent {
  final ProjectModel project;

  UpdateProjectEvent(this.project);
}

class DeleteProjectEvent extends AdminEvent {
  final String id;

  DeleteProjectEvent(this.id);
}

// ── Skills ─────────────────────────────────────────────────────────────────────

class AddSkillEvent extends AdminEvent {
  final SkillCategoryModel skill;

  AddSkillEvent(this.skill);
}

class UpdateSkillEvent extends AdminEvent {
  final SkillCategoryModel skill;

  UpdateSkillEvent(this.skill);
}

class DeleteSkillEvent extends AdminEvent {
  final String id;

  DeleteSkillEvent(this.id);
}

// ── Seed ───────────────────────────────────────────────────────────────────────

class SeedDataEvent extends AdminEvent {}

// ── Target ─────────────────────────────────────────────────────────────────────

abstract class AdminTarget {
  static const String back = 'back';
}
