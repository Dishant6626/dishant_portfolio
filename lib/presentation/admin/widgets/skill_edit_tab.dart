import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/portfolio_models.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_state.dart';
import 'shared_widgets.dart';

class SkillEditTab extends StatelessWidget {
  final List<SkillCategoryModel> skills;
  final AdminBloc bloc;

  const SkillEditTab({super.key, required this.skills, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Expanded(
                  child: AdminSectionTitle(
                    title: 'Skills',
                    icon: Icons.code_rounded,
                  ),
                ),
                AdminAddButton(
                  label: 'Add Category',
                  onTap: () => _showEditDialog(context, null),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (skills.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No skills yet.',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              )
            else
              ...skills.map(
                (s) => AdminItemCard(
                  title: s.category,
                  subtitle: s.skills.join(', '),
                  onEdit: () => _showEditDialog(context, s),
                  onDelete: () async {
                    if (await showDeleteConfirm(context, s.category)) {
                      bloc.add(DeleteSkillEvent(s.id));
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, SkillCategoryModel? existing) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _SkillDialog(
        existing: existing,
        onSave: (s) {
          if (existing == null) {
            bloc.add(AddSkillEvent(s));
          } else {
            bloc.add(UpdateSkillEvent(s));
          }
        },
      ),
    );
  }
}

class _SkillDialog extends StatefulWidget {
  final SkillCategoryModel? existing;
  final void Function(SkillCategoryModel) onSave;

  const _SkillDialog({required this.existing, required this.onSave});

  @override
  State<_SkillDialog> createState() => _SkillDialogState();
}

class _SkillDialogState extends State<_SkillDialog> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _categoryCtrl;
  late final TextEditingController _skillsCtrl;

  @override
  void initState() {
    super.initState();
    final s = widget.existing;
    _idCtrl = TextEditingController(text: s?.id ?? '');
    _categoryCtrl = TextEditingController(text: s?.category ?? '');
    _skillsCtrl = TextEditingController(text: (s?.skills ?? []).join(', '));
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    _categoryCtrl.dispose();
    _skillsCtrl.dispose();
    super.dispose();
  }

  void _save() {
    final skill = SkillCategoryModel(
      id: _idCtrl.text.trim().isNotEmpty
          ? _idCtrl.text.trim()
          : DateTime.now().millisecondsSinceEpoch.toString(),
      category: _categoryCtrl.text.trim(),
      skills: _skillsCtrl.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
    );
    widget.onSave(skill);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Text(
                    widget.existing == null
                        ? 'Add Skill Category'
                        : 'Edit Skill Category',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      fontFamily: 'Lato',
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close_rounded,
                      color: AppColors.textMuted,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AdminRow(
                      children: [
                        AdminField(
                          label: 'Document ID',
                          controller: _idCtrl,
                          hint: 'e.g. languages',
                        ),
                        AdminField(
                          label: 'Category Name',
                          controller: _categoryCtrl,
                        ),
                      ],
                    ),
                    AdminField(
                      label: 'Skills (comma-separated)',
                      controller: _skillsCtrl,
                      maxLines: 3,
                      fullWidth: true,
                      hint: 'Flutter, Dart, Kotlin',
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancel',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Lato',
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AdminSaveButton(onTap: _save),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
