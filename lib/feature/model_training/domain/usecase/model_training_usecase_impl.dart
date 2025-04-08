import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boudary/usecase/model_training_usecase.dart';

class ModelTrainingUseCaseImpl implements ModelTrainingUseCase {
  @override
  List<Rule> gradientDescent(List<Rule> listRule,
      double singleton,
      List<Plenty> plenties,
      List<ChartData> membershipAll,
      ) {
    // === A. Параметры обучения ===
    final int numEpochs    = 1000;      // число эпох
    final double learningRate = singleton;  // скорость обучения
    final double eps       = 1e-12;     // защита от деления на 0

    // === B. Предполагаем, что у нас 3 входа + 1 выход => всего 4 "Plenty":
    // plenties[0] => x0
    // plenties[1] => x1
    // plenties[2] => x2
    // plenties[3] => y (фактическое значение)
    final int dataSize = plenties[0].data.length;
    if (plenties.any((p) => p.data.length != dataSize)) {
      throw Exception("Все входные/выходные ряды должны иметь одинаковую длину!");
    }

    // === C. Основной цикл обучения ===
    for (int epoch = 0; epoch < numEpochs; epoch++) {
      // 1) Обнуляем градиенты для каждого правила
      final List<double> gradY = List<double>.filled(listRule.length, 0.0);
      final List<double> gradW = List<double>.filled(listRule.length, 0.0);

      double mse = 0.0;

      // 2) Проходим по всей выборке
      for (int n = 0; n < dataSize; n++) {
        // а) Считываем входы (x0,x1,x2) и настоящий выход realY
        final double x0 = plenties[0].data[n];
        final double x1 = plenties[1].data[n];
        final double x2 = plenties[2].data[n];
        final double realY = plenties[3].data[n];

        // б) Вычисляем firing strength alpha[r] для каждого правила
        final List<double> alpha = List.filled(listRule.length, 0.0);

        for (int r = 0; r < listRule.length; r++) {
          final Rule rule = listRule[r];

          double alphaR = 1.0;  // T-норма MIN => начинаем с 1
          for (int col = 0; col < 3; col++) {
            final int termIndex = rule.x[col].toInt();  // какой терм
            final double xVal   = (col == 0) ? x0 : (col == 1) ? x1 : x2;

            // Берём массив точек функции принадлежности:
            // membershipAll[col] — это ChartData для колонки col
            // membershipAll[col].membershipData[termIndex] — конкретный терм
            final List<Point> membershipPoints =
            membershipAll[col].membershipData[termIndex];

            // Ищем mu(xVal) через _findMembership
            final double mu = _findMembership(xVal, membershipPoints);

            // MIN:
            if (mu < alphaR) alphaR = mu;
          }
          alpha[r] = alphaR;
        }

        // в) Считаем предсказание модели:
        // predictedY = (Σ alpha[r]*weight[r]*y[r]) / (Σ alpha[r]*weight[r])
        double numerator = 0.0;
        double denominator = 0.0;
        for (int r = 0; r < listRule.length; r++) {
          numerator   += alpha[r] * listRule[r].weight * listRule[r].y;
          denominator += alpha[r] * listRule[r].weight;
        }
        final double predictedY = (denominator.abs() < eps)
            ? 0.0
            : (numerator / denominator);

        // г) Считаем ошибку и накапливаем в MSE
        final double error = predictedY - realY;
        mse += error * error;

        // д) Считаем частные производные и аккумулируем градиенты
        if (denominator.abs() >= eps) {
          final double denom2 = denominator * denominator;
          for (int r = 0; r < listRule.length; r++) {
            if (alpha[r] < eps) continue; // если активация почти 0, вклад мало значит

            final double w_r = listRule[r].weight;
            final double y_r = listRule[r].y;

            // d(y^)/d(y_r) = alpha_r * w_r / denominator
            final double dYr = alpha[r] * w_r / denominator;

            // d(y^)/d(w_r) = (alpha_r / denominator^2) * (y_r*denominator - numerator)
            final double dWr = alpha[r] / denom2 * (y_r * denominator - numerator);

            gradY[r] += error * dYr;
            gradW[r] += error * dWr;
          }
        }
      } // конец прохода по датасету

      // Усреднённая MSE
      mse /= dataSize;

      // 3) Шаг градиентного спуска (учитываем factor = 2.0 / dataSize)
      final double scale = 2.0 / dataSize;
      for (int r = 0; r < listRule.length; r++) {
        listRule[r].y      -= learningRate * scale * gradY[r];
        listRule[r].weight -= learningRate * scale * gradW[r];
      }

      // 4) Печать ошибки раз в 100 итераций
      if (epoch % 100 == 0) {
        print("Epoch: $epoch, MSE: $mse");
      }
    }

    // Возвращаем обученные правила (веса и y)
    return listRule;
  }

  @override
  Future<double> predictTSK({
    required double x0,
    required double x1,
    required double x2,
    required List<Rule> listRule,
    required List<ChartData> membershipAll,
  }) async {
    // Параметры
    final double eps = 1e-12;

    // Для каждого правила r считаем α_r = min(...) по входам
    final alpha = List<double>.filled(listRule.length, 0.0);

    for (int r = 0; r < listRule.length; r++) {
      final rule = listRule[r];
      double alphaR = 1.0;

      for (int col = 0; col < 3; col++) {
        final int termIndex = rule.x[col].toInt();
        final double xVal = (col == 0) ? x0 : (col == 1) ? x1 : x2;

        // Берём нужный набор точек функц. принадлежности
        final membershipPoints = membershipAll[col].membershipData[termIndex];

        // Ищем mu через ближайшую точку
        final mu = _findMembership(xVal, membershipPoints);

        // T-норма (MIN)
        if (mu < alphaR) alphaR = mu;
      }
      alpha[r] = alphaR;
    }

    // Считаем выход: (Σ α[r]*w[r]*y[r]) / (Σ α[r]*w[r])
    double numerator   = 0.0;
    double denominator = 0.0;
    for (int r = 0; r < listRule.length; r++) {
      numerator   += alpha[r] * listRule[r].weight * listRule[r].y;
      denominator += alpha[r] * listRule[r].weight;
    }

    if (denominator.abs() < eps) {
      // Если все alpha[r] почти нули, возвращаем 0 или другое безопасное значение
      return 0.0;
    }
    return numerator / denominator;
  }

  /// Находим mu(xVal) путём поиска ближайшей точки в membershipPoints
  double _findMembership(double xVal, List<Point> membershipPoints) {
    double minDist = double.infinity;
    double bestMu = 0.0;
    for (final p in membershipPoints) {
      final dist = (p.x - xVal).abs();
      if (dist < minDist) {
        minDist = dist;
        bestMu = p.y;  // берём значение принадлежности точки
      }
    }
    return bestMu;
  }
}
