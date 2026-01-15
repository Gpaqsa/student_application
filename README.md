# ScholarSync 🎓

### A Comprehensive Student Management Command Center

ScholarSync is a robust Flutter application designed to centralize the academic life of university students. It goes beyond simple task tracking by integrating course management, real-time grade calculation, and study material organization into a single, reactive ecosystem.


## 🚀 Key Features

### 1. Intelligence Dashboard (Home)

- Quick Stats: Real-time summary of active modules and pending tasks.

- Nerve Center: "Upcoming Tasks" list for immediate focus and quick navigation to full task views.

### 2. Multi-Layered Module Management

- Unified Module View: Data-rich cards displaying course codes, professors, and real-time grade percentages.

- The Triple-Tab Detail System:

    - Info: Syllabus, credit hours, and descriptions.

    - Tasks: Color-coded task management (Assignments, Exams, Quizzes, Projects).

    - Materials: File repository with upload/download functionality and metadata tracking.

### 3. Dynamic Academic Tools

- Calendar View: Monthly grid with dots for events and distinct red borders for exams.

- Advanced To-Do List: High-performance filtering (Pending, Completed, Overdue) with priority indicators (Low, Medium, High).

### 4. Advanced Grade Logic & Persistence

- Sliding Progress Panel: A refined UI approach allowing users to adjust progress per module.

- Auto-Grade Engine: Real-time calculation of final letter grades (A, B, C, etc.) based on accumulated scores.

- SQLite Backbone: Reliable local storage ensuring data (especially grades) remains persistent across app restarts.

## 🛠 Technical Stack

Framework: Flutter

State Management: Provider (Reactive UI updates)

Database: SQLite (Local relational storage)

Architecture: Clean Architecture with a dedicated DatabaseHelper and Indexed Tables.

## 📊 Database Schema

The application utilizes 3 SQLite tables with optimized indexing for high-speed performance:

- Modules Table: Stores course details, instructor info, and current grades.

- Tasks Table: Stores all academic deliverables. Indexes: module_code, due_date, type is_completed.

- Study_Materials Table: Tracks uploaded documents and resources.


## 🛠 Installation & Setup

Clone the repository: git clone git@github.com:Gpaqsa/student_application.git


Install dependencies:

    flutter pub get

Run the application:

    flutter run