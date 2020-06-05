// conductor object
class UserData {
  String message;
  String token;
  String uid;
  String phoneNumber;
  String role;

  UserData({this.message, this.token, this.uid, this.phoneNumber, this.role});

  factory UserData.fromJson(Map<String,dynamic> data)  {
    return UserData(
      message: data['message'],
      token: data['token'],
      uid: data['user']['user']['user']['uid'],
      phoneNumber: data['user']['user']['user']['phoneNumber'], 
      role: data['user']['role'],
    );
  }
}