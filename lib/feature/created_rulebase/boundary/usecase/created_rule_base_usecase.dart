import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';

abstract class CreatedRuleBaseUseCase {
  Future<void> ruleBaseGeneration(RulesData rulesData);
  Future<double> singleton(RulesData rulesData);
}
