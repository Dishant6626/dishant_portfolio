import 'package:flutter/material.dart';

class ResponsiveUtils {
  static bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 768;

  static bool isTablet(BuildContext context) =>
      MediaQuery.of(context).size.width >= 768 &&
      MediaQuery.of(context).size.width < 1024;

  static bool isDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1024;

  static bool isLargeDesktop(BuildContext context) =>
      MediaQuery.of(context).size.width >= 1440;

  static double getWidth(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double getHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static double getHorizontalPadding(BuildContext context) {
    final width = getWidth(context);
    if (width >= 1440) return (width - 1200) / 2;
    if (width >= 1024) return 80;
    if (width >= 768) return 48;
    return 24;
  }

  static double getSectionSpacing(BuildContext context) {
    if (isDesktop(context)) return 120;
    if (isTablet(context)) return 80;
    return 60;
  }
}

class Responsive extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const Responsive({
    super.key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (ResponsiveUtils.isDesktop(context)) return desktop;
    if (ResponsiveUtils.isTablet(context)) return tablet ?? desktop;
    return mobile;
  }
}
