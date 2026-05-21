// ── vBloc template ────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../../../core/base/base_bloc.dart';
import '../../../core/base/screen_state.dart';
import '../../../data/repositories/portfolio_repository.dart';
import 'home_state.dart';

class HomeBloc extends BaseBloc<HomeEvent, HomeState> {
  HomeBloc() : super(initState) {
    on<InitHomeEvent>(_initHomeEvent);
    on<UpdateHomeState>((event, emit) => emit(event.state));
  }

  static HomeState get initState =>
      const HomeState(state: ScreenState.loading, errorMessage: '');

  void _initHomeEvent(InitHomeEvent event, _) async {
    try {
      final repo = PortfolioRepository.instance;

      // First-time setup: seed Firestore with resume data
      if (await repo.isEmpty()) {
        await repo.seedInitialData();
      }
      // Load all sections in parallel — typed separately for safety
      final about = await repo.getAbout();
      final experiences = await repo.getExperiences();
      final projects = await repo.getProjects();
      final skills = await repo.getSkills();
      final achievements = await repo.getAchievements();

      add(
        UpdateHomeState(
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
      print("errorMessage::${e}");
      add(
        UpdateHomeState(
          state.copyWith(state: ScreenState.error, errorMessage: e.toString()),
        ),
      );
    }
  }
}
