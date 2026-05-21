# 🚀 Dishant Patel — Flutter Portfolio

A responsive Flutter **Web + Mobile** portfolio backed by **Firebase Firestore**.  

---

## 📐 Architecture — dp_bloc_structure pattern

Every screen follows **3-file vCtr / vBloc / vFul** structure:

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

## 🗄️ FireStore Data Structure

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


## 🔑 Admin Access

Sign in with the email/password.  
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

**Developer:** Dishant Patel · pateldishant815@gmail.com · Kheda, Gujarat
