import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/home/home_page/home_page_binding.dart';
import '../screens/home/home_page/home_page_view.dart';
import '../utils/utils.dart';
import 'app_routes.dart';

class AppPages {

  static var initial = AppRoutes.home;

  static var list = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomePageWidget(),
      binding: HomePageBinding(),
    ),
  ];
}
