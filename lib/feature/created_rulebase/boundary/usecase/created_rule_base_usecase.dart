import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';

import '../../domain/enity/rule.dart';

abstract class CreatedRuleBaseUseCase {
  Future<List<Rule>?> ruleBaseGeneration(RulesData rulesData);

  Future<void> creatingFile();
}
