import 'package:get/get.dart';

class SearchController extends GetxController {
  var search = ''.obs;
  
  void searchProduct(String value) {
    search.value = value;
  }
}
