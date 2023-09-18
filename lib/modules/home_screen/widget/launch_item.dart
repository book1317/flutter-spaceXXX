import 'package:flutter/material.dart';
import 'package:space_xxx/logic/utility/date_time.dart';

class LaunchItem extends StatelessWidget {
  final int index;
  final String name;
  final String launchedDate;
  final bool success;
  final String image;

  const LaunchItem({
    super.key,
    required this.index,
    required this.name,
    required this.launchedDate,
    required this.success,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              convertUtcStringToFormatDate(launchedDate),
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              success ? 'Success' : 'Fail',
              style: TextStyle(
                color: success ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
        trailing: Text('#$index'),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(image),
        ));
  }
}
