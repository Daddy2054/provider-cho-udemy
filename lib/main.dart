import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/todos_page.dart';
import 'providers/providers.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoList>(create: (context) => TodoList()),
        ChangeNotifierProvider<TodoFilter>(create: (context) => TodoFilter()),
        ChangeNotifierProvider<TodoSearch>(create: (context) => TodoSearch()),
        ProxyProvider<TodoList, ActiveTodoCount>(
          update: (
            BuildContext context,
            TodoList todoList,
            ActiveTodoCount? _,
          ) {
            return ActiveTodoCount(
              todoList: todoList,
            );
          },
        ),
        ProxyProvider3<TodoList, TodoFilter, TodoSearch, FilteredTodos>(
          update: (
            BuildContext context,
            TodoList todoList,
            TodoFilter todoFilter,
            TodoSearch todoSearch,
            FilteredTodos? _,
          ) {
            return FilteredTodos(
              todoList: todoList,
              todoFilter: todoFilter,
              todoSearch: todoSearch,
            );
          },
        ),
      ],
      child: MaterialApp(
        title: 'TODOS',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const TodosPage(),
      ),
    );
  }
}
