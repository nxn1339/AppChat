class MDMessage {
  String? id;
  String? content;
  String? image;
  String? idGroup;
  String? idUser;
  String? name;
  String? avatar;

  MDMessage(
      {this.id,
      this.content,
      this.image,
      this.idGroup,
      this.idUser,
      this.name,
      this.avatar});

  MDMessage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    image = json['image'];
    idGroup = json['id_group'];
    idUser = json['id_user'];
    name = json['name'];
    avatar = json['avatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['image'] = this.image;
    data['id_group'] = this.idGroup;
    data['id_user'] = this.idUser;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    return data;
  }
}
