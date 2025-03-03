import '../../domain/entity/point.dart';

abstract class MembershipUseCase {
  Future<List<Point>> triangles(List<double> data, int countTerm);

  Future<List<Point>> trapezoids(List<double> data, int countTerm);

  Future<List<Point>> gaussians(List<double> data, int countTerm);

  Future<List<Point>> parabolas(List<double> data, int countTerm);
}
