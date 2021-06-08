class User {
  String _name;

  User(String name) {
    this._name = name;
  }

  String get getName => _name;

  set setName(String value) { _name = value; }
}