## Facebook feed

This app utilizes Flutter Bloc and Firebase database for smooth pagination in creating Facebook feeds.

Built with Flutter Bloc and Firebase, our Facebook feed project ensures a smooth user experience with pagination. 
Scroll effortlessly, enjoy real-time updates, and explore a clean, organized codebase for easy maintenance.


## A few packages used in the Flutter project:
- flutter_bloc: State management, separate UI, and business logic, making it easy to maintain and predict how the app behaves. 
- firebase: Smooth data handling, pagination, real-time updates, and secure data storage. 
- tuple: Handling multiple values together, enhancing code readability and organization.
- google_sign_in: Google authentication, ensuring users a seamless and familiar sign-in experience.
- share_plus: Easy content sharing across apps.
- equatable: Object equality checks, enhancing code clarity and efficiency.
- intl: Effortless internationalization and localization in your app.
- flutter_native_splash: Seamless and customized splash screen setup, enhancing the overall user experience. so on...


## Firebase Database
## **1. Users:** 
After user login, I set up a 'users' collection with individual user IDs and added their related data.

- 'avtar': I use avatar's as profile pictures for users.
- 'date_of_birth': Show users' birth dates in their profiles using this field.
- 'name': Show users' name's in their profiles using this field.
- 'userId': I use the user ID for finding future user data.

**New Path: /users/H3ha2knIVaU6lrQ7Z2wqzxA7g3r1**

<img width="1009" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/35c8737f-05a0-45b6-ac71-7a2800e092fc">



 ## **2. Posts:** 
I created a post collection with auto-generated IDs and added data, showcasing the results in the attached screenshot,

- 'content': Display the user's post description using the content.
- 'createdTime': Display the user's post-added time using the created time.
- 'images': Display the user's post image using the images.
- 'likes': Display the user's post total likes using the likes.
- 'shares': Display the user's post total shares using the shares.
- 'totalComment': Display the user's post total comment using the totalComment.
- 'userId': Use the user ID to get user information.
- 'id': Use the ID to create 'reactions' and 'comments'.


**New Path: /posts/15dKPJO5B1ccRuMRiury**
 <img width="1008" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/573db321-8488-4827-81f5-4672e0f00977">


 ## **3. Reactions:** 
 After fetching post data from the stream, I created a reactions collection using the reaction ID as the post ID and added corresponding data. Refer to the attached screenshot for a detailed view of the updates.

 - 'userId': Use the user ID for setting, updating, and deleting reactions.
 - 'reactionId': Use the reaction ID to find a reaction.
 - 'id': Use the id to find a post.

**New Path: /posts/15dKPJO5B1ccRuMRiury/reactions/PM8AtLSDbUaUPgmrroF8qJ5Eq7p2**

 <img width="1006" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/5e602d87-099a-4f6d-8653-0b2b5aaea3bf">


## **4. Comments:** 
After retrieving post data from the stream, I established a comments collection with unique IDs, added relevant data, and illustrated the outcome in the attached screenshot.

 - 'comment': Use comment to display user's post comments.
 - 'userName': Use the userName to determine which user commented on the post.
 - 'userProfile': Show the user profile.
 - 'commentTime': Display the user's comment-added time using the commentTime.
 - 'postId': find a post.
 - 'userId': find a user.
 - 'id': check comment.


**New Path: /posts/15dKPJO5B1ccRuMRiury/comments/1701352403178**
 
 <img width="1013" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/eb273a7d-e979-439b-86e4-5c0acb6e4001">


## Code Structure

- 'lib/app': contains flutter apps entry point files (like main.dart).
- 'lib/infrastructure/models': Handle app data parsing from and to Firebase Database and also for reusability of and converted JSON data into an object.
- 'lib/infrastructure/repository': These are the classes that define the data structure of your app. They usually mirror the structure of the data in your database. Data Sources: They are responsible for fetching the data from the database.
- 'lib/infrastructure/theme': used for maintaining the whole app theme structure from one place.
- 'lib/ui/common': used for any UI common widget or any item.
- 'lib/ui/view/comment_page': it's for displaying a comment widget of a user post in the app.
- 'lib/ui/view/home_page': which contains the home page user interface and bloc structure for the home page.
- 'lib/ui/view/profile_page': it's for displaying a profile widget of a user profile in the app.

## User Interfaces

![image](https://github.com/Androidsignal/facebook_feed/assets/114283718/152ad8c1-56f4-4381-a2b6-fe307f196089)

![image](https://github.com/Androidsignal/facebook_feed/assets/114283718/8006cd2c-dd3e-4067-adad-ca689ee1772b) 

![image](https://github.com/Androidsignal/facebook_feed/assets/114283718/d9dec6fd-a4f8-4336-8b68-71bb94aa9b49)

![image](https://github.com/Androidsignal/facebook_feed/assets/114283718/fe0acc28-f780-4a46-900d-fd2c279c6b56) 

![image](https://github.com/Androidsignal/facebook_feed/assets/114283718/b9bd7ef3-9151-44cc-8ffa-2ef67f32180a)

