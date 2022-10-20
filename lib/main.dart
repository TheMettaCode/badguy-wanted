import 'dart:async';
import 'dart:math';
import 'package:background_fetch/background_fetch.dart';
import 'package:badguy/constants/app_constants.dart';
import 'package:badguy/constants/fbi_constants.dart';
import 'package:badguy/constants/sharedWidgets.dart';
import 'package:badguy/constants/styles.dart';
import 'package:badguy/constants/themes.dart';
import 'package:badguy/factory/sharedFunctions.dart';
import 'package:badguy/services/notifications/notification_api.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';
import 'models/json/fbi/fbi_field_offices.dart';

// [Android-only] This "Headless Task" is run when the Android app
// is terminated with enableHeadless: true
void backgroundFetchHeadlessTask(HeadlessTask task) async {
  String taskId = task.taskId;
  bool isTimeout = task.timeout;
  if (isTimeout) {
    // This task has exceeded its allowed running-time.
    // You must stop what you're doing and immediately .finish(taskId)
    debugPrint("[BackgroundFetch] Headless task timed-out: $taskId");
    BackgroundFetch.finish(taskId);
    return;
  }
  debugPrint('[BackgroundFetch] Headless event received.');
  // Do your work here...
  debugPrint('***** BACKGROUND FETCH IS WORKING HERE! *****');
  debugPrint('***** OPENING DATA BOX (Background Fetch) *****');

  await Functions.initializeBox();
  await Functions.getWantedApi(1, '', '');

  BackgroundFetch.finish(taskId);
  debugPrint('***** Background Fetch Complete and Closed *****');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Functions.initializeBox();
  if (!kIsWeb) {
    debugPrint('***** Halting Background Fetch... *****');
    await BackgroundFetch.stop();
    debugPrint('***** Enabling Mobile Ads... *****');
    await MobileAds.instance.initialize();
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Box<dynamic> userDatabase = Hive.box<dynamic>(appDatabase);
  int randomNumber = Random().nextInt(99999);
  // bool _enabled = true;
  // int _status = 0;
  List<DateTime> _events = [];

  FbiFieldOffices fbiFieldOffices = FbiFieldOffices.fromJson(fieldOffices);
  List<FieldOffice> userFieldOffices = [];
  Map<String, dynamic> userDeviceInfo = {};

  PackageInfo appPackageInfo = PackageInfo(
      appName: appTitle,
      buildNumber: '',
      buildSignature: '',
      packageName: '',
      version: '');

  String userId = "";
  double latitude = 0;
  double longitude = 0;
  String country = "";
  String countryCode = "";
  String county = "";
  String state = "";
  String city = "";
  String postalCode = "";
  String locationData = "";
  int credits = 0;
  int appOpens = 0;
  bool advertise = true;
  bool darkTheme = false;
  bool fugitiveAlerts = false;
  bool cautionDismissed = false;
  bool termsAgreed = false;

  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await NotificationApi.init();
      await getData();

      if (!kIsWeb) {
        // Register to receive BackgroundFetch events after app is terminated.
        // Requires {stopOnTerminate: false, enableHeadless: true}
        BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
        await initBgFetchPlatformState();
      }
    });
    super.initState();
  }

  Future<void> initBgFetchPlatformState() async {
    // Configure BackgroundFetch.
    int status = await BackgroundFetch.configure(
        BackgroundFetchConfig(
            minimumFetchInterval: 15,
            startOnBoot: true,
            stopOnTerminate: false,
            enableHeadless: true,
            requiresBatteryNotLow: false,
            requiresCharging: false,
            requiresStorageNotLow: false,
            requiresDeviceIdle: false,
            forceAlarmManager: false,
            requiredNetworkType: NetworkType.ANY), (String taskId) async {
      // <-- Event handler
      // This is the fetch-event callback.
      debugPrint("[BackgroundFetch] Event received $taskId");
      setState(() {
        _events.insert(0, new DateTime.now());
      });
      // IMPORTANT:  You must signal completion of your task or the OS can punish your app
      // for taking too long in the background.
      BackgroundFetch.finish(taskId);
    }, (String taskId) async {
      // <-- Task timeout handler.
      // This task has exceeded its allowed running-time.  You must stop what you're doing and immediately .finish(taskId)
      debugPrint("[BackgroundFetch] TASK TIMEOUT taskId: $taskId");
      BackgroundFetch.finish(taskId);
    });
    debugPrint('[BackgroundFetch] configure success: $status');
    // setState(() {
    //   _status = status;
    // });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }

  Future<void> getData() async {
    debugPrint('***** Beginning Data Retreival *****');

    await Functions.getPosition().whenComplete(
      () async {
        setState(() {
          userFieldOffices = fbiFieldOffices.fieldOffices!
              .where((office) =>
                  office.office.toLowerCase() != 'washingtondc' &&
                  office.state.toLowerCase() ==
                      userDatabase.get('lastState').trim().toLowerCase())
              .toList();
          debugPrint(
              '***** User Field Offices (getData): ${userFieldOffices.first.office} *****');
        });
      },
    ).whenComplete(
      () async {
        if (userDatabase.get('userId').isNotEmpty) {
          debugPrint('***** SETTING LOAD DATA *****');
          setState(() {
            userId = userDatabase.get('userId');
            credits = userDatabase.get('credits');
            appOpens = userDatabase.get('appOpens');
            advertise = userDatabase.get('advertise');
            darkTheme = userDatabase.get('darkTheme');
            fugitiveAlerts = userDatabase.get('fugitiveAlerts');
            cautionDismissed = userDatabase.get('cautionDismissed');
            termsAgreed = userDatabase.get('termsAgreed');
            country = userDatabase.get('lastCountry');
            countryCode = userDatabase.get('lastIsoCountryCode');
            county = userDatabase.get('lastSubAdministrativeArea');
            state = userDatabase.get('lastState');
            city = userDatabase.get('lastLocality');
            postalCode = userDatabase.get('lastPostalCode');
          });
        }
        debugPrint('***** Determining Device & Package Info *****');
        await Functions.getPackageInfo(context).then((value) async {
          if (value.appName.isNotEmpty) setState(() => appPackageInfo = value);
        });
        if (!kIsWeb) {
          await Functions.getDeviceInfo().then((value) async {
            if (value.isNotEmpty) setState(() => userDeviceInfo = value);
          });
        }
      },
    );
    await userDatabase.put('appOpens', userDatabase.get('appOpens') + 1);
    debugPrint('***** App Opens: ${userDatabase.get('appOpens')} *****');
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    return userFieldOffices.length == 0
        ? Center(
            child: new Stack(
            alignment: Alignment.center,
            children: [
              new Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/splash_background.png'))),
              ),
              new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    height: 150,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: AssetImage('assets/splash_logo.png'),
                    )),
                  ),
                  new CircularProgressIndicator(
                    color: Color(0xff900000),
                    backgroundColor: Color(0xfff9b900),
                  ),
                ],
              ),
            ],
          ))
        : new ValueListenableBuilder(
            valueListenable:
                Hive.box(appDatabase).listenable(keys: ['darkTheme']),
            builder: (context, box, widget) {
              return new MaterialApp(
                title: appTitle,
                theme: darkTheme ? Themes().darkTheme : Themes().defaultTheme,
                debugShowCheckedModeBanner: false,
                home: new SafeArea(
                  child: new Scaffold(
                    drawer: new ValueListenableBuilder(
                        valueListenable: Hive.box(appDatabase)
                            .listenable(keys: ['darkTheme', 'fugitiveAlerts']),
                        builder: (context, box, widget) {
                          return new Drawer(
                            child: new Column(
                              children: <Widget>[
                                new DrawerHeader(
                                  padding: const EdgeInsets.all(0),
                                  child: new Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 5, 0),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.65),
                                      backgroundBlendMode: BlendMode.overlay,
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            userFieldOffices.first.photoUrl),
                                        fit: BoxFit.cover,
                                        colorFilter: ColorFilter.mode(
                                            Colors.black, BlendMode.color),
                                      ),
                                    ),
                                    // foregroundDecoration: BoxDecoration(
                                    //     color: Colors.black.withOpacity(0.65),
                                    //     backgroundBlendMode: BlendMode.src),
                                    child: new Scrollbar(
                                      child: new ListView(
                                          shrinkWrap: true,
                                          physics: BouncingScrollPhysics(),
                                          children: userFieldOffices
                                                  .map((office) => new ListTile(
                                                        tileColor: Colors.white
                                                            .withOpacity(1),
                                                        enabled: true,
                                                        enableFeedback: true,
                                                        dense: true,
                                                        isThreeLine: true,
                                                        contentPadding:
                                                            const EdgeInsets
                                                                .all(5),
                                                        title: new Text(
                                                            '${office.city} Field Office',
                                                            // '${office.city}, ${office.state} Field Office',
                                                            style: googleStyle.copyWith(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColorLight,
                                                                fontSize: 25,
                                                                shadows:
                                                                    new StrokeText()
                                                                        .shadowStrokeTextBlack)),
                                                        subtitle: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            new Text(
                                                                '${office.phone}',
                                                                style: regularStyle.copyWith(
                                                                    fontSize:
                                                                        14,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    shadows:
                                                                        new StrokeText()
                                                                            .shadowStrokeTextBlack)),
                                                            new Text(
                                                                '${office.website}',
                                                                style: regularStyle.copyWith(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                            .grey[
                                                                        300],
                                                                    shadows:
                                                                        new StrokeText()
                                                                            .shadowStrokeTextBlack)),
                                                          ],
                                                        ),
                                                        onTap: () => launchUrl(
                                                            Uri.parse(office
                                                                .website)),
                                                      ))
                                                  .toList() +
                                              [
                                                new ListTile(
                                                  enabled: true,
                                                  enableFeedback: true,
                                                  dense: true,
                                                  isThreeLine: true,
                                                  contentPadding:
                                                      const EdgeInsets.all(5),
                                                  title: new Text(
                                                      'FBI Headquarters',
                                                      style: googleStyle.copyWith(
                                                          color:
                                                              Colors.grey[300],
                                                          fontSize: 25,
                                                          shadows: new StrokeText()
                                                              .shadowStrokeTextBlack)),
                                                  subtitle: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      new Text(
                                                          '${fbiFieldOffices.fieldOffices!.first.phone}',
                                                          style: regularStyle.copyWith(
                                                              fontSize: 14,
                                                              color: Colors
                                                                  .grey[300],
                                                              shadows:
                                                                  new StrokeText()
                                                                      .shadowStrokeTextBlack)),
                                                      new Text(
                                                          '${fbiFieldOffices.fieldOffices!.first.website}',
                                                          style: regularStyle.copyWith(
                                                              fontSize: 12,
                                                              color: Colors
                                                                  .grey[300],
                                                              shadows:
                                                                  new StrokeText()
                                                                      .shadowStrokeTextBlack)),
                                                    ],
                                                  ),
                                                  onTap: () async =>
                                                      await canLaunchUrl(Uri.parse(
                                                              fbiFieldOffices
                                                                  .fieldOffices!
                                                                  .first
                                                                  .website))
                                                          ? await launchUrl(Uri
                                                              .parse(fbiFieldOffices
                                                                  .fieldOffices!
                                                                  .first
                                                                  .website))
                                                          : null,
                                                ),
                                              ]),
                                    ),
                                  ),
                                ),
                                new Expanded(
                                  child: new ListView(
                                    children: <Widget>[
                                      new ListTile(
                                        leading: Icon(Icons.theater_comedy),
                                        title: Row(
                                          children: [
                                            new Text('Dark Theme'),
                                            new Expanded(
                                                child: new Container()),
                                            new Switch(
                                                inactiveThumbColor:
                                                    Theme.of(context)
                                                        .unselectedWidgetColor,
                                                value: darkTheme,
                                                onChanged: (val) async {
                                                  setState(() {
                                                    darkTheme = val;
                                                    userDatabase.put(
                                                        'darkTheme', val);
                                                  });
                                                })
                                          ],
                                        ),
                                      ),
                                      kIsWeb
                                          ? const SizedBox.shrink()
                                          : ListTile(
                                              leading: Icon(
                                                  Icons.notification_important),
                                              title: Row(
                                                children: [
                                                  new Text('Fugitive Alerts'),
                                                  new Expanded(
                                                      child: new Container()),
                                                  new Switch(
                                                      inactiveThumbColor: Theme
                                                              .of(context)
                                                          .unselectedWidgetColor,
                                                      value: fugitiveAlerts,
                                                      onChanged: (val) async {
                                                        setState(() async {
                                                          fugitiveAlerts = val;
                                                          await userDatabase.put(
                                                              'fugitiveAlerts',
                                                              val);
                                                        });
                                                      })
                                                ],
                                              ),
                                            ),
                                      new ListTile(
                                          leading: Icon(Icons.share),
                                          title: new Text('Share This App'),
                                          trailing: kIsWeb
                                              ? Icon(Icons.copy)
                                              : SizedBox.shrink(),
                                          onTap: () async {
                                            if (kIsWeb) {
                                              Navigator.pop(context);
                                              Clipboard.setData(
                                                  const ClipboardData(
                                                      text: siteAddress));
                                              Messages.popMessage(context,
                                                  'Website link has been copied to your clipboard');
                                            } else {
                                              await Share.share(
                                                  'Check out all of these fugitives wanted by the FBI!\n'
                                                  'Visit the website at $siteAddress',
                                                  subject:
                                                      'Wanted by the FBI!');
                                            }
                                          }),
                                      !kIsWeb ||
                                              (kIsWeb &&
                                                  userDatabase.get(
                                                          'fieldOfficeLocation') ==
                                                      'headquarters')
                                          ? SizedBox.shrink()
                                          : new ListTile(
                                              leading: Icon(Icons.restore),
                                              title: new Text('Reset Location'),
                                              onTap: () async {
                                                await userDatabase.put(
                                                    'fieldOfficeLocation',
                                                    'headquarters');
                                                await userDatabase.put(
                                                    'lastFullAddress',
                                                    '935 Pennsylvania Avenue NW, Washington, DC 20535-001');
                                                await userDatabase.put(
                                                    'lastStreet',
                                                    '935 Pennsylvania Avenue NW');
                                                await userDatabase.put(
                                                    'lastLocality',
                                                    'District of Columbia');
                                                await userDatabase.put(
                                                    'lastSubAdministrativeArea',
                                                    'District of Columbia');
                                                await userDatabase.put(
                                                    'lastAdministrativeArea',
                                                    'District of Columbia');
                                                await userDatabase.put(
                                                    'lastPostalCode',
                                                    '20535-001');
                                                await userDatabase.put(
                                                    'lastIsoCountryCode', 'US');
                                                await userDatabase.put(
                                                    'lastState',
                                                    'District of Columbia');
                                                await userDatabase.put(
                                                    'lastCountry',
                                                    'United States');
                                                await userDatabase.put(
                                                    'appOpens', 0);
                                              },
                                            ),
                                    ],
                                  ),
                                ),
                                new Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: new Text(
                                        'Version: ${userDatabase.get('packageInfo')['version']}+${userDatabase.get('packageInfo')['buildNumber']}',
                                        style: regularStyle.copyWith(
                                            color: Theme.of(context)
                                                .primaryColorLight
                                                .withAlpha(100),
                                            fontSize: 9),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    appBar: new PreferredSize(
                        child: new PageHeader(),
                        preferredSize: Size.fromHeight(80)),
                    body: new Container(
                        child: new MyHomePage(
                            title: appTitle,
                            userDeviceInfo: userDeviceInfo,
                            appPackageInfo: appPackageInfo,
                            fbiFieldOffices: fbiFieldOffices)),
                  ),
                ),
              );
            });
  }
}

