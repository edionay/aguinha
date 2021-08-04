import 'package:aguinha/components/section_title.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';

class UserSearchSection extends StatefulWidget {
  @override
  _UserSearchSectionState createState() => _UserSearchSectionState();
}

class _UserSearchSectionState extends State<UserSearchSection> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    String? username;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionTitle('Convite por nome de usuário'),
        Container(
          padding: EdgeInsets.all(kDefaultPadding),
          color: kPrimaryColor,
          child: Column(
            children: [
              TextField(
                onChanged: (value) {
                  username = value;
                },
                enabled: !loading,
                textCapitalization: TextCapitalization.characters,
                style:
                    TextStyle(color: Colors.white, fontSize: kMediumFontSize),
                decoration: InputDecoration(
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        if (username == null || username!.isEmpty) {
                          final snackBar = SnackBar(
                              content: Text('Insira um nome de usuário'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          return;
                        }
                        setState(() {
                          loading = true;
                        });

                        HttpsCallable callable = FirebaseFunctions.instance
                            .httpsCallable('userExists');
                        final userExists =
                            await callable.call({'username': username});

                        setState(() {
                          loading = false;
                        });
                        if (userExists.data) {
                          final splittedUsername = username!.split('#');
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                      'Deseja enviar uma solicitação de amizade para'),
                                  SizedBox(
                                    height: kDefaultPadding * 2,
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        splittedUsername[0],
                                        style: TextStyle(
                                            fontSize: 40,
                                            color: kPrimaryColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text('#${splittedUsername[1]}',
                                          textAlign: TextAlign.left,
                                          style: TextStyle(
                                              fontWeight: FontWeight.normal,
                                              fontSize: 24,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                  SizedBox(
                                    height: kDefaultPadding,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () async {
                                          HttpsCallable callable =
                                              FirebaseFunctions
                                                  .instance
                                                  .httpsCallable(
                                                      'requestFriendship');
                                          final response = await callable
                                              .call({'username': username});
                                          if (response.data) {
                                            Navigator.pop(context);
                                            final snackBar = SnackBar(
                                                content: Text(
                                                    'Solicitação enviada!'));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                            primary: kPrimaryColor),
                                        child: Text('Sim'),
                                      ),
                                      SizedBox(
                                        width: kDefaultPadding,
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(
                                          'Não',
                                          style:
                                              TextStyle(color: kPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        } else {
                          final snackBar =
                              SnackBar(content: Text('Usuário não encontrado'));
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                        print(userExists.data);
                      },
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                        size: kBigIconSize,
                      ),
                    ),
                    hintText: 'EXEMPLO#1212',
                    fillColor: Colors.white),
              ),
              if (loading) LinearProgressIndicator()
            ],
          ),
        ),
      ],
    );
  }
}
