class User {
  int _id;
  String _name;

  User(int id, String name) {
    this._id = id;
    this._name = name;
  }

  int get getId => _id;
  String get getName => _name;
  
  set setName(String value) { _name = value; }
}