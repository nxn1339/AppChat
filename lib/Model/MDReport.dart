class MDReport {
  String? id;
  String? name;
  var percent;
  var workTime;
  String? idWork;
  String? updateAt;
  String? nameUser;
  String? idUser;

  MDReport(
      {this.id,
      this.name,
      this.percent,
      this.workTime,
      this.idWork,
      this.updateAt,
      this.nameUser,
      this.idUser});

  MDReport.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    percent = json['percent'];
    workTime = json['work_time'];
    idWork = json['id_work'];
    updateAt = json['update_at'];
    nameUser = json['name_user'];
    idUser = json['id_user'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['percent'] = this.percent;
    data['work_time'] = this.workTime;
    data['id_work'] = this.idWork;
    data['update_at'] = this.updateAt;
    data['name_user'] = this.nameUser;
    data['id_user'] = this.idUser;
    return data;
  }
}
