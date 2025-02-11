import 'package:series_app/models/models.dart';

class Cast {
  Person person;

  Cast({
    required this.person,
  });

  factory Cast.fromJson(String str) => Cast.fromMap(json.decode(str));

  factory Cast.fromMap(Map<String, dynamic> json) => Cast(
        person: Person.fromMap(json["person"]),
      );

  get fullCastPath {
    if (person.image != null) {
      return person.image?.medium;
    }
    return 'https://i.stack.imgur.com/GNhxO.png';
  }
}

class Person {
  int id;
  String name;
  ShowImage? image;

  Person({
    required this.id,
    required this.name,
    required this.image,
  });

  factory Person.fromJson(String str) => Person.fromMap(json.decode(str));

  factory Person.fromMap(Map<String, dynamic> json) => Person(
        id: json["id"],
        name: json["name"],
        image: json["image"] != null
            ? ShowImage.fromMap(json["image"])
            : null, // Manejo de null
      );
}

class ShowImage {
  String medium;
  String original;

  ShowImage({
    required this.medium,
    required this.original,
  });

  factory ShowImage.fromJson(String str) => ShowImage.fromMap(json.decode(str));

  factory ShowImage.fromMap(Map<String, dynamic> json) => ShowImage(
        medium: json["medium"],
        original: json["original"],
      );
}
