import 'dart:convert';
import 'dart:html' as html;
import 'dart:math';
import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boundary/storage/rules_storage.dart';
import '../../boundary/usecase/created_rule_base_usecase.dart';
import '../enity/rule.dart';

class CreatedRuleBaseUseCaseImpl implements CreatedRuleBaseUseCase {
  final RulesStorage rulesStorage;

  CreatedRuleBaseUseCaseImpl({required this.rulesStorage});

  @override
  Future<void> ruleBaseGeneration(RulesData rulesData) async {
    List<Rule> rules = [];
    final unityMatrix = await _createMatrix(rulesData);
    _generateCombinations(unityMatrix[0], unityMatrix[1], 0, [], rules);
    final rulesString = await rulesStorage.getRules();
    if (rulesString == null) {
      rulesStorage.saveRules(Rule.toJsonStrList(rules));
    } else {
      rulesStorage.removeRules();
      rulesStorage.saveRules(Rule.toJsonStrList(rules));
    }
  }

  void _generateCombinations(
    List<List<double>> xMatrix,
    List<List<double>> yMatrix,
    int row,
    List<double> current,
    List<Rule> rules,
  ) {
    if (row == xMatrix.length) {
      for (int column = 0; column < yMatrix[0].length; column++) {
        Random random = new Random();
        double randomNumber = random.nextDouble();
        double count = rules.length + 1;
        final newRule = Rule(
          id: "$count",
          x: List.from(current),
          y: yMatrix[0][column],
          weight: randomNumber,
        );
        rules.add(newRule);
      }
      return;
    }

    for (int col = 0; col < xMatrix[row].length; col++) {
      current.add(xMatrix[row][col]);
      _generateCombinations(xMatrix, yMatrix, row + 1, current, rules);
      current.removeLast();
    }
  }

  @override
  Future<void> creatingFile() async {
    final rulesString = await rulesStorage.getRules();

    final bytes = utf8.encode(rulesString!);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "RuleBase.txt")
      ..click();

    html.Url.revokeObjectUrl(url);
  }

  Future<double> _parametersNormalization(List<Point> membershipData) async {
    List<double> yValues = [];
    for (final point in membershipData) {
      yValues.add(point.y);
    }
    if (yValues.isEmpty) {
      return 0;
    }
    return yValues.reduce(min);
  }

  Future<double> _parametersReverseNormalization({
    required List<Point> membershipData,
    required int countPlenty,
    required int j,
    required List<List<double>> xMatrix,
  }) async {
    List<double> yValues = [];
    for (final point in membershipData) {
      yValues.add(point.y);
    }
    if (yValues.isEmpty) {
      return 0;
    }
    final List<double> listX = [];
    for (int i = 0; i < countPlenty - 1; i++) {
      listX.add(xMatrix[i][j]);
    }
    final xMax = listX.reduce(max);

    final yMax = yValues.reduce(max);

    return max(1 - xMax, yMax);
  }

  Future<List<List<List<double>>>> _createMatrix(RulesData rulesData) async {
    List<List<double>> xMatrix = [];
    List<List<double>> yMatrix = [];
    List<double> listX = [];
    List<double> listY = [];
    for (int i = 0; i < rulesData.countPlenty; i++) {
      for (int j = 0; j < rulesData.countTerm; j++) {
        if (i == rulesData.countPlenty - 1) {
          listY.add(
            await _parametersReverseNormalization(
              membershipData: rulesData.allCharts[i].membershipData[j],
              countPlenty: rulesData.countPlenty,
              j: j,
              xMatrix: xMatrix,
            ),
          );
        } else {
          listX.add(
            await _parametersNormalization(
              rulesData.allCharts[i].membershipData[j],
            ),
          );
        }
      }
      if (i == rulesData.countPlenty - 1) {
        yMatrix.add(listY);
      } else {
        xMatrix.add(List.from(listX));
        listX.clear();
      }
    }
    final List<List<List<double>>> unityMatrix = [];
    unityMatrix.add(xMatrix);
    unityMatrix.add(yMatrix);
    return unityMatrix;
  }

  void _generateSingleton(
    List<List<double>> xMatrix,
    List<List<double>> yMatrix,
    int row,
    List<double> current,
    double sumNumerator,
    double sumDenominator,
  ) {
    if (row == xMatrix.length) {
      for (int column = 0; column < yMatrix[0].length; column++) {
        double multiple = 1;
        for (var x in current) {
          multiple *= x;
        }
        sumDenominator += multiple;
        sumNumerator += (multiple * yMatrix[0][column]);
      }
      return;
    }

    for (int col = 0; col < xMatrix[row].length; col++) {
      current.add(xMatrix[row][col]);
      _generateSingleton(
        xMatrix,
        yMatrix,
        row + 1,
        current,
        sumNumerator,
        sumDenominator,
      );
      current.removeLast();
    }
  }

  @override
  Future<double> singleton(RulesData rulesData) async {
    final unityMatrix = await _createMatrix(rulesData);
    double sumNumerator = 0;
    double sumDenominator = 1;
    _generateSingleton(
      unityMatrix[0],
      unityMatrix[1],
      0,
      [],
      sumNumerator,
      sumDenominator,
    );
    final singleton = sumNumerator / sumDenominator;
    return singleton;
  }
}
