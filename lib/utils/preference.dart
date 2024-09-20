import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

/* global class for handle all the preference activity into application */

class Preference {
  // Preference key
  static const String selectedLanguage = "LANGUAGE";
  static const String selectedCountryCode = "SELECTED_COUNTRY_CODE";

  static const String fcmToken = "FCM_TOKEN";
  static const String accessToken = "ACCESS_TOKEN";
  static const String userData = "USER_DATA";
  static const String isFirstTime = "IS_FIRST_TIME";

  static const String isPurchasePremium = "IS_PURCHASE_PREMIUM";

  // ------------------ SINGLETON -----------------------
  static final Preference _preference = Preference._internal();

  factory Preference() {
    return _preference;
  }

  Preference._internal();

  static Preference get shared => _preference;

  static SharedPreferences? _pref;

  /* make connection with preference only once in application */
  Future<SharedPreferences?> instance() async {
    if (_pref != null) return _pref;
    await SharedPreferences.getInstance().then((onValue) {
      _pref = onValue;
    }).catchError((onError) {
      _pref = null;
    });
    return _pref;
  }

  String? getString(String key) {
    return _pref!.getString(key);
  }

  Future<void> setString(String key, String value) {
    return _pref!.setString(key, value);
  }

  int? getInt(String key) {
    return _pref!.getInt(key);
  }

  Future<void> setInt(String key, int value) {
    return _pref!.setInt(key, value);
  }

  bool? getBool(String key) {
    return _pref!.getBool(key);
  }

  Future<void> setBool(String key, bool value) {
    return _pref!.setBool(key, value);
  }

  // Double get & set
  double? getDouble(String key) {
    return _pref!.getDouble(key);
  }

  Future<void> setDouble(String key, double value) {
    return _pref!.setDouble(key, value);
  }

  // Array get & set
  List<String>? getStringList(String key) {
    return _pref!.getStringList(key);
  }

  Future<void> setStringList(String key, List<String> value) {
    return _pref!.setStringList(key, value);
  }

  /* remove element from preferences */
  Future<bool?> remove(key, [multi = false]) async {
    SharedPreferences? pref = await instance();
    if (multi) {
      key.forEach((f) async {
        return await pref?.remove(f);
      });
    } else {
      return await pref?.remove(key);
    }

    return Future.value(true);
  }

  /// In app purchase
  Future<void> setIsPurchase(bool value) {
    return _pref!.setBool(isPurchasePremium, value);
  }

  bool getIsPurchase() {
    return _pref!.getBool(isPurchasePremium) ?? false;
  }

  /* remove all elements from preferences */
  static Future<bool> clear() async {
    // return await _pref.clear();
    _pref!.getKeys().forEach((key) async {
      await _pref!.remove(key);
    });

    return Future.value(true);
  }

  static Future<bool> clearLogout() async {
    /*_pref!.getKeys().forEach((key) async {
      if (key == accessToken ||
          key == tokenType ||
          key == expiresIn ||
          key == userEmail ||
          key == userData) {
        await _pref!.remove(key);
      }
    });*/
    await _pref!.remove(accessToken);
    await _pref!.remove(userData);
    return Future.value(true);
  }
}
