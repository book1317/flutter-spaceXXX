import 'package:equatable/equatable.dart';

class Launchpad extends Equatable {
  final String id;
  final String name;
  final String fullName;
  final String locality;
  final String region;
  final int launchAttempts;
  final int launchSuccesses;
  final String status;
  final String details;
  final List<String> images;

  const Launchpad({
    required this.id,
    required this.name,
    required this.fullName,
    required this.locality,
    required this.region,
    required this.launchAttempts,
    required this.launchSuccesses,
    required this.status,
    required this.details,
    required this.images,
  });

  Launchpad.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        fullName = json['full_name'] ?? '',
        locality = json['locality'] ?? '',
        region = json['region'] ?? '',
        launchAttempts = json['launch_attempts'] ?? 0,
        launchSuccesses = json['launch_successes'] ?? 0,
        status = json['status'] ?? '',
        details = json['details'] ?? '',
        images = json['images']['large'].cast<String>() ?? [];

  @override
  List<Object> get props => [
        id,
        name,
        fullName,
        locality,
        region,
        launchAttempts,
        launchSuccesses,
        status,
        details,
        images,
      ];
}
