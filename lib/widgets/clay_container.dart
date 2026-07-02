import 'package:flutter/material.dart';

class ClayContainerDecoration extends BoxDecoration {
  ClayContainerDecoration({
    required Color color,
    required double borderRadius,
    bool depthInverted = false,
  }) : super(
          color: color,
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: depthInverted
              ? [
                  const BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(3, 3),
                    blurRadius: 4,
                  ),
                  const BoxShadow(
                    color: Color(0x1AFFFFFF),
                    offset: Offset(-3, -3),
                    blurRadius: 4,
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.35),
                    offset: const Offset(6, 6),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: const Color(0xFFF2EDE1).withOpacity(0.06),
                    offset: const Offset(-6, -6),
                    blurRadius: 10,
                  ),
                ],
        );
}
