import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

abstract class ModelTrainingUseCase {
  Future<List<Rule>> modelTraining({
    required List<Plenty> listPlenty,
    required List<ChartData> listChartData,
    required List<Rule> listRule,
  });

  Future<double> predictTSK({
    required List<Plenty> listPlenty,
    required List<ChartData> listChartData,
    required List<Rule> listRule,
  });
}
