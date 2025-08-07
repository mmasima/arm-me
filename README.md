# ArmMe App

A simple Flutter application to interact with a demo alarm system.

## Features

- **Login Screen**  
  Authenticates users using a username and password.

- **Dashboard Screen**  
  Displays the current status of the alarm system with the ability to arm/disarm.

- **State Management**  
  Uses `Cubit` from `flutter_bloc` for managing login and dashboard state.

- **Persistent Storage**  
  Uses `SharedPreferences` to store the access token and user session data locally.

## Workflow

1. User logs in via the **Login Screen**.
2. If login is successful, the app navigates to the **Dashboard**.
3. On the dashboard:
   - System status is fetched and displayed.
   - User can refresh status or arm/disarm the system.
4. User can logout, which clears the session and returns to the login screen.

## Tech Stack

- Flutter
- Bloc (Cubit)
- SharedPreferences
- Dio (for HTTP requests)

## Notes

- The app checks if the user is already logged in using `SharedPreferences` and skips login if a valid token exists.
- Basic success/failure dialogs are shown for login, logout, and system actions.

