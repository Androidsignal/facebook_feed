import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_theme.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../infrastructure/models/post_model.dart';
import '../../../../infrastructure/repository/firestore_repository.dart';
import '../../../common/keep_alive_page.dart';
import '../../comment_page/comment_page.dart';
import '../../post_user_widget.dart';
import '../../reaction_widget.dart';

class PostWidget extends StatelessWidget {
  final PostModel postModel;

  const PostWidget({Key? key, required this.postModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String? date = DateFormat('EEEE, MMM d, yyyy').format(postModel.createdTime);
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return KeepAlivePage(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostUserWidget(postModel: postModel),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Text(postModel.content),
            ),
            const SizedBox(height: 10),
            Container(
              height: (postModel.images.length >= 3) ? height / 2.2 : width / 2,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 3.0, offset: Offset(0.0, 2.0)),
                ],
              ),
              child: ListView.builder(
                scrollDirection: (postModel.images.length == 3 || postModel.images.length == 4) ? Axis.vertical : Axis.horizontal,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: postModel.images.length,
                itemBuilder: (context, index) {
                  List lastImg = postModel.images;

                  if (postModel.images.length == 3) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.network(
                          postModel.images.first,
                          height: width,
                          width: width / 2.05,
                          fit: BoxFit.cover,
                        ),
                        const VerticalDivider(width: 4),
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
                            ),
                          ),
                        ),
                      ],
                    );
                  } else if (postModel.images.length == 4) {
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
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
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
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReactionWidget(postModel: postModel),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CommentPage(postModel: postModel),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/comment.png', height: 20, width: 20),
                        const SizedBox(width: 10),
                        Text('Comment', style: context.caption),
                      ],
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () async {
                      await Share.share('www.example.com/${postModel.id} \n\n Hi, I am Angelia,i add new post in $date, Bio: ${postModel.content}', subject: 'Bio: ${postModel.content}');
                      await FirestoreRepository().updateData(path: 'posts/${postModel.id}', data: {'shares': FieldValue.increment(1)});
                    },
                    child: Row(
                      children: [
                        Image.asset('assets/share.png', height: 20, width: 20),
                        const SizedBox(width: 10),
                        Text('Share', style: context.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
