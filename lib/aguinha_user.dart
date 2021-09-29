class AguinhaUser {
  String uid;
  String nickname;
  String suffix;

  String get username => '$nickname#$suffix';

  AguinhaUser(this.uid, this.nickname, this.suffix);
}
