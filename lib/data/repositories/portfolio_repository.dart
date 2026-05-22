import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/portfolio_models.dart';

/// Centralises every Firestore read/write for portfolio data.
/// Collection structure:
///   /about          → single document
///   /experiences    → collection
///   /projects       → collection
///   /skills         → collection
///   /achievements   → collection
class PortfolioRepository {
  PortfolioRepository._();

  static final PortfolioRepository instance = PortfolioRepository._();

  final _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  // ── Collection references ─────────────────────────────────────────────────

  DocumentReference get _aboutDoc => _db.collection('portfolio').doc('about');

  CollectionReference get _experiences => _db.collection('experiences');

  CollectionReference get _projects => _db.collection('projects');

  CollectionReference get _skills => _db.collection('skills');

  CollectionReference get _achievements => _db.collection('achievements');

  // ── Reads ─────────────────────────────────────────────────────────────────

  Future<AboutModel?> getAbout() async {
    final snap = await _aboutDoc.get();
    if (!snap.exists) return null;
    return AboutModel.fromJson(snap.data() as Map<String, dynamic>);
  }

  Future<List<ExperienceModel>> getExperiences() async {
    final snap = await _experiences.orderBy('order').get();
    return snap.docs
        .map(
          (d) => ExperienceModel.fromJson(
            d.data() as Map<String, dynamic>,
            id: d.id,
          ),
        )
        .toList();
  }

  Future<List<ProjectModel>> getProjects() async {
    final snap = await _projects.orderBy('order').get();
    return snap.docs
        .map(
          (d) =>
              ProjectModel.fromJson(d.data() as Map<String, dynamic>, id: d.id),
        )
        .toList();
  }

  Future<List<SkillCategoryModel>> getSkills() async {
    final snap = await _skills.orderBy('order').get();
    return snap.docs
        .map(
          (d) => SkillCategoryModel.fromJson(
            d.data() as Map<String, dynamic>,
            id: d.id,
          ),
        )
        .toList();
  }

  Future<List<AchievementModel>> getAchievements() async {
    final snap = await _achievements.orderBy('order').get();
    return snap.docs
        .map(
          (d) => AchievementModel.fromJson(
            d.data() as Map<String, dynamic>,
            id: d.id,
          ),
        )
        .toList();
  }

  // ── About write ───────────────────────────────────────────────────────────

  Future<void> saveAbout(AboutModel about) =>
      _aboutDoc.set(about.toJson(), SetOptions(merge: true));

  // ── Resume upload ─────────────────────────────────────────────────────────
  Future<String> uploadResume(Uint8List bytes, String fileName) async {
    // Always stored at a fixed path so it overwrites the previous resume
    log('DP=> uploadResume_start');
    try {
      final ref = _storage.ref('resumes/resume.pdf');
      log('DP=> uploadResume_start1');

      await ref.putData(
        bytes,
        SettableMetadata(contentType: 'application/pdf'),
      );
      log('DP=> uploadResume_start2');

      final url = await ref.getDownloadURL();
      log('DP=> uploadResume_start3');

      // Patch only resumeUrl — leaves every other field untouched
      await _aboutDoc.update({'resumeUrl': url});
      log('DP=> uploadResume_start4');

      return url;
    } catch (e) {
      log('DP=> uploadResume_error::${e}');
    } finally {
      log('DP=> uploadResume_done::');
      return '';
    }
  }

  // ── Experience writes ─────────────────────────────────────────────────────

  Future<void> addExperience(ExperienceModel exp) =>
      _experiences.doc(exp.id.isEmpty ? null : exp.id).set(exp.toJson());

  Future<void> updateExperience(ExperienceModel exp) =>
      _experiences.doc(exp.id).update(exp.toJson());

  Future<void> deleteExperience(String id) => _experiences.doc(id).delete();

  // ── Project writes ────────────────────────────────────────────────────────

  Future<void> addProject(ProjectModel proj) =>
      _projects.doc(proj.id.isEmpty ? null : proj.id).set(proj.toJson());

  Future<void> updateProject(ProjectModel proj) =>
      _projects.doc(proj.id).update(proj.toJson());

  Future<void> deleteProject(String id) => _projects.doc(id).delete();

  // ── Skill writes ──────────────────────────────────────────────────────────

  Future<void> addSkill(SkillCategoryModel skill) =>
      _skills.doc(skill.id.isEmpty ? null : skill.id).set(skill.toJson());

  Future<void> updateSkill(SkillCategoryModel skill) =>
      _skills.doc(skill.id).update(skill.toJson());

  Future<void> deleteSkill(String id) => _skills.doc(id).delete();

  // ── Seed ─────────────────────────────────────────────────────────────────

  /// Pushes static resume data to Firestore on first-time setup.
  Future<void> seedInitialData() async {
    final batch = _db.batch();

    batch.set(_aboutDoc, AboutModel.seed.toJson());

    for (final exp in ExperienceModel.seed) {
      batch.set(_experiences.doc(exp.id), exp.toJson());
    }
    for (final proj in ProjectModel.seed) {
      batch.set(_projects.doc(proj.id), proj.toJson());
    }
    for (final skill in SkillCategoryModel.seed) {
      batch.set(_skills.doc(skill.id), skill.toJson());
    }
    for (final a in AchievementModel.seed) {
      batch.set(_achievements.doc(a.id), a.toJson());
    }

    await batch.commit();
  }

  /// Returns true if Firestore has no data yet (first-time setup).
  Future<bool> isEmpty() async {
    final snap = await _aboutDoc.get();
    return !snap.exists;
  }
}
