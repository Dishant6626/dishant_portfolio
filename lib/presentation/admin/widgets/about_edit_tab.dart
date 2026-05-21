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
  late final TextEditingController _desc1Ctrl;
  late final TextEditingController _desc2Ctrl;
  late final TextEditingController _strengthsCtrl;

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

  @override
  Widget build(BuildContext context) {
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
                  AdminField(
                    label: 'LinkedIn URL',
                    controller: _linkedInUrlCtrl,
                    fullWidth: true,
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
          ],
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
