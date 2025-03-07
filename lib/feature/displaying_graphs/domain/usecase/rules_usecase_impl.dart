import 'package:ics/feature/displaying_graphs/boundary/usecase/membership_usecase.dart';
import '../../boundary/usecase/rules_usecase.dart';
import '../entity/point.dart';
import '../entity/rule.dart';
import '../../boundary/usecase/charts_usecase.dart';

import 'package:ics/feature/displaying_graphs/boundary/usecase/membership_usecase.dart';
import '../../boundary/usecase/rules_usecase.dart';
import '../entity/point.dart';
import '../entity/rule.dart';
import '../../boundary/usecase/charts_usecase.dart';

class RulesUseCaseImpl implements RulesUseCase {
  final MembershipUseCase membershipUseCaseUseCase;

  RulesUseCaseImpl({required this.membershipUseCaseUseCase});

  @override
  Future<List<Rule>> buildrules(int countTerm, List<List<Point>> membershipData) async {
    List<Rule> rules = [];

    // Мы генерируем комбинации для каждого терма
    for (int i = 0; i < countTerm; i++) {
      for (int j = 0; j < countTerm; j++) {
        for (int k = 0; k < countTerm; k++) {
          // Мы комбинируем термы для каждого из 3 параметров
          String condition = 'Rain is ${membershipData[i].first.y}, Snowfall is ${membershipData[j].first.y}, Cloud Cover is ${membershipData[k].first.y}';
          String result = 'Weather Code is ${membershipData[i].first.y * membershipData[j].first.y * membershipData[k].first.y}';

          rules.add(Rule(condition: condition, result: result));
        }
      }
    }

    return rules;
  }
}

