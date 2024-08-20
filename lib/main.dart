import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/todo_bloc.dart';
import 'models/todo.dart';
import 'objectbox.g.dart'; // Import generated code
import 'page/todo_page.dart';

late final Store store;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize ObjectBox
  store = await openStore();
  final todoBox = store.box<Todo>();

  runApp(MyApp(
    todoBox: todoBox,
  ));
}

class MyApp extends StatelessWidget {
  final Box<Todo> todoBox;
  const MyApp({super.key, required this.todoBox});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => TodoBloc(todoBox),
        child: MaterialApp(
          title: 'Flutter ToDo BLoC App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const TodoPage(),
        ));
  }
}
