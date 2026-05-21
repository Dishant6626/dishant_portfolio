// ─── Portfolio Models ─────────────────────────────────────────────────────────
// All models have fromJson/toJson for Firestore + copyWith for BLoC state updates.

class AboutModel {
  final String name;
  final String tagline;
  final String email;
  final String phone;
  final String location;
  final String linkedIn;
  final String linkedInUrl;
  final String desc1;
  final String desc2;
  final List<String> strengths;

  const AboutModel({
    required this.name,
    required this.tagline,
    required this.email,
    required this.phone,
    required this.location,
    required this.linkedIn,
    required this.linkedInUrl,
    required this.desc1,
    required this.desc2,
    required this.strengths,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
    name: json['name'] ?? '',
    tagline: json['tagline'] ?? '',
    email: json['email'] ?? '',
    phone: json['phone'] ?? '',
    location: json['location'] ?? '',
    linkedIn: json['linkedIn'] ?? '',
    linkedInUrl: json['linkedInUrl'] ?? '',
    desc1: json['desc1'] ?? '',
    desc2: json['desc2'] ?? '',
    strengths: List<String>.from(json['strengths'] ?? []),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'tagline': tagline,
    'email': email,
    'phone': phone,
    'location': location,
    'linkedIn': linkedIn,
    'linkedInUrl': linkedInUrl,
    'desc1': desc1,
    'desc2': desc2,
    'strengths': strengths,
  };

  AboutModel copyWith({
    String? name,
    String? tagline,
    String? email,
    String? phone,
    String? location,
    String? linkedIn,
    String? linkedInUrl,
    String? desc1,
    String? desc2,
    List<String>? strengths,
  }) => AboutModel(
    name: name ?? this.name,
    tagline: tagline ?? this.tagline,
    email: email ?? this.email,
    phone: phone ?? this.phone,
    location: location ?? this.location,
    linkedIn: linkedIn ?? this.linkedIn,
    linkedInUrl: linkedInUrl ?? this.linkedInUrl,
    desc1: desc1 ?? this.desc1,
    desc2: desc2 ?? this.desc2,
    strengths: strengths ?? this.strengths,
  );

  /// Default data used for initial Firestore seed
  static AboutModel get seed => AboutModel(
    name: 'Dishant Patel',
    tagline: 'Flutter & Native Android Developer',
    email: 'pateldishant815@gmail.com',
    phone: '+91 9574860845',
    location: 'Kheda, Gujarat, India',
    linkedIn: 'linkedin.com/in/patel-dishant-18b3311ba',
    linkedInUrl: 'https://www.linkedin.com/in/patel-dishant-18b3311ba',
    desc1:
        'Innovative Flutter & Native Android Developer committed to delivering high-quality, scalable mobile applications. I specialize in building cross-platform solutions that combine beautiful UI with rock-solid architecture.',
    desc2:
        'With 5+ years of hands-on experience across healthcare, fintech, and sports domains, I have a proven track record of delivering mission-critical products in Agile environments. My passion lies in integrating AI features, architecting clean codebases, and shipping polished apps to production.',
    strengths: [
      'Mobile App Lifecycle',
      'State Management',
      'Clean Architecture',
      'REST API Integration',
      'AI Model Integration',
      'Agile / Scrum',
      'CI/CD Pipelines',
      'Cross-Platform UI',
    ],
  );
}

// ─────────────────────────────────────────────────────────────────────────────

class ExperienceModel {
  final String id;
  final String company;
  final String role;
  final String duration;
  final String type;
  final List<String> bullets;
  final bool isCurrent;
  final int order;

  const ExperienceModel({
    required this.id,
    required this.company,
    required this.role,
    required this.duration,
    required this.type,
    required this.bullets,
    this.isCurrent = false,
    this.order = 0,
  });

  factory ExperienceModel.fromJson(
    Map<String, dynamic> json, {
    String id = '',
  }) => ExperienceModel(
    id: id,
    company: json['company'] ?? '',
    role: json['role'] ?? '',
    duration: json['duration'] ?? '',
    type: json['type'] ?? 'Full-time',
    bullets: List<String>.from(json['bullets'] ?? []),
    isCurrent: json['isCurrent'] ?? false,
    order: json['order'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'company': company,
    'role': role,
    'duration': duration,
    'type': type,
    'bullets': bullets,
    'isCurrent': isCurrent,
    'order': order,
  };

  ExperienceModel copyWith({
    String? id,
    String? company,
    String? role,
    String? duration,
    String? type,
    List<String>? bullets,
    bool? isCurrent,
    int? order,
  }) => ExperienceModel(
    id: id ?? this.id,
    company: company ?? this.company,
    role: role ?? this.role,
    duration: duration ?? this.duration,
    type: type ?? this.type,
    bullets: bullets ?? this.bullets,
    isCurrent: isCurrent ?? this.isCurrent,
    order: order ?? this.order,
  );

  static List<ExperienceModel> get seed => [
    const ExperienceModel(
      id: 'freelance',
      company: 'Self-Employed',
      role: 'Freelance Flutter Developer',
      duration: 'Feb 2026 – Present',
      type: 'Freelance',
      isCurrent: true,
      order: 0,
      bullets: [
        'Designing and developing end-to-end Flutter applications for clients across e-commerce, health, and productivity domains.',
        'Architecting scalable app structures using Bloc and Riverpod state management patterns for robust, maintainable codebases.',
        'Integrating third-party APIs, payment gateways, and AI-driven features to deliver intelligent mobile experiences.',
        'Managing full project lifecycle — from requirements gathering and UI/UX wireframing to deployment on Play Store and App Store.',
      ],
    ),
    const ExperienceModel(
      id: 'infopulse',
      company: 'InfoPulse Technologies Pvt Ltd',
      role: 'Flutter Developer',
      duration: 'May 2025 – Nov 2025',
      type: 'Full-time',
      order: 1,
      bullets: [
        'Contributed to development and deployment of mobile and web applications using Flutter and Dart across multiple product lines.',
        'Implemented responsive mobile UI/UX using a unified Flutter codebase, maintaining clean architecture across screens.',
        'Utilized Bloc and Riverpod state management to optimize application performance and maintain clean architecture.',
        'Conducted thorough API testing with Postman, identifying and resolving issues to improve system reliability.',
      ],
    ),
    const ExperienceModel(
      id: 'inheritx',
      company: 'Inheritx Solutions Pvt Ltd',
      role: 'Software Developer',
      duration: 'Jun 2021 – May 2025',
      type: 'Full-time',
      order: 2,
      bullets: [
        'Led Flutter development for 2 production apps spanning healthcare, fintech, sports, and food inspection sectors.',
        'Spearheaded responsive cross-platform UI design for web, tablet, and mobile using a single Flutter codebase (TotalMed+).',
        'Owned API integration and state management (Provider, Bloc) for the Underwriter stock research tool.',
        'Implemented in-app purchase flows using RevenueCat on Android (Stinu), achieving seamless subscription management.',
        'Built dynamic, API-driven UI with local SQLite caching for Continuum food inspection app, improving offline reliability.',
      ],
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String platform;
  final List<String> tags;
  final String? role;
  final int order;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.platform,
    required this.tags,
    this.role,
    this.order = 0,
  });

  factory ProjectModel.fromJson(Map<String, dynamic> json, {String id = ''}) =>
      ProjectModel(
        id: id,
        title: json['title'] ?? '',
        description: json['description'] ?? '',
        platform: json['platform'] ?? '',
        tags: List<String>.from(json['tags'] ?? []),
        role: json['role'],
        order: json['order'] ?? 0,
      );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'platform': platform,
    'tags': tags,
    'role': role,
    'order': order,
  };

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? platform,
    List<String>? tags,
    String? role,
    int? order,
  }) => ProjectModel(
    id: id ?? this.id,
    title: title ?? this.title,
    description: description ?? this.description,
    platform: platform ?? this.platform,
    tags: tags ?? this.tags,
    role: role ?? this.role,
    order: order ?? this.order,
  );

  static List<ProjectModel> get seed => [
    const ProjectModel(
      id: 'totalmed',
      title: 'TotalMed+',
      description:
          'Healthcare job marketplace delivering personalized job matching and licensing integration for travel & permanent positions. Built responsive UI across web, tablet, and mobile using a single Flutter codebase.',
      platform: 'Flutter (Mobile + Web)',
      tags: ['Flutter', 'Bloc', 'REST API', 'Healthcare', 'Cross-Platform'],
      role: 'Lead Developer',
      order: 0,
    ),
    const ProjectModel(
      id: 'underwriter',
      title: 'Underwriter',
      description:
          'Next-generation stock research tool featuring AI chatbot, company comparison engine, daily market outlook, and company metrics. Led API integration, UI design, and Provider state management.',
      platform: 'Flutter',
      tags: ['Flutter', 'Provider', 'AI Chatbot', 'Fintech', 'REST API'],
      role: 'Lead Developer',
      order: 1,
    ),
    const ProjectModel(
      id: 'unboundx',
      title: 'UnboundX',
      description:
          'Stock & crypto trading platform with content creation, short video feeds, and market-oriented social features.',
      platform: 'Flutter',
      tags: ['Flutter', 'Trading', 'Crypto', 'Social Feed', 'Fintech'],
      role: 'Flutter Developer',
      order: 2,
    ),
    const ProjectModel(
      id: 'hoopdna',
      title: 'Hoop DNA',
      description:
          'Athlete performance platform enabling players to follow professional training regimens with integrated workout tracking and analytics.',
      platform: 'Flutter',
      tags: ['Flutter', 'Sports', 'Analytics', 'Workout Tracking'],
      role: 'Flutter Developer',
      order: 3,
    ),
    const ProjectModel(
      id: 'stinu',
      title: 'Stinu',
      description:
          'Stock market analysis app with global currency risk calculation. Implemented in-app purchase subscriptions using RevenueCat for seamless subscription management.',
      platform: 'Android (Java/Kotlin)',
      tags: ['Kotlin', 'Java', 'RevenueCat', 'Fintech', 'In-App Purchase'],
      role: 'Android Developer',
      order: 4,
    ),
    const ProjectModel(
      id: 'continuum',
      title: 'Continuum',
      description:
          'Food inspection app for third-party clients. Dynamic API-driven UI with local SQLite caching for offline-first data access.',
      platform: 'Android',
      tags: ['Android', 'SQLite', 'Offline-First', 'REST API'],
      role: 'Android Developer',
      order: 5,
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────

class SkillCategoryModel {
  final String id;
  final String category;
  final List<String> skills;
  final int order;

  const SkillCategoryModel({
    required this.id,
    required this.category,
    required this.skills,
    this.order = 0,
  });

  factory SkillCategoryModel.fromJson(
    Map<String, dynamic> json, {
    String id = '',
  }) => SkillCategoryModel(
    id: id,
    category: json['category'] ?? '',
    skills: List<String>.from(json['skills'] ?? []),
    order: json['order'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'category': category,
    'skills': skills,
    'order': order,
  };

  SkillCategoryModel copyWith({
    String? id,
    String? category,
    List<String>? skills,
    int? order,
  }) => SkillCategoryModel(
    id: id ?? this.id,
    category: category ?? this.category,
    skills: skills ?? this.skills,
    order: order ?? this.order,
  );

  static List<SkillCategoryModel> get seed => [
    const SkillCategoryModel(
      id: 'languages',
      category: 'Languages & Frameworks',
      skills: ['Flutter', 'Dart', 'Java', 'Kotlin', 'Android SDK'],
      order: 0,
    ),
    const SkillCategoryModel(
      id: 'state',
      category: 'State Management',
      skills: ['Bloc', 'Riverpod', 'Provider'],
      order: 1,
    ),
    const SkillCategoryModel(
      id: 'database',
      category: 'Database & Storage',
      skills: ['SQLite', 'Hive', 'Firebase Firestore', 'SharedPreferences'],
      order: 2,
    ),
    const SkillCategoryModel(
      id: 'tools',
      category: 'Tools & Platforms',
      skills: [
        'Android Studio',
        'Xcode',
        'Postman',
        'JIRA',
        'Git',
        'GitHub',
        'Bitbucket',
        'Cursor',
      ],
      order: 3,
    ),
    const SkillCategoryModel(
      id: 'testing',
      category: 'Testing',
      skills: ['Unit Testing', 'Widget Testing', 'Integration Testing'],
      order: 4,
    ),
    const SkillCategoryModel(
      id: 'integrations',
      category: 'Integrations & APIs',
      skills: [
        'RESTful APIs',
        'In-App Purchases',
        'RevenueCat',
        'AI Model Integration',
        'Firebase',
        'Payment Gateways',
      ],
      order: 5,
    ),
    const SkillCategoryModel(
      id: 'methodologies',
      category: 'Methodologies',
      skills: ['Agile', 'Scrum', 'CI/CD Pipelines', 'Clean Architecture'],
      order: 6,
    ),
  ];
}

// ─────────────────────────────────────────────────────────────────────────────

class AchievementModel {
  final String id;
  final String title;
  final String company;
  final String year;
  final int order;

  const AchievementModel({
    required this.id,
    required this.title,
    required this.company,
    required this.year,
    this.order = 0,
  });

  factory AchievementModel.fromJson(
    Map<String, dynamic> json, {
    String id = '',
  }) => AchievementModel(
    id: id,
    title: json['title'] ?? '',
    company: json['company'] ?? '',
    year: json['year'] ?? '',
    order: json['order'] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'company': company,
    'year': year,
    'order': order,
  };

  static List<AchievementModel> get seed => [
    const AchievementModel(
      id: 'team2024',
      title: 'Team of the Year',
      company: 'Inheritx Solutions Pvt Ltd',
      year: '2024',
      order: 0,
    ),
    const AchievementModel(
      id: 'stellar2023',
      title: 'Stellar Achiever Award',
      company: 'Inheritx Solutions Pvt Ltd',
      year: '2023',
      order: 1,
    ),
    const AchievementModel(
      id: 'eom2023',
      title: 'Employee of the Month',
      company: 'Inheritx Solutions Pvt Ltd',
      year: 'March 2023',
      order: 2,
    ),
  ];
}
