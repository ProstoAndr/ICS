import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

class ChartParams {
  final int chartIndex;
  final int termCount;
  final List<Plenty> listPlenty;

  ChartParams({
    required this.chartIndex,
    required this.termCount,
    required this.listPlenty,
  });
}
