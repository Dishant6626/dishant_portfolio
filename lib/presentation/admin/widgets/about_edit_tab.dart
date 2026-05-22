import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/models/portfolio_models.dart';
import '../bloc/admin_bloc.dart';
import '../bloc/admin_state.dart';
import 'shared_widgets.dart';

class AboutEditTab extends StatefulWidget {
  final AboutModel? about;
  final AdminBloc bloc;

  const AboutEditTab({super.key, required this.about, required this.bloc});

  @override
  State<AboutEditTab> createState() => _AboutEditTabState();
}

class _AboutEditTabState extends State<AboutEditTab> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _taglineCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _locationCtrl;
  late final TextEditingController _linkedInCtrl;
  late final TextEditingController _linkedInUrlCtrl;
  late final TextEditingController _githubUrlCtrl;
  late final TextEditingController _resumeUrlCtrl;
  late final TextEditingController _desc1Ctrl;
  late final TextEditingController _desc2Ctrl;
  late final TextEditingController _strengthsCtrl;

  // Resume upload state
  String? _pickedFileName;
  Uint8List? _pickedFileBytes;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    final a = widget.about;
    _nameCtrl = TextEditingController(text: a?.name ?? '');
    _taglineCtrl = TextEditingController(text: a?.tagline ?? '');
    _emailCtrl = TextEditingController(text: a?.email ?? '');
    _phoneCtrl = TextEditingController(text: a?.phone ?? '');
    _locationCtrl = TextEditingController(text: a?.location ?? '');
    _linkedInCtrl = TextEditingController(text: a?.linkedIn ?? '');
    _linkedInUrlCtrl = TextEditingController(text: a?.linkedInUrl ?? '');
    _githubUrlCtrl = TextEditingController(text: a?.githubUrl ?? '');
    _resumeUrlCtrl = TextEditingController(text: a?.resumeUrl ?? '');
    _desc1Ctrl = TextEditingController(text: a?.desc1 ?? '');
    _desc2Ctrl = TextEditingController(text: a?.desc2 ?? '');
    _strengthsCtrl = TextEditingController(
      text: (a?.strengths ?? []).join(', '),
    );
  }

  @override
  void dispose() {
    for (final c in [
      _nameCtrl,
      _taglineCtrl,
      _emailCtrl,
      _phoneCtrl,
      _locationCtrl,
      _linkedInCtrl,
      _linkedInUrlCtrl,
      _githubUrlCtrl,
      _resumeUrlCtrl,
      _desc1Ctrl,
      _desc2Ctrl,
      _strengthsCtrl,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  void _save() {
    final about = AboutModel(
      name: _nameCtrl.text.trim(),
      tagline: _taglineCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      location: _locationCtrl.text.trim(),
      linkedIn: _linkedInCtrl.text.trim(),
      linkedInUrl: _linkedInUrlCtrl.text.trim(),
      githubUrl: _githubUrlCtrl.text.trim(),
      resumeUrl: _resumeUrlCtrl.text.trim(),
      desc1: _desc1Ctrl.text.trim(),
      desc2: _desc2Ctrl.text.trim(),
      strengths: _strengthsCtrl.text
          .split(',')
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList(),
    );
    widget.bloc.add(SaveAboutEvent(about));
  }

  Future<void> _pickResume() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      withData: true, // required for web & to get bytes
    );
    if (result == null || result.files.isEmpty) return;
    final file = result.files.first;
    if (file.bytes == null) return;

    setState(() {
      _pickedFileName = file.name;
      _pickedFileBytes = file.bytes;
    });
  }

  void _uploadResume() {
    if (_pickedFileBytes == null || _pickedFileName == null) return;
    widget.bloc.add(SaveResumeEvent(_pickedFileBytes!, _pickedFileName!));
    setState(() {
      _pickedFileName = null;
      _pickedFileBytes = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final existingResumeUrl = widget.about?.resumeUrl ?? '';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdminSectionTitle(
              title: 'About Section',
              icon: Icons.person_rounded,
            ),
            const SizedBox(height: 24),
            _AdminCard(
              child: Column(
                children: [
                  AdminRow(
                    children: [
                      AdminField(label: 'Full Name', controller: _nameCtrl),
                      AdminField(
                        label: 'Tagline / Role',
                        controller: _taglineCtrl,
                      ),
                    ],
                  ),
                  AdminRow(
                    children: [
                      AdminField(label: 'Email', controller: _emailCtrl),
                      AdminField(label: 'Phone', controller: _phoneCtrl),
                    ],
                  ),
                  AdminRow(
                    children: [
                      AdminField(label: 'Location', controller: _locationCtrl),
                      AdminField(
                        label: 'LinkedIn Display',
                        controller: _linkedInCtrl,
                      ),
                    ],
                  ),
                  AdminRow(
                    children: [
                      AdminField(
                        label: 'LinkedIn URL',
                        controller: _linkedInUrlCtrl,
                      ),
                      AdminField(
                        label: 'GitHub URL',
                        controller: _githubUrlCtrl,
                        hint: 'https://github.com/yourhandle',
                      ),
                    ],
                  ),
                  AdminField(
                    label: 'Resume URL',
                    controller: _resumeUrlCtrl,
                    hint: 'https://resume.com/yoururl',
                  ),
                  AdminField(
                    label: 'About Description 1',
                    controller: _desc1Ctrl,
                    maxLines: 4,
                    fullWidth: true,
                  ),
                  AdminField(
                    label: 'About Description 2',
                    controller: _desc2Ctrl,
                    maxLines: 4,
                    fullWidth: true,
                  ),
                  AdminField(
                    label: 'Core Strengths (comma-separated)',
                    controller: _strengthsCtrl,
                    maxLines: 3,
                    fullWidth: true,
                    hint: 'Clean Architecture, BLoC, REST API...',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AdminSaveButton(onTap: _save),

            // ── Resume Upload Section ───────────────────────────────────────
            const SizedBox(height: 32),
            const AdminSectionTitle(
              title: 'Resume',
              icon: Icons.picture_as_pdf_rounded,
            ),
            const SizedBox(height: 16),
            _AdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Current resume status
                  if (existingResumeUrl.isNotEmpty)
                    _ResumeStatusRow(url: existingResumeUrl)
                  else
                    const _ResumeEmptyState(),

                  const SizedBox(height: 20),
                  const Divider(color: AppColors.border),
                  const SizedBox(height: 20),

                  // Pick + upload row
                  Row(
                    children: [
                      // Pick file button
                      _OutlineButton(
                        icon: Icons.upload_file_rounded,
                        label: 'Choose PDF',
                        onTap: _pickResume,
                      ),
                      const SizedBox(width: 12),

                      // Picked file name chip
                      if (_pickedFileName != null)
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: AppColors.accent.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.picture_as_pdf_rounded,
                                  size: 16,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    _pickedFileName!,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontSize: 13,
                                      fontFamily: 'Lato',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // Clear selection
                                GestureDetector(
                                  onTap: () => setState(() {
                                    _pickedFileName = null;
                                    _pickedFileBytes = null;
                                  }),
                                  child: const Icon(
                                    Icons.close_rounded,
                                    size: 16,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                        const Expanded(
                          child: Text(
                            'No file chosen',
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                              fontFamily: 'Lato',
                            ),
                          ),
                        ),

                      const SizedBox(width: 12),

                      // Upload button — only active when a file is picked
                      _UploadButton(
                        enabled: _pickedFileBytes != null,
                        onTap: _uploadResume,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Resume sub-widgets ─────────────────────────────────────────────────────────

class _ResumeStatusRow extends StatelessWidget {
  final String url;

  const _ResumeStatusRow({required this.url});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.check_circle_rounded,
            color: Colors.green,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Resume uploaded',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  fontFamily: 'Lato',
                ),
              ),
              Text(
                'A resume PDF is currently live on your portfolio.',
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontFamily: 'Lato',
                ),
              ),
            ],
          ),
        ),
        // Preview link
        GestureDetector(
          onTap: () {
            // Use url_launcher: launchUrl(Uri.parse(url))
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.border),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.open_in_new_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                SizedBox(width: 4),
                Text(
                  'Preview',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _ResumeEmptyState extends StatelessWidget {
  const _ResumeEmptyState();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.textMuted.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.picture_as_pdf_rounded,
            color: AppColors.textMuted,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'No resume uploaded',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Lato',
              ),
            ),
            Text(
              'Upload a PDF to make it available on your portfolio.',
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontFamily: 'Lato',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _OutlineButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton> {
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
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: _hovered
                ? AppColors.accent.withOpacity(0.08)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: _hovered ? AppColors.accent : AppColors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 16,
                color: _hovered ? AppColors.accent : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  color: _hovered ? AppColors.accent : AppColors.textSecondary,
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

class _UploadButton extends StatefulWidget {
  final bool enabled;
  final VoidCallback onTap;

  const _UploadButton({required this.enabled, required this.onTap});

  @override
  State<_UploadButton> createState() => _UploadButtonState();
}

class _UploadButtonState extends State<_UploadButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.enabled
                ? (_hovered
                      ? AppColors.accent.withValues(alpha: 0.85)
                      : AppColors.accent)
                : AppColors.accent.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.cloud_upload_rounded,
                size: 16,
                color: widget.enabled
                    ? AppColors.bgPrimary
                    : AppColors.bgPrimary.withValues(alpha: 0.5),
              ),
              const SizedBox(width: 6),
              Text(
                'Upload',
                style: TextStyle(
                  color: widget.enabled
                      ? AppColors.bgPrimary
                      : AppColors.bgPrimary.withValues(alpha: 0.5),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
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

class _AdminCard extends StatelessWidget {
  final Widget child;

  const _AdminCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: child,
    );
  }
}
