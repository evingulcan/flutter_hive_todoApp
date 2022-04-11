import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todo_app_proje4/main.dart';
import 'package:todo_app_proje4/todo/feature/data/local_storage.dart';
import 'package:todo_app_proje4/todo/feature/model/task_model.dart';
import 'package:todo_app_proje4/todo/product/widgets/task_list_item.dart';

import '../../product/widgets/custom_search_delegate.dart';
import '../helper/translations_helper.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  late List<Task> _allTasks;
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _allTasks = <Task>[];
    _getAllTaskFormDb();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: GestureDetector(
            onTap: () {
              _showAddTaskBottomSheet();
            },
            child: const Text(
              'title',
              style: TextStyle(color: Colors.black),
            ).tr(),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              onPressed: () {
                _showSearchPage();
              },
              icon: const Icon(Icons.search),
            ),
            IconButton(
              onPressed: () {
                _showAddTaskBottomSheet();
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: _allTasks.isNotEmpty
            ? ListView.builder(
                itemCount: _allTasks.length,
                itemBuilder: (context, index) {
                  var _oankiListeElemani = _allTasks[index];
                  return Dismissible(
                      background: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          const Text('remove_task').tr(),
                        ],
                      ),
                      key: Key(_oankiListeElemani.id),
                      onDismissed: (direction) {
                        _allTasks.removeAt(index);
                        _localStorage.deleteTask(task: _oankiListeElemani);
                        setState(() {});
                      },
                      child: TaskListItem(task: _oankiListeElemani));
                })
            : Center(
                child: const Text(
                  'empty_task_list',
                  style: TextStyle(fontSize: 20),
                ).tr(),
              ));
  }

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          width: MediaQuery.of(context).size.width,
          child: ListTile(
            title: TextField(
              autofocus: true,
              style: const TextStyle(fontSize: 20),
              decoration: InputDecoration(
                hintText: 'add_task'.tr(),
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                Navigator.of(context).pop();
                if (value.length > 3) {
                  DatePicker.showTimePicker(context,
                      locale: TranslationHelper.getDeviceLanguage(context),
                      showSecondsColumn: false, onConfirm: (time) async {
                    var yeniEklenecekGorev = Task.create(value, time);

                    _allTasks.insert(0, yeniEklenecekGorev);
                    await _localStorage.addTask(task: yeniEklenecekGorev);
                    setState(() {});
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _getAllTaskFormDb() async {
    _allTasks = await _localStorage.getAllTask();
    setState(() {});
  }

  Future<void> _showSearchPage() async {
    await showSearch(
        context: context, delegate: CustomSearchDelegate(allTask: _allTasks));
    _getAllTaskFormDb();
  }
}
