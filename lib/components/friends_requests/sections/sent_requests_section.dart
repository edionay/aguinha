import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/services/api.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/components/friends_requests/sections/sent_request_tile.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/shared/ui/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SentRequestsSection extends StatelessWidget {
  const SentRequestsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Subtitle(title: AppLocalizations.of(context)!.sent),
        SizedBox(
          height: kDefaultPadding,
        ),
        Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: API.getSentRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final sentRequests = snapshot.data!.docs;
                if (sentRequests.isEmpty) return Text('nenhuma solicitação');
                List<SentRequestTile> requestsWidgets = [];
                for (var request in sentRequests) {
                  print(request.get('nickname'));
                  sentRequests.indexOf(request);

                  requestsWidgets.add(
                    SentRequestTile(
                      AguinhaUser(
                        request.id,
                        request.get('nickname'),
                        request.get('suffix'),
                      ),
                    ),
                  );
                }
                return Column(
                  children: requestsWidgets,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
