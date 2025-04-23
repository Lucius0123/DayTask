import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../dashboard/dashboard_screen.dart';

class AuthService extends GetxController {
  final SupabaseClient _supabase = Supabase.instance.client;
  final RxBool isLoggedIn = false.obs;
  final Rx<User?> currentUser = Rx<User?>(null);
  
  @override
  void onInit() {
    super.onInit();
    _initializeAuthState();
    _setupAuthListener();
  }
  
  void _initializeAuthState() {
    //This line fetches the current active session from Supabase
    final session = _supabase.auth.currentSession;
    if (session != null) {
      isLoggedIn.value = true;
      currentUser.value = session.user;
    }
  }
  //This function sets up a listener for authentication events from Supabase — such as logging in, logging out, or token refresh. It helps your app react in real-time to auth changes.
  void _setupAuthListener() {
    _supabase.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      final Session? session = data.session;
      
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.tokenRefreshed) {
        isLoggedIn.value = true;
        currentUser.value = session?.user;
      } else if (event == AuthChangeEvent.signedOut || event == AuthChangeEvent.userDeleted) {
        isLoggedIn.value = false;
        currentUser.value = null;
      }
    });
  }
  //SignUp
  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'full_name': fullName},
      );

      if (response.user != null) {
        Get.snackbar(
          'Success',
          'Account created successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // ✅ Navigate to home after short delay
        await Future.delayed(const Duration(milliseconds: 500));
         Get.offAll(() => DashboardScreen());
      } else {
        throw Exception('Failed to create account');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      
      if (response.user == null) {
        throw Exception('Invalid credentials');
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
  
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
  
  Future<void> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
      Get.snackbar(
        'Success',
        'Password reset link sent to your email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }
}
