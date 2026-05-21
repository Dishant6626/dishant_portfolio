import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../data/models/portfolio_models.dart';

class AboutSection extends StatelessWidget {
  final AboutModel? about;
  final List<AchievementModel> achievements;

  const AboutSection({
    super.key,
    required this.about,
    required this.achievements,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    final isTablet = ResponsiveUtils.isTablet(context);
    final padding = ResponsiveUtils.getHorizontalPadding(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: ResponsiveUtils.getSectionSpacing(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: '01. About', title: 'About Me'),
          const SizedBox(height: 56),
          if (isMobile || isTablet)
            _MobileAbout(about: about, achievements: achievements)
          else
            _DesktopAbout(about: about, achievements: achievements),
        ],
      ),
    );
  }
}

class _DesktopAbout extends StatelessWidget {
  final AboutModel? about;
  final List<AchievementModel> achievements;

  const _DesktopAbout({required this.about, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: _AboutText(about: about, achievements: achievements),
        ),
        const SizedBox(width: 80),
        Expanded(flex: 4, child: _AboutCards(about: about)),
      ],
    );
  }
}

class _MobileAbout extends StatelessWidget {
  final AboutModel? about;
  final List<AchievementModel> achievements;

  const _MobileAbout({required this.about, required this.achievements});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _AboutText(about: about, achievements: achievements),
        const SizedBox(height: 48),
        _AboutCards(about: about),
      ],
    );
  }
}

class _AboutText extends StatelessWidget {
  final AboutModel? about;
  final List<AchievementModel> achievements;

  const _AboutText({required this.about, required this.achievements});

  @override
  Widget build(BuildContext context) {
    final desc1 = about?.desc1 ?? '';
    final desc2 = about?.desc2 ?? '';
    final strengths = about?.strengths ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (desc1.isNotEmpty)
          Text(
            desc1,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.8,
            ),
          ),
        if (desc2.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text(
            desc2,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.8,
            ),
          ),
        ],
        if (strengths.isNotEmpty) ...[
          const SizedBox(height: 36),
          const Text(
            'Core Strengths',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: strengths.map((s) => _StrengthChip(s)).toList(),
          ),
        ],
        if (achievements.isNotEmpty) ...[
          const SizedBox(height: 36),
          const Text(
            'Achievements',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 20),
          ...achievements.map((a) => _AchievementItem(achievement: a)),
        ],
      ],
    );
  }
}

class _StrengthChip extends StatelessWidget {
  final String label;

  const _StrengthChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.chipBorder, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.accent,
            size: 16,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementItem extends StatelessWidget {
  final AchievementModel achievement;

  const _AchievementItem({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.accentGlow,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: AppColors.accent,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '${achievement.company} · ${achievement.year}',
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutCards extends StatelessWidget {
  final AboutModel? about;

  const _AboutCards({required this.about});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _InfoCard(about: about),
        const SizedBox(height: 24),
        const _EducationCard(),
        const SizedBox(height: 24),
        const _LanguagesCard(),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final AboutModel? about;

  const _InfoCard({required this.about});

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(icon: Icons.person_rounded, label: 'Contact Info'),
          const SizedBox(height: 20),
          _InfoRow(
            icon: Icons.location_on_rounded,
            text: about?.location ?? 'Kheda, Gujarat, India',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.email_rounded,
            text: about?.email ?? 'pateldishant815@gmail.com',
          ),
          const SizedBox(height: 12),
          _InfoRow(
            icon: Icons.phone_rounded,
            text: about?.phone ?? '+91 9574860845',
          ),
          const SizedBox(height: 12),
          _InfoRow(icon: Icons.link_rounded, text: 'LinkedIn Profile'),
        ],
      ),
    );
  }
}

class _EducationCard extends StatelessWidget {
  const _EducationCard();

  @override
  Widget build(BuildContext context) {
    return const _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CardTitle(icon: Icons.school_rounded, label: 'Education'),
          SizedBox(height: 20),
          Text(
            'Bachelor of Computer Application (BCA)',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Dharmsinh Desai University, Nadiad, Gujarat',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Text(
                'Jul 2018 – May 2021',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
              Spacer(),
              Text(
                'CGPA: 6.8 / 10',
                style: TextStyle(
                  color: AppColors.accent,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LanguagesCard extends StatelessWidget {
  const _LanguagesCard();

  @override
  Widget build(BuildContext context) {
    return _Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _CardTitle(icon: Icons.language_rounded, label: 'Languages'),
          const SizedBox(height: 20),
          _LanguageRow(
            language: 'English',
            level: 'Professional',
            progress: 0.85,
          ),
          const SizedBox(height: 14),
          _LanguageRow(language: 'Hindi', level: 'Fluent', progress: 0.95),
          const SizedBox(height: 14),
          _LanguageRow(language: 'Gujarati', level: 'Native', progress: 1.0),
        ],
      ),
    );
  }
}

class _LanguageRow extends StatelessWidget {
  final String language;
  final String level;
  final double progress;

  const _LanguageRow({
    required this.language,
    required this.level,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              language,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              level,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            minHeight: 4,
          ),
        ),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;

  const _Card({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: child,
    );
  }
}

class _CardTitle extends StatelessWidget {
  final IconData icon;
  final String label;

  const _CardTitle({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.accent, size: 18),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
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
