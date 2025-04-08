import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

abstract class ModelTrainingUseCase {
  List<Rule> gradientDescent(
    List<Rule> listRule,
    double singleton,
    List<Plenty> plenties,
    List<ChartData> membershipAll,
  );

  Future<double> predictTSK({
    required double x0,
    required double x1,
    required double x2,
    required List<Rule> listRule,
    required List<ChartData> membershipAll,
  });
}
