import 'package:equatable/equatable.dart';

class LaunchDetail {
  final List<Launch> launchs;
  final PageDetail pageDetail;

  const LaunchDetail({
    required this.launchs,
    required this.pageDetail,
  });
}

class Launch extends Equatable {
  final String id;
  final String name;
  final String image;
  final String launchedDate;
  final bool success;
  final String rocketId;
  final String launchpadId;
  final String details;

  const Launch({
    required this.name,
    required this.id,
    required this.image,
    required this.launchedDate,
    required this.success,
    required this.rocketId,
    required this.launchpadId,
    required this.details,
  });

  Launch.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        image = json['links']['patch']['small'] ?? '',
        launchedDate = json['static_fire_date_utc'] ?? '',
        success = json['success'] ?? false,
        rocketId = json['rocket'] ?? '',
        launchpadId = json['launchpad'] ?? '',
        details = json['details'] ?? '';

  @override
  List<Object> get props =>
      [id, name, image, launchedDate, success, rocketId, launchpadId, details];
}

class PageDetail extends Equatable {
  final int page;
  final int totalPages;
  final bool hasNextPage;

  const PageDetail({
    required this.page,
    required this.totalPages,
    required this.hasNextPage,
  });

  PageDetail.fromJson(Map<String, dynamic> json)
      : page = json['page'] ?? 1,
        totalPages = json['totalPages'] ?? 1,
        hasNextPage = json['hasNextPage'] ?? false;

  @override
  List<Object> get props => [page, totalPages, hasNextPage];
}

class Filter extends Equatable {
  final String name;
  final int page;
  final int limit;

  const Filter({
    required this.name,
    required this.page,
    required this.limit,
  });

  Filter.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        page = json['page'],
        limit = json['limit'];

  @override
  List<Object> get props => [
        name,
        page,
        limit,
      ];
}

class Sorter extends Equatable {
  final Map<String, String> sorter;

  const Sorter(
    this.sorter,
  );

  Map<String, dynamic> toMap() {
    return sorter;
  }

  @override
  List<Object> get props => [
        sorter,
      ];
}
