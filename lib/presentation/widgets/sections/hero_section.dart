import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../data/models/portfolio_models.dart';

class HeroSection extends StatelessWidget {
  final AboutModel? about;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const HeroSection({
    super.key,
    required this.about,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final padding = ResponsiveUtils.getHorizontalPadding(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: Stack(
        children: [
          const _GridBackground(),
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.accent.withOpacity(0.08),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                _HeroContent(
                  isMobile: isMobile,
                  about: about,
                  onViewWork: onViewWork,
                  onContact: onContact,
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroContent extends StatelessWidget {
  final bool isMobile;
  final AboutModel? about;
  final VoidCallback onViewWork;
  final VoidCallback onContact;

  const _HeroContent({
    required this.isMobile,
    required this.about,
    required this.onViewWork,
    required this.onContact,
  });

  @override
  Widget build(BuildContext context) {
    final name = about?.name ?? 'Dishant Patel';
    final tagline = about?.tagline ?? 'Flutter & Native Android Developer';
    final desc = about?.desc1 ?? '';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.accentGlow,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.accent.withOpacity(0.4),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Available for Freelance',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Hi, I'm",
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            fontWeight: FontWeight.w400,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '$name.',
          style: TextStyle(
            fontSize: isMobile ? 44 : 72,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
            letterSpacing: isMobile ? -1 : -3,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text(
              'I build ',
              style: TextStyle(
                fontSize: isMobile ? 22 : 32,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
            AnimatedTextKit(
              repeatForever: true,
              animatedTexts: [
                TyperAnimatedText(
                  'Flutter apps.',
                  textStyle: TextStyle(
                    fontSize: isMobile ? 22 : 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                  speed: const Duration(milliseconds: 80),
                ),
                TyperAnimatedText(
                  'Android apps.',
                  textStyle: TextStyle(
                    fontSize: isMobile ? 22 : 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                  speed: const Duration(milliseconds: 80),
                ),
                TyperAnimatedText(
                  'great UI.',
                  textStyle: TextStyle(
                    fontSize: isMobile ? 22 : 32,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                  speed: const Duration(milliseconds: 80),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Text(
            tagline,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textSecondary,
              height: 1.7,
            ),
          ),
        ),
        if (desc.isNotEmpty) ...[
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              desc,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.7,
              ),
            ),
          ),
        ],
        const SizedBox(height: 40),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _PrimaryButton(label: 'View My Work', onTap: onViewWork),
            _SecondaryButton(label: 'Get In Touch', onTap: onContact),
            if (about != null && about!.resumeUrl.isNotEmpty)
              _ResumeCard(resumeUrl: about!.resumeUrl),
          ],
        ),
        const SizedBox(height: 48),
        const Wrap(
          spacing: 40,
          runSpacing: 24,
          children: [
            _StatItem(value: '5', label: 'Years Experience'),
            _StatItem(value: '10+', label: 'Projects Delivered'),
            _StatItem(value: '3', label: 'Awards Won'),
          ],
        ),
      ],
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            gradient: _hovered
                ? const LinearGradient(
                    colors: [AppColors.accentLight, AppColors.accent],
                  )
                : const LinearGradient(
                    colors: [AppColors.accent, AppColors.accentDark],
                  ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: _hovered
                ? [
                    BoxShadow(
                      color: AppColors.accent.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: const TextStyle(
                  color: AppColors.bgPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_downward_rounded,
                color: AppColors.bgPrimary,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.onTap});

  @override
  State<_SecondaryButton> createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<_SecondaryButton> {
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
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.bgCard : AppColors.bgSecondary,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.border, width: 1.5),
          ),
          child: Text(
            widget.label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 15,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (b) => const LinearGradient(
            colors: [AppColors.accent, AppColors.accentLight],
          ).createShader(b),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

class _GridBackground extends StatelessWidget {
  const _GridBackground();

  @override
  Widget build(BuildContext context) =>
      Positioned.fill(child: CustomPaint(painter: _GridPainter()));
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.border.withOpacity(0.3)
      ..strokeWidth = 0.5;
    const spacing = 50.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ResumeCard extends StatelessWidget {
  final String resumeUrl;

  const _ResumeCard({required this.resumeUrl});

  Future<void> _preview() async {
    await launchUrl(Uri.parse(resumeUrl), mode: LaunchMode.externalApplication);
  }

  Future<void> _download() async {
    // Forces download by appending ?dl=1 — works with Firebase Storage URLs
    // If your URL doesn't support this, launchUrl still works as fallback
    final downloadUri = Uri.parse('$resumeUrl&dl=1');
    await launchUrl(downloadUri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // PDF icon
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.picture_as_pdf_rounded,
              color: AppColors.accent,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),

          // Label
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Resume',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Lato',
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Open & download via Google Drive',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    fontFamily: 'Lato',
                  ),
                ),
              ],
            ),
          ),

          // ── Action buttons ─────────────────────────────────────
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ResumeActionBtn(
                icon: Icons.open_in_new_rounded,
                label: 'View Resume',
                onTap: _preview,
                filled: true, // accent-filled for the primary action
              ),
              // const SizedBox(width: 8),
              // _ResumeActionBtn(
              //   icon: Icons.download_rounded,
              //   label: 'Download',
              //   onTap: _download,
              //   filled: true, // accent-filled for the primary action
              // ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ResumeActionBtn extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool filled;

  const _ResumeActionBtn({
    required this.icon,
    required this.label,
    required this.onTap,
    this.filled = false,
  });

  @override
  State<_ResumeActionBtn> createState() => _ResumeActionBtnState();
}

class _ResumeActionBtnState extends State<_ResumeActionBtn> {
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: widget.filled
                ? (_hovered
                      ? AppColors.accent.withValues(alpha: 0.85)
                      : AppColors.accent)
                : (_hovered
                      ? AppColors.accent.withValues(alpha: 0.08)
                      : Colors.transparent),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: widget.filled
                  ? AppColors.accent
                  : (_hovered ? AppColors.accent : AppColors.border),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                size: 14,
                color: widget.filled
                    ? AppColors.bgPrimary
                    : (_hovered ? AppColors.accent : AppColors.textSecondary),
              ),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Lato',
                  color: widget.filled
                      ? AppColors.bgPrimary
                      : (_hovered ? AppColors.accent : AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
