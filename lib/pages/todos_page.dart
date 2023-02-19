// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:provider_cho_udemy/models/todo_model.dart';
import 'package:provider_cho_udemy/utils/debounce.dart';

import '../providers/providers.dart';

class TodosPage extends StatefulWidget {
  const TodosPage({Key? key}) : super(key: key);

  @override
  State<TodosPage> createState() => _TodosPageState();
}

class _TodosPageState extends State<TodosPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 40,
            ),
            child: Column(
              children: [
//                              Text('TODOS'),
                const TodoHeader(),
                const CreateTodo(),
                const SizedBox(height: 20),
                SearchAndFilterTodo(),
                const ShowTodos(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SearchAndFilterTodo extends StatelessWidget {
  SearchAndFilterTodo({super.key});
  final debounce = Debounce(milliseconds: 1000);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Search todos',
            border: InputBorder.none,
            filled: true,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (String? newSearchTerm) {
            debounce.run(() {
              context.read<TodoSearch>().setSearchTerm(newSearchTerm!);
            });
          },
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            filterButton(context, Filter.all),
            filterButton(context, Filter.active),
            filterButton(context, Filter.completed),
          ],
        ),
      ],
    );
  }

  Widget filterButton(BuildContext context, Filter filter) {
    return TextButton(
      onPressed: () {
        context.read<TodoFilter>().changeFilter(filter);
      },
      child: Text(
        filter == Filter.all
            ? 'All'
            : filter == Filter.active
                ? 'Active'
                : 'Completed',
        style: TextStyle(
          fontSize: 18,
          color: textColor(context, filter),
        ),
      ),
    );
  }

  Color textColor(BuildContext context, Filter filter) {
    return context.watch<TodoFilter>().state.filter == filter
        ? Colors.blue
        : Colors.grey;
  }
}

class TodoHeader extends StatelessWidget {
  const TodoHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'TODO',
          style: TextStyle(
            fontSize: 40,
            //fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '${context.watch<ActiveTodoCount>().state.activeTodoCount} items left',
          style: TextStyle(
            fontSize: 20,
            color: Colors.redAccent,
          ),
        )
//        Icon(Icons.settings),
      ],
    );
  }
}

class CreateTodo extends StatefulWidget {
  const CreateTodo({super.key});

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}

class _CreateTodoState extends State<CreateTodo> {
  final newTodoController = TextEditingController();

  @override
  void dispose() {
    newTodoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: newTodoController,
      decoration: InputDecoration(
        labelText: 'What to do?',
      ),
      onSubmitted: (String? todoDesc) {
        if (todoDesc != null && todoDesc.isNotEmpty) {
          context.read<TodoList>().addTodo(todoDesc);
          newTodoController.clear();
        }
      },
    );
  }
}

class ShowTodos extends StatelessWidget {
  const ShowTodos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final todos = context.watch<FilteredTodos>().state.filteredTodos;

    Widget showBackground(int direction) {
      return Container(
        margin: EdgeInsets.all(4),
        padding: EdgeInsets.symmetric(horizontal: 10),
        color: Colors.red,
        alignment:
            direction == 0 ? Alignment.centerLeft : Alignment.centerRight,
        child: Icon(
          Icons.delete,
          size: 30,
          color: Colors.white,
        ),
        //  SizedBox(width: 20),
      );
    }

    return ListView.separated(
      primary: false,
      shrinkWrap: true,
      itemCount: todos.length,
      separatorBuilder: (
        BuildContext context,
        int index,
      ) =>
          Divider(
        color: Colors.grey,
      ),
      itemBuilder: (BuildContext context, int index) {
        return Dismissible(
          key: ValueKey(
            todos[index].id,
          ),
          background: showBackground(0),
          secondaryBackground: showBackground(1),
          onDismissed: (_) {
            context.read<TodoList>().removeTodo(
                  todos[index],
                );
          },
          confirmDismiss: (_) {
            return showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text('Are you sure?'),
                  content: Text('Do you really want to delete?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('NO'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('YES'),
                    ),
                  ],
                );
              },
            );
          },
          child: TodoItem(
            todo: todos[index],
          ),
        );
      },
    );
  }
}

class TodoItem extends StatefulWidget {
  final Todo todo;
  const TodoItem({
    Key? key,
    required this.todo,
  }) : super(key: key);

  @override
  State<TodoItem> createState() => _TodoItemState();
}

class _TodoItemState extends State<TodoItem> {
  late final TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            bool _error = false;
            textController.text = widget.todo.desc;
            return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return AlertDialog(
                  title: Text('Edit Todo'),
                  content: TextField(
                    controller: textController,
                    autofocus: true,
                    decoration: InputDecoration(
                      errorText: _error ? 'Value cannot be empty' : null,
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(
                          () {
                            _error = textController.text.isEmpty ? true : false;
                            if (!_error) {
                              context.read<TodoList>().editTodo(
                                    widget.todo.id,
                                    textController.text,
                                  );
                              Navigator.pop(context);
                            }
                          },
                        );
                      },
                      child: Text('Edit'),
                    ),
                  ],
                );
              },
            );
          },
        );
      },
      leading: Checkbox(
        value: widget.todo.completed,
        onChanged: (bool? checked) {
          context.read<TodoList>().toggleTodo(
                widget.todo.id,
              );
        },
      ),
      title: Text(
        widget.todo.desc,
        style: TextStyle(
          fontSize: 20,
          decoration: widget.todo.completed
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
    );
  }
}
