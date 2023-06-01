import 'dart:convert';
import 'package:http/http.dart';
import 'package:spaceXXX/data/models/rocket_model.dart';

class RocketRepository {
  Future<Rocket> getRocketById(String rocketId) async {
    final url = 'https://api.spacexdata.com/v4/rockets/$rocketId';
    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return Rocket.fromJson(result);
    } else {
      throw ("Status code: ${response.statusCode}");
    }
  }
}
