import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:prep/utils/query.dart';
import 'package:prep/screens/empty_screen_placeholder.dart';
import 'package:prep/widgets/appointment_info/appointment_banner.dart';

class AppointmentInfo extends StatelessWidget {
  Widget _buildListItem(BuildContext context, DocumentSnapshot document) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: SingleChildScrollView(
        child: Html(
          data: document['description'],
          useRichText: true,
          //turn this off to get the alternative parser
          onLinkTap: (url) {
            _launchURL(url);
          },
          customRender: null,
        ),
      )
    );
  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Cloud not launch url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(10.0),
      children: <Widget>[
        AppointmentDetailsBanner(),
        StreamBuilder(
            stream: Queries.testSnapshots,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Align(
                  alignment: Alignment.topCenter,
                  child: LinearProgressIndicator(),
                );
              } else {
                if (snapshot.data['description'] != null &&
                    snapshot.data['description'].length > 0) {
                  return _buildListItem(context, snapshot.data);
                } else {
                  return Container(
                    padding: EdgeInsets.only(top: 50.0),
                    child: EmptyScreenPlaceholder("This article contains no more information", "")
                  );
                }
              }
            }),
      ],
    );
  }
}