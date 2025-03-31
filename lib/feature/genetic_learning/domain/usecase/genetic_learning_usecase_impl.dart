import 'dart:math';
import 'dart:io';
import 'dart:async';

class Chromosome {
  List<double> values;
  double badness;
  int dimension;

  Chromosome(this.dimension, {bool empty = false}) :
        values = empty ? List.filled(dimension, 0.0) : List.generate(dimension, (_) => Random().nextDouble() * 1.0 - 0.5),
        badness = 0.0;

  @override
  String toString() {
    StringBuffer s = StringBuffer();
    s.writeln('#' * 100);
    values.forEach((v) => s.write('$v  '));
    s.writeln('\nBadness: $badness');
    return s.toString();
  }

  bool operator ==(Object other) {
    if (other is! Chromosome) return false;
    for (int i = 0; i < values.length; i++) {
      if ((values[i] - other.values[i]).abs() > 0.03) return false;
    }
    return true;
  }
}

class Population {
  List<Chromosome> chromosomes;
  int iterator;
  int size;

  Population(this.size, int dimension, {bool empty = false}) :
        chromosomes = List.generate(size, (_) => Chromosome(dimension, empty: empty)),
        iterator = 0;

  Chromosome operator [](int index) => chromosomes[index];

  void sort() {
    chromosomes.sort((a, b) => a.badness.compareTo(b.badness));
  }

  int get length => size;
}

class GeneticAlgorithm {
  static final Random rand = Random(); // Create a single instance of Random class

  // Generates a Gaussian random number using the Box-Muller transform
  static double nextGaussian() {
    double u1 = rand.nextDouble();
    double u2 = rand.nextDouble();
    double z0 = sqrt(-2 * log(u1)) * cos(2 * pi * u2);
    return z0;
  }

  static Chromosome chooseParentKTournament(Population p, int k) {
    List<Chromosome> possibleParents = List.generate(k, (_) => p[rand.nextInt(p.size)]);
    possibleParents.sort((a, b) => a.badness.compareTo(b.badness));
    return possibleParents[0];
  }

  static double evaluateIndividual(Chromosome c, Function nn, List<List<double>> trainingSets) {
    c.badness = nn(trainingSets, c.values);
    return c.badness;
  }

  static Tuple<Chromosome, Chromosome> simpleArithmeticRecombination2(double crossoverProbability, Chromosome parent1, Chromosome parent2) {
    Chromosome child1 = Chromosome(parent1.dimension);
    Chromosome child2 = Chromosome(parent1.dimension);
    if (rand.nextDouble() <= crossoverProbability) {
      int xPoint = rand.nextInt(parent1.dimension);
      for (int i = 0; i < xPoint; i++) {
        child1.values[i] = parent1.values[i];
        child2.values[i] = (parent2.values[i] + parent1.values[i]) / 2;
      }
      for (int i = xPoint; i < parent1.dimension; i++) {
        child1.values[i] = (parent1.values[i] + parent2.values[i]) / 2;
        child2.values[i] = parent2.values[i];
      }
    } else {
      for (int i = 0; i < parent1.dimension; i++) {
        child1.values[i] = parent1.values[i];
        child2.values[i] = parent2.values[i];
      }
    }
    return Tuple(child1, child2);
  }

  static Tuple<Chromosome, Chromosome> simpleHeuristicRecombination2(double crossoverProbability, Chromosome parent1, Chromosome parent2) {
    Chromosome child1 = Chromosome(parent1.dimension);
    Chromosome child2 = Chromosome(parent1.dimension);
    if (rand.nextDouble() <= crossoverProbability) {
      for (int i = 0; i < parent1.dimension; i++) {
        child1.values[i] = rand.nextDouble() * (parent2.values[i] - parent1.values[i]) + parent1.values[i];
        child2.values[i] = rand.nextDouble() * (parent2.values[i] - parent1.values[i]) + parent1.values[i];
      }
    } else {
      for (int i = 0; i < parent1.dimension; i++) {
        child1.values[i] = parent1.values[i];
        child2.values[i] = parent2.values[i];
      }
    }
    return Tuple(child1, child2);
  }

  static void addGaussMutation(double mutationProbability, Chromosome c) {
    for (int i = 0; i < c.values.length; i++) {
      if (rand.nextDouble() <= mutationProbability) {
        c.values[i] += nextGaussian() * 0.4;  // Using Gaussian random
      }
    }
  }

  static void setGaussMutation(double mutationProbability, Chromosome c) {
    for (int i = 0; i < c.values.length; i++) {
      if (rand.nextDouble() <= mutationProbability) {
        c.values[i] = nextGaussian() * 2;  // Using Gaussian random
      }
    }
  }
}

