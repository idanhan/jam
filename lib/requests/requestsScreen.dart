import 'package:budget_app/requests/requestsController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class RequestsScreen extends StatelessWidget {
  String username;
  RequestsScreen({required this.username});
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Consumer<RequestsController>(
        builder: (context, controller, child) => Column(
          children: [
            SizedBox(
              height: height * 0.1,
            ),
            const Text(
              "Friend requests",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(
              height: height * 0.05,
            ),
            const Divider(),
            SingleChildScrollView(
              child: Container(
                height: height * 0.5,
                child: FutureBuilder(
                    future: controller.getRequests(username),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Center(
                            child: snapshot.hasData
                                ? Text("Error ${snapshot.error}")
                                : const Text("No new requests"));
                      } else {
                        return ListView.builder(
                          itemBuilder: (context, index) => Column(
                            children: [
                              SizedBox(
                                height: height * 0.05,
                              ),
                              ListTile(
                                title: Text(snapshot.data![index].name),
                                leading: CircleAvatar(
                                  child: controller
                                      .images[snapshot.data![index].name],
                                ),
                                trailing: Wrap(children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.removeRequest(
                                          username, snapshot.data![index].name);
                                    },
                                    child: const Text("Remove"),
                                  ),
                                  ElevatedButton(
                                      onPressed: () async {
                                        await controller.acceptrequest(username,
                                            snapshot.data![index].name);
                                      },
                                      child: const Text("Add Friend"))
                                ]),
                              )
                            ],
                          ),
                          itemCount: snapshot.data!.length,
                        );
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
