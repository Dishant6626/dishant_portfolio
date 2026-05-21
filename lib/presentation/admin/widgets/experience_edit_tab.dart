import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/portfolio_models.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_state.dart';
import 'shared_widgets.dart';

class ExperienceEditTab extends StatelessWidget {
  final List<ExperienceModel> experiences;
  final AdminBloc bloc;

  const ExperienceEditTab({
    super.key,
    required this.experiences,
    required this.bloc,
  });

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
                    title: 'Work Experience',
                    icon: Icons.work_rounded,
                  ),
                ),
                AdminAddButton(
                  label: 'Add Experience',
                  onTap: () => _showEditDialog(context, null),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (experiences.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40),
                  child: Text(
                    'No experiences yet. Add one!',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontFamily: 'Lato',
                    ),
                  ),
                ),
              )
            else
              ...experiences.map(
                (exp) => AdminItemCard(
                  title: exp.role,
                  subtitle: '${exp.company} · ${exp.duration}',
                  trailing: exp.isCurrent
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.accentGlow,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Current',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 10,
                              fontFamily: 'Lato',
                            ),
                          ),
                        )
                      : null,
                  onEdit: () => _showEditDialog(context, exp),
                  onDelete: () async {
                    if (await showDeleteConfirm(context, exp.role)) {
                      bloc.add(DeleteExperienceEvent(exp.id));
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, ExperienceModel? existing) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _ExperienceDialog(
        existing: existing,
        onSave: (exp) {
          if (existing == null) {
            bloc.add(AddExperienceEvent(exp));
          } else {
            bloc.add(UpdateExperienceEvent(exp));
          }
        },
      ),
    );
  }
}

class _ExperienceDialog extends StatefulWidget {
  final ExperienceModel? existing;
  final void Function(ExperienceModel) onSave;

  const _ExperienceDialog({required this.existing, required this.onSave});

  @override
  State<_ExperienceDialog> createState() => _ExperienceDialogState();
}

class _ExperienceDialogState extends State<_ExperienceDialog> {
  late final TextEditingController _idCtrl;
  late final TextEditingController _companyCtrl;
  late final TextEditingController _roleCtrl;
  late final TextEditingController _durationCtrl;
  late final TextEditingController _typeCtrl;
  late final TextEditingController _bulletsCtrl;
  late bool _isCurrent;
  late int _order;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _idCtrl = TextEditingController(text: e?.id ?? '');
    _companyCtrl = TextEditingController(text: e?.company ?? '');
    _roleCtrl = TextEditingController(text: e?.role ?? '');
    _durationCtrl = TextEditingController(text: e?.duration ?? '');
    _typeCtrl = TextEditingController(text: e?.type ?? 'Full-time');
    _bulletsCtrl = TextEditingController(text: (e?.bullets ?? []).join('\n'));
    _isCurrent = e?.isCurrent ?? false;
    _order = e?.order ?? 0;
  }

  @override
  void dispose() {
    for (final c in [
      _idCtrl,
      _companyCtrl,
      _roleCtrl,
      _durationCtrl,
      _typeCtrl,
      _bulletsCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final exp = ExperienceModel(
      id: _idCtrl.text.trim().isNotEmpty
          ? _idCtrl.text.trim()
          : DateTime.now().millisecondsSinceEpoch.toString(),
      company: _companyCtrl.text.trim(),
      role: _roleCtrl.text.trim(),
      duration: _durationCtrl.text.trim(),
      type: _typeCtrl.text.trim(),
      bullets: _bulletsCtrl.text
          .split('\n')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
      isCurrent: _isCurrent,
      order: _order,
    );
    widget.onSave(exp);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return _AdminDialog(
      title: widget.existing == null ? 'Add Experience' : 'Edit Experience',
      onSave: _save,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AdminRow(
            children: [
              AdminField(
                label: 'Document ID',
                controller: _idCtrl,
                hint: 'e.g. freelance',
              ),
              AdminField(
                label: 'Order',
                controller: TextEditingController(text: _order.toString())
                  ..addListener(() {}),
              ),
            ],
          ),
          AdminRow(
            children: [
              AdminField(label: 'Role', controller: _roleCtrl),
              AdminField(label: 'Company', controller: _companyCtrl),
            ],
          ),
          AdminRow(
            children: [
              AdminField(
                label: 'Duration',
                controller: _durationCtrl,
                hint: 'Jun 2021 – May 2025',
              ),
              AdminField(
                label: 'Type',
                controller: _typeCtrl,
                hint: 'Full-time / Freelance',
              ),
            ],
          ),
          Row(
            children: [
              Switch(
                value: _isCurrent,
                activeColor: AppColors.accent,
                onChanged: (v) => setState(() => _isCurrent = v),
              ),
              const SizedBox(width: 8),
              const Text(
                'Current Position',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontFamily: 'Lato',
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          AdminField(
            label: 'Bullet Points (one per line)',
            controller: _bulletsCtrl,
            maxLines: 6,
            fullWidth: true,
          ),
        ],
      ),
    );
  }
}

// ── Shared admin dialog wrapper ───────────────────────────────────────────────

class _AdminDialog extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;

  const _AdminDialog({
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
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
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
            // Body
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: child,
              ),
            ),
            // Footer
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
