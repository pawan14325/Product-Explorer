import 'package:shared_preferences/shared_preferences.dart';

abstract class CacheService {
  Future<void> saveProducts(String key, String data);
  Future<String?> getProducts(String key);
  Future<void> clearCache();
}

class CacheServiceImpl implements CacheService {
  final SharedPreferences _prefs;

  CacheServiceImpl(this._prefs);

  @override
  Future<void> saveProducts(String key, String data) async {
    await _prefs.setString(key, data);
  }

  @override
  Future<String?> getProducts(String key) async {
    return _prefs.getString(key);
  }

  @override
  Future<void> clearCache() async {
    await _prefs.clear();
  }
}
