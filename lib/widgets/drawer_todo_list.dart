import 'package:flutter/material.dart';
// import 'package:simple_todo/classes/todo.dart';
import 'package:simple_todo/db/tasks/task_dao.dart';
import 'package:simple_todo/db/todos/todo_dao.dart';
// import 'package:simple_todo/pages/todos/edit_todo.dart';

// ignore: must_be_immutable
class DrawerTodoList extends StatefulWidget {
  Function(int) changeCurrentTodo;
  int currentIdTodo;

  DrawerTodoList(
      {Key? key, required this.changeCurrentTodo, required this.currentIdTodo})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DrawerTodoListState createState() => _DrawerTodoListState();
}

class _DrawerTodoListState extends State<DrawerTodoList> {
  bool loadingTodos = true;
  final todos = TodoDao.instance;
  final tasks = TaskDao.instance;
  List<Map<String, dynamic>> _todoList = [];

  @override
  void initState() {
    super.initState();
    getTodos();
  }

  Future<void> getTodos() async {
    var resp = await todos.queryAllByName();
    setState(() {
      _todoList = resp;
      loadingTodos = false;
    });
    _todoList.toString();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: _todoList.length,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          elevation: 0,
          shape: const StadiumBorder(),
          color: _todoList[index]['id_todo'] == widget.currentIdTodo
              ? Theme.of(context).colorScheme.secondaryContainer
              : Colors.transparent,
          child: ListTile(
            shape: const StadiumBorder(),
            leading: Icon(
              Icons.done_all_outlined,
              color: _todoList[index]['id_todo'] == widget.currentIdTodo
                  ? Theme.of(context).colorScheme.onSecondaryContainer
                  : null,
            ),
            key: UniqueKey(),
            title: Text(
              _todoList[index]['name'],
              style: _todoList[index]['id_todo'] == widget.currentIdTodo
                  ? TextStyle(
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500)
                  : const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            onTap: () async {
              await widget.changeCurrentTodo(_todoList[index]['id_todo']);
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }
}
