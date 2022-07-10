import 'package:flutter/material.dart';
import 'package:pokedex/animations/jump_curve.dart';
import 'package:pokedex/animations/page_loading_animation.dart';

class PageTransitionRoute extends PageRouteBuilder {
  PageTransitionRoute({required this.page})
      : super(
            pageBuilder: (_, __, ___) => page,
            transitionsBuilder: (_, animation, __, child) {
              final _tween = CurveTween(curve: JumpCurve());
              return FadeTransition(
                opacity: animation,
                child: child,
              );
              FutureBuilder(
                future: Future.delayed(Duration(milliseconds: 1000))
                    .then((value) => 1),
                builder: (context, snapshot) {
                  List<Widget> children;
                  Widget chill;

                  // TODO: for some reason, in the second initialization of PPLA
                  // SlideAnimation dont appears
                  if (snapshot.hasData) {
                    print("data");
                    children = [
                      child,
                      const PokeballPageLoadingAnimation(
                        duration: Duration(milliseconds: 1500),
                        delay: Duration(milliseconds: 1000),
                      ),
                    ];
                    chill = PokeballPageLoadingAnimation(
                      duration: Duration(milliseconds: 1500),
                      delay: Duration(milliseconds: 1000),
                    );
                  } else {
                    print("no data");
                    children = [
                      // Closing animation
                      const PokeballPageLoadingAnimation(
                        duration: Duration(milliseconds: 1000),
                        reverse: true,
                      )
                    ];
                    chill = const PokeballPageLoadingAnimation(
                      duration: Duration(milliseconds: 1000),
                      reverse: true,
                    );
                  }

                  // TRY THIS!!!
                  final sec = Duration(milliseconds: 1000);

                  return Stack(
                    children: [
                      SlideTransition(
                        position: animation.drive(
                            Tween(begin: Offset(0, 1.0), end: Offset(0, 0))),
                        child: child,
                      ),
                      const PokeballPageLoadingAnimation(
                        duration: Duration(milliseconds: 1000),
                        reverse: true,
                      ),
                    ],
                  );
                },
              );
            });

  final Widget page;
}
