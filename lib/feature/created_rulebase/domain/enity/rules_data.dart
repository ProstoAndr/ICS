import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

class RulesData {
  final int countTerm;
  final int countPlenty;
  final List<ChartData> allCharts ;
  final List<Plenty> plenties;

  RulesData({
    required this.countTerm,
    required this.countPlenty,
    required this.allCharts,
    required this.plenties,
  });
}
