class MDGroup {
  String? id;
  String? owner;
  String? image;
  String? name;

  MDGroup({this.id, this.owner, this.image, this.name});

  MDGroup.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    owner = json['Owner'];
    image = json['image'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['Owner'] = this.owner;
    data['image'] = this.image;
    data['name'] = this.name;
    return data;
  }
}
