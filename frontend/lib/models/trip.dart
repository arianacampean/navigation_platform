class Trip {
  int? id;
  double latitude;
  double longitude;
  String city;
  String country;
  String name;
  bool visited;

  Trip(
      {this.id,
      required this.latitude,
      required this.longitude,
      required this.city,
      required this.country,
      required this.name,
      required this.visited});
  @override
  String toString() {
    // TODO: implement toString
    return this.city + " - " + this.country + " - " + this.name;
    // this.latitude.toString() +
    //     " -" +
    //     this.longitude.toString() +
    //     "- " +

    //     "- " +

    //     this.visited.toString();
  }

  Trip.clone(Trip clone)
      : this.id = clone.id,
        this.latitude = clone.latitude,
        this.longitude = clone.longitude,
        this.city = clone.city,
        this.country = clone.country,
        this.name = clone.name,
        this.visited = clone.visited;
}
