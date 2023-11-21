import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getTasks() async {
  List tasks = [];

  CollectionReference tasksRef = db.collection('tasks');

  QuerySnapshot queryTasks = await tasksRef.get();

  queryTasks.docs.forEach((element) {
    tasks.add(element.data());
  });
  
  return tasks;
}