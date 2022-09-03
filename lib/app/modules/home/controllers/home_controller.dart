import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:testcode/app/data/models/add_task_params.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final list = <AddTaskParams>[].obs;
  final TextEditingController controllerTitle = TextEditingController();
  final TextEditingController controllerMSg = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    readData();
  }

  addData() {
    if (controllerTitle.text.isEmpty || controllerMSg.text.isEmpty) {
      Get.snackbar("Fields required", "Place enter all fields");
      return;
    }

    final AddTaskParams params = AddTaskParams(
        title: controllerTitle.text,
        timestamp: FieldValue.serverTimestamp(),
        message: controllerMSg.text);
    db.collection("tasks").add(params.toJson()).then((value) {
      log("value ");
    }, onError: (er) {
      log("e $er");
    });
  }

  readData() {
    try {
      db
          .collection("tasks")
          .orderBy('timestamp', descending: true)
          .snapshots()
          .listen((event) {
        list.clear();
        for (final DocumentSnapshot<Map<String, dynamic>> doc in event.docs) {
          list.add(AddTaskParams.fromFirestore(doc));
        }
        log("list length ${list.length}");
      });
    } catch (e) {
      log("e $e");
    }
  }

  updateTask(dynamic timestamp, bool check) async {
    final QuerySnapshot searcheduserid = await db
        .collection('tasks')
        .where('timestamp', isEqualTo: timestamp)
        .limit(1)
        .get();

    final document = searcheduserid.docs.first;
    final userDocId = document.id;
    log("id $userDocId");
    db
        .collection("tasks")
        .doc(userDocId)
        .update({'check': check}).then((value) {
         
        });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
  void increment() => count.value++;
}
