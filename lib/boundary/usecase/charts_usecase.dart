import 'package:ics/domain/entity/point.dart';

abstract class ChartsUseCase {
  Future<List<List<Point>>> buildTriangle(int countTerm);
}