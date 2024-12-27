import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationController extends GetxController {
  late RxInt currentIndex;
  final List<Widget> pages;

  NavigationController({required this.pages, required int index}) {
    currentIndex = index.obs;
  }

  void navigateTo(int index) {
    currentIndex.value = index;
  }
}
