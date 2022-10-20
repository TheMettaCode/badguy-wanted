import 'package:badguy/constants/app_constants.dart';
import 'package:badguy/constants/styles.dart';
import 'package:badguy/factory/sharedFunctions.dart';
import 'package:badguy/services/admob/ad_library.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class SharedWidgets {
  static Widget bottomCard(
      BuildContext context, String title, Widget subContent) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        margin: const EdgeInsets.all(0),
        elevation: 5,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: [
              Divider(
                indent: MediaQuery.of(context).size.width / 2.5,
                endIndent: MediaQuery.of(context).size.width / 2.5,
                height: 30,
                thickness: 4,
              ),
              Text(title, style: googleBangersHeader),
              const Divider(height: 4, color: Colors.transparent),
              subContent,
            ],
          ),
        ));
  }

  static Widget appUpdates(BuildContext context) {
    Box userDatabase = Hive.box<dynamic>(appDatabase);
    debugPrint(
        '***** APP UPDATES FOUND: ${List.from(userDatabase.get('appUpdates'))} *****');
    return bottomCard(
      context,
      'Latest Updates',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Application version has been updated!',
              style: regularStyle.copyWith(fontSize: 16)),
          const Divider(),
          ListView(
            shrinkWrap: true,
            children: List.from(userDatabase.get('appUpdates'))
                .sublist(1)
                .map((update) => ListTile(
                    leading: update.toString().split('<|:|>').last == 'high'
                        ? Icon(Icons.label_important, color: Colors.amber)
                        : Icon(Icons.label),
                    title: Text(update.toString().split('<|:|>').first),
                    subtitle: update.toString().split('<|:|>')[1] == 'none'
                        ? SizedBox.shrink()
                        : Text(update.toString().split('<|:|>')[1])))
                .toList(),
          ),
        ],
      ),
    );
  }

  static Widget supportOptionsWidget(BuildContext context) {
    Box userDatabase = Hive.box<dynamic>(appDatabase);
    return bottomCard(
      context,
      'Enjoying $appTitle?',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Please consider...',
              style: regularStyle.copyWith(fontSize: 16)),
          kIsWeb
              ? SizedBox.shrink()
              : ListTile(
                  enabled: true,
                  enableFeedback: true,
                  leading: Icon(Icons.live_tv,
                      size: 20, color: const Color(0xffffc107)),
                  title: Text('Watching A Short Ad'),
                  // subtitle: Text('Click the "Contribute" link'),
                  trailing: Icon(Icons.touch_app),
                  onTap: () => AdMobLibrary().defaultInterstitial(),
                ),
          kIsWeb || userDatabase.get('appRated') == true
              ? SizedBox.shrink()
              : ListTile(
                  enabled: true,
                  enableFeedback: true,
                  leading: Icon(Icons.star,
                      size: 20, color: const Color(0xffffc107)),
                  title: Text('Rating The App'),
                  trailing: Icon(Icons.launch),
                  onTap: () => Functions.linkLaunch(context, appLink)
                      .whenComplete(() => userDatabase.put('appRated', true)),
                ),
          ListTile(
            enabled: true,
            enableFeedback: true,
            leading: Icon(Icons.volunteer_activism,
                size: 20, color: const Color(0xffffc107)),
            title: Text('Developer Support'),
            // subtitle: Text('Click the "Contribute" link'),
            trailing: Icon(Icons.launch),
            onTap: () => Functions.linkLaunch(context, developerWebLink),
          ),
        ],
      ),
    );
  }
}
