import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app/bindings/initial_binding.dart';
import 'app/routes/app_pages.dart';
import 'theme/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  runApp(
    GetMaterialApp(
      title: "Estuaire Achats",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      theme: EstuaireTheme.lightTheme,
      darkTheme: EstuaireTheme.darkTheme,
      themeMode: ThemeMode.system, // Follow system theme by default
      debugShowCheckedModeBanner: false,
    ),
  );
}
