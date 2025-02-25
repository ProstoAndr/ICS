import 'package:ics/domain/entity/point.dart';
import '../../boundary/usecase/charts_usecase.dart';

class ChartsUseCaseImpl implements ChartsUseCase {
  @override
  Future<List<List<Point>>> buildTriangle(List<double> data, int countTerm) async {
    double minVal = data.reduce((a, b) => a < b ? a : b);
    double maxVal = data.reduce((a, b) => a > b ? a : b);

    double step = (maxVal - minVal) / (countTerm - 1);

    List<List<Point>> allTriangles = [];

    for (int i = 0; i < countTerm; i++) {
      double bX = minVal + i * step; // Центр треугольника
      double aX = bX - step;
      double cX = bX + step;

      List<Point> triangle = [];

      if (i == 0) {
        // Первый треугольник без левого края
        triangle = [
          Point(x: bX, y: 1),
          Point(x: cX, y: 0),
        ];
      } else if (i == countTerm - 1) {
        // Последний треугольник без правого края
        triangle = [
          Point(x: aX, y: 0),
          Point(x: bX, y: 1),
        ];
      } else {
        // Обычные треугольники
        triangle = [
          Point(x: aX, y: 0),
          Point(x: bX, y: 1),
          Point(x: cX, y: 0),
        ];
      }

      allTriangles.add(triangle);
    }

    return allTriangles;
  }
}
