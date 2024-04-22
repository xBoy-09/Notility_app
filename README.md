# Notility
 Revolutionize your note-taking with our AI-powered app – effortlessly organize, search, and stay productive.

# Setup instructions for Notility

Step 1: Have Flutter installed on your local machine.

Step 2: Clone the repo and open in your local VS Code.

Step 3: Open the command line and enter the command `flutter pub get` to retrieve dependencies.

Step 4: Open the mobile app simulator in VS Code

Step 5: Navigate to the bottom and click on this tab
![image](https://github.com/xBoy-09/notility/assets/157277754/fe878786-bf90-4e54-9f63-e77acfcc8ad0)

Step 6: Click on the respective simulator inside the menu

![image](https://github.com/xBoy-09/notility/assets/157277754/1b7a768b-9c9d-4f03-b7f3-ed1a89850238)

Step 7. Once the simulator has launched, run the command `flutter run`

Step 8. After the above command executes (may take a few minutes), you will be met with the Notility Welcome Screen

![image](https://github.com/xBoy-09/notility/assets/157277754/3a9deaad-e8eb-40dd-b719-24938f406b21)


Step 9. Click on sign up, and enter a username, password, and email.

Step 10. Confirm and then log in using your new credentials.

Step 11. You are all set to note!

> [!Note]
>Current Use Cases:
>1. Login
>2. Signup
>3. Create Note
>4. Edit Note
>5. Delete Note(s)
>6. Pinned Note(s)
>7. Add tags to Note(s)

# Directories and Files
- android, ios, linux, macos, test, web, windows
   - all project skeleton files that are included in any Flutter project
  
- images
   - contains the image assets used in the application
  
- lib
   - main project code
   - components
     - contains the buttons and text fields made to be used in various areas of the application
    
   - data
     - contains data we used to make note entries
    
   - models
     - Contains classes that encapsulate the data and behavior associated with their respective entities, allowing for easy management and manipulation within the application
    
   - screens
     - Contains the screens that the user sees while interacting with the application for various tasks
    
   - server
     - contains code that was used to connect the Flutter app with the MongoDB database and interact with it
    
   - themes
     - contains app theme used for notes
    
   - widgets
     - this encapsulates reusable UI components related to note-taking functionality within the larger application
    
   - main.dart
     - It establishes the main function, initializes necessary components, connects to a database, and defines the root widget of the application with the appropriate theme and initial screen. This would either be the login page or the home screen of the app depending on the current status of the user.
    
- .gitignore
   - specifies the intentionally untracked files in Git
  
- analysis_options.yaml
   - specifies rules for code formatting, linting, and other static analysis checks
  
- pubspec.lock
   - specifies all the dependencies and their versions used in the project
  
- pubspec.yaml
   - specifies the packages required to use in the project




