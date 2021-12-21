class Product {
  String name;
  String launchedAt;
  String launchSite;
  double popularity;

  Product(this.name, this.launchedAt,this.launchSite,this.popularity);

  Product.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        launchedAt = json['launchedAt'],
        launchSite = json['launchSite'],
        popularity = json['popularity'];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "name": name,
      "launchedAt": launchedAt,
      "launchSite": launchSite,
      "popularity": popularity,
    };
  }
}
