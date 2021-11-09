import 'package:aguinha/constants.dart';
import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/shared/common.dart';

class SendRequestModal extends StatelessWidget {
  const SendRequestModal(this.friend);

  final AguinhaUser friend;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'enviar solicitação de amizade para',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        SizedBox(
          height: kDefaultPadding * 4,
        ),
        Text(
          friend.nickname,
          style: TextStyle(color: Color(0xFF7FBFE5), fontSize: 36),
        ),
        Text(
          '#${friend.suffix}',
          textAlign: TextAlign.right,
          style: TextStyle(color: Color(0xFFB0D9EF), fontSize: 24),
        ),
        SizedBox(
          height: kDefaultPadding * 4,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: Colors.white)),
                  child: Text(
                    'não',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: kDefaultPadding * 4,
                      vertical: kDefaultPadding),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(color: kPrimaryColor)),
                  child: Text(
                    'sim',
                    style: TextStyle(
                        color: kPrimaryColor, fontWeight: FontWeight.bold),
                  )),
            ),
          ],
        )
      ],
    );
  }
}
