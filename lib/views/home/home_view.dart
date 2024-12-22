import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:lottie/lottie.dart';
import 'package:todoapp/extentions/space_exs.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/utils/app_colors.dart';
import 'package:todoapp/utils/app_str.dart';
import 'package:todoapp/utils/constant.dart';
import 'package:todoapp/views/home/components/fab.dart';
import 'package:todoapp/views/home/components/home_appbar.dart';
import 'package:todoapp/views/home/components/slider_drawer.dart';
import 'package:todoapp/views/home/widgets/task_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  static const String routName = "home";

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();

  /// Checking Done Tasks
  int checkDoneTask(List<Task> task) {
    int i = 0;
    for (Task doneTasks in task) {
      if (doneTasks.isCompleted) {
        i++;
      }
    }
    return i;
  }

  /// Checking The Value Of the Circle Indicator
  dynamic valueOfTheIndicator(List<Task> task) {
    if (task.isNotEmpty) {
      return task.length;
    } else {
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme themeText = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);
    return ValueListenableBuilder(
      valueListenable: base.hiveDataStore.listenToTask(),
      builder: (context, Box<Task> box, Widget? child) {
        var tasks = box.values.toList();

        /// Sort Task List
        tasks.sort(((a, b) => a.createdAtDate.compareTo(b.createdAtDate)));
        return Scaffold(
          backgroundColor: Colors.white,

          /// Floating Action Button
          floatingActionButton: const Fab(),

          /// Body
          body: SliderDrawer(
              key: drawerKey,
              isDraggable: false,
              animationDuration: 1000,

              /// My Drawer Slider
              slider: CustomSliderDrawer(),

              /// My AppBar
              appBar: HomeAppBar(drawerKey: drawerKey),

              /// Main Body
              child: _buildHomeBody(themeText, base, tasks)),
        );
      },
    );
  }

  /// Main Body
  Widget _buildHomeBody(
      TextTheme themeText, BaseWidget base, List<Task> tasks) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Column(
        children: [
          /// Top Section Of Home page : Text, Progress Indicator
          SizedBox(
            width: double.infinity,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// CircularProgressIndicator
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    value: checkDoneTask(tasks) / valueOfTheIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor:
                        const AlwaysStoppedAnimation(AppColors.primaryColor),
                  ),
                ),
                //space
                25.w,

                ///Top level task info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style: themeText.displayLarge,
                    ),
                    Text(
                      '${checkDoneTask(tasks)} of ${tasks.length} task',
                      style: themeText.titleMedium,
                    ),
                  ],
                )
              ],
            ),
          ),
          //Divider
          const Divider(
            thickness: 2,
            indent: 100,
          ),

          /// Bottom ListView : Tasks
          SizedBox(
            width: double.infinity,
            height: 590,
            child: tasks.isNotEmpty
                ? ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      var task = tasks[index];
                      return Dismissible(
                          direction: DismissDirection.horizontal,
                          onDismissed: (direction) {
                            base.hiveDataStore.deleteTask(task: task);
                          },
                          background: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.delete_outline,
                                color: Colors.grey,
                              ),
                              8.w,
                              const Text(
                                AppStr.deletedTask,
                                style: TextStyle(color: Colors.grey),
                              )
                            ],
                          ),
                          key: Key(task.id),
                          child: TaskWidget(
                            task: task,
                          ));
                    })

                /// if All Tasks Done Show this Widgets
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeIn(
                        child: SizedBox(
                          width: 200,
                          height: 200,
                          child: Lottie.asset(lottieURL,
                              animate: tasks.isNotEmpty ? false : true),
                        ),
                      ),
                      FadeInUp(from: 30, child: const Text(AppStr.doneAllTask))
                    ],
                  ),
          )
        ],
      ),
    );
  }
}
