import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:velocity_x/velocity_x.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        centerTitle: true,
      ),
      floatingActionButton:
          const CircleAvatar(radius: 25, child: Icon(Icons.add))
              .marginAll(10)
              .onInkTap(() {
        Get.bottomSheet(Column(
          children: [
            10.heightBox,
            VxTextField(
              hint: "Enter Title",
              controller: controller.controllerTitle,
            ),
            10.heightBox,
            VxTextField(
              hint: "Enter Message",
              controller: controller.controllerMSg,
            ),
            20.heightBox,
            ElevatedButton(
                    onPressed: () {
                      controller.addData();
                    },
                    child: "Add Task".text.make())
                .w(double.infinity)
          ],
        ).p(10).box.white.topRounded().height(250).make());
      }),
      body: Obx(() {
        return controller.list.isEmpty
            ? "No Tasks Found".text.make()
            : ListView.builder(
                itemCount: controller.list.length,
                itemBuilder: ((context, index) {
                  final task = controller.list[index];
                  return Obx(() {
                    return CheckboxListTile(
                        title: task.check?.isTrue == true
                            ? task.title!.text.lineThrough.make()
                            : task.title!.text.make(),
                        value: controller.list[index].check?.value ?? false,
                        onChanged: (value) {
                          log("value $value");
                          controller.list[index].check?.value = value!;
                          controller.updateTask(task.timestamp,value!);
                        });
                  });
                }));
      }),
    );
  }
}
