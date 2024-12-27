import 'package:flutter/material.dart';
import 'package:freaky_fridge/controllers/db.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:get/get.dart';

class MainPage extends StatelessWidget {
  final DatabaseController db = Get.find(tag: 'db');
  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Freaky Fridge"),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => {
              db.productDatabase.deleteTable(),
              db.productDatabase.insertProduct(
                ProductCompanion.insert(
                  name: "Test",
                  expiration: DateTime.now(),
                ),
              )
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: db.productDatabase.allProducts,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(snapshot.data![index].name!),
              );
            },
          );
        },
      ),
    );
  }
}
