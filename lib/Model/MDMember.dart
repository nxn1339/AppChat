class MDMember {
  String? idUser;
  String? idGroup;
  int? readMessage;

  MDMember({this.idUser, this.idGroup, this.readMessage});

  MDMember.fromJson(Map<String, dynamic> json) {
    idUser = json['id_user'];
    idGroup = json['id_group'];
    readMessage = json['read_message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_user'] = this.idUser;
    data['id_group'] = this.idGroup;
    data['read_message'] = this.readMessage;
    return data;
  }
}
