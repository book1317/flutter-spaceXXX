import 'package:equatable/equatable.dart';

class Rocket extends Equatable {
  final String id;
  final String name;
  final String type;
  final bool active;
  final String country;
  final String company;
  final String description;
  final List<String> flickrImages;

  const Rocket({
    required this.id,
    required this.name,
    required this.type,
    required this.active,
    required this.country,
    required this.company,
    required this.description,
    required this.flickrImages,
  });

  Rocket.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        name = json['name'] ?? '',
        type = json['type'] ?? '',
        active = json['active'] ?? '',
        country = json['name'] ?? '',
        company = json['company'] ?? '',
        description = json['description'] ?? '',
        flickrImages = json['flickr_images'].cast<String>() ?? [];

  @override
  List<Object> get props => [
        id,
        name,
        type,
        active,
        country,
        company,
        description,
        flickrImages,
      ];
}
