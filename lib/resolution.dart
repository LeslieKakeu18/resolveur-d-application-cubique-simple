import 'package:flutter/material.dart';
import 'package:equations/equations.dart' as eq;

void main() {
  runApp(const Resolution());
}

class Resolution extends StatelessWidget {
  const Resolution({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Résolveur d\'équations cubiques'),
        ),
        body: const CubicSolver(),
      ),
    );
  }
}

class CubicSolver extends StatefulWidget {
  const CubicSolver({Key? key}) : super(key: key);

  @override
  _CubicSolverState createState() => _CubicSolverState();
}

class _CubicSolverState extends State<CubicSolver> {
  final TextEditingController aController = TextEditingController();
  final TextEditingController bController = TextEditingController();
  final TextEditingController cController = TextEditingController();
  final TextEditingController dController = TextEditingController();

  String result = '';

  void solve() {
    final a = double.tryParse(aController.text);
    final b = double.tryParse(bController.text);
    final c = double.tryParse(cController.text);
    final d = double.tryParse(dController.text);

    if ((a == null || a == 0.0) && (b == null || b == 0.0) && (c == null || c == 0.0) && (d == null || d == 0.0)) {
      setState(() {
        result = 'Veuillez entrer au moins une valeur non nulle.';
      });
    } else if (a == null || a == 0.0) {
      setState(() {
        result = 'Veuillez entrer une valeur non nulle pour a.';
      });
    } else if (b == null) {
      setState(() {
        result = 'Veuillez entrer une valeur valide pour b.';
      });
    } else if (c == null) {
      setState(() {
        result = 'Veuillez entrer une valeur valide pour c.';
      });
    } else if (d == null) {
      setState(() {
        result = 'Veuillez entrer une valeur valide pour d.';
      });
    } else {
      try {
        final equation = eq.Cubic(
          a: eq.Complex.fromReal(a),
          b: eq.Complex.fromReal(b),
          c: eq.Complex.fromReal(c),
          d: eq.Complex.fromReal(d),
        );

        final solutions = equation.solutions();

        // je filtre les solutions réelles et je garde uniquement les parties réelles
        final realSolutions = solutions
            .where((sol) => sol.imaginary.abs() < 1e-10) // Considérer comme réel si la partie imaginaire est suffisamment petite
            .map((sol) => sol.real.round()) // Arrondir à l'entier le plus proche
            .toList();

        // je vérifie s'il y a des solutions complexes
        final complexSolutions = solutions
            .where((sol) => sol.imaginary.abs() >= 1e-10) // Considérer comme complexe si la partie imaginaire est suffisamment grande
            .toList();

        setState(() {
          if (realSolutions.isNotEmpty && complexSolutions.isNotEmpty) {
            result = 'Solutions réelles : ${realSolutions.join(', ')}. Il y a aussi des solutions complexes.';
          } else if (realSolutions.isNotEmpty) {
            result = 'Solutions réelles : ${realSolutions.join(', ')}';
          } else if (complexSolutions.isNotEmpty) {
            result = 'Il n\'y a pas de solutions réelles. Il y a des solutions complexes.';
          } else {
            result = 'Aucune solution trouvée.';
          }
        });

      } catch (e) {
        setState(() {
          result = 'Une erreur est survenue lors de la résolution de l\'équation.';
        });
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          TextField(
            controller: aController,
            decoration: const InputDecoration(labelText: 'a'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: bController,
            decoration: const InputDecoration(labelText: 'b'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: cController,
            decoration: const InputDecoration(labelText: 'c'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: dController,
            decoration: const InputDecoration(labelText: 'd'),
            keyboardType: TextInputType.number,
          ),
          ElevatedButton(
            onPressed: solve,
            child: const Text('Résoudre'),
          ),
          const SizedBox(height: 16.0),
          Text(
            result,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
        ],
      ),
    );
  }
}
