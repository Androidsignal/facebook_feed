## Facebook feed

This app utilizes Flutter Bloc and Firebase database for smooth pagination in creating a Facebook feeds.

Built with Flutter Bloc and Firebase, our Facebook feed project ensures a smooth user experience with pagination. 
Scroll effortlessly, enjoy real-time updates, and explore a clean, organized codebase for easy maintenance.


## A few packages use in Flutter project:
- flutter_bloc: State management, separate UI and business logic, making it easy to maintain and predict how the app behaves. 
- firebase: Smooth data handling, pagination, real-time updates, and secure data storage. 
- tuple: Handling multiple values together, enhancing code readability and organization.
- google_sign_in: Google authentication, ensuring a seamless and familiar sign-in experience for users.
- share_plus: Easy content sharing across apps.
- equatable: Object equality checks, enhancing code clarity and efficiency.
- intl: Effortless internationalization and localization in your app.
- flutter_native_splash: Seamless and customized splash screen setup, enhancing the overall user experience. so on...


## Firebase Database
## **1. Users:** 
After user login, I set up a 'users' collection with individual user IDs and added their related data.

**New Path: /users/H3ha2knIVaU6lrQ7Z2wqzxA7g3r1**

<img width="1009" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/35c8737f-05a0-45b6-ac71-7a2800e092fc">



 ## **2. Posts:** 
I created a post collection with auto-generated IDs and added data, showcasing the results in the attached screenshot,

**New Path: /posts/15dKPJO5B1ccRuMRiury**
 <img width="1008" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/573db321-8488-4827-81f5-4672e0f00977">


 ## **3. Reactions:** 
 After fetching post data from the stream, I created a reactions collection using the reaction ID as the post ID and added corresponding data. Refer to the attached screenshot for a detailed view of the updates.

**New Path: /posts/15dKPJO5B1ccRuMRiury/reactions/PM8AtLSDbUaUPgmrroF8qJ5Eq7p2**

 <img width="1006" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/5e602d87-099a-4f6d-8653-0b2b5aaea3bf">


## **4. Comments:** 
After retrieving post data from the stream, I established a comments collection with unique IDs, added relevant data, and illustrated the outcome in the attached screenshot.

**New Path: /posts/15dKPJO5B1ccRuMRiury/comments/1701352403178**
 
 <img width="1013" alt="image" src="https://github.com/Androidsignal/facebook_feed/assets/30517653/eb273a7d-e979-439b-86e4-5c0acb6e4001">


## User Interface




For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
