import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/services/api.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/constants.dart';
import 'package:flutter_svg/svg.dart';

class ReceivedRequestTile extends StatelessWidget {
  const ReceivedRequestTile(this.requester);

  final AguinhaUser requester;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final acceptRequest = await showModalBottomSheet(
            backgroundColor: kPrimaryColor,
            context: context,
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'aceitar solicitação de amizade?',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(
                    height: kDefaultPadding * 4,
                  ),
                  Text(
                    requester.nickname,
                    style: TextStyle(color: Color(0xFF7FBFE5), fontSize: 36),
                  ),
                  Text(
                    '#${requester.suffix}',
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  )
                ],
              );
            });
        if (acceptRequest != null) {
          try {
            final snackBar =
                SnackBar(content: Text('aceitando solicitação...'));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            await API.acceptFriendshipRequest(requester);
          } catch (error) {
            final errorSnackBar = SnackBar(
                content: Text(AppLocalizations.of(context)!.unknownError));
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
                requester.nickname,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: kPrimaryColor),
              ),
              Text(
                '#${requester.suffix}',
                style: TextStyle(color: Color(0xFF4B9CCB)),
              ),
            ],
          )
        ],
      ),
    );
  }
}
