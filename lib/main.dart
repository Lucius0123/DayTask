import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/theme.dart';
import 'auth/auth_service.dart';
import 'auth/login_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'dashboard/task_controller.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase - you'll add your credentials after setup
  await Supabase.initialize(
    url: 'https://izfhlhokbhbhuuxuaouo.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Iml6ZmhsaG9rYmhiaHV1eHVhb3VvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUxNTYzNjcsImV4cCI6MjA2MDczMjM2N30.M09R1-W3ayP4O7m3MjEiOuvjfe_SUEtaGYYUxa3-Wpo',
  );
  Get.put(TaskController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthService _authService = Get.put(AuthService());

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'DayTask',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false,
      home: Obx(() {
        return _authService.isLoggedIn.value
            ? DashboardScreen()
            : LoginScreen();
      }),
    );
  }
}
