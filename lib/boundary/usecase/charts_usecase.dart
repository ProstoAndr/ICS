import 'package:ics/domain/entity/point.dart';

abstract class ChartsUseCase {
  Future<List<List<Point>>> buildTriangle(List<double> data, int countTerm);

  Future<List<List<Point>>> buildParabolic(List<double> data, int countTerm);

  Future<List<List<Point>>> buildTrapezoidal(List<double> data, int countTerm);

  Future<List<List<Point>>> buildGaussian(List<double> data, int countTerm);
}
