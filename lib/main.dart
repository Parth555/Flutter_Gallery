import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttergallery/theme/app_theme.dart';
import 'package:fluttergallery/utils/app_color.dart';
import 'package:fluttergallery/utils/constant.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';
import 'services/dio_client.dart';
import 'utils/preference.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Preference().instance();
  await DioClient().instance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Gallery',
      color: primaryColor,
      theme: AppTheme.lightTheme(context),
      defaultTransition: Transition.fade,
      transitionDuration: const Duration(milliseconds: 50),
      getPages: AppPages.list,
      initialRoute: AppPages.initial,
    );
  }
}
