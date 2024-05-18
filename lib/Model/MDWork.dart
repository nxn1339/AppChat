class MDWork {
  String? id;
  String? name;
  String? idUser;
  String? idGroup;

  MDWork({this.id, this.name, this.idUser, this.idGroup});

  MDWork.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    idUser = json['id_user'];
    idGroup = json['id_group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['id_user'] = this.idUser;
    data['id_group'] = this.idGroup;
    return data;
  }
}
