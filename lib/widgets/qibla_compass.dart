// lib/widgets/qibla_compass.dart

import 'dart:math' show pi;
import 'package:flutter/material.dart';

class QiblaCompass extends StatelessWidget {
  final double qiblaDirection;
  final double compassDirection;

  const QiblaCompass({
    Key? key,
    required this.qiblaDirection,
    required this.compassDirection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        // Pusula Gövdesi (Compass SVG yerine Icon)
        Transform.rotate(
          angle: (compassDirection * (pi / 180) * -1),
          child: Icon(
              Icons.explore,
              size: 300,
              color: Theme.of(context).iconTheme.color!.withOpacity(0.5)
          ),
        ),
        // Kıble İğnesi (Needle SVG yerine Icon)
        Transform.rotate(
          angle: ((qiblaDirection) * (pi / 180) * -1),
          alignment: Alignment.center,
          child: const Icon(
            Icons.arrow_upward_rounded,
            size: 200,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}