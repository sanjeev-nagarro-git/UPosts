Project Name: UPosts
Technologies used: Xcode, Swift, RxSwift, RxCocoa, Alamofire, SPM
Architecture: MVVM
Local Database: Core Data
 
Follow these steps to run the application:
Step1: Download the code from develop branch.
Step2: Run the application in machine, if facing code building issue, do the reset package. Reset Package path XCode->File>Packages->Reset Package Caches
Step3: Run the application
Step4: On application launch Login screen will be appeared with Login button disabled
Step5: Entering valid email and password(should be between 8 - 15 character), Login button will be enabled
Step6: On press Login button user will go inside the application
Step7: Inside the application user can see 2 tabs Posts and Favorite.
Step8: First Post screen will be visible.
Step9: Post will call an API to show Posts from server, and in background it will store the data in Core Data.
Step10: On click of each post, will mark as Favorite and beside of that check mark will be show.
Step11: Now click on Favorite tab, what we have marked as Favorite all that posts will be show in this tab. All this tab data coming from local database.
Step12. Now if user disabling internet connection it will run without any issue. Because all data stored in local database.
