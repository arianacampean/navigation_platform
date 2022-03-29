class Photo {
  int id;
  String photo_name;

  Photo({required this.id, required this.photo_name});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'id': id,
      'photo_name': photo_name,
    };
    return map;
  }

  static Photo fromMap(Map<dynamic, dynamic?> json) => Photo(
        id: json["id"] as int,
        photo_name: json["photo_name"] as String,
      );
}
