import 'package:shared_preferences/shared_preferences.dart';

import '../boundary/storage/rules_storage.dart';

class RulesStorageImpl implements RulesStorage {

  @override
  Future<void> saveRules(String rulesText) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('rules_text', rulesText);
  }

  @override
  Future<String?> getRules() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('rules_text');
  }

  @override
  Future<void> removeRules() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('rules_text');
  }
}
