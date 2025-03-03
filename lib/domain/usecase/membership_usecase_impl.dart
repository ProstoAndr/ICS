import 'dart:math';

import '../../boundary/usecase/membership_usecase.dart';
import '../../domain/entity/point.dart';
import '../../boundary/usecase/charts_usecase.dart';

class MembershipUseCaseImpl implements MembershipUseCase {
  final ChartsUseCase chartsUseCase;

  MembershipUseCaseImpl({required this.chartsUseCase});

  @override
  Future<List<Point>> gaussians(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    double step = (maxVal - minVal) / (countTerm - 1);
    double sigma = step / 2; // Отклонение Гаусса (чтобы функции плавно перекрывались)

    List<Point> points = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step; // Центр гауссовой функции

      for (double x in data) {
        // Гауссова функция: exp(- (x - bX)^2 / (2 * sigma^2))
        double membership = exp(-pow((x - bX), 2) / (2 * pow(sigma, 2)));

        points.add(Point(x: x, y: membership));
      }
    }

    return points;
  }

  @override
  Future<List<Point>> parabolas(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    double step = (maxVal - minVal) / (countTerm - 1);

    List<Point> points = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step; // Центр параболы
      double aX = bX - step;
      double cX = bX + step;

      for (double x in data) {
        if (x < aX || x > cX) continue; // Пропускаем точки вне диапазона

        // Вычисление значения по параболической функции (нормализованная)
        double membership = 1 - ((x - bX) * (x - bX)) / (step * step);
        membership = membership < 0 ? 0 : membership; // Ограничение значений снизу

        points.add(Point(x: x, y: membership));
      }
    }

    return points;
  }

  @override
  Future<List<Point>> trapezoids(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    double step = (maxVal - minVal) / (countTerm - 1);

    List<Point> points = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step; // Центр трапеции
      double aX = bX - step;         // Левая граница
      double dX = bX + step;         // Правая граница
      double cX = bX + step / 2;     // Верхняя правая граница

      for (double x in data) {
        if (x < aX || x > dX) continue; // Пропускаем точки вне диапазона

        double membership;
        if (x <= bX) {
          membership = (x - aX) / (bX - aX);
        } else if (x <= cX) {
          membership = 1.0; // Плато трапеции
        } else {
          membership = (dX - x) / (dX - cX);
        }

        points.add(Point(x: x, y: membership));
      }
    }

    return points;
  }

  @override
  Future<List<Point>> triangles(List<double> data, int countTerm) async {
    if (data.isEmpty) return [];

    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);
    double step = (maxVal - minVal) / (countTerm - 1);

    List<Point> points = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step; // Центр треугольника
      double aX = bX - step;
      double cX = bX + step;

      for (double x in data) {
        if (x < aX || x > cX) continue; // Пропускаем точки вне диапазона

        double membership;
        if (x < bX) {
          membership = (x - aX) / (bX - aX);
        } else {
          membership = (cX - x) / (cX - bX);
        }

        points.add(Point(x: x, y: membership));
      }
    }

    return points;
  }
}
