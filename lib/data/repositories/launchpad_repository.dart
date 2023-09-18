import 'dart:convert';
import 'package:http/http.dart';
import 'package:space_xxx/data/models/launchpad_model.dart';

class LaunchpadRepository {
  Future<Launchpad> getLaunchpadById(String launchpadId) async {
    final url = 'https://api.spacexdata.com/v4/launchpads/$launchpadId';
    Response response = await get(Uri.parse(url));

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return Launchpad.fromJson(result);
    } else {
      throw ("Status code: ${response.statusCode}");
    }
  }
}
