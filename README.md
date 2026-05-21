# 🚀 Dishant Patel — Flutter Portfolio

A responsive Flutter **Web + Mobile** portfolio backed by **Firebase Firestore**.  
Admin panel accessible via **long-press on the "DP" logo** in the navbar.

---

## 📐 Architecture — dp_bloc_structure pattern

Every screen follows your **3-file vCtr / vBloc / vFul** live-template structure:

```
presentation/
  login/
    bloc/
      login_state.dart   ← vCtr  (LoginData state + events + LoginTarget)
      login_bloc.dart    ← vBloc (extends BaseBloc, Firebase Auth)
    login_screen.dart    ← vFul  (BaseState + BlocProvider + BlocBuilder + _MainContent)

  admin/
    bloc/
      admin_state.dart   ← vCtr  (AdminData + all CRUD events)
      admin_bloc.dart    ← vBloc (Firestore CRUD via PortfolioRepository)
    admin_screen.dart    ← vFul  (4-tab admin dashboard)
    widgets/
      about_edit_tab.dart
      experience_edit_tab.dart
      project_edit_tab.dart
      skill_edit_tab.dart
      shared_widgets.dart

  home/
    bloc/
      home_state.dart    ← vCtr  (HomeState + InitHomeEvent)
      home_bloc.dart     ← vBloc (loads Firestore, seeds on first run)
    home_screen.dart     ← vFul
```

### Base classes (core/base/)

| File                | Role                                                                         |
|---------------------|------------------------------------------------------------------------------|
| `base_bloc.dart`    | Extends `Bloc`, adds `dispatchViewEvent(ViewAction)` stream                  |
| `base_state.dart`   | Abstract `State<W>` — calls `createBloc()`, subscribes to view-action stream |
| `screen_state.dart` | `enum ScreenState { loading, content, error }`                               |
| `view_action.dart`  | `NavigateScreen`, `DisplayMessage` (MessageType)                             |

---

## 🔥 Firebase Setup (required before running)

### 1. Create a Firebase project

- Go to [console.firebase.google.com](https://console.firebase.google.com)
- Create a project named `dishant-portfolio`

### 2. Enable Authentication

- Authentication → Sign-in method → **Email/Password** → Enable
- Add an admin user: Authentication → Users → Add user

### 3. Enable Firestore

- Firestore Database → Create database → **Production mode**
- Add these security rules:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Public reads for portfolio data
    match /about/{doc} { allow read: if true; allow write: if request.auth != null; }
    match /experiences/{doc} { allow read: if true; allow write: if request.auth != null; }
    match /projects/{doc} { allow read: if true; allow write: if request.auth != null; }
    match /skills/{doc} { allow read: if true; allow write: if request.auth != null; }
    match /achievements/{doc} { allow read: if true; allow write: if request.auth != null; }
  }
}
```

### 4. Generate firebase_options.dart

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

This overwrites `lib/firebase_options.dart` with your real project values.

### 5. Add Lato fonts

Download from [fonts.google.com/specimen/Lato](https://fonts.google.com/specimen/Lato) and place
in `assets/fonts/`:

- `Lato-Regular.ttf`
- `Lato-Medium.ttf`
- `Lato-Bold.ttf`

---

## 🗄️ Firestore Data Structure

```
/about           (single document)
  name, tagline, email, phone, location,
  linkedIn, linkedInUrl, desc1, desc2, strengths[]

/experiences     (collection, ordered by `order` field)
  id, company, role, duration, type,
  bullets[], isCurrent, order

/projects        (collection, ordered by `order` field)
  id, title, description, platform, tags[], role, order

/skills          (collection, ordered by `order` field)
  id, category, skills[], order

/achievements    (collection, ordered by `order` field)
  id, title, company, year, order
```

> **First run** auto-seeds Firestore with all resume data from `portfolio_models.dart`.  
> Or use **Admin → "Seed Data"** button to repopulate manually.

---

## 🔑 Admin Access

**Long-press the "DP" logo** in the navbar → Login screen opens.

Sign in with the email/password you created in Firebase Authentication.  
After login, the **Admin Panel** provides:

| Tab        | Operations                                  |
|------------|---------------------------------------------|
| About      | Edit name, tagline, bio, contact, strengths |
| Experience | Add / Edit / Delete work experience entries |
| Projects   | Add / Edit / Delete portfolio projects      |
| Skills     | Add / Edit / Delete skill categories        |

---

## 🚀 Run & Deploy

```bash
# Install deps
flutter pub get

# Run locally (Chrome)
flutter run -d chrome

# Production web build
flutter build web --release --web-renderer canvaskit

# Deploy to Firebase Hosting
firebase init hosting   # public dir = build/web, SPA = yes
flutter build web --release
firebase deploy
```

---

## 📦 Key Dependencies

| Package             | Version | Use                                |
|---------------------|---------|------------------------------------|
| `flutter_bloc`      | ^9.1.1  | BLoC state management              |
| `firebase_core`     | ^3.6.0  | Firebase init                      |
| `firebase_auth`     | ^5.3.1  | Admin login                        |
| `cloud_firestore`   | ^5.4.4  | Portfolio data storage             |
| `equatable`         | ^2.0.5  | Immutable state (copyWith pattern) |
| `get_it`            | ^9.2.0  | DI (ready for expansion)           |
| `logger`            | ^2.6.2  | Bloc-level logging                 |
| `dio`               | ^5.9.0  | HTTP (ready for expansion)         |
| `animated_text_kit` | ^4.2.2  | Hero typewriter animation          |
| `url_launcher`      | ^6.2.1  | Email / phone / LinkedIn           |

---

**Developer:** Dishant Patel · pateldishant815@gmail.com · Kheda, Gujarat
