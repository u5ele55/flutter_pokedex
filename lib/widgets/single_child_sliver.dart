import 'package:flutter/material.dart';

class SimpleSliver extends StatelessWidget {
  SimpleSliver({Key? key, this.child, this.children}) : super(key: key) {
    assert((child == null) ^ (children == null));
  }
  final Widget? child;
  final List<Widget>? children;

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(children ?? [child!]),
    );
  }
}
