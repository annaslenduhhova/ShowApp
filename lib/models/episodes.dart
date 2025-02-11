import 'package:series_app/models/models.dart';

class Episode {
  int id;
  String name;
  int season;
  ShowImage? image; // Permitimos que sea null
  String summary;
  Rating rating;

  Episode({
    required this.id,
    required this.name,
    required this.season,
    required this.image, // Permitimos que sea null
    required this.summary,
    required this.rating,
  });

  factory Episode.fromJson(String str) => Episode.fromMap(json.decode(str));

  factory Episode.fromMap(Map<String, dynamic> json) => Episode(
        id: json["id"] ?? 0,
        name: json["name"] ?? "Episodio sin título",
        season: json["season"] ?? 0,
        image: json["image"] != null ? ShowImage.fromMap(json["image"]) : null,
        summary: json["summary"] ?? "No hay descripción disponible",
        rating: Rating.fromMap(json["rating"]),
      );

  String get fullPosterPath {
    return image?.original ?? 'https://i.stack.imgur.com/GNhxO.png';
  }
}
