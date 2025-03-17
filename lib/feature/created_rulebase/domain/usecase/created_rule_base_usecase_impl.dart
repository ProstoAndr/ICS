import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boundary/usecase/created_rule_base_usecase.dart';
import '../enity/rule.dart';

class CreatedRuleBaseUseCaseImpl implements CreatedRuleBaseUseCase {
  @override
  Future<void> ruleBaseGeneration(RulesData rulesData) async {
    ///Пример правил
    final rules = [
      Rule(id: "1", x: [1.0, 2.0], y: 3.0, weight: 4.0),
      Rule(id: "2", x: [2.0, 3.0], y: 4.0, weight: 5.0),
    ];
    _creatingFile(rules);
    // TODO: implement ruleBaseGeneration
    throw UnimplementedError();
  }

  Future<void> _creatingFile(List<Rule> rules) async {

    ///Пример работы с провилами
    /// Преобразуем список объектов в JSON-строку
    String jsonStr = Rule.toJsonStrList(rules);
    print(jsonStr);
    // TODO: implement _creatingFile
    throw UnimplementedError();
  }

  Future<List<double>> _parametersNormalization(List<List<Point>> membershipData) async {
    // TODO: implement _parametersNormalization
    throw UnimplementedError();
  }

  Future<List<double>> _parametersReverseNormalization(List<List<Point>> membershipData) async {
    // TODO: implement _parametersReverseNormalization
    throw UnimplementedError();
  }

  Future<List<Point>> _singleton(List<List<double>> matrix) async {
    // TODO: implement _parametersReverseNormalization
    throw UnimplementedError();
  }
}
