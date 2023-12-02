import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/models/user_model.dart';
import 'package:news_feed_flutter/infrastructure/repository/user_repository.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/user_cubit.dart';
import 'package:news_feed_flutter/ui/view/profile_page/profile_page.dart';

class PostUserWidget extends StatelessWidget {
  final PostModel postModel;

  const PostUserWidget({Key? key, required this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(context.read<UserRepository>())..fetchUser(userId: postModel.userId),
      child: PostUserView(postModel: postModel),
    );
  }
}

class PostUserView extends StatelessWidget {
  final PostModel postModel;

  const PostUserView({Key? key, required this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? date = DateFormat('EEEE, MMM d, yyyy').format(postModel.createdTime);
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfilePage(userModel: state.userModel ?? UserModel()),
              ),
            );
          },
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14),
            leading: CircleAvatar(
              backgroundImage: NetworkImage(
                state.userModel?.avtar ?? 'https://t3.ftcdn.net/jpg/02/95/26/46/360_F_295264675_clwKZxogAhxLS9sD163Tgkz1WMHsq1RJ.jpg',
              ),
            ),
            subtitle: Text(date, style: context.caption),
            title: Text(state.userModel?.name ?? '',style: context.titleSmall),
            trailing: Image.asset('assets/more.png', height: 20),
          ),
        );
      },
    );
  }
}
