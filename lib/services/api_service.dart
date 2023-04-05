import "dart:convert";

import "package:http/http.dart" as http;
import "package:toonflix/models/webtoon_detail_model.dart";
import "package:toonflix/models/webtoon_episode_model.dart";
import "package:toonflix/models/webtoon_model.dart";

class ApiService {
  static const String _baseUrl =
      "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String _today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {
    final Uri url = Uri.parse("$_baseUrl/$_today");
    final http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw Error();
    }
    final List<dynamic> webtoons = jsonDecode(response.body);
    return webtoons
        .map((dynamic webtoon) => WebtoonModel.fromJson(webtoon))
        .toList();
  }

  static Future<WebtoonDetailModel> getToonById(String id) async {
    final Uri url = Uri.parse("$_baseUrl/$id");
    final http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw Error();
    }
    return WebtoonDetailModel.fromJson(jsonDecode(response.body));
  }

  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(
      String id) async {
    final Uri url = Uri.parse("$_baseUrl/$id/episodes");
    final http.Response response = await http.get(url);
    if (response.statusCode != 200) {
      throw Error();
    }
    final List<dynamic> episodes = jsonDecode(response.body);
    return episodes
        .map((dynamic webtoon) => WebtoonEpisodeModel.fromJson(webtoon))
        .toList();
  }
}
