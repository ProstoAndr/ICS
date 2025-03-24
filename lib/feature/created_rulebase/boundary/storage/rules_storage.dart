abstract class RulesStorage {
  Future<void> saveRules(String rulesText);

  Future<String?> getRules();

  Future<void> removeRules();
}
