import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:series_app/models/models.dart';

class ShowsProvider extends ChangeNotifier {
  final String _baseUrl = 'api.tvmaze.com';

  List<Show> onDisplayShows = [];
  List<Episode> onDisplayEpisodes = [];
  Map<int, List<Cast>> casting = {};

  ShowsProvider() {
    getOnDisplayShows();
  }

  Future<void> getOnDisplayShows() async {
    var url = Uri.https(_baseUrl, '/shows');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);

      onDisplayShows =
          decodedData.map((showJson) => Show.fromMap(showJson)).toList();
      notifyListeners();
    }
  }

  Future<List<Cast>> getShowCast(int idShow) async {
    var url = Uri.https(_baseUrl, '/shows/$idShow/cast');

    final result = await http.get(url);

    if (result.statusCode != 200) {
      throw Exception('Failed to load cast data');
    }
    final List<dynamic> decodedData = json.decode(result.body);
    if (decodedData.isEmpty) {
      return [];
    }
    List<Cast> castList = decodedData
        .map((json) {
          try {
            return Cast.fromMap(json);
          } catch (e) {
            return null;
          }
        })
        .where((cast) => cast != null)
        .cast<Cast>()
        .toList();
    casting[idShow] = castList;

    return castList;
  }

  Future<List<Episode>> getOnDisplayEpisodes(int showId) async {
    var url = Uri.https(_baseUrl, 'shows/$showId/episodes');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> decodedData = json.decode(response.body);
      final List<Episode> episodes = decodedData
          .map((episodeJson) => Episode.fromMap(episodeJson))
          .toList();

      onDisplayEpisodes = episodes;
      notifyListeners();

      return episodes;
    } else {
      throw Exception("Error al cargar episodios");
    }
  }

  Future<List<dynamic>> getShowImages(int showId) async {
    var url = Uri.https(_baseUrl, '/shows/$showId/images');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      return [];
    }

    final List<dynamic> decodedData = json.decode(response.body);
    return decodedData;
  }

  Future<String> getBannerUrl(int showId) async {
    List<dynamic> images = await getShowImages(showId);
    final banners = images.where((img) => img["type"] == "banner").toList();

    if (banners.isNotEmpty) {
      return banners.first["resolutions"]["original"]["url"];
    }

    return 'https://placehold.co/110x110.png';
  }

  Future<String> getPosterUrl(int showId) async {
    List<dynamic> images = await getShowImages(showId);
    final posters = images.where((img) => img["type"] == "poster").toList();

    if (posters.isNotEmpty) {
      return posters.first["resolutions"]["original"]["url"];
    }

    return 'https://placehold.co/130x190';
  }
}
