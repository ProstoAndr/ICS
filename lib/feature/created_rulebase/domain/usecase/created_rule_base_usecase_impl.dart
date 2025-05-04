import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';

import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';

import '../../boundary/storage/rules_storage.dart';
import '../../boundary/usecase/created_rule_base_usecase.dart';

class CreatedRuleBaseUseCaseImpl implements CreatedRuleBaseUseCase {
  final RulesStorage rulesStorage;

  CreatedRuleBaseUseCaseImpl({required this.rulesStorage});

  @override
  Future<List<Rule>?> ruleBaseGeneration(RulesData rulesData) async {
    final int N = rulesData.countPlenty;
    if (N < 2) return null;

    final int m = rulesData.countTerm;
    final rand = Random();

    final combos = _enumerateAllCombinations(List.filled(N - 1, m));

    List<Rule> finalRules = [];
    int ruleId = 1;

    for (final combo in combos) {
      final weight = rand.nextDouble();

      final rule = Rule(
        id: '$ruleId',
        x: combo.map((e) => e.toDouble()).toList(),
        weight: weight,
      );
      finalRules.add(rule);
      ruleId++;
    }

    await rulesStorage.removeRules();
    rulesStorage.saveRules(Rule.toJsonStrList(finalRules));
    return finalRules;
  }

  List<List<int>> _enumerateAllCombinations(List<int> dims) {
    List<List<int>> result = [];

    void recurse(List<int> current, int idx) {
      if (idx == dims.length) {
        result.add(List.from(current));
        return;
      }
      for (int v = 0; v < dims[idx]; v++) {
        current[idx] = v;
        recurse(current, idx + 1);
      }
    }

    recurse(List.filled(dims.length, 0), 0);
    return result;
  }

  @override
  Future<void> creatingFile() async {
    final rulesString = await rulesStorage.getRules();
    if (rulesString == null) return;

    final bytes = utf8.encode(rulesString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', 'RuleBase.txt')
      ..click();

    html.Url.revokeObjectUrl(url);
  }
}
