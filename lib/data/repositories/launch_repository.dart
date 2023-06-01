import 'package:spaceXXX/constants/enums.dart';
import 'package:spaceXXX/data/models/launch_model.dart';
import 'dart:convert';
import 'package:http/http.dart';

class LaunchRepository {
  Future<LaunchDetail> getlaunchesList(Filter filter, Sorter sorter) async {
    const url = 'https://api.spacexdata.com/v5/launches/query';
    Map<String, dynamic> body = {
      "options": {
        "page": filter.page
            as dynamic, // on add sort engine assume options type value type int
        "limit": filter.limit,
      },
    };

    if (filter.name != '') {
      body["query"] = {
        "name": {"\$regex": filter.name}
      };
    }

    final sorterMap = sorter.toMap();
    final key = sorterMap.keys.toList().first;
    final value = sorterMap[key];
    if (value != SorterOrder.none) {
      body["options"]["sort"] = {key: value};
    }

    Response response = await post(Uri.parse(url),
        headers: {"Content-Type": "application/json"}, body: json.encode(body));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List launchs = result['docs'];
      return LaunchDetail(
        launchs: launchs.map((e) => Launch.fromJson(e)).toList(),
        pageDetail: PageDetail.fromJson(result),
      );
    } else {
      throw ("Status code: ${response.statusCode}");
    }
  }
}

// class FetchDetail {
//   final int page;
//   final int limit;
//   final Sorter sorter;
//   final String query;

//   const FetchDetail({
//     required this.page,
//     required this.limit,
//     required this.sorter,
//     required this.query,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       "options": {"page": page, "limit": limit, "sort": sorter},
//       "query": {
//         "name": {"\$regex": query}
//       }
//     };
//   }
// }

// class Sorter {
//   final String key;
//   final String sortOrder;

//   const Sorter({
//     required this.key,
//     required this.sortOrder,
//   });
// }
