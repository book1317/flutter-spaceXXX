import 'package:flutter/material.dart';

class DetailContainer extends StatelessWidget {
  final Widget child;

  const DetailContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 48, 48, 48),
      ),
      child: child,
    );
  }
}
