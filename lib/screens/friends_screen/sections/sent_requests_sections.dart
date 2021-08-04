import 'package:aguinha/api.dart';
import 'package:aguinha/components/sent_invitation_tile.dart';
import 'package:aguinha/components/section_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SentRequestsSection extends StatelessWidget {
  const SentRequestsSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Convites enviados'),
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

            final receivedRequests = snapshot.data!.docs;
            if (receivedRequests.isEmpty)
              return Text('Nenhum convite pendente');
            List<SentInvitationTile> requestsWidgets = [];
            for (var request in receivedRequests) {
              print(request.get('nickname'));
              receivedRequests.indexOf(request);
              requestsWidgets.add(
                SentInvitationTile(
                  '${request.get('nickname')}#${request.get('suffix')}',
                  request.id,
                ),
              );
            }
            return Column(
              children: requestsWidgets,
            );
          },
        ),
      ],
    );
  }
}
