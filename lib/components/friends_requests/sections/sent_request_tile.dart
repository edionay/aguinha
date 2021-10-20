import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/services/api.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/constants.dart';
import 'package:flutter_svg/svg.dart';

class SentRequestTile extends StatelessWidget {
  const SentRequestTile(this.friend);

  final AguinhaUser friend;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final deleteRequest = await showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'excluir solicitação de amizade?',
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
                              'cancelar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                      // SizedBox(
                      //   width: kDefaultPadding,
                      // ),
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
                              'excluir',
                              style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  )
                ],
              );
            });
        if (deleteRequest != null) {
          try {
            final snackBar =
                SnackBar(content: Text('excluindo solicitação...'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            await API.denyFriendRequest(friend);
          } catch (error) {
            final errorSnackBar = SnackBar(
                content: Text('não foi possível excluir a solicitação'));
            ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
          }
        }
      },
      child: Row(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/whale_icon.svg',
                  alignment: Alignment.center,
                ),
              ),
            ],
          ),
          SizedBox(
            width: kDefaultPadding / 2,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                friend.nickname,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              Text(
                '#${friend.suffix}',
                style: TextStyle(color: Color(0xFF4B9CCB)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
