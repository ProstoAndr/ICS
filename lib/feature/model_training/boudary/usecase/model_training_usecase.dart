import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

abstract class ModelTrainingUseCase {
  Future<List<Rule>> gradientDescent(
    List<Rule> listRule,
    double singleton,
    List<Plenty> plenties,
  );
}
