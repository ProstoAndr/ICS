import 'package:flutter/material.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boudary/usecase/model_training_usecase.dart';

class ModelTrainingUseCaseImpl implements ModelTrainingUseCase {
  double _currentMj = 0.0;
  double _currentSumMj = 0.0;
  List<double> _mjRow = const [];

  @override
  Future<List<Rule>> modelTraining({
    required List<Plenty> listPlenty,
    required List<ChartData> listChartData,
    required List<Rule> listRule,
  }) async {
    const int countEpochs = 1000;
    const attenuationCoefficient = 0.95;
    double learningRate = 0.08;

    final countWeight = listRule.length;

    final countRows = listPlenty.first.data.length;

    final List<List<List<Point>>> membershipAll = [
      for (final c in listChartData) c.membershipData
    ];

    final List<Rule> newListRule = [];

    final List<Rule> temporaryListRule = List<Rule>.from(listRule);

    for (int epoch = 0; epoch < countEpochs; epoch++) {
      final List<double> sumWeight = List<double>.filled(countWeight, 0);

      for (int row = 0; row < countRows; row++) {
        final List<double> inputValueRow = [
          listPlenty[0].data[row],
          listPlenty[1].data[row],
          listPlenty[2].data[row],
        ];
        final predictedY = _singleton(
          inputValueRow,
          membershipAll,
          listRule,
        );

        final double expectedY = listPlenty[3].data[row];

        for (int i = 0; i < countWeight; i++) {
          _currentMj = _mjRow[i];
          sumWeight[i] += learningRate * _gradient(expectedY, predictedY);
        }
      }

      for (int i = 0; i < countWeight; i++) {
        final rule = temporaryListRule[i];
        temporaryListRule[i] = Rule(
          id: rule.id,
          x: rule.x,
          weight: rule.weight - (sumWeight[i] / countRows),
        );
      }

      if (epoch % 100 == 0) {
        learningRate *= attenuationCoefficient;
      }
    }
    newListRule.addAll(temporaryListRule);

    return newListRule;
  }

  double _singleton(
    List<double> inputRow,
    List<List<List<Point>>> membershipFns,
    List<Rule> rules,
  ) {
    final int varCount = inputRow.length;
    final int ruleCount = rules.length;

    // буфер mj на всю строку
    _mjRow = List<double>.filled(ruleCount, 0.0);
    _currentSumMj = 0.0;

    double weightedSum = 0.0;

    for (int j = 0; j < ruleCount; j++) {
      final rule = rules[j];
      double activation = double.infinity;

      for (int v = 0; v < varCount; v++) {
        final int idx = rule.x[v].round();
        if (idx < 0 || idx >= membershipFns[v].length) {
          activation = 0.0;
          break;
        }
        final double mu = _findMembership(inputRow[v], membershipFns[v][idx]);
        if (mu < activation) activation = mu;
      }

      _mjRow[j] = activation;
      _currentSumMj += activation;

      if (activation > 0) weightedSum += activation * rule.weight;
    }

    return _currentSumMj == 0 ? 0.0 : weightedSum / _currentSumMj;
  }

  /// Находим mu(xVal) путём поиска ближайшей точки в membershipPoints
  double _findMembership(double xVal, List<Point> membershipPoints) {
    double minDist = double.infinity;
    double bestMu = 0.0;
    for (final p in membershipPoints) {
      final dist = (p.x - xVal).abs();
      if (dist < minDist) {
        minDist = dist;
        bestMu = p.y; // берём значение принадлежности точки
      }
    }
    return bestMu;
  }

  double _gradient(double expectedY, double predictedY) {
    final double err = 2 * (predictedY - expectedY);
    final double gradPart =
        _currentSumMj == 0 ? 0.0 : err * (_currentMj / _currentSumMj);
    debugPrint('err=$err  mj=$_currentMj  Tk=$_currentSumMj  grad=$gradPart');
    return gradPart;
  }

  @override
  Future<double> predictTSK({
    required double x0,
    required double x1,
    required double x2,
    required List<Rule> listRule,
    required List<ChartData> listChartData,
  }) {
    // TODO: implement predictTSK
    throw UnimplementedError();
  }
}

//
// @override
// Future<double> predictTSK({
//   required double x0,
//   required double x1,
//   required double x2,
//   required List<Rule> listRule,
//   required List<ChartData> membershipAll,
// }) async {
//   // Параметры
//   final double eps = 1e-12;
//
//   // Для каждого правила r считаем α_r = min(...) по входам
//   final alpha = List<double>.filled(listRule.length, 0.0);
//
//   for (int r = 0; r < listRule.length; r++) {
//     final rule = listRule[r];
//     double alphaR = 1.0;
//
//     for (int col = 0; col < 3; col++) {
//       final int termIndex = rule.x[col].toInt();
//       final double xVal = (col == 0) ? x0 : (col == 1) ? x1 : x2;
//
//       // Берём нужный набор точек функц. принадлежности
//       final membershipPoints = membershipAll[col].membershipData[termIndex];
//
//       // Ищем mu через ближайшую точку
//       final mu = _findMembership(xVal, membershipPoints);
//
//       // T-норма (MIN)
//       if (mu < alphaR) alphaR = mu;
//     }
//     alpha[r] = alphaR;
//   }
//
//   // Считаем выход: (Σ α[r]*w[r]*y[r]) / (Σ α[r]*w[r])
//   double numerator   = 0.0;
//   double denominator = 0.0;
//   for (int r = 0; r < listRule.length; r++) {
//     numerator   += alpha[r] * listRule[r].weight * listRule[r].weight;
//     denominator += alpha[r] * listRule[r].weight;
//   }
//
//   if (denominator.abs() < eps) {
//     // Если все alpha[r] почти нули, возвращаем 0 или другое безопасное значение
//     return 0.0;
//   }
//   return numerator / denominator;
// }
//
// /// Находим mu(xVal) путём поиска ближайшей точки в membershipPoints
// double _findMembership(double xVal, List<Point> membershipPoints) {
//   double minDist = double.infinity;
//   double bestMu = 0.0;
//   for (final p in membershipPoints) {
//     final dist = (p.x - xVal).abs();
//     if (dist < minDist) {
//       minDist = dist;
//       bestMu = p.y;  // берём значение принадлежности точки
//     }
//   }
//   return bestMu;
// }
