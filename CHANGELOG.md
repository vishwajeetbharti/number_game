## 0.0.1

* TODO: Describe initial release.

# game
# Number Game

A fast and fun number puzzle game built with Flutter & Dart.

---

### 📥 Download APK
[Download app-release.apk](https://github.com/vishwajeetbharti/game/tree/main/release-build/app-release.apk)


### 🎥 Demo Video
[Watch Demo Video](https://github.com/vishwajeetbharti/game/blob/main/release-build/Screen_recording_20250826_114238%20(online-video-cutter.com).mp4)



##  About the Project

**Number Game** is a visually engaging and intuitive number puzzle where players solve number-based challenges under time constraints. Designed for both single sessions and daily challenges, it combines increasing difficulty levels with strategic play.

---

##  Setup

### Requirements
- Flutter SDK (stable) 3.29.0 --version
- Dart
- Android Studio / Xcode (for emulator or real device)
- Device/emulator with Flutter installed

```

---

## 🎮 Core Gameplay Mechanics & Rules

### Match Rule
- Player must **match two cells** if:
    - The numbers are **equal**, or
    - The numbers **sum to 10**.
- Similar to the gameplay of the referenced app (linked on Play Store).

### Cell Behavior
- **Matched cells remain visible** on the grid.
- Once matched, the cells become **dull/faded** but still show the number.
- This provides feedback while keeping the game state persistent.

### Feedback & Interactions
- **Valid Match** → Cells dull/fade with a short visual effect.
- **Invalid Match** → Animate the cells (shake / red flash).
- Interaction flow:
    1. Tap first cell → highlight it.
    2. Tap second cell → check rule.
    3. Animate the result (valid or invalid).

### Progression
- Game includes **3 distinct levels**:
    - **Level 1**: Basic matches (equal or sum = 10), fewer numbers, easy pace.
    - **Level 2**: More numbers, grid expands, increased difficulty.
    - **Level 3**: Advanced constraints (more complex placements, fewer chances).
- Each level introduces **harder constraints and faster gameplay**.

### Grid Layout
- The grid is **partially filled**, not the entire screen.
- At start, only **3–4 rows are filled** with numbers.
- Remaining space is empty, allowing room for progression.

### Add Row Button
- A dedicated **“Add Row” button** is available.
- Pressing it **adds a few rows** of numbers (not the full grid).
- This keeps the game dynamic and prevents early grid saturation.

### Further Rules
- All additional rules and mechanics follow the exact behavior of the referenced game (as per LinkedIn/Play Store version).
- This includes handling row additions, matches, progression pacing, and game-over conditions

---

##  Architecture

- **Pattern**: Clean architecture, feature-first project structure using **BLoC** for state.
- **Layers**:
    - `presentation/`: UI screens, widgets, BLoC events & states.
    - `domain/`: Core entities (`NumberCell`, `Rule`, `LevelConfig`), use cases for logic (grid generation, validation, scoring).
    - `data/`: Repositories, data sources, persistent storage (e.g., high scores).
- **State Flow**:
  User taps → `GameEvent` → `GameBloc` computes next state → `GameState` updates UI.
- **Deterministic Levels**:
  Uses seeded `Random` for reproducible puzzles (e.g., Daily Challenge).

---

##  Persistence

- High scores, user preferences, and progress saved via local storage (e.g., Hive or SharedPreferences).

---

##  Folders Overview

```
lib/
├── features/
│   └── game/
│       ├── presentation/
│       │   ├── screens/
│       │   └── widgets/
│       ├── bloc/
│       ├── domain/
│       └── data/
└── core/             # Utilities (timer, RNG, constants)
test/                # Mirrors structure for tests
```

---

##  Configuration (Level Difficulty)

Configured inside `LevelConfig`:

- `gridSize` (4–6)
- `ruleSet` (even/odd/sum/prime/mixed)
- `timeLimitMs`
- `mistakePenalty`
- `streakThreshold` (win-back hearts)

Can be tweaked locally or remotely in future updates.

---

##  UI Components

- **Top Bar**: Displays rule, timer, hearts, and score.
- **Grid**: Number tiles animate, show feedback on taps.
- **Bottom Bar**: Power-ups, pause, next-level buttons.
- **Combo Feedback**: Visual/Toast effect for combos and bonuses.

---

##  Dev Commands

```bash
# Formatting, analysis, and tests
flutter format .
flutter analyze
flutter test

# Builds
flutter build apk
flutter build ios
```

---

##  Roadmap

- Haptics, sound/color themes
- Cloud saves & leaderboards
- Advanced rules (Fibonacci, squares)
- In-app tutorials & adaptive difficulty

---

##  License

Distributed under the **MIT License**.

---

##  Contact

Created by Vishwa. Have feedback or ideas? Reach out via GitHub Issues or DM.


