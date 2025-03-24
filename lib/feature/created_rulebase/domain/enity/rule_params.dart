import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';

class RuleParams {
  final String nameMethod;
  final RulesData rulesData;

  RuleParams({
    required this.nameMethod,
    required this.rulesData,
  });
}
