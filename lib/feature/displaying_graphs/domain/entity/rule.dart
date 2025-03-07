class Rule {
  final String condition;
  final String result;

  Rule({required this.condition, required this.result});

  @override
  String toString() {
    return 'IF $condition THEN $result';
  }
}