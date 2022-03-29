// import 'package:json_annotation/json_annotation.dart';
// import 'package:moor_flutter/moor_flutter.dart';

// //part 'details.g.dart';

// final String DetailsTable = "details";

// class DetailsFileds {
//   static final List<String> values = [theme, picture];
//   static final String theme = "theme";
//   static final String picture = "picture";
// }

// @JsonSerializable()
// class Details {
//   String theme;
//   Uint8List picture;
//   Details({required this.theme, required this.picture});

//   static Details fromJson(Map<String, Object?> json) => Details(
//       theme: json["theme"] as String, picture: json["picture"] as Uint8List
//       //       modPreparare: json[DrinksFileds.modPreparare] as String,
//       //       categorie: json[DrinksFileds.categorie] as String,
//       );

//   Map<String, dynamic> toMap() => {
//         "theme": theme,
//         "picture": picture,
//       };
//   // factory Details.fromJson(Map<String, dynamic> json) =>
//   //     _$DetailsFromJson(json);
//   // Map<String, dynamic> toJson() => _$DetailsToJson(this);
// }
