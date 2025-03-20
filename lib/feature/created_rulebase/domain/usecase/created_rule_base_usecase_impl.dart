import 'dart:math';
import 'package:ics/feature/created_rulebase/domain/enity/rules_data.dart';
import 'package:ics/feature/displaying_graphs/domain/entity/point.dart';

import '../../boundary/usecase/created_rule_base_usecase.dart';
import '../enity/rule.dart';

class CreatedRuleBaseUseCaseImpl implements CreatedRuleBaseUseCase {
  @override
  Future<void> ruleBaseGeneration(RulesData rulesData) async {
    ///Пример правил
    final rules = [
      Rule(id: "1", x: [1.0, 2.0], y: 3.0, weight: 4.0),
      Rule(id: "2", x: [2.0, 3.0], y: 4.0, weight: 5.0),
    ];
    // TODO: implement ruleBaseGeneration
    List<List<double>> xMatrix = [];
    List<List<double>> yMatrix = [];
    List<double> listX = [];
    List<double> listY = [];
    print(rulesData.countPlenty);
    for (int i = 0; i < rulesData.countPlenty; i++) {
      print('$i and ${rulesData.countPlenty}');
      for (int j = 0; j < rulesData.countTerm; j++) {
        print('i = $i; rulesData.countPlenty = ${rulesData.countPlenty}');
        if (i == rulesData.countPlenty - 1) {
          listY.add(
            await _parametersReverseNormalization(
              membershipData: rulesData.allCharts[i].membershipData[j],
              countPlenty: rulesData.countPlenty,
              j: j,
              xMatrix: xMatrix,
            ),
          );
          print('listY: $listY');
        } else {
          listX.add(
            await _parametersNormalization(
              rulesData.allCharts[i].membershipData[j],
            ),
          );
        }
      }
      if (i == rulesData.countPlenty - 1) {
        print('Flag');
        yMatrix.add(listY);
      } else {
        xMatrix.add(listX);
      }
    }
    print('xMatrix: $xMatrix');
    print('yMatrix: $yMatrix');
    _creatingFile(rules);
  }

  Future<void> _creatingFile(List<Rule> rules) async {
    ///Пример работы с провилами
    /// Преобразуем список объектов в JSON-строку
    String jsonStr = Rule.toJsonStrList(rules);
    //print(jsonStr);
    // TODO: implement _creatingFile
  }

  Future<double> _parametersNormalization(List<Point> membershipData) async {
    List<double> yValues = [];
    for (final point in membershipData) {
      yValues.add(point.y);
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
    for (int i = 0; i < countPlenty; i++) {
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
