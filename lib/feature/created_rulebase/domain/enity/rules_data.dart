import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';

class RulesData {
  final int countTerm;
  final int countPlenty;
  final List<ChartData> allCharts ;

  RulesData({
    required this.countTerm,
    required this.countPlenty,
    required this.allCharts,
  });
}
