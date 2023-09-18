import 'package:flutter/material.dart';

class ContentText extends StatelessWidget {
  final String title;
  final String text;

  const ContentText({
    super.key,
    required this.title,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      // child: ListTile(
      //   leading: Text(
      //     title,
      //     style: Theme.of(context).textTheme.labelLarge,
      //   ),
      //   trailing: Text(
      //     text,
      //     textAlign: TextAlign.right,
      //   ),
      // ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(width: 30),
          Flexible(
              child: Text(
            text,
            textAlign: TextAlign.right,
          )),
        ],
      ),
    );
  }
}
