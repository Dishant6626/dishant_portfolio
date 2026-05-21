import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../data/models/portfolio_models.dart';

class ContactSection extends StatelessWidget {
  final AboutModel? about;

  const ContactSection({super.key, required this.about});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getHorizontalPadding(context);
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: ResponsiveUtils.getSectionSpacing(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: '05. Contact', title: 'Get In Touch'),
          const SizedBox(height: 56),
          isMobile
              ? _MobileContact(about: about)
              : _DesktopContact(about: about),
        ],
      ),
    );
  }
}

class _DesktopContact extends StatelessWidget {
  final AboutModel? about;

  const _DesktopContact({required this.about});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 5, child: _ContactText(email: about?.email ?? '')),
        const SizedBox(width: 80),
        Expanded(flex: 4, child: _ContactCards(about: about)),
      ],
    );
  }
}

class _MobileContact extends StatelessWidget {
  final AboutModel? about;

  const _MobileContact({required this.about});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactText(email: about?.email ?? ''),
        const SizedBox(height: 48),
        _ContactCards(about: about),
      ],
    );
  }
}

class _ContactText extends StatelessWidget {
  final String email;

  const _ContactText({required this.email});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Whether you have a project in mind, a question, or just want to say hi — my inbox is always open.",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 16,
            height: 1.8,
          ),
        ),
        const SizedBox(height: 32),
        const Text(
          "I'm currently available for:",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 20),
        ...const [
          'Freelance Flutter / Android Projects',
          'Full-time Flutter Developer Roles',
          'Technical Consultation',
        ].map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.accent,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  item,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 36),
        if (email.isNotEmpty) _EmailButton(email: email),
      ],
    );
  }
}

class _EmailButton extends StatefulWidget {
  final String email;

  const _EmailButton({required this.email});

  @override
  State<_EmailButton> createState() => _EmailButtonState();
}

class _EmailButtonState extends State<_EmailButton> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri(scheme: 'mailto', path: widget.email);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accent, width: 1.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.email_outlined,
                color: _hovered ? AppColors.bgPrimary : AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                'Say Hello',
                style: TextStyle(
                  color: _hovered ? AppColors.bgPrimary : AppColors.accent,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContactCards extends StatelessWidget {
  final AboutModel? about;

  const _ContactCards({required this.about});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ContactInfoCard(about: about),
        const SizedBox(height: 24),
        _SocialLinksCard(linkedInUrl: about?.linkedInUrl ?? ''),
      ],
    );
  }
}

class _ContactInfoCard extends StatelessWidget {
  final AboutModel? about;

  const _ContactInfoCard({required this.about});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.contact_phone_rounded,
                color: AppColors.accent,
                size: 20,
              ),
              SizedBox(width: 10),
              Text(
                'Contact Details',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _DetailRow(
            icon: Icons.email_rounded,
            label: 'Email',
            value: about?.email ?? '',
            url: 'mailto:${about?.email ?? ''}',
          ),
          const SizedBox(height: 16),
          _DetailRow(
            icon: Icons.phone_rounded,
            label: 'Phone',
            value: about?.phone ?? '',
            url: 'tel:${about?.phone ?? ''}',
          ),
          const SizedBox(height: 16),
          _DetailRow(
            icon: Icons.location_on_rounded,
            label: 'Location',
            value: about?.location ?? '',
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? url;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.url,
  });

  @override
  State<_DetailRow> createState() => _DetailRowState();
}

class _DetailRowState extends State<_DetailRow> {
  bool _hovered = false;

  Future<void> _launch() async {
    if (widget.url == null) return;
    final uri = Uri.parse(widget.url!);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.url != null
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.accentGlow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(widget.icon, color: AppColors.accent, size: 18),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  Text(
                    widget.value,
                    style: TextStyle(
                      color: _hovered && widget.url != null
                          ? AppColors.accent
                          : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
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

class _SocialLinksCard extends StatelessWidget {
  final String linkedInUrl;

  const _SocialLinksCard({required this.linkedInUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.share_rounded, color: AppColors.accent, size: 20),
              SizedBox(width: 10),
              Text(
                'Social Links',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SocialBtn(
            icon: Icons.people_alt_rounded,
            label: 'LinkedIn',
            subtitle: 'Connect with me',
            url: linkedInUrl.isNotEmpty ? linkedInUrl : 'https://linkedin.com',
          ),
        ],
      ),
    );
  }
}

class _SocialBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final String subtitle;
  final String url;

  const _SocialBtn({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.url,
  });

  @override
  State<_SocialBtn> createState() => _SocialBtnState();
}

class _SocialBtnState extends State<_SocialBtn> {
  bool _hovered = false;

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: _launch,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.accentGlow : AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _hovered
                  ? AppColors.accent.withOpacity(0.4)
                  : AppColors.border,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: _hovered ? AppColors.accent : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.label,
                    style: TextStyle(
                      color: _hovered
                          ? AppColors.accent
                          : AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Icon(
                Icons.arrow_forward_rounded,
                size: 16,
                color: _hovered ? AppColors.accent : AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String label;
  final String title;

  const _SectionHeader({required this.label, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.accent,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 36,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(child: Container(height: 1, color: AppColors.border)),
          ],
        ),
      ],
    );
  }
}
