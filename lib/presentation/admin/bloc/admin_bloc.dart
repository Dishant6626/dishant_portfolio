// ── vBloc template ────────────────────────────────────────────────────────────

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';

import '../../../core/base/base_bloc.dart';
import '../../../core/base/screen_state.dart';
import '../../../core/base/view_action.dart';
import '../../../data/repositories/portfolio_repository.dart';
import 'admin_state.dart';

class AdminBloc extends BaseBloc<AdminEvent, AdminData> {
  AdminBloc() : super(initState) {
    on<InitAdminEvent>(_initAdminEvent);
    on<BackAdminEvent>(_backAdminEvent);
    on<UpdateAdminState>((event, emit) => emit(event.state));
    on<SelectTabEvent>(_onSelectTab);
    on<SaveAboutEvent>(_onSaveAbout);
    on<AddExperienceEvent>(_onAddExperience);
    on<UpdateExperienceEvent>(_onUpdateExperience);
    on<DeleteExperienceEvent>(_onDeleteExperience);
    on<AddProjectEvent>(_onAddProject);
    on<UpdateProjectEvent>(_onUpdateProject);
    on<DeleteProjectEvent>(_onDeleteProject);
    on<AddSkillEvent>(_onAddSkill);
    on<UpdateSkillEvent>(_onUpdateSkill);
    on<DeleteSkillEvent>(_onDeleteSkill);
    on<SeedDataEvent>(_onSeedData);
  }

  static AdminData get initState =>
      const AdminData(state: ScreenState.loading, errorMessage: '');

  final _repo = PortfolioRepository.instance;
  final _log = Logger();

  // ── Init ───────────────────────────────────────────────────────────────────

  void _initAdminEvent(InitAdminEvent event, _) async {
    try {
      final about = await _repo.getAbout();
      final experiences = await _repo.getExperiences();
      final projects = await _repo.getProjects();
      final skills = await _repo.getSkills();
      final achievements = await _repo.getAchievements();

      add(
        UpdateAdminState(
          state.copyWith(
            state: ScreenState.content,
            about: about,
            experiences: experiences,
            projects: projects,
            skills: skills,
            achievements: achievements,
          ),
        ),
      );
    } catch (e) {
      _log.e('Admin init error: $e');
      add(
        UpdateAdminState(
          state.copyWith(state: ScreenState.error, errorMessage: e.toString()),
        ),
      );
    }
  }

  // ── Back / Logout ──────────────────────────────────────────────────────────

  void _backAdminEvent(BackAdminEvent event, _) async {
    await FirebaseAuth.instance.signOut();
    dispatchViewEvent(NavigateScreen(AdminTarget.back));
  }

  // ── Tab ────────────────────────────────────────────────────────────────────

  void _onSelectTab(SelectTabEvent event, _) {
    add(UpdateAdminState(state.copyWith(selectedTab: event.index)));
  }

  // ── About ──────────────────────────────────────────────────────────────────

  void _onSaveAbout(SaveAboutEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.saveAbout(event.about);
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            about: event.about,
            successMessage: 'About section updated!',
          ),
        ),
      );
    } catch (e) {
      _log.e('Save about error: $e');
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: 'Failed to save: $e'),
        ),
      );
    }
  }

  // ── Experience ─────────────────────────────────────────────────────────────

  void _onAddExperience(AddExperienceEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.addExperience(event.experience);
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            experiences: [...state.experiences, event.experience],
            successMessage: 'Experience added!',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  void _onUpdateExperience(UpdateExperienceEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.updateExperience(event.experience);
      final updated = state.experiences
          .map((e) => e.id == event.experience.id ? event.experience : e)
          .toList();
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            experiences: updated,
            successMessage: 'Experience updated!',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  void _onDeleteExperience(DeleteExperienceEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.deleteExperience(event.id);
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            experiences: state.experiences
                .where((e) => e.id != event.id)
                .toList(),
            successMessage: 'Experience deleted.',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  // ── Projects ───────────────────────────────────────────────────────────────

  void _onAddProject(AddProjectEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.addProject(event.project);
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            projects: [...state.projects, event.project],
            successMessage: 'Project added!',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  void _onUpdateProject(UpdateProjectEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.updateProject(event.project);
      final updated = state.projects
          .map((p) => p.id == event.project.id ? event.project : p)
          .toList();
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            projects: updated,
            successMessage: 'Project updated!',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  void _onDeleteProject(DeleteProjectEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.deleteProject(event.id);
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            projects: state.projects.where((p) => p.id != event.id).toList(),
            successMessage: 'Project deleted.',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  // ── Skills ─────────────────────────────────────────────────────────────────

  void _onAddSkill(AddSkillEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.addSkill(event.skill);
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            skills: [...state.skills, event.skill],
            successMessage: 'Skill category added!',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  void _onUpdateSkill(UpdateSkillEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.updateSkill(event.skill);
      final updated = state.skills
          .map((s) => s.id == event.skill.id ? event.skill : s)
          .toList();
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            skills: updated,
            successMessage: 'Skill updated!',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  void _onDeleteSkill(DeleteSkillEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true)));
    try {
      await _repo.deleteSkill(event.id);
      add(
        UpdateAdminState(
          state.copyWith(
            isSaving: false,
            skills: state.skills.where((s) => s.id != event.id).toList(),
            successMessage: 'Skill deleted.',
          ),
        ),
      );
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }

  // ── Seed ───────────────────────────────────────────────────────────────────

  void _onSeedData(SeedDataEvent event, _) async {
    add(UpdateAdminState(state.copyWith(isSaving: true, successMessage: null)));
    try {
      await _repo.seedInitialData();
      add(InitAdminEvent()); // reload all data after seed
    } catch (e) {
      add(
        UpdateAdminState(
          state.copyWith(isSaving: false, errorMessage: e.toString()),
        ),
      );
    }
  }
}
