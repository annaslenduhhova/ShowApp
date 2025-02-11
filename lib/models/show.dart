import 'package:series_app/models/models.dart';

class Show {
  int id;
  String name;
  ShowImage? image;
  String summary;
  Rating rating;
  String language;

  Show({
    required this.id,
    required this.name,
    required this.image,
    required this.summary,
    required this.rating,
    required this.language,
  });

  factory Show.fromJson(String str) => Show.fromMap(json.decode(str));

  factory Show.fromMap(Map<String, dynamic> json) => Show(
        id: json["id"],
        name: json["name"],
        image: ShowImage.fromMap(json["image"]),
        summary: json["summary"],
        rating: Rating.fromMap(json["rating"]),
        language: json["language"],
      );

  get fullPosterPath {
    if (image != null) {
      return image?.original;
    }
    return 'https://i.stack.imgur.com/GNhxO.png';
  }
}

class Rating {
  double average;

  Rating({
    required this.average,
  });

  factory Rating.fromJson(String str) => Rating.fromMap(json.decode(str));

  factory Rating.fromMap(Map<String, dynamic> json) {
    double avg = json["average"] != null ? json["average"].toDouble() : 0.0;

    return Rating(
      average: avg,
    );
  }
}
