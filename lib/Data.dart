class Login{
  int controlum;
  String note;

  Login(this.controlum, this.note);
  Map<String,dynamic>toMap(){
    var map = <String,dynamic>{
      'controlum':controlum,
      'note': note
    };
    return map;
  }
  Login.fromMap(Map<String,dynamic> map){
    controlum=map['controlum'];
    note=map['note'];

  }
}