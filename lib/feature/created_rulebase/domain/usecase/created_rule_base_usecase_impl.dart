import 'dart:convert';
import 'dart:html' as html;

import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';
import 'package:ics/feature/created_rulebase/domain/enity/rule.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boundary/storage/rules_storage.dart';
import '../../boundary/usecase/created_rule_base_usecase.dart';

class CreatedRuleBaseUseCaseImpl implements CreatedRuleBaseUseCase {
  final RulesStorage rulesStorage;

  CreatedRuleBaseUseCaseImpl({required this.rulesStorage});

  @override
  Future<void> ruleBaseGeneration(RulesData rulesData) async {
    final int N = rulesData.countPlenty;
    if (N < 2) return;

    final int outputIndex = N - 1;
    final int m = rulesData.countTerm;

    List<List<List<Point>>> membershipAll = [];
    for (int column = 0; column < N; column++) {
      membershipAll.add(rulesData.allCharts[column].membershipData);
    }

    final int dataSize = rulesData.plenties[0].data.length;

    Map<String, List<_ActivationAndOutput>> aggregator = {};

    List<List<int>> allCombos = _enumerateAllCombinations(List.filled(N-1, m));

    for (int row = 0; row < dataSize; row++) {
      // Получаем фактический выход
      final double outputVal = rulesData.plenties[outputIndex].data[row];

      // Пробегаем по всем сочетаниям (например, 27 при 3×3×3)
      for (final combo in allCombos) {
        // combo может быть [0,2,1], значит для столбца0=term0, столбца1=term2, столбца2=term1...
        // Вычислим alpha = min( µ_{col, combo[col]}( xVal ) ) по всем входным столбцам
        double alpha = 1.0;
        bool first = true;

        for (int col = 0; col < N - 1; col++) {
          final int termIndex = combo[col];
          final double xVal = rulesData.plenties[col].data[row];
          // Найдём µ
          final double muVal = _findMembership(xVal, membershipAll[col][termIndex]);

          if (first) {
            alpha = muVal;
            first = false;
          } else {
            // T-норма MIN
            if (muVal < alpha) alpha = muVal;
          }
        }

        // Сформируем ключ вида "0-2-1"
        final key = combo.map((e) => e.toString()).join('-');

        // Добавим в aggregator
        aggregator.putIfAbsent(key, () => []);
        aggregator[key]!.add(_ActivationAndOutput(alpha, outputVal));
      }
    }

    // --------------------------
    // (2) Формируем итоговые правила
    //     Для каждой combo считаем средний выход, но взвешенный по alpha
    // --------------------------
    List<Rule> finalRules = [];
    int ruleId = 1;

    aggregator.forEach((key, listAlphaOut) {
      double sumAlpha = 0.0;
      double sumAlphaOut = 0.0;
      for (final ao in listAlphaOut) {
        sumAlpha += ao.alpha;
        sumAlphaOut += ao.alpha * ao.output;
      }

      double yAvg = 0.0;
      if (sumAlpha > 0) {
        yAvg = sumAlphaOut / sumAlpha;
      }

      // Превращаем "0-2-1" => [0.0, 2.0, 1.0]
      final splitted = key.split('-').map((e) => double.parse(e)).toList();

      final rule = Rule(
        id: '$ruleId',
        x: splitted,
        y: yAvg,
        weight: 1.0,
      );
      finalRules.add(rule);
      ruleId++;
    });

    final rulesString = await rulesStorage.getRules();
    if (rulesString == null) {
      rulesStorage.saveRules(Rule.toJsonStrList(finalRules));
    } else {
      rulesStorage.removeRules();
      rulesStorage.saveRules(Rule.toJsonStrList(finalRules));
    }
  }

  // --------------------------
  // Метод для генерации всех сочетаний
  // Пример: dims=[3,3,3] => [0,0,0], [0,0,1], ..., [2,2,2]
  List<List<int>> _enumerateAllCombinations(List<int> dims) {
    List<List<int>> result = [];
    void recurse(List<int> current, int idx) {
      if (idx == dims.length) {
        result.add(List.from(current));
        return;
      }
      for (int val = 0; val < dims[idx]; val++) {
        current[idx] = val;
        recurse(current, idx + 1);
      }
    }
    recurse(List.filled(dims.length, 0), 0);
    return result;
  }

  // --------------------------
  // Ищем µ: для заданного xVal находим точку membershipPoints,
  // где |p.x - xVal| минимально, возвращаем p.y
  double _findMembership(double xVal, List<Point> membershipPoints) {
    double minDist = double.infinity;
    double bestMu = 0.0;
    for (final p in membershipPoints) {
      final dist = (p.x - xVal).abs();
      if (dist < minDist) {
        minDist = dist;
        bestMu = p.y;
      }
    }
    return bestMu;
  }

  @override
  Future<void> creatingFile() async {
    final rulesString = await rulesStorage.getRules();
    if (rulesString == null) return;

    final bytes = utf8.encode(rulesString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "RuleBase.txt")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  @override
  Future<double> singletonMethod() async {
    final rulesString = await rulesStorage.getRules();
    if (rulesString == null) return 0.0;

    final listRule = Rule.fromJsonToList(rulesString);

    // ЗАГЛУШКА: Если в rule.x лежат индексы термов,
    // нам нужно при "онлайн" использовании иметь текущие входы,
    // заново находить µ(...) и брать min.
    // Пока оставим, как есть, умножать x[] не имеет смысла
    double sumNum = 0;
    double sumDen = 0;

    for (final r in listRule) {
      double alpha = 1.0;
      for (final xVal in r.x) {
        alpha *= xVal; // по сути неверно, т.к. xVal — индекс
      }
      sumNum += alpha * r.y;
      sumDen += alpha;
    }

    if (sumDen == 0) return 0.0;
    print(sumNum / sumDen);
    return sumNum / sumDen;
  }
}

class _ActivationAndOutput {
  final double alpha;
  final double output;
  _ActivationAndOutput(this.alpha, this.output);
}
