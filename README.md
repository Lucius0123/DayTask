
DayTask - Flutter Task Management App

A modern task management application built with Flutter and Supabase. DayTask allows users to create, manage, and organize their tasks with a clean and intuitive interface.

DayTask App

Features
User Authentication: Secure email/password authentication via Supabase
Task Management: Create, delete, and mark tasks as complete
Task Priority: Assign priority levels to tasks (High, Medium, Low)
Responsive UI: Clean and intuitive interface that works on various screen sizes
Dark/Light Theme: Toggle between dark and light themes
Offline Support: Basic functionality works offline with data synchronization
Real-time Updates: Changes reflect instantly across devices (optional)
**Setup Instructions**
```markdown project="DayTask" file="README.md"
...
```

2. **Install dependencies**


```shellscript
flutter pub get
```

3. **Update Supabase credentials**


Open `lib/main.dart` and update the Supabase URL and anon key with your own:

```plaintext
await Supabase.initialize(
  url: 'https://izfhlhokbhbhuuxuaouo.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml6ZmhsaG9rYmhiaHV1eHVhb3VvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNTYzNjcsImV4cCI6MjA2MDczMjM2N30.M09R1-W3ayP4O7m3MjEiOuvjfe_SUEtaGYYUxa3-Wpo',
);
```

4. **Run the app**


```shellscript
flutter run
```

### Supabase Setup Steps

1. **Create a Supabase project**

 Created a new project in Supabase dashboard
 Set up project name, password, and region

**Database table setup**
Created a `tasks` table with the following structure:

1. `id`: UUID primary key with auto-generation
2. `user_id`: UUID foreign key to auth.users
3. `title`: Text field for task name
4. `is_completed`: Boolean field (default: false)
5. `priority`: Text field for task priority (default: 'medium')
6. `due_date`: Date field for task due date
7. `description`: Text field for task description

 **Row Level Security (RLS) implementation**
1. Enabled Row Level Security for the `tasks` table
2. Created policies for all CRUD operations:
1. SELECT policy: Users can only read their own tasks
2. INSERT policy: Users can only create tasks linked to their user_id
3. UPDATE policy: Users can only update their own tasks
4. DELETE policy: Users can only delete their own tasks

 **All policies use the condition `auth.uid() = user_id`**

 **Authentication configuration**
1. Enabled email/password authentication
2. Configured email templates for authentication flows
3. Set up password recovery functionality

**API credentials**
1. Retrieved URL and anon key from Project Settings
2. Integrated these credentials into the Flutter app
3. **Update Supabase credentials**

await Supabase.initialize(
  url: "",
  anonKey: "",
);

### Supabase Setup Steps

1. **Create a Supabase project**

1. Created a new project in Supabase dashboard
2. Set up project name, password, and region


2. **Database table setup**

1. Created a `tasks` table with the following structure:

1. `id`: UUID primary key with auto-generation
2. `user_id`: UUID foreign key to auth.users
3. `title`: Text field for task name
4. `is_completed`: Boolean field (default: false)
5. `priority`: Text field for task priority (default: 'medium')
6. `created_at`: Timestamp field with auto-generation

3. **Row Level Security (RLS) implementation**

1. Enabled Row Level Security for the `tasks` table
2. Created policies for all CRUD operations:

1. SELECT policy: Users can only read their own tasks
2. INSERT policy: Users can only create tasks linked to their user_id
3. UPDATE policy: Users can only update their own tasks
4. DELETE policy: Users can only delete their own tasks
All policies use the condition `auth.uid() = user_id`


**Authentication configuration**

1. Enabled email/password authentication
2. Configured email templates for authentication flows
3. Set up password recovery functionality

**API credentials**

1. Retrieved URL and anon key from Project Settings
2. Integrated these credentials into the Flutter app

## App Functionality Implementation

### Authentication Implementation

The authentication system in DayTask uses Supabase Auth and includes:
- **User Registration**: Email and password registration with form validation
- **User Login**: Secure login with error handling
- **Password Reset**: Functionality to reset forgotten passwords
- **Auth State Management**: Using GetX to track and respond to authentication state changes
- **Session Persistence**: Maintaining user sessions across app restarts
- **Logout Functionality**: Allowing users to securely sign out


The implementation uses the Supabase auth client to handle all authentication operations and maintains the user state throughout the app.

### Data Fetching Implementation

Task data is fetched from Supabase using the following approach:

- **Initial Load**: Tasks are loaded when the dashboard screen initializes
- **User-Specific Data**: Only fetching tasks belonging to the current user
- **Loading States**: Showing loading indicators during data fetching
- **Error Handling**: Displaying user-friendly error messages if fetching fails
- **State Management**: Using GetX observables to reactively update the UI when data changes


The implementation ensures that users only see their own tasks and that the UI updates appropriately when tasks are added, modified, or deleted.

### Data Update Implementation

The app handles data updates through several key operations:

- **Task Creation**: Adding new tasks with title and priority
- **Task Completion**: Toggling the completion status of tasks
- **Task Deletion**: Removing tasks via swipe-to-delete or delete button
- **Priority Updates**: Changing the priority level of existing tasks
- **Optimistic Updates**: Updating the UI immediately before server confirmation
- **Error Recovery**: Handling and displaying errors if updates fail

All data operations are synchronized with Supabase to ensure data consistency across devices and sessions.

 Hot Reload
🔹 **What it does:**
Injects updated source code files into the Dart Virtual Machine (VM)

Preserves app state (like current screen, form inputs, counter values)

Only rebuilds the widget tree if changes affect it

🔹 **When to use:**
Small UI tweaks

Changing widget layout or styles

Editing build methods, variable values, etc.

 **Pros:**
Fast — takes less than a second

Keeps current app state

Saves time during development

 **Limitation:**
Doesn't reflect changes in:

Global variables

Initializers outside widget trees

main() method or initState() logic

Hot Restart
🔹 **What it does:**
Destroys and rebuilds the entire app

Loses all runtime state

Re-runs main() and reinitializes everything

🔹 **When to use:**
When changes don’t reflect after hot reload

After modifying:

Global variables

Provider/init data

initState() methods

Static variables or singletons

 **Pros:**
Applies all code changes completely

 **Limitation:**
Slower than hot reload

Resets app to initial state
