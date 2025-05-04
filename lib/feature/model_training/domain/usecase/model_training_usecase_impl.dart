import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:ics/feature/created_rulebase/boundary/storage/rules_storage.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/chart_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boudary/usecase/model_training_usecase.dart';

class ModelTrainingUseCaseImpl implements ModelTrainingUseCase {
  final RulesStorage rulesStorage;

  double _currentMj = 0.0;
  double _currentSumMj = 0.0;
  List<double> _mjRow = const [];

  ModelTrainingUseCaseImpl({required this.rulesStorage});

  @override
  Future<List<Rule>> modelTraining({
    required List<Plenty> listPlenty,
    required List<ChartData> listChartData,
    required List<Rule> listRule,
  }) async {
    const int countEpochs = 1000;
    const attenuationCoefficient = 0.95;
    double learningRate = 0.2;

    final countWeight = listRule.length;

    final countRows = listPlenty.first.data.length;

    final List<List<List<Point>>> membershipAll = [
      for (final c in listChartData) c.membershipData
    ];

    final List<Rule> newListRule = [];

    final List<Rule> temporaryListRule = List<Rule>.from(listRule);

    for (int epoch = 0; epoch < countEpochs; epoch++) {
      debugPrint('Epoch=$epoch;');
      final List<double> sumWeight = List<double>.filled(countWeight, 0);
      List<double> listError = [];
      double sumError = 0;

      for (int row = 0; row < countRows; row++) {
        final List<double> inputValueRow = [
          listPlenty[0].data[row],
          listPlenty[1].data[row],
          listPlenty[2].data[row],
        ];
        final predictedY = _singleton(
          inputValueRow,
          membershipAll,
          temporaryListRule,
        );

        final double expectedY = listPlenty[3].data[row];

        final double error = 2 * (predictedY - expectedY);
        // debugPrint(
        //     'Epoch: $epoch\npredictedY=$predictedY; expectedY=$expectedY; Error=$error;');
        listError.add(error);
        sumError += error;

        for (int i = 0; i < countWeight; i++) {
          _currentMj = _mjRow[i];
          final gradPart = _gradient(expectedY, predictedY, error);
          final deltaWeight = learningRate * gradPart;
          sumWeight[i] += deltaWeight;
        }
      }
      final double meanError = (sumError * sumError) / (countRows * 4);
      debugPrint('meanError=${sqrt(meanError)};');

      for (int i = 0; i < countWeight; i++) {
        final rule = temporaryListRule[i];
        temporaryListRule[i] = Rule(
          id: rule.id,
          x: rule.x,
          weight: rule.weight - (sumWeight[i] / countRows),
        );
      }

      if (epoch % 500 == 0 && epoch != 0) {
        learningRate *= attenuationCoefficient;
      }
      debugPrint('learningRate=$learningRate;');
      debugPrint('\n');
    }
    newListRule.addAll(temporaryListRule);
    await _creatingFile(newListRule);
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

  double _gradient(double expectedY, double predictedY, error) {
    final double gradPart =
        _currentSumMj == 0 ? 0.0 : error * (_currentMj / _currentSumMj);
    return gradPart;
  }

  Future<void> _creatingFile(List<Rule> newListRule) async {
    final rulesString = Rule.toJsonStrList(newListRule);

    final bytes = utf8.encode(rulesString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    html.AnchorElement(href: url)
      ..setAttribute('download', 'NewRuleBase.txt')
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  @override
  Future<double> predictTSK({
    required List<Plenty> listPlenty,
    required List<ChartData> listChartData,
    required List<Rule> listRule,
  }) async {

    final countRows = listPlenty.first.data.length;

    final List<List<List<Point>>> membershipAll = [
      for (final c in listChartData) c.membershipData
    ];

    double sumError = 0;

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

      final double error = 2 * (predictedY - expectedY);

      sumError += error;
    }
    final double meanError = (sumError * sumError) / (countRows * 4);
    debugPrint('meanError=${sqrt(meanError)};');
    debugPrint('\n');

    return sqrt(meanError * 100);
  }
}
