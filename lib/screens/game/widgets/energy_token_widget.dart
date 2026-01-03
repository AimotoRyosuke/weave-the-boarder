import 'package:flutter/material.dart';
import 'package:weave_the_border/models/game/energy_token_stack.dart';

class EnergyTokenWidget extends StatelessWidget {
  const EnergyTokenWidget({super.key, required this.stack});

  final EnergyTokenStack stack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.amber.shade600,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Colors.black38,
              blurRadius: 4,
              offset: Offset(2, 2),
            )
          ],
        ),
        child: Center(
          child: Text(
            '${stack.count}',
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}
