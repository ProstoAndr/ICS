import 'point.dart';

class ChartData {
  final String name;
  final List<List<Point>> data;
  final List<List<Point>> membershipData;

  ChartData(this.name, this.data, this.membershipData);
}