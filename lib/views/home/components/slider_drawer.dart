import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todoapp/utils/app_colors.dart';

class CustomSliderDrawer extends StatelessWidget {
  CustomSliderDrawer({super.key});

  /// Icons
  final List<IconData> icons = [
    CupertinoIcons.home,
    CupertinoIcons.person_fill,
    CupertinoIcons.settings,
    CupertinoIcons.info_circle_fill,
  ];

  /// Texts
  final List<String> texts = [
    "Home",
    "Profile",
    "Settings",
    "Details",
  ];

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        colors: AppColors.primaryGradientColor,
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: Column(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage('assets/img/main.jpeg'),
          ),
          Text(
            "Maanar Ateto",
            style: textTheme.displayMedium,
          ),
          Text(
            "Flutter Developer",
            style: textTheme.displaySmall,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 30 ,horizontal: 10),
            width: double.infinity,
            height: 300,
            child: ListView.builder(
                itemCount: icons.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: (){
                      log("${texts[index]} Item Tapped");
                    },
                    child: Container(
                      margin: const EdgeInsets.all(3),
                      child: ListTile(
                        leading: Icon(icons[index],color: Colors.white,size: 30,),
                        title: Text(texts[index],style: const TextStyle(color: Colors.white),),
                      ),
                    ),
                  );
                }),
          )
        ],
      ),
    );
  }
}