class PageHeader extends StatelessWidget {
  const PageHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: new Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              new GestureDetector(
                onTap: () => Scaffold.of(context).openDrawer(),
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle),
                  child: new ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: const AssetImage('assets/bg_logo.png'),
                      height: 30,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(appTitle,
                  style: googleStyle.copyWith(fontSize: 35, height: 1)),
              Text('  by FBI',
                  style: regularStyle.copyWith(
                      fontSize: 10, height: 4, fontStyle: FontStyle.italic)),
            ],
          ),
          Row(
            children: [
              kIsWeb
                  ? Row(
                      children: [
                        InkWell(
                            enableFeedback: true,
                            child: Image.asset('assets/android_badge.png',
                                height: 28),
                            onTap: () =>
                                Functions.linkLaunch(context, appLink)),
                        const SizedBox(width: 10),
                      ],
                    )
                  : SizedBox.shrink(),
              InkWell(
                  child: Container(
                      child: Icon(Icons.volunteer_activism, size: 20)),
                  onTap: () => showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return SharedWidgets.supportOptionsWidget(context);
                        },
                      )),
              const SizedBox(width: 10),
              InkWell(
                  child: Container(child: Icon(Icons.more_vert, size: 20)),
                  onTap: () => Scaffold.of(context).openDrawer()),
            ],
          ),
        ],
      ),
    );
  }
}
