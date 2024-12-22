import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:todoapp/extentions/space_exs.dart';
import 'package:todoapp/main.dart';
import 'package:todoapp/models/task.dart';
import 'package:todoapp/utils/app_colors.dart';
import 'package:todoapp/utils/app_str.dart';
import 'package:todoapp/utils/constant.dart';
import 'package:todoapp/views/tasks/components/date_time_selection.dart';
import 'package:todoapp/views/tasks/components/rep_textformfield.dart';
import 'package:todoapp/views/tasks/widgets/task_view_appbar.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {super.key,
      this.taskControllerForTitle,
      this.taskControllerForSubtitle,
      this.task});
  static const String routName = "tasks";

  final TextEditingController? taskControllerForTitle;
  final TextEditingController? taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subTitle;
  DateTime? date;
  DateTime? time;

  /// Show Selected Time As String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  /// Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// If any Task Already exist return TRUE otherWise FALSE
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// If any task already exist app will update it otherwise the app will add a new task
  dynamic isTaskAlreadyExistUpdateOtherWiseCreate() {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title;
        widget.taskControllerForSubtitle?.text = subTitle;
        widget.task?.save();
        Navigator.of(context).pop();
      } catch (e) {
        updateTaskWarning(context);
      }
    } else {
      if (title != null && subTitle != null) {
        var task = Task.create(
            title: title,
            subTitle: subTitle,
            createdAtTime: time,
            createdAtDate: date);
        BaseWidget.of(context).hiveDataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    TextTheme themeText = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
        appBar: const TaskViewAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ///Top Side Texts
                  _buildTopSideTexts(themeText),

                  ///Main Task View Activity
                  _buildMainTaskViewActivity(themeText, context),

                  ///Bottom Side Buttons
                  _buildBottomSideButtons()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  ///Bottom Side Buttons
  Widget _buildBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          ///Delete Current Task
          MaterialButton(
            onPressed: () {
              deleteTask;
            },
            minWidth: 150,
            color: Colors.white,
            height: 55,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                const Icon(
                  Icons.close,
                  color: AppColors.primaryColor,
                ),
                5.w,
                const Text(
                  AppStr.deleteTask,
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ],
            ),
          ),
          20.w,

          ///Add or Update Current Task
          MaterialButton(
            onPressed: () {
              isTaskAlreadyExistUpdateOtherWiseCreate();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            height: 55,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Text(
              isTaskAlreadyExistBool()
                  ? AppStr.addNewTask
                  : AppStr.updateCurrentTask,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  ///Main Task View Activity
  Widget _buildMainTaskViewActivity(TextTheme themeText, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 500,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: themeText.headlineMedium,
            ),
          ),

          ///Task Title
          RepTextFormField(
            controller:
                widget.taskControllerForTitle ?? TextEditingController(),
            onFieldSubmitted: (String inputTitle) {
              title = inputTitle;
            },
            onChanged: (String inputTitle) {
              title = inputTitle;
            },
          ),
          5.h,

          ///Task Title
          RepTextFormField(
            controller:
                widget.taskControllerForSubtitle ?? TextEditingController(),
            isForDescription: true,
            onFieldSubmitted: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
            onChanged: (String inputSubTitle) {
              subTitle = inputSubTitle;
            },
          ),

          ///Time Selection
          DateTimeSelection(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => SizedBox(
                  height: 254,
                  child: TimePickerWidget(
                    onChange: (_, __) {},
                    initDateTime: showDateAsDateTime(time),
                    dateFormat: 'HH:mm',
                    onConfirm: (dateTime, _) {
                      setState(() {
                        if (widget.task?.createdAtTime == null) {
                          time = dateTime;
                        } else {
                          widget.task!.createdAtTime = dateTime;
                        }
                      });
                    },
                  ),
                ),
              );
            },
            isTime: true,
            title: AppStr.timeString,
            time: showTime(time),
          ),

          ///Date Selection
          DateTimeSelection(
            onTap: () {
              DatePicker.showDatePicker(
                context,
                maxDateTime: DateTime(2030, 12, 30),
                minDateTime: DateTime.now(),
                initialDateTime: showDateAsDateTime(date),
                onConfirm: (dateTime, _) {
                  setState(() {
                    if (widget.task?.createdAtDate == null) {
                      date = dateTime;
                    } else {
                      widget.task!.createdAtDate = dateTime;
                    }
                  });
                },
              );
            },
            title: AppStr.dateString,
            time: showDate(date),
          )
        ],
      ),
    );
  }

  ///Top Side Task
  Widget _buildTopSideTexts(TextTheme themeText) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
          RichText(
            text: TextSpan(
                text: isTaskAlreadyExistBool()
                    ? AppStr.addNewTask
                    : AppStr.updateCurrentTask,
                style: themeText.titleLarge,
                children: const [
                  TextSpan(
                      text: AppStr.taskStrnig,
                      style: TextStyle(fontWeight: FontWeight.w400)),
                ]),
          ),
          const SizedBox(
            width: 70,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
