import '../../domain/entity/point.dart';
import '../../domain/entity/rule.dart';

abstract class RulesUseCase {
  Future<List<Rule>> buildrules (int countTerm, List<List<Point>> membershipData);
}
