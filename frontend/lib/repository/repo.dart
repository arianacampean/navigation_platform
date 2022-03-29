import 'package:frontend/models/user.dart';

class Repo {
  late User user;
  List<String> categories = [];

  Repo() {}
  static final Repo repo = Repo();
}