class Tuple<T, U> {
  final T first;
  final U second;

  Tuple(this.first, this.second);
}

double nn(List<List<double>> trainingSets, List<double> parameters) {
  // Here nn is a placeholder for the neural network evaluation function.
  // Replace it with the actual NN evaluation function that will calculate the error (badness).
  return 0.0; // This is just a placeholder for the badness computation.
}

void GA_Generation(int populationSize, Function nn, int dimension, double mutationProbability, double crossoverProbability, List<List<List<double>>> dataset, int seconds, {String? resume}) async {
  final Random rand = Random();
  Stopwatch stopwatch = Stopwatch()..start();
  int numberOfFunctionEval = 0;

  Population populationX = Population(populationSize, dimension);
  Population newGeneration = Population(populationSize, dimension);

  if (resume != null) {
    List<String> lines = await File(resume).readAsLines();
    for (int i = 0; i < dimension; i++) {
      populationX[0].values[i] = double.parse(lines[i]);
    }
    print('Loaded from $resume');
  }

  // Split dataset into inputs and outputs
  List<List<double>> trainingSets = [];
  for (var testcase in dataset) {
    // Flattening the input-output data pairs
    var input = testcase.sublist(0, 2).expand((e) => e).toList();
    var output = testcase.sublist(2, 5).expand((e) => e).toList();
    trainingSets.add(input + output); // Combine input + output as a single list
  }

  for (var item in populationX.chromosomes) {
    GeneticAlgorithm.evaluateIndividual(item, nn, trainingSets);
    numberOfFunctionEval++;
  }

  populationX.sort();
  Chromosome bestChromosome = populationX[0];
  int count = 0;
  while (true) {
    count++;
    int numOfElites = 0;
    if (true) { // Elitism
      newGeneration.chromosomes[0] = bestChromosome;
      numOfElites = 1;
    }

    for (int i = numOfElites; i < populationSize ~/ 2; i++) {
      Chromosome parent1 = GeneticAlgorithm.chooseParentKTournament(populationX, 3);
      Chromosome parent2 = GeneticAlgorithm.chooseParentKTournament(populationX, 3);

      Tuple<Chromosome, Chromosome> children;
      if (rand.nextInt(2) == 0) {
        children = GeneticAlgorithm.simpleArithmeticRecombination2(crossoverProbability, parent1, parent2);
      } else {
        children = GeneticAlgorithm.simpleHeuristicRecombination2(crossoverProbability, parent1, parent2);
      }

      if (rand.nextDouble() >= mutationProbability) {
        GeneticAlgorithm.addGaussMutation(mutationProbability, children.first);
        GeneticAlgorithm.addGaussMutation(mutationProbability, children.second);
      } else {
        GeneticAlgorithm.setGaussMutation(mutationProbability, children.first);
        GeneticAlgorithm.setGaussMutation(mutationProbability, children.second);
      }

      newGeneration.chromosomes[2 * i - 1] = children.first;
      newGeneration.chromosomes[2 * i] = children.second;
    }

    populationX = newGeneration;
    for (var item in populationX.chromosomes) {
      GeneticAlgorithm.evaluateIndividual(item, nn, trainingSets);
      numberOfFunctionEval++;
    }

    populationX.sort();
    if (populationX.chromosomes[0].badness < bestChromosome.badness) {
      print('#' * 50);
      print('Generation #$count');
      print('Badness: ${populationX.chromosomes[0].badness}');
      print('Time elapsed: ${stopwatch.elapsed.inSeconds}s');
      bestChromosome = populationX.chromosomes[0];
    }

    if (bestChromosome.badness <= 0.03 || stopwatch.elapsed.inSeconds > seconds) {
      print('DONE!');
      print('Time elapsed: ${stopwatch.elapsed.inSeconds}s');
      print('Function evaluations: $numberOfFunctionEval');
      File('best_params.txt').writeAsStringSync(bestChromosome.values.join('\n'));
      print(bestChromosome);
      return;
    }

    if (count >= 100000) {
      print('Generation count limit exceeded!');
      print('Time elapsed: ${stopwatch.elapsed.inSeconds}s');
      print('Function evaluations: $numberOfFunctionEval');
      break;
    }
  }
}

void main() {
  // Example dataset and parameters for testing
  List<List<List<double>>> dataset = [
    [[0.0, 0.0], [0.0, 0.0, 0.0]],
    [[1.0, 0.0], [1.0, 0.0, 1.0]],
    [[0.0, 1.0], [1.0, 1.0, 0.0]],
    [[1.0, 1.0], [1.0, 1.0, 1.0]],
  ];

  GA_Generation(
    31,
    nn,
    2,
    0.15,
    0.7,
    dataset,
    300,
    resume: null,
  );
}
