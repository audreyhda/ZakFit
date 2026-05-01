# 💪 ZakFit

> **A full-stack iOS app for tracking fitness and nutrition — with meal logging, activity tracking, progress charts, and JWT-secured sync across devices.**

*La forme, c'est pas sorcier, c'est Zak !*

---

## 📌 Problem Statement

Fitness and nutrition apps often suffer from the same core problems: data fragmentation across devices, rigid tracking that doesn't adapt to individual needs, and a lack of clear visual feedback on progress. ZakFit addresses this by centralising all user data in a MySQL database accessible via a Vapor API — so whether you switch phones, log out, or come back weeks later, everything is exactly where you left it. Tracking meals, activities, and goals is fast and intuitive, and progress is visualised through charts that make it easy to understand at a glance.

---

## 🧩 Project Overview

ZakFit is a solo project built in December 2024 as part of the **Apple Foundation Program Advanced** at [Simplon](https://simplon.co/), Paris, under the direction of instructor Zakariae Kassimi. It is a complete iOS health tracking application with a SwiftUI frontend and a Vapor + MySQL backend — built alone from scratch in the span of one challenge.

The app covers the full specification (*Cahier des Charges*): user authentication (JWT), meal and food tracking with macronutrient calculation, physical activity logging, personal goals, and progress visualisation through interactive charts.

**Server repo:** [github.com/audreyhda/ZakFitServer](https://github.com/audreyhda/ZakFitServer)

---

## 🛠️ Tech Stack

### 🌐 Languages
- Swift 5
- SQL (MySQL)

### 📦 Frameworks & Libraries
- SwiftUI — Declarative iOS UI
- Swift Charts — Interactive bar, line, and sector charts
- URLSession + `async`/`await` — HTTP networking layer

### 🗄️ Databases & Storage
- MySQL — Centralised relational database
- `Keychain` / `UserDefaults` — Local JWT token storage

### ☁️ Infrastructure & DevOps
- Vapor 4 (backend) — REST API server ([ZakFitServer](https://github.com/audreyhda/ZakFitServer))
- Fluent — Vapor ORM for database modelling and migrations
- JWT — Stateless authentication
- CORS middleware — Secure cross-origin API access

### 🔧 Tools & Other
- MVVM architecture
- Figma — UI/UX mockups (course deliverable)
- MySQL Workbench — Schema design and data modelling
- UML: class diagrams, use-case diagrams, MCD/MLD/MPD (course deliverables)

---

## ✨ Features

- **Authentication** — Secure registration and login with bcrypt password hashing and JWT token-based sessions. Data persists across devices and reconnections.
- **Dashboard** — At-a-glance overview of today's calories consumed vs. burned, macronutrient breakdown, and active goals.
- **Meal Tracking** — Log meals (breakfast, lunch, dinner, snack) by selecting foods from a pre-populated database. Calories and macros (protein, carbs, fat) are calculated automatically per item and totalled per meal and per day.
- **Activity Tracking** — Record physical activities (cardio, strength, yoga, walking, etc.) with duration and calories burned. Optional auto-estimation of calories based on activity type and duration.
- **Goals** — Set personalised targets for daily calories, weekly training frequency, and weight. The app tracks progress toward each goal and displays alerts when objectives are met or missed.
- **History** — Browse past meals and activities by day, week, or month. Filter and search by date range.
- **Progress Charts** — Bar charts (calories burned per week), line charts (weight evolution over time), and sector charts (macronutrient distribution) powered by Swift Charts.
- **Profile Management** — Update personal info (name, email, height, weight, dietary preferences, health goals). Password changes are re-hashed server-side.
- **Secure Logout** — JWT is deleted from local storage, immediately revoking access to protected routes.

---

## 🏗️ Architecture & Technical Details

### System Design

ZakFit follows **MVVM** on the iOS side, with a clear separation between data models, view models (business logic + API calls), and SwiftUI views. The backend is a stateless REST API: all state lives in the MySQL database, authenticated per-request via JWT bearer tokens.

```
iOS (SwiftUI / MVVM)
        │
        │  HTTPS + JSON  (Bearer JWT on protected routes)
        ▼
  Vapor REST API  →  Fluent ORM  →  MySQL
```

### Data Flow

User action → ViewModel calls `async` service function → URLSession sends HTTP request with JWT → Vapor controller validates token → Fluent queries MySQL → JSON response → decoded `Codable` model → `@Published` property update → SwiftUI re-renders.

### Database Schema

```
Utilisateur ──< Activite
     │
     ├──< Repas >── Aliment >── Categorie_aliment
     │         └── Categorie_repas
     │
     └──< Objectif
```

Full schema defined in [`zakfit_migration.sql`](./zakfit_migration.sql).

Key tables:

| Table | Description |
|-------|-------------|
| `Utilisateur` | User accounts (UUID PK, bcrypt hash, profile data) |
| `Activite` | Physical activity entries per user (name, date, duration, `calorie_brulee`) |
| `Aliment` | Food database (name, calories, `proteine`, `glucide`, `lipide` as `double`) |
| `Categorie_aliment` | Food categories (fruits, vegetables, meat, etc.) |
| `Repas` | Meal entries linking user + food + date + meal type |
| `Categorie_repas` | Meal types: Petit déjeuner, Déjeuner, Dîner, Snack (seeded UUIDs) |
| `Objectif` | User-defined health goals (weight, calories, training targets) |

### Key Technical Decisions

- **MySQL over SQLite**: The spec required a centralised, multi-device relational database. MySQL with UUID binary(16) primary keys ensures data is portable and collision-free across devices.
- **Vapor + Fluent**: Keeps the entire stack in Swift. Fluent migrations manage schema evolution cleanly; raw SQL is used where needed for performance-critical queries.
- **JWT (stateless auth)**: No server-side sessions. The iOS client stores the token securely and includes it in every protected request. Token expiry is enforced server-side.
- **`double` for macros**: The migration explicitly converts legacy `int` macro fields to `double` to support fractional values (e.g. 31.5g protein) — a deliberate precision improvement.
- **`async`/`await` throughout**: All network calls are non-blocking. SwiftUI's `.task {}` modifier triggers data loading on view appearance without blocking the main thread.
- **MVVM strictly applied**: ViewModels are `ObservableObject` classes injected via `@EnvironmentObject` or `@StateObject`. Views contain zero business logic.

---

## 📁 Project Structure

```
ZakFit/
├── App/
│   └── ZakFitApp.swift                  # App entry point, environment injection
├── Models/
│   ├── User.swift                       # Codable user model + profile
│   ├── Activite.swift                   # Activity model
│   ├── Aliment.swift                    # Food item model
│   ├── Repas.swift                      # Meal entry model
│   ├── CategorieRepas.swift             # Meal category model
│   └── Objectif.swift                   # Goal model
├── ViewModels/
│   ├── AuthViewModel.swift              # Login, register, logout, JWT storage
│   ├── DashboardViewModel.swift         # Daily summary, calorie totals
│   ├── ActiviteViewModel.swift          # Activity CRUD + history
│   ├── RepasViewModel.swift             # Meal CRUD + nutritional calc
│   ├── AlimentViewModel.swift           # Food search and selection
│   ├── ObjectifViewModel.swift          # Goals management
│   └── ProfilViewModel.swift            # Profile update
├── Views/
│   ├── Auth/
│   │   ├── LoginView.swift
│   │   └── RegisterView.swift
│   ├── Dashboard/
│   │   └── DashboardView.swift          # Calorie summary + charts
│   ├── Activite/
│   │   ├── ActiviteListView.swift
│   │   └── ActiviteFormView.swift
│   ├── Repas/
│   │   ├── RepasListView.swift
│   │   └── RepasFormView.swift
│   ├── Objectif/
│   │   └── ObjectifView.swift
│   └── Profil/
│       └── ProfilView.swift
├── Services/
│   ├── APIService.swift                 # Base URLSession + JWT injection
│   ├── AuthService.swift
│   ├── ActiviteService.swift
│   ├── RepasService.swift
│   └── ObjectifService.swift
└── Resources/
    └── Assets.xcassets
```

---

## ⚙️ Getting Started

### Prerequisites

- Xcode 15+
- iOS 17+ simulator or device
- The [ZakFitServer](https://github.com/audreyhda/ZakFitServer) running locally or deployed

### Installation

```bash
# 1. Clone the repository
git clone https://github.com/audreyhda/ZakFit.git
cd ZakFit

# 2. Open in Xcode
open ZakFit.xcodeproj

# 3. Set the API base URL (in APIService.swift or a config file)
# e.g. http://localhost:8080

# 4. Make sure ZakFitServer is running, then press Run (⌘R)
```

### Setting Up the Database

```bash
# Run the migration script against your local MySQL instance
mysql -u root -p zakfit_db < zakfit_migration.sql
```

> ⚠️ Run this in the terminal, not in phpMyAdmin — phpMyAdmin stops on the first error.

### Environment Variables

| Variable | Description | Required |
|----------|-------------|----------|
| `API_BASE_URL` | Base URL of the ZakFitServer (e.g. `http://localhost:8080`) | ✅ |

---

## 📸 Screenshots

*To add screenshots:*
1. Run the app in a simulator (e.g. iPhone 16 Pro)
2. Take screenshots with **⌘ + S** in Simulator, or drag from Simulator to Finder
3. Create a `screenshots/` folder at the root of the repo
4. Add your images there and reference them like this:

```markdown
<div align="center">
  <img src="screenshots/dashboard.png" width="220">
  <img src="screenshots/meal_log.png" width="220">
  <img src="screenshots/activity.png" width="220">
</div>
```

Good screens to capture: Dashboard, Login, Meal log form, Activity history, Charts.

---

## 🗺️ Roadmap

- [x] JWT authentication (register, login, logout)
- [x] Dashboard with daily calorie summary
- [x] Activity tracking (log, history, filter)
- [x] Meal and food tracking with auto macronutrient calculation
- [x] 4 meal categories (seeded: Petit déjeuner, Déjeuner, Dîner, Snack)
- [x] Personal goals management
- [x] Progress charts (bar, line, sector) via Swift Charts
- [x] Profile management
- [x] MySQL migration script (`zakfit_migration.sql`)
- [ ] HTTPS in production
- [ ] Push notifications for goal reminders
- [ ] PDF/CSV export of reports
- [ ] Admin dashboard

---

## 🔗 Related

- **Backend (Vapor + MySQL)** → [github.com/audreyhda/ZakFitServer](https://github.com/audreyhda/ZakFitServer)

---

## 📄 License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

## 👤 Author

**Audrey**
- GitHub: [@audreyhda](https://github.com/audreyhda)

---

*Apple Foundation Program Advanced · Simplon Paris · Solo project · December 2024*
*Instructor: Zakariae Kassimi*
