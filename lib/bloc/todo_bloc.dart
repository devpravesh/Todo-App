import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
import '../Services/service.dart';
import '../models/todo.dart';
import '../models/todo_model.dart';
import 'todo_event.dart';
import 'todo_state.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final Box<Todo> todoBox;
  late final StreamSubscription<List<Todo>> _subscription;
  final ApiService apiService = ApiService();

  TodoBloc(this.todoBox) : super(TodoInitial()) {
    print("TodoBloc initialized");

    // Register the event handlers
    _registerEventHandlers();

    // Trigger the LoadTodos event after handlers are registered
    add(LoadTodos());
  }

  void _registerEventHandlers() {
    // Register the handler for LoadTodos
    on<LoadTodos>((event, emit) async {
      debugPrint("LoadTodos event triggered");

      try {
        // Check if there are existing todos in the database
        List<Todo> todos = todoBox.getAll();

        if (todos.isEmpty) {
          final List<TodoModel> fetchedTodos = await apiService.fetchTasks();
          todos = fetchedTodos
              .map((task) => Todo(
                    id: task.id!,
                    title: task.title!,
                    isCompleted: task.isCompleted!,
                  ))
              .toList();
          todoBox.putMany(todos);
        }

        // Emit the loaded todos
        emit(TodoLoaded(todos));
      } catch (e) {
        debugPrint('Error loading todos: $e');
        emit(const TodoError('Failed to load todos'));
      }
    });

    // Handle AddTodo event
    on<AddTodo>((event, emit) {
      todoBox.put(event.todo);
      emit(TodoLoaded(todoBox.getAll()));
    });

    // Handle UpdateTodo event
    on<UpdateTodo>((event, emit) {
      todoBox.put(event.todo);
      emit(TodoLoaded(todoBox.getAll()));
    });

    // Handle DeleteTodo event
    on<DeleteTodo>((event, emit) {
      todoBox.remove(event.id);
      emit(TodoLoaded(todoBox.getAll()));
    });

    // Subscribe to changes in the database
    _subscription =
        todoBox.query().watch(triggerImmediately: true).map((query) {
      return query.find();
    }).listen((todos) {
      // ignore: invalid_use_of_visible_for_testing_member
      emit(TodoLoaded(todos));
    });
  }

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
