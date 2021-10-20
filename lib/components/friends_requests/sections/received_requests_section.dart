import 'package:aguinha/models/aguinha_user.dart';
import 'package:aguinha/services/api.dart';
import 'package:aguinha/shared/common.dart';
import 'package:aguinha/components/friends_requests/sections/received_request_tile.dart';
import 'package:aguinha/constants.dart';
import 'package:aguinha/shared/ui/subtitle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceivedRequestsSection extends StatelessWidget {
  const ReceivedRequestsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Subtitle(title: AppLocalizations.of(context)!.received),
        SizedBox(
          height: kDefaultPadding,
        ),
        Column(
          children: [
            StreamBuilder<QuerySnapshot>(
              stream: API.getReceivedRequests(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final receivedRequests = snapshot.data!.docs;
                if (receivedRequests.isEmpty)
                  return Text('nenhuma solicitação');
                List<ReceivedRequestTile> requestsWidgets = [];
                for (var request in receivedRequests) {
                  print(request.get('nickname'));
                  receivedRequests.indexOf(request);

                  requestsWidgets.add(
                    ReceivedRequestTile(AguinhaUser(request.id,
                        request.get('nickname'), request.get('suffix'))),
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
