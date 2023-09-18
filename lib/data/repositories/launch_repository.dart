import 'package:space_xxx/constants/sort_order.dart';
import 'package:space_xxx/core/network/mj_network.dart';
import 'package:space_xxx/data/models/launch_model.dart';
import 'dart:convert';
import 'package:http/http.dart';

class LaunchRepository {
  final Network _apiClient;

  LaunchRepository(this._apiClient);

  Future<LaunchDetail> getlaunchesList(FetchDetail fetchDetail) async {
    const url = 'https://api.spacexdata.com/v5/launches/query';

    Response response = await post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        fetchDetail.toMap(),
      ),
    );

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

class FetchDetail {
  final int page;
  final int limit;
  final String? query;
  final Sorter sorter;

  const FetchDetail({
    required this.page,
    required this.limit,
    this.query,
    required this.sorter,
  });

  FetchDetail copyWith({
    final int? page,
    final int? limit,
    final String? query,
    final Sorter? sorter,
  }) {
    return FetchDetail(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      query: query ?? this.query,
      sorter: sorter ?? this.sorter,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      "options": {
        "page": page,
        "limit": limit as dynamic,
      },
    };

    if (query != null && query != '') {
      data['query'] = {
        "name": {
          "\$regex": query,
        }
      };
    }

    if (sorter.sortOrder != SorterOrder.none) {
      data['options']['sort'] = {
        sorter.key: sorter.sortOrder,
      };
    }

    return data;
  }
}

class Sorter {
  final String key;
  final String sortOrder;

  const Sorter({
    required this.key,
    required this.sortOrder,
  });

  Map<String, dynamic> toMap() {
    return {key: sortOrder};
  }
}
