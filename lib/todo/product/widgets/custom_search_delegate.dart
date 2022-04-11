import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:todo_app_proje4/main.dart';
import 'package:todo_app_proje4/todo/feature/data/local_storage.dart';
import 'package:todo_app_proje4/todo/product/widgets/task_list_item.dart';

import '../../feature/model/task_model.dart';

class CustomSearchDelegate extends SearchDelegate {
  final List<Task> allTask;

  CustomSearchDelegate({required this.allTask});

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.black,
          size: 24,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Task> filteredList = allTask
        .where(
            (gorev) => gorev.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
    return filteredList.length > 0
        ? ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              var _oankiListeElemani = filteredList[index];
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
                  onDismissed: (direction) async {
                    filteredList.removeAt(index);

                    await locator<LocalStorage>()
                        .deleteTask(task: _oankiListeElemani);
                  },
                  child: TaskListItem(task: _oankiListeElemani));
            })
        : Center(
            child: const Text('search_not_found').tr(),
          );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container();
  }
}
