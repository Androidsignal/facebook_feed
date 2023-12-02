import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_bloc.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_event.dart';
import 'package:news_feed_flutter/ui/view/home_page/bloc/home_state.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'widget/post_widget.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  void onRefresh(HomeBloc bloc) {
    bloc.add(const FetchMatchList(isRefresh: true));
    refreshController.refreshCompleted();
  }

  void pullUpToLoad() {
    if (context.mounted) {
      context.read<HomeBloc>().add(const FetchMoreMatchList());
    }
  }

  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = context.read<HomeBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/fb_logo.png', height: 60),
        centerTitle: false,
        elevation: 2,
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listenWhen: (previous, current) => previous.isFetchMore != current.isFetchMore || previous.posts != current.posts,
        listener: (context, state) {
          if (!state.isFetchMore) {
            refreshController.loadComplete();
          }
        },
        buildWhen: (previous, current) => previous.isLoading != current.isLoading || previous.isFetchMore != current.isFetchMore || previous.posts != current.posts,
        builder: (context, state) {
          return SmartRefresher(
            enablePullUp: true,
            primary: false,
            header: const WaterDropMaterialHeader(),
            footer: CustomFooter(
              builder: (context, mode) {
                Widget body;
                switch (mode) {
                  case LoadStatus.idle:
                    body = const Text('Pull up to load more');
                    break;
                  case LoadStatus.loading:
                    body = const CircularProgressIndicator();
                    break;
                  case LoadStatus.failed:
                    body = const Text('Load Failed! Click retry!');
                    break;
                  default:
                    body = const Text('No more matches');
                    break;
                }
                return SizedBox(
                  height: 55,
                  child: Center(child: body),
                );
              },
            ),
            controller: refreshController,
            onRefresh: () {
              HapticFeedback.lightImpact();
              onRefresh(homeBloc);
            },
            onLoading: () {
              HapticFeedback.lightImpact();
              pullUpToLoad();
            },
            child: ListView.separated(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              primary: false,
              itemCount: state.posts.length,
              separatorBuilder: (BuildContext context, int index) => Divider(thickness: 10, color: Colors.grey.shade200),
              itemBuilder: (BuildContext context, int index) {
                return PostWidget(
                  postModel: state.posts[index],
                );
              },
            ),
          );
        },
      ),
    );
  }
}
