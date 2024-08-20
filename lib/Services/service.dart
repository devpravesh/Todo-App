import 'dart:convert'; // Import for jsonDecode
import 'dart:developer'; // Import for log
import 'package:dio/dio.dart';
import '../models/todo_model.dart'; // Adjust the import path as needed

class ApiService {
  final Dio _dio = Dio();

  Future<List<TodoModel>> fetchTasks() async {
    try {
      final response = await _dio
          .get('https://raw.githubusercontent.com/devpravesh/api/main/db.json');

      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.data);

        // Ensure jsonData is treated as a List<dynamic>
        List<dynamic> tasksList = jsonData;

        // Map each dynamic item in the list to a TodoModel
        return tasksList.map((task) => TodoModel.fromJson(task)).toList();
      } else {
        throw Exception('Failed to load tasks');
      }
    } on Exception catch (e) {
      log(e.toString());
      return []; // Return an empty list in case of error
    } finally {
      print("function Completed");
    }
  }
}
