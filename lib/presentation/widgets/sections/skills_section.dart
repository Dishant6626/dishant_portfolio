import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../data/models/portfolio_models.dart';

class SkillsSection extends StatelessWidget {
  final List<SkillCategoryModel> skills;

  const SkillsSection({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    final padding = ResponsiveUtils.getHorizontalPadding(context);
    final isMobile = ResponsiveUtils.isMobile(context);

    return Container(
      width: double.infinity,
      color: AppColors.bgSecondary,
      padding: EdgeInsets.symmetric(
        horizontal: padding,
        vertical: ResponsiveUtils.getSectionSpacing(context),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionHeader(label: '02. Skills', title: 'Technical Skills'),
          const SizedBox(height: 56),
          if (skills.isEmpty)
            const Center(
              child: Text(
                'No skills data',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          else
            _SkillsGrid(isMobile: isMobile, skills: skills),
        ],
      ),
    );
  }
}

class _SkillsGrid extends StatelessWidget {
  final bool isMobile;
  final List<SkillCategoryModel> skills;

  const _SkillsGrid({required this.isMobile, required this.skills});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        childAspectRatio: isMobile ? 2.4 : 2.0,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: skills.length,
      itemBuilder: (_, i) => _SkillCard(category: skills[i]),
    );
  }
}

class _SkillCard extends StatefulWidget {
  final SkillCategoryModel category;

  const _SkillCard({required this.category});

  @override
  State<_SkillCard> createState() => _SkillCardState();
}

class _SkillCardState extends State<_SkillCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.bgCardHover : AppColors.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withOpacity(0.4)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.accentGlow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _iconFor(widget.category.category),
                    color: AppColors.accent,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.category.category,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: widget.category.skills
                  .map((s) => _SkillTag(label: s))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(String cat) {
    switch (cat) {
      case 'Languages & Frameworks':
        return Icons.code_rounded;
      case 'State Management':
        return Icons.hub_rounded;
      case 'Database & Storage':
        return Icons.storage_rounded;
      case 'Tools & Platforms':
        return Icons.build_rounded;
      case 'Testing':
        return Icons.bug_report_rounded;
      case 'Integrations & APIs':
        return Icons.api_rounded;
      default:
        return Icons.star_rounded;
    }
  }
}

class _SkillTag extends StatelessWidget {
  final String label;

  const _SkillTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.chipBorder, width: 1),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 12,
          fontWeight: FontWeight.w500,
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
