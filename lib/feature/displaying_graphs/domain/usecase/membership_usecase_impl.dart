import 'dart:math';

import '../../boundary/usecase/membership_usecase.dart';
import '../entity/point.dart';
import '../../boundary/usecase/charts_usecase.dart';

class MembershipUseCaseImpl implements MembershipUseCase {
  final ChartsUseCase chartsUseCase;

  MembershipUseCaseImpl({required this.chartsUseCase});

  @override
  Future<List<List<Point>>> gaussians(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce(min);
    double maxVal = data.reduce(max);
    double step = (maxVal - minVal) / (countTerm - 1);
    double sigma = step / 2; // Разброс

    List<List<Point>> allMemberships = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step;
      List<Point> termPoints = [];

      for (double x in data) {
        double membership = exp(-pow((x - bX), 2) / (2 * pow(sigma, 2)));
        termPoints.add(Point(x: x, y: membership));
      }

      allMemberships.add(termPoints);
    }

    return allMemberships;
  }

  @override
  Future<List<List<Point>>> parabolas(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce(min);
    double maxVal = data.reduce(max);
    double step = (maxVal - minVal) / (countTerm - 1);

    List<List<Point>> allMemberships = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step;
      double aX = bX - step;
      double cX = bX + step;
      List<Point> termPoints = [];

      for (double x in data) {
        if (x < aX || x > cX) continue;
        double membership = 1 - ((x - bX) * (x - bX)) / (step * step);
        termPoints.add(Point(x: x, y: max(0, membership)));
      }

      allMemberships.add(termPoints);
    }

    return allMemberships;
  }

  @override
  Future<List<List<Point>>> trapezoids(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce(min);
    double maxVal = data.reduce(max);
    double step = (maxVal - minVal) / (countTerm - 1);

    List<List<Point>> allMemberships = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step;
      double aX = bX - step;
      double dX = bX + step;
      double cX = bX + step / 2;
      List<Point> termPoints = [];

      for (double x in data) {
        if (x < aX || x > dX) continue;
        double membership = x <= bX
            ? (x - aX) / (bX - aX)
            : (dX - x) / (dX - cX);
        termPoints.add(Point(x: x, y: membership));
      }

      allMemberships.add(termPoints);
    }

    return allMemberships;
  }

  @override
  Future<List<List<Point>>> triangles(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce(min);
    double maxVal = data.reduce(max);
    double step = (maxVal - minVal) / (countTerm - 1);

    List<List<Point>> allMemberships = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step;
      double aX = bX - step;
      double cX = bX + step;
      List<Point> termPoints = [];

      for (double x in data) {
        if (x < aX || x > cX) continue;
        double membership = x < bX ? (x - aX) / (bX - aX) : (cX - x) / (cX - bX);
        termPoints.add(Point(x: x, y: membership));
      }

      allMemberships.add(termPoints);
    }

    return allMemberships;
  }
}
