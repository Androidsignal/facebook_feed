import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed_flutter/app/test_screen.dart';
import 'package:news_feed_flutter/firebase_options.dart';
import 'package:news_feed_flutter/infrastructure/repository/firestore_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/post_repository.dart';
import 'package:news_feed_flutter/infrastructure/repository/user_repository.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_bloc.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_event.dart';
import 'package:news_feed_flutter/presentation/home/bloc/user_cubit.dart';
import 'package:news_feed_flutter/presentation/home/view/home_page.dart';

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
        RepositoryProvider.value(value: FirestoreRepository()),
        RepositoryProvider(
          create: (context) => PostRepository(context.read<FirestoreRepository>()),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(context.read<FirestoreRepository>()),
        )
      ],
      child: const AppPage(),
    );
  }
}

class AppPage extends StatelessWidget {
  const AppPage({Key? key}) : super(key: key);

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
        locale: Locale('en'),

        darkTheme: AppTheme().dark(),
        theme: AppTheme().light(),
        home: HomePage(),
        // home: TestScreen(),
      ),
    );
  }
}
