import 'package:aguinha/aguinha_user.dart';
import 'package:aguinha/api.dart';
import 'package:aguinha/common.dart';
import 'package:aguinha/constants.dart';
import 'package:flutter_svg/svg.dart';

class FriendTile extends StatefulWidget {
  const FriendTile(
      {required this.friend,
      required this.notifying,
      this.lastSentNotification,
      this.lastReceivedNotification});
  final bool notifying;
  final AguinhaUser friend;

  final DateTime? lastSentNotification, lastReceivedNotification;

  @override
  _FriendTileState createState() => _FriendTileState();
}

class _FriendTileState extends State<FriendTile> {
  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton(
        onLongPress: disabled || widget.notifying
            ? null
            : () async {
                final bool? unfriend = await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      color: kPrimaryColor,
                      child: Column(
                        children: [
                          Flexible(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.friend.nickname,
                                  style: TextStyle(
                                      color: Color(0xFF7FBFE5), fontSize: 36),
                                ),
                                Text(
                                  '#${widget.friend.suffix}',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      color: Color(0xFFB0D9EF), fontSize: 24),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: kDefaultPadding * 4,
                                  vertical: kDefaultPadding * 2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40.0),
                              ),
                              child: Text(
                                'desfazer amizade',
                                style: TextStyle(
                                    color: kPrimaryColor, fontSize: 20),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: kDefaultPadding * 2),
                            child: TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'voltar',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 20),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
                if (unfriend != null) {
                  API.unfriend(widget.friend);
                  final snackBar =
                      SnackBar(content: Text('desfazendo amizade...'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
        onPressed: disabled || widget.notifying
            ? null
            : () async {
                setState(() {
                  disabled = true;
                });
                try {
                  await API.notify(widget.friend);

                  final snackBar = SnackBar(
                      content: Text(
                          '${AppLocalizations.of(context)!.notifying} ${widget.friend.nickname}'));

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  setState(() {
                    disabled = false;
                  });
                } catch (error) {
                  print(error);
                  setState(() {
                    disabled = false;
                  });
                }
              },
        style: TextButton.styleFrom(
          primary: Colors.blue,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                  color: disabled || widget.notifying
                      ? Colors.grey
                      : kPrimaryColor,
                  borderRadius: BorderRadius.circular(40)),
              child: SvgPicture.asset(
                'assets/whale_icon.svg',
                alignment: Alignment.center,
                // fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(
              width: kDefaultPadding / 2,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.friend.nickname,
                    maxLines: 1,
                    style: TextStyle(
                        color: disabled || widget.notifying
                            ? Colors.grey
                            : kPrimaryColor),
                  ),
                  if (widget.lastSentNotification != null)
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 200,
                          child: Icon(
                            Icons.arrow_forward,
                            size: 10,
                            semanticLabel: 'última notificação enviada',
                          ),
                        ),
                        Text(
                          '${widget.lastSentNotification!.hour}:${widget.lastSentNotification!.minute}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  if (widget.lastReceivedNotification != null)
                    Row(
                      children: [
                        Transform.rotate(
                          angle: 200,
                          child: Icon(
                            Icons.arrow_back,
                            size: 10,
                            semanticLabel: 'última notificação recebida',
                          ),
                        ),
                        Text(
                          '${widget.lastReceivedNotification!.hour}:${widget.lastReceivedNotification!.minute}',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
