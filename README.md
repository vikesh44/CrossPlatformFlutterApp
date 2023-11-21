# Todo List App

This is a simple Todo List application created using Flutter as a frontend and Back4App as a backend. This application is created for Cross Platform Application Development subject.

## Overview

This Todo List app allows users to manage their tasks with basic CRUD operations. Users can 
- **Add Task:** Add new task with a title and optional description.
- **Mark as Complete:** Mark tasks as complete or incomplete using checkboxes.
- **Edit Task:** Modify the title and description of existing task.
- **Delete Task:** Remove task from the list.
- **View Task Details:** Tap on a task to view its details.

The app utilizes Back4App as the backend for storing and retrieving task data. Below are classes present in Back4App:
- **Auth:** Holds the username and password of the valid users.
- **Todo:** Holds the title, description and status of the todo task.
- **ExpenseManager:** As a extra feature added expense management CRUD operations where user can add expense with title, description and amount.


## Setup

### Prerequisites

- Flutter installed on your machine
    - [Flutter Install Guide](https://flutter.dev/docs/get-started/install)
- Back4App account
    - [Back4App Page](https://www.back4app.com/)
- Any IDE of your choice
    - Preferred to use [Android Studio](https://developer.android.com/studio)

### Installation

1. Create below classes with columns:

| Class Name  | Column Name | Is Required Field? | Value Type | Default Value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| Auth  | Username  | Yes | String |  |
| Auth  | Password  | Yes | String |  |

| Class Name  | Column Name | Is Required Field? | Value Type | Default Value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| Todo  | Title  | Yes | String |  |
| Todo  | Description  | No | String |  |
| Todo  | Done  | Yes | Boolean | false |

| Class Name  | Column Name | Is Required Field? | Value Type | Default Value |
| ------------- | ------------- | ------------- | ------------- | ------------- |
| ExpenseManager  | Title  | Yes | String |  |
| ExpenseManager  | Description  | No | String |  |
| ExpenseManager  | Amount  | Yes | Number | 0 |

2. Clone the repository:
- Repository is present at: https://github.com/vikesh44/CrossPlatformFlutterApp
- We can use below https based command to clone the repository:

    ```bash
    git clone https://github.com/vikesh44/CrossPlatformFlutterApp.git
    ```

3. Navigate to the project directory:

    ```bash
    cd CrossPlatformFlutterApp
    ```

4. Install dependencies:

    ```bash
    flutter pub get
    ```

5. Run the app:

    ```bash
    flutter run
    ```

### Configuration

1. Open the below files one by one.
- `lib/main.dart`
- `lib/SignUp.dart`
- `lib/TodoList.dart`
- `lib/ExpenseManager.dart`

2. Update the Back4App credentials:

    ```dart
    const keyApplicationId = 'your_back4app_application_id';
    const keyClientKey = 'your_back4app_client_key';
    const keyParseServerUrl = 'https://parseapi.back4app.com';
    ```

3. Save the file and restart the application.