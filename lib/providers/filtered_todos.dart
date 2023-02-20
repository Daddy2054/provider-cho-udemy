// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';

import 'package:provider_cho_udemy/models/todo_model.dart';
import 'package:provider_cho_udemy/providers/providers.dart';
import 'package:state_notifier/state_notifier.dart';

class FilteredTodosState extends Equatable {
  final List<Todo> filteredTodos;
  FilteredTodosState({
    required this.filteredTodos,
  });

  factory FilteredTodosState.initial() => FilteredTodosState(filteredTodos: []);

  @override
  List<Object> get props => [filteredTodos];

  @override
  bool get stringify => true;

  FilteredTodosState copyWith({
    List<Todo>? filteredTodos,
  }) {
    return FilteredTodosState(
      filteredTodos: filteredTodos ?? this.filteredTodos,
    );
  }
}

class FilteredTodos extends StateNotifier<FilteredTodosState>
    with LocatorMixin {
  FilteredTodos() : super(FilteredTodosState.initial());

  @override
  void update(Locator watch) {
    final Filter filter = watch<TodoFilterState>().filter;
    final List<Todo> todos = watch<TodoListState>().todos;
    final String searchTerm = watch<TodoSearchState>().searchTerm;

    // FilteredTodosState get state  {
//     List<Todo> _filteredTodos;
//     switch (todoFilter.state.filter) {
//       case Filter.active:
//         _filteredTodos =
//             todoList.state.todos.where((Todo todo) => !todo.completed).toList();
//         break;
//       case Filter.completed:
//         _filteredTodos =
//             todoList.state.todos.where((Todo todo) => todo.completed).toList();
//         break;

//       case Filter.all:
//       default:
//         _filteredTodos = todoList.state.todos;
//         break;
//     }
//     if (todoSearch.state.searchTerm.isNotEmpty) {
//       _filteredTodos = _filteredTodos.where((Todo todo) {
//         return todo.desc.toLowerCase().contains(
//               todoSearch.state.searchTerm.toLowerCase(),
//             );
//       }).toList();
//     }
// return FilteredTodosState(filteredTodos: _filteredTodos);
//   }

    List<Todo> _filteredTodos;
    switch (filter) {
      case Filter.active:
        _filteredTodos = todos.where((Todo todo) => !todo.completed).toList();
        break;
      case Filter.completed:
        _filteredTodos = todos.where((Todo todo) => todo.completed).toList();
        break;

      case Filter.all:
      default:
        _filteredTodos = todos;
        break;
    }
    if (searchTerm.isNotEmpty) {
      _filteredTodos = _filteredTodos.where((Todo todo) {
        return todo.desc.toLowerCase().contains(
              searchTerm.toLowerCase(),
            );
      }).toList();
    }
    state = state.copyWith(filteredTodos: _filteredTodos);

    super.update(watch);
  }
}
