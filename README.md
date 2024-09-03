# UPosts
 
## Overview
UPosts is an iOS application built using Xcode, Swift, RxSwift, RxCocoa, RealmSwift, Alamofire, and following the MVVM architecture pattern. 
RealmDB is used for local data storage. The project is uses Swift Package Manager (SPM) for dependency management.
 
## Features
- **Login Screen**: Secure login with validation on email and password.
- **Post and Favorite Tabs**: Users can view posts fetched from the server and mark them as favorites. Favorites are stored locally.
- **Offline Access**: The app supports offline functionality, using RealmDB to store posts locally.
 
## Prerequisites
- **Xcode**: Ensure you have Xcode installed (version supporting Swift and RxSwift). Developed on Xcode 15.4
- **SPM**: Make sure the required packages are configured via Swift Package Manager.
 
## Steps to Run the Application
1. **Download the Code**:
   - Clone or download the code from the `develop` branch.
 
2. **Build the Project**:
   - Open the project in Xcode.
   - If you face any build issues related to package dependencies, reset the package caches.
     - Path: `Xcode -> File -> Packages -> Reset Package Caches`.
 
3. **Run the Application**:
   - Build and run the application on your device or simulator.
 
4. **Login**:
   - On the launch screen, you'll see the login interface. Initially, the login button will be disabled.
   - Enter a valid email and password (8-15 characters). Once valid, the login button will be enabled.
   - on login screen not implemented any API, so if user entered validated email and password user can go inside.
 
5. **Explore the Application**:
   - After logging in, you'll see two tabs: **Posts** and **Favorites**.
   
6. **Posts Screen**:
   - On the Posts screen, the app will fetch posts from the server and display them. These posts will also be stored in RealmDB.
   - You can mark posts as favorites by clicking on them, which will show a check mark.
 
7. **Favorites Screen**:
   - Switch to the Favorites tab to view posts marked as favorites. The data displayed here is fetched from the local database.
 
8. **Offline Mode**:
   - If the internet connection is disabled, the app will still function without issues. The posts and favorites data is stored in RealmDB and accessible offline.
 
## Notes
- Ensure all dependencies are installed and configured via Swift Package Manager before building the project.
- For any issues, try resetting the package caches as mentioned above.
 
## License
This project is licensed under the [MIT License](LICENSE).
 
---
 
This README provides the necessary steps to set up and run the UPosts application. For more details or specific queries, refer to the documentation within the project or contact the development team.

![Simulator Screenshot - iPhone 15 - 2024-09-03 at 14 40 52](https://github.com/user-attachments/assets/2928fa00-9ba4-460f-bbfe-07a8a7a08a6a)
![Simulator Screenshot - iPhone 15 - 2024-09-03 at 14 40 49](https://github.com/user-attachments/assets/d201574a-f689-4bd6-8254-c3da64178d28)
![Simulator Screenshot - iPhone 15 - 2024-09-03 at 14 40 32](https://github.com/user-attachments/assets/a1c5d15a-efee-4966-9e85-1e253d38ec3e)


