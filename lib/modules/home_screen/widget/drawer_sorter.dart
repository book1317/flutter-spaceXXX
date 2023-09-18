import 'package:flutter/material.dart';
import 'package:space_xxx/constants/sort_order.dart';
import 'package:space_xxx/data/repositories/launch_repository.dart';

class DrawerSorter extends StatelessWidget {
  final Sorter sorter;
  final void Function(String key) onToggleSortOrder;

  const DrawerSorter({
    super.key,
    required this.sorter,
    required this.onToggleSortOrder,
  });

  _getSortOrderText(String key, Sorter sorter) {
    Map<String, dynamic> mapSorter = sorter.toMap();
    switch (mapSorter[key]) {
      case SorterOrder.asc:
        return const Text('Ascending');
      case SorterOrder.desc:
        return const Text('Descending');
      default:
        return const Text('None');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        height: 200,
        color: Colors.black,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                'Sort By',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                onPressed: () {
                  onToggleSortOrder('name');
                },
                icon: const Icon(Icons.sort_by_alpha),
                label: _getSortOrderText('name', sorter),
              ),
              TextButton.icon(
                onPressed: () {
                  onToggleSortOrder('static_fire_date_utc');
                },
                icon: const Icon(Icons.date_range),
                label: _getSortOrderText('static_fire_date_utc', sorter),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
