import 'package:aguinha/api.dart';
import 'package:aguinha/components/requested_invitation_tile.dart';
import 'package:aguinha/components/section_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReceivedInvitesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Convites recebidos'),
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
                  return Text('Nenhum convite pendente');
                List<RequestedInvitationTile> requestsWidgets = [];
                for (var request in receivedRequests) {
                  print(request.get('nickname'));
                  receivedRequests.indexOf(request);
                  requestsWidgets.add(
                    RequestedInvitationTile(
                        '${request.get('nickname')}#${request.get('suffix')}',
                        request.id),
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
