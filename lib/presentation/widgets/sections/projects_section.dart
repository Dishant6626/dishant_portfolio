import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/responsive_utils.dart';
import '../../../data/models/portfolio_models.dart';

class ProjectsSection extends StatelessWidget {
  final List<ProjectModel> projects;

  const ProjectsSection({super.key, required this.projects});

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
          const _SectionHeader(
            label: '04. Projects',
            title: 'Featured Projects',
          ),
          const SizedBox(height: 56),
          if (projects.isEmpty)
            const Center(
              child: Text(
                'No projects data',
                style: TextStyle(color: AppColors.textMuted),
              ),
            )
          else
            _ProjectsGrid(isMobile: isMobile, projects: projects),
        ],
      ),
    );
  }
}

class _ProjectsGrid extends StatelessWidget {
  final bool isMobile;
  final List<ProjectModel> projects;

  const _ProjectsGrid({required this.isMobile, required this.projects});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Column(
        children: projects
            .mapIndexed(
              (i, p) => Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: _ProjectCard(
                  project: p,
                  featured: i == 0,
                  isMobile: isMobile,
                ),
              ),
            )
            .toList(),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.5,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
      ),
      itemCount: projects.length,
      itemBuilder: (_, i) => _ProjectCard(
        project: projects[i],
        featured: i == 0,
        isMobile: isMobile,
      ),
    );
  }
}

class _ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final bool featured;
  final bool isMobile;

  const _ProjectCard({
    required this.project,
    required this.featured,
    required this.isMobile,
  });

  @override
  State<_ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<_ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.bgCardHover : AppColors.bgCard,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered
                ? AppColors.accent.withOpacity(0.5)
                : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.accent.withOpacity(0.08),
                    blurRadius: 24,
                    spreadRadius: 4,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: widget.isMobile ? MainAxisSize.min : MainAxisSize.max,
            children: [
              // Accent bar
              Container(
                height: 6,
                decoration: BoxDecoration(
                  gradient: widget.featured
                      ? AppColors.accentGradient
                      : LinearGradient(
                          colors: [
                            AppColors.border,
                            AppColors.border.withOpacity(0.3),
                          ],
                        ),
                ),
              ),
              // Body
              widget.isMobile
                  ? Padding(
                      // ← mobile: no Expanded, wraps freely
                      padding: const EdgeInsets.all(24),
                      child: _CardBody(project: widget.project, isMobile: true),
                    )
                  : Expanded(
                      // ← desktop: fills GridView cell height
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: _CardBody(
                          project: widget.project,
                          isMobile: false,
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CardBody extends StatelessWidget {
  final ProjectModel project;
  final bool isMobile;

  const _CardBody({required this.project, required this.isMobile});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Text(
          project.title,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            const Icon(
              Icons.devices_rounded,
              size: 13,
              color: AppColors.accent,
            ),
            const SizedBox(width: 6),
            Text(
              project.platform,
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Description — Expanded only on desktop
        isMobile
            ? Text(
                project.description,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.6,
                ),
              )
            : Expanded(
                child: Text(
                  project.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.6,
                  ),
                  overflow: TextOverflow.fade,
                ),
              ),

        const SizedBox(height: 16),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: project.tags.map((t) => _TagChip(t)).toList(),
        ),
        if (project.role != null) ...[
          const SizedBox(height: 12),
          const Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(
                Icons.badge_rounded,
                size: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(
                project.role!,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;

  const _TagChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.chipBg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.chipBorder),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: AppColors.accent,
          fontSize: 11,
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
