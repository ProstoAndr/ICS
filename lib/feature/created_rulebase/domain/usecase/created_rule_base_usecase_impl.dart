import 'dart:math';
import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boundary/usecase/created_rule_base_usecase.dart';
import '../enity/rule.dart';

class CreatedRuleBaseUseCaseImpl implements CreatedRuleBaseUseCase {
  @override
  Future<void> ruleBaseGeneration(RulesData rulesData) async {
    List<Rule> rules = [];
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
    print('xMatrix: $xMatrix');
    print('yMatrix: $yMatrix');
    //_generateCombinations(xMatrix, yMatrix, 0, [], rules);
    //print('Rules: $rules');
    //_creatingFile(rules);
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

  Future<void> _creatingFile(List<Rule> rules) async {
    String jsonStr = Rule.toJsonStrList(rules);
    print(jsonStr);
    //File file = File("RuleBase.txt");
    //await file.writeAsString(jsonStr);
  }

  Future<double> _parametersNormalization(List<Point> membershipData) async {
    List<double> yValues = [];
    for (final point in membershipData) {
      yValues.add(point.y);
      print(point.y);
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
    final List<double> listX = [];
    for (int i = 0; i < countPlenty - 1; i++) {
      listX.add(xMatrix[i][j]);
    }
    final xMax = listX.reduce(max);

    final yMax = yValues.reduce(max);

    return max(1 - xMax, yMax);
  }

  Future<List<Point>> _singleton(List<List<double>> matrix) async {
    // TODO: implement _parametersReverseNormalization
    throw UnimplementedError();
  }
}
