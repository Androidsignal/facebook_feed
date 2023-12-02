import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:news_feed_flutter/infrastructure/models/comments_model.dart';
import 'package:news_feed_flutter/infrastructure/models/post_model.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_bloc.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_event.dart';
import 'package:news_feed_flutter/presentation/home/bloc/home_state.dart';

class CommentPage extends StatelessWidget {
  final PostModel postModel;

  CommentPage({Key? key, required this.postModel}) : super(key: key);
 final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          var width = MediaQuery.of(context).size.width;
          var height = MediaQuery.of(context).size.height;
          String? date = DateFormat('EEEE, MMM d, yyyy').format(postModel.createdTime);
          return Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                      leading: const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://1.bp.blogspot.com/--QNc44nYTo8/Xk1X9MFexUI/AAAAAAAAdOg/Bsa6IvOGgi0Dw30yiFqlsta7YJrbVfqdwCEwYBhgL/s1600-rw/Most%2BBeautiful%2B%2BFacebook%2BGirl%2BDP%2B2020%2B%25286%2529.jpg',
                        ),
                      ),
                      subtitle: Text(date, style: context.caption),
                      title: const Text('Angelina'),
                      trailing: Image.asset('assets/more.png', height: 25),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(postModel.content),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: (postModel.images.length >= 3) ? height / 2.2 : width / 2,
                      child: ListView.builder(
                        scrollDirection: (postModel.images.length == 3 || postModel.images.length == 4) ? Axis.vertical : Axis.horizontal,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: postModel.images.length,
                        itemBuilder: (context, index) {
                          if (postModel.images.length == 3) {
                            var img = postModel.images.first;
                            List lastImg = postModel.images;
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (index == 0)
                                  Image.network(
                                    img,
                                    height: width,
                                    width: width / 2.05,
                                    fit: BoxFit.cover,
                                  ),
                                const VerticalDivider(width: 5),
                                if (index == 0)
                                  Column(
                                    children: List.generate(
                                        lastImg.length - 1,
                                            (inx) => Column(
                                          children: [
                                            const SizedBox(height: 5),
                                            Image.network(
                                              lastImg[inx + 1],
                                              height: width / 2,
                                              width: width / 2.05,
                                              fit: BoxFit.cover,
                                            ),
                                          ],
                                        )),
                                  ),
                              ],
                            );
                          } else if (postModel.images.length == 4) {
                            List lastImg = postModel.images;

                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Image.network(
                                      lastImg[0],
                                      height: width / 2,
                                      width: width / 2.05,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 5),
                                    Image.network(
                                      lastImg[1],
                                      height: width / 2,
                                      width: width / 2.05,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                                const VerticalDivider(width: 5),
                                Column(
                                  children: [
                                    const SizedBox(height: 5),
                                    Image.network(
                                      lastImg[2],
                                      height: width / 2,
                                      width: width / 2.05,
                                      fit: BoxFit.cover,
                                    ),
                                    const SizedBox(height: 5),
                                    Image.network(
                                      lastImg[3],
                                      height: width / 2,
                                      width: width / 2.05,
                                      fit: BoxFit.cover,
                                    ),
                                  ],
                                ),
                              ],
                            );
                          } else {
                            return Row(
                              children: [
                                Image.network(
                                  postModel.images[index],
                                  width: postModel.images.length == 1 ? MediaQuery.of(context).size.width : MediaQuery.of(context).size.width / 2.05,
                                  height: MediaQuery.of(context).size.width / 2,
                                  fit: BoxFit.cover,
                                ),
                                if (index < postModel.images.length - 1) const SizedBox(width: 5), // Adjust spacing
                              ],
                            );
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Image.asset('assets/like.png', height: 20, width: 20),
                          const SizedBox(width: 10),
                          Text('${postModel.likes}'),
                          const Spacer(),
                          Text('${postModel.shares}'),
                          const SizedBox(width: 5),
                          Text('Shares', style: context.caption),
                        ],
                      ),
                    ),
                    const Divider(),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('posts').doc(postModel.id).collection('comments').snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<CommentsModel> commentsModelList = [];
                          commentsModelList = snapshot.data?.docs.map((e) => CommentsModel(id: '', commentTime: DateTime.now()).fromJson(e.data())).toList() ?? [];
                          return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            itemCount: commentsModelList.length,
                            itemBuilder: (context, index) {
                              CommentsModel commentModel = commentsModelList[index];
                              String? date = DateFormat('EEEE, MMM d, yyyy').format(commentModel.commentTime);

                              return ListTile(
                                title: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(15)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(commentModel.userName),
                                      Text(commentModel.comment, style: theme.textTheme.bodySmall),
                                    ],
                                  ),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
                                  child: Text(date, style: theme.textTheme.bodySmall),
                                ),
                                leading: CircleAvatar(backgroundImage: NetworkImage(commentModel.userProfile)),
                              );
                            },
                          );
                        } else {
                          return const Center(
                            child: Text('Not at comments'),
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.grey.shade200,
                    ),
                    child: TextFormField(
                      controller: controller,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 15),
                        hintText: 'Write a comment...',
                        border: InputBorder.none,
                        suffix: InkWell(
                          onTap: () {
                            context.read<HomeBloc>().add(
                                  SendComments(
                                    comment: controller.text,
                                    id: postModel.id,
                                  ),
                                );
                            controller.clear();
                          },
                          child: Image.asset('assets/send.png', height: 20, color: controller.text.isEmpty ? theme.disabledColor : theme.primaryColor),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
