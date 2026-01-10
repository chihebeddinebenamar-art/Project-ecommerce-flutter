import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_profile.dart';

class UserService {
  static final UserService _instance = UserService._internal();
  factory UserService() => _instance;
  UserService._internal();

  static const String _profileKey = 'user_profile';

  Future<UserProfile?> getCurrentUserProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return null;

    
    final prefs = await SharedPreferences.getInstance();
    final profileJson = prefs.getString(_profileKey);
    
    if (profileJson != null) {
      try {
        final profile = UserProfile.fromJson(jsonDecode(profileJson));
      
        if (profile.uid == user.uid) {
          return profile;
        }
      } catch (e) {
       
      }
    }

   
    return UserProfile.fromFirebaseUser(
      user.uid,
      user.email ?? '',
      name: user.displayName,
      phone: user.phoneNumber,
    );
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
    
   
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && user.displayName != profile.name) {
      await user.updateDisplayName(profile.name);
      await user.reload();
    }
  }

  Future<void> updateUserProfile(UserProfile profile) async {
    await saveUserProfile(profile);
  }

  Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}

