import '../../domain/entity/point.dart';

abstract class MembershipUseCase {
  Future<List<List<Point>>> triangles(List<double> data, int countTerm);

  Future<List<List<Point>>> trapezoids(List<double> data, int countTerm);

  Future<List<List<Point>>> gaussians(List<double> data, int countTerm);

  Future<List<List<Point>>> parabolas(List<double> data, int countTerm);
}
