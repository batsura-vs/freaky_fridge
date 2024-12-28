import 'package:flutter/material.dart';
import 'package:freaky_fridge/database/database.dart';
import 'package:freaky_fridge/widgets/product.dart';
import 'package:freaky_fridge/widgets/qr_product.dart';
import 'package:get/get.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ProductDatabase.instance.watchAllProducts(),
      builder: (context, snapshot) => Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchAnchor(
              isFullScreen: false,
              viewConstraints: const BoxConstraints(
                maxHeight: 300.0,
              ),
              builder: (context, controller) => SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                leading: const Icon(Icons.search),
                hintText: "Search",
                controller: controller,
                onTap: () => controller.openView(),
                onChanged: (value) => controller.openView(),
                trailing: [
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () => Get.to(
                      () => ProductWidget(),
                    ),
                  ),
                ],
              ),
              suggestionsBuilder: (context, controller) {
                List<Widget> suggestions = [];
                for (var product in snapshot.data!) {
                  if (product.name
                      .toLowerCase()
                      .contains(controller.text.toLowerCase())) {
                    suggestions.add(
                      ListTile(
                        title: Text(product.name),
                        onTap: () => controller.closeView(product.name),
                      ),
                    );
                  }
                  if (suggestions.length > 5) {
                    break;
                  }
                }
                return suggestions;
              },
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: snapshot.hasData
              ? snapshot.data!.isNotEmpty
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) => Card(
                        child: ListTile(
                          title: Text(snapshot.data![index].name),
                          subtitle: snapshot.data![index].description == null
                              ? null
                              : Text(snapshot.data![index].description!),
                          onTap: () => Get.to(
                            () => ProductWidget(
                              product: snapshot.data![index],
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.qr_code),
                            onPressed: () => Get.to(
                              () => QrProductWidget(
                                product: snapshot.data![index],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  : const Center(child: Text("No products"))
              : const Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }
}
