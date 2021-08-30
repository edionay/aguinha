class AguinhaUser {
  String uid;
  String nickname;
  String suffix;

  AguinhaUser(this.uid, this.nickname, this.suffix);

  getUsername() => '$nickname#$suffix';
}
