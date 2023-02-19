import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_cho_udemy/models/todo_model.dart';

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
                const SearchAndFilterTodo(),
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
  const SearchAndFilterTodo({super.key});

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
            context.read<TodoSearch>().setSearchTerm(newSearchTerm!);
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
          child: Text(
            todos[index].desc,
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
