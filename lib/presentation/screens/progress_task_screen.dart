import 'package:flutter/material.dart';
import 'package:task_manager_app/data/models/task_list_wrapper.dart';
import 'package:task_manager_app/data/services/network_caller.dart';
import 'package:task_manager_app/data/utility/urls.dart';
import 'package:task_manager_app/presentation/widgets/background_widget.dart';
import 'package:task_manager_app/presentation/widgets/profile_app_bar.dart';
import 'package:task_manager_app/presentation/widgets/empty_list_widget.dart';
import 'package:task_manager_app/presentation/widgets/snack_bar_message.dart';
import 'package:task_manager_app/presentation/widgets/task_card.dart';

import '../widgets/circular_progress_widget.dart';

class ProgressTaskScreen extends StatefulWidget {
  const ProgressTaskScreen({super.key});

  @override
  State<ProgressTaskScreen> createState() => _ProgressTaskScreenState();
}

class _ProgressTaskScreenState extends State<ProgressTaskScreen> {
  bool _getAllProgressTaskListInProgress = false;
  TaskListWrapper _progressTaskListWrapper = TaskListWrapper();

  @override
  void initState() {
    super.initState();
    _getAllProgressTaskList();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: profileAppBar,
      body: BackgroundWidget(
        child: Visibility(
          visible: _getAllProgressTaskListInProgress == false,
          replacement: const CircularProgressWidget(),
          child: RefreshIndicator(
            onRefresh: () async {
              _getAllProgressTaskList();
            },
            child: Visibility(
              visible: _progressTaskListWrapper.taskList?.isNotEmpty ?? false,
              replacement: const EmptyListWidget(),
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: _progressTaskListWrapper.taskList?.length ?? 0,
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskItem: _progressTaskListWrapper.taskList![index],
                    refreshList: () {
                      _getAllProgressTaskList();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future<void> _getAllProgressTaskList() async {
    _getAllProgressTaskListInProgress = true;
    setState(() {});
    final response = await NetworkCaller.getRequest(Urls.progressTaskList);
    if (response.isSuccess) {
      _progressTaskListWrapper = TaskListWrapper.fromJson(response.responseBody);
      _getAllProgressTaskListInProgress= false;
      setState(() {});
    } else {
      _getAllProgressTaskListInProgress = false;
      setState(() {});
      if (mounted) {
        showSnackBarMessage(
            context,
            response.errorMessage ??
                'Get progress task list has been failed');
      }
    }
  }
}