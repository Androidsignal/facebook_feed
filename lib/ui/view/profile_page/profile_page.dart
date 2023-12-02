import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:news_feed_flutter/infrastructure/models/user_model.dart';
import 'package:news_feed_flutter/infrastructure/theme/app_colors.dart';

class ProfilePage extends StatelessWidget {
 final UserModel userModel;
  const ProfilePage({Key? key, required this.userModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.arrow_back,
              color: AppColors.backgroundColor,
            ),
          ),
          automaticallyImplyLeading: false,
          title: const Text(
            'Profile',
            style: TextStyle(color: AppColors.backgroundColor),
          ),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: const BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))),
              child: Center(
                child: Column(
                  children: [
                    Container(
                      height: 120,
                      width: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(image: NetworkImage(userModel.avtar), fit: BoxFit.fill),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(userModel.name, style: const TextStyle(color: AppColors.backgroundColor, fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 5,
                    ),
                    Text('DOB : ${userModel.date_of_birth}', style: const TextStyle(color: AppColors.backgroundColor, fontSize: 16, fontWeight: FontWeight.w600))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
