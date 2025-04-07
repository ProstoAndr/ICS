import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/plenty.dart';

import '../../boudary/usecase/model_training_usecase.dart';

class ModelTrainingUseCaseImpl implements ModelTrainingUseCase {
  @override
  Future<List<Rule>> gradientDescent(
    List<Rule> listRule,
    double singleton,
    List<Plenty> plenties,
  ) async {
    // Параметры «чистого» градиентного спуска
    final double learningRate = 0.01;
    final int epochs = 50; // число полных проходов по датасету

    // Инициализируем веса всех правил (примерно нулём)
    // Если хотите, можете оставить исходные weight из listRule.
    for (var rule in listRule) {
      rule.weight = 0.0;
    }

    // === Обучающий цикл ===
    for (int epoch = 0; epoch < epochs; epoch++) {
      // Проходим по всем примерам (Plenty) в датасете
      for (final data in plenties) {
        // Например, возьмём последний элемент как желаемый выход:
        if (data.data.isEmpty) continue; // защита на случай пустого списка
        final double targetValue = data.data.last;

        // Пример: обновляем ВСЕ правила одним и тем же примером
        // (или пишите свою логику сопоставления Plenty -> Rule)
        for (var rule in listRule) {
          // Предположим, текущее предсказание:
          //   prediction = weight + singleton
          final double prediction = rule.weight + singleton;

          // Ошибка = (targetValue - prediction)
          final double error = targetValue - prediction;

          // Шаг градиентного спуска (простая формула):
          rule.weight += learningRate * error;
        }
      }
    }

    return listRule;
  }
}
