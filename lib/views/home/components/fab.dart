import 'package:flutter/material.dart';
import 'package:todoapp/utils/app_colors.dart';
import 'package:todoapp/views/tasks/task_view.dart';

class Fab extends StatelessWidget {
  const Fab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const TaskView(
                  taskControllerForTitle: null,
                  taskControllerForSubtitle: null,
                  task: null,
                )));
      },
      child: Material(
        borderRadius: BorderRadius.circular(20),
        elevation: 20,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
