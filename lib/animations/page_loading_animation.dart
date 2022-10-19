import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pokedex/animations/widget_size_expanding_animation.dart';
import 'package:pokedex/animations/widget_slide_animation.dart';
import 'package:pokedex/core/constants.dart' as constants;
import 'package:pokedex/pages/content/list_view/pokeball_inner_circle.dart';

/// Use only in Stack, this widget should be the last one in the Stack.
class PokeballPageLoadingAnimation extends StatelessWidget {
  const PokeballPageLoadingAnimation(
      {Key? key,
      this.duration = constants.slideDuration,
      this.delay = Duration.zero,
      this.reverse = false})
      : super(key: key);
  final Duration duration;
  final Duration delay;
  final bool reverse;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double gradientRadius = screenHeight >= 2 * screenWidth
        ? screenHeight / (2 * screenWidth)
        : 2 * screenWidth / screenHeight;

    double pokeballDiameter = min(screenWidth / 2, screenHeight / 2);

    return Stack(
      children: [
        SlideAnimation(
          destroyAfterCompletion: true,
          endOffset: const Offset(0.0, 1.0),
          delay: delay,
          duration: duration,
          reverse: reverse,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight / 2,
              width: screenWidth,
              decoration: BoxDecoration(
                border: const Border(top: BorderSide(color: Colors.grey)),
                gradient: RadialGradient(
                  colors: const [
                    Color.fromRGBO(255, 255, 255, 1),
                    Color.fromRGBO(128, 128, 128, 1),
                  ],
                  center: Alignment.topCenter,
                  radius: gradientRadius,
                ),
              ),
              child: Align(
                alignment: Alignment.topCenter,
                child: SizeExpandingAnimation(
                  duration: delay - constants.blinkDuration < Duration.zero
                      ? Duration.zero
                      : delay - constants.blinkDuration,
                  child: _pokeballBottomPart(pokeballDiameter),
                ),
              ),
            ),
          ),
        ),
        SlideAnimation(
          destroyAfterCompletion: true,
          endOffset: const Offset(0.0, -1.0),
          delay: delay,
          duration: duration,
          reverse: reverse,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: screenHeight / 2,
              width: screenWidth,
              decoration: BoxDecoration(
                border: const Border(bottom: BorderSide(color: Colors.grey)),
                gradient: RadialGradient(
                  colors: const [
                    constants.pokeballTopColor,
                    // taken from splash picture
                    Color.fromRGBO(70, 14, 20, 1),
                  ],
                  center: Alignment.bottomCenter,
                  radius: gradientRadius,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizeExpandingAnimation(
                  duration: delay - constants.blinkDuration < Duration.zero
                      ? Duration.zero
                      : delay - constants.blinkDuration,
                  child: _pokeballTopPart(pokeballDiameter),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _pokeballTopPart(double pokeballDiameter) => Container(
        decoration: BoxDecoration(
          color: constants.pokeballTopColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(pokeballDiameter),
            topRight: Radius.circular(pokeballDiameter),
          ),
          //border: Border.all(color: Colors.black, width: 4),
        ),
        height: pokeballDiameter / 2,
        width: pokeballDiameter,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              //border: Border.all(color: Colors.black, width: 4),
            ),
            transform: Matrix4.translationValues(0, pokeballDiameter / 6, 0),
            height: pokeballDiameter / 3,
            child: PokeballInnerCircle(
              delay: duration - constants.blinkDuration,
              duration: constants.blinkDuration,
            ),
            width: pokeballDiameter / 3,
          ),
        ),
      );

  _pokeballBottomPart(double pokeballDiameter) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(pokeballDiameter),
            bottomRight: Radius.circular(pokeballDiameter),
          ),
          //border: Border.all(color: Colors.black, width: 4),
        ),
        height: pokeballDiameter / 2,
        width: pokeballDiameter,
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(pokeballDiameter),
                bottomRight: Radius.circular(pokeballDiameter),
              ),
              //border: Border.all(color: Colors.black, width: 4),
            ),
            height: pokeballDiameter / 6,
            width: pokeballDiameter / 3,
          ),
        ),
      );
}
