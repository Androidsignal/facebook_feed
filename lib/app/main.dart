import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed_flutter/firebase_options.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/post_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/user_repository.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_bloc.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_event.dart';

import '../ui/view/home_page/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: FirestoreRepository(),
        ),
        RepositoryProvider(
          create: (context) => PostRepository(
            context.read<FirestoreRepository>(),
          ),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(
            context.read<FirestoreRepository>(),
          ),
        )
      ],
      child: const AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({Key? key}) : super(key: key);

  Future<User?> anonymousSignIn() async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      return FirebaseAuth.instance.currentUser;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "operation-not-allowed":
          print("Anonymous auth hasn't been enabled for this project.");
          break;
        default:
          print("Unknown error.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => HomeBloc(
                  postRepository: context.read<PostRepository>(),
                  firestoreRepository: context.read<FirestoreRepository>(),
                  userRepository: context.read<UserRepository>(),
                )..add(const FetchMatchList())),
      ],
      child: MaterialApp(
        title: 'News Feed',
        locale: const Locale('en'),

        darkTheme: AppTheme().dark(),
        theme: AppTheme().light(),
        home: FutureBuilder(
            future: anonymousSignIn(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return HomePage();
              }
              return Scaffold(
                  body: SizedBox(
                width: double.infinity,
                child: snapshot.hasError
                    ? const Center(
                        child: Text(
                          "Something want wront",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    : const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(
                            height: 20,
                          ),
                          Text("Please wait...")
                        ],
                      ),
              ));
            }),
        // home: TestScreen(),
      ),
    );
  }
}
