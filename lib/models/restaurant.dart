class Restaurant {
  Restaurant({
    this.id,
    this.name,
    this.pictureId,
    this.city,
    this.rating,
  });

  String id;
  String name;
  String pictureId;
  String city;
  double rating;

  static const tableName = "restaurants";

  factory Restaurant.fromJson(Map<String, dynamic> json) => Restaurant(
        id: json["id"],
        name: json["name"],
        pictureId:
            'https://restaurant-api.dicoding.dev/images/medium/${json["pictureId"]}',
        city: json["city"],
        rating: json["rating"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pictureId": pictureId,
        "city": city,
        "rating": rating,
      };
}
