import 'package:project_mesa/src/model/statistic.dart';
import 'package:http/http.dart' as http;

class WarframeMarket {
  Future<Statistic?> getStatistic(String itemSlug) async {
    Statistic? statistic;

    // try {
    var client = http.Client();

    var uri =
        Uri.parse('https://api.warframe.market/v1/items/$itemSlug/statistics');

    var response = await client.get(uri);

    if (response.statusCode == 200) {
      var json = response.body;
      statistic = statisticFromJson(json);
    }
    // } catch (_) {}

    return statistic;
  }
}
