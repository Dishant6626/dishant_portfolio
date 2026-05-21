import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/portfolio_models.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_state.dart';
import 'shared_widgets.dart';

class ProjectEditTab extends StatelessWidget {
  final List<ProjectModel> projects;
  final AdminBloc bloc;

  const ProjectEditTab({super.key, required this.projects, required this.bloc});

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
                    title: 'Projects',
                    icon: Icons.folder_rounded,
                  ),
                ),
                AdminAddButton(
                  label: 'Add Project',
                  onTap: () => _showEditDialog(context, null),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (projects.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No projects yet. Add one!',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              )
            else
              ...projects.map(
                (proj) => AdminItemCard(
                  title: proj.title,
                  subtitle: proj.platform,
                  onEdit: () => _showEditDialog(context, proj),
                  onDelete: () async {
                    if (await showDeleteConfirm(context, proj.title)) {
                      bloc.add(DeleteProjectEvent(proj.id));
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, ProjectModel? existing) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ProjectDialog(
        existing: existing,
        onSave: (proj) {
          if (existing == null) {
            bloc.add(AddProjectEvent(proj));
          } else {
            bloc.add(UpdateProjectEvent(proj));
          }
        },
      ),
    );
  }
}

class _ProjectDialog extends StatefulWidget {
  final ProjectModel? existing;
  final void Function(ProjectModel) onSave;

  const _ProjectDialog({required this.existing, required this.onSave});

  @override
  State<_ProjectDialog> createState() => _ProjectDialogState();
}

class _ProjectDialogState extends State<_ProjectDialog> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _platformCtrl;
  late final TextEditingController _tagsCtrl;
  late final TextEditingController _roleCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.existing;
    _idCtrl = TextEditingController(text: p?.id ?? '');
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _platformCtrl = TextEditingController(text: p?.platform ?? '');
    _tagsCtrl = TextEditingController(text: (p?.tags ?? []).join(', '));
    _roleCtrl = TextEditingController(text: p?.role ?? '');
  }

  @override
  void dispose() {
    for (final c in [
      _idCtrl,
      _titleCtrl,
      _descCtrl,
      _platformCtrl,
      _tagsCtrl,
      _roleCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final proj = ProjectModel(
      id: _idCtrl.text.trim().isNotEmpty
          ? _idCtrl.text.trim()
          : DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleCtrl.text.trim(),
      description: _descCtrl.text.trim(),
      platform: _platformCtrl.text.trim(),
      tags: _tagsCtrl.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      role: _roleCtrl.text.trim().isNotEmpty ? _roleCtrl.text.trim() : null,
    );
    widget.onSave(proj);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _DialogWrapper(
      title: widget.existing == null ? 'Add Project' : 'Edit Project',
      onSave: _save,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminRow(
            children: [
              AdminField(
                label: 'Document ID',
                controller: _idCtrl,
                hint: 'e.g. totalmed',
              ),
              AdminField(label: 'Title', controller: _titleCtrl),
            ],
          ),
          AdminField(
            label: 'Platform',
            controller: _platformCtrl,
            fullWidth: true,
            hint: 'Flutter (Mobile + Web)',
          ),
          AdminField(
            label: 'Description',
            controller: _descCtrl,
            maxLines: 4,
            fullWidth: true,
          ),
          AdminField(
            label: 'Tags (comma-separated)',
            controller: _tagsCtrl,
            fullWidth: true,
            hint: 'Flutter, Bloc, REST API',
          ),
          AdminField(
            label: 'Your Role',
            controller: _roleCtrl,
            fullWidth: true,
            hint: 'Lead Developer',
          ),
        ],
      ),
    );
  }
}

class _DialogWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;

  const _DialogWrapper({
    required this.title,
    required this.child,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.bgSecondary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520, maxHeight: 580),
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
                    title,
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
                child: child,
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
                  AdminSaveButton(onTap: onSave),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
