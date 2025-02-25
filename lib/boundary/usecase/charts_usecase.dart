import 'package:ics/domain/entity/point.dart';

abstract class ChartsUseCase {
  Future<List<List<Point>>> buildTriangle(List<double> data, int countTerm);
}