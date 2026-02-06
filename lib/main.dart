import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'theme/theme.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      title: "Estuaire Achats",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: EstuaireTheme.lightTheme,
      darkTheme: EstuaireTheme.darkTheme,
      themeMode: ThemeMode.system, // Follow system theme by default
      debugShowCheckedModeBanner: false,
    ),
  );
}
