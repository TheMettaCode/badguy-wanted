import 'dart:io';
import 'package:badguy/services/notifications/notification_api.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:badguy/constants/app_constants.dart';
import 'package:badguy/constants/fbi_constants.dart';
import 'package:badguy/constants/sharedWidgets.dart';
import 'package:badguy/constants/styles.dart';
import 'package:badguy/models/json/fbi/fbi_field_offices.dart';
import 'package:badguy/models/json/fbi/fbi_wanted.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:url_launcher/url_launcher.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Messages {
  static Future<void> popMessage(BuildContext context, String message,
      {Color barColor = const Color(0xffffffff),
      Color textColor = const Color(0xff000000),
      int durationInSeconds = 3}) async {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Container(
          padding: const EdgeInsets.all(10.0),
          // height: 100,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).primaryColorDark, width: 3),
              borderRadius: BorderRadius.circular(20),
              color: barColor),
          child: new Text(message,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 16, color: textColor, fontWeight: FontWeight.bold)),
        ),
      ),
      backgroundColor: Colors.transparent,
      duration: Duration(seconds: durationInSeconds),
      elevation: 0,
    ));
  }
}

class Functions {
  static Future<void> linkLaunch(BuildContext context, linkUrl) async {
    if (await canLaunchUrl(Uri.parse(linkUrl))) {
      launchUrl(Uri.parse(linkUrl));
    } else {
      Messages.popMessage(context, 'Could not launch link');
    }
  }

  static Future<void> checkAppLoyalty(BuildContext context) async {
    Box userDatabase = Hive.box<dynamic>(appDatabase);

    // REWARD FOR MULTIPLE APP OPENS
    if (userDatabase.get('appOpens') % 10 == 0) {
      debugPrint('***** 10 Android Opens Reward Here *****');
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return SharedWidgets.supportOptionsWidget(context);
        },
      );
    } else {
      debugPrint('***** No Opens Reward *****');
    }
  }

  static Future<void> initializeBox() async {
    debugPrint(
        '***** OPENING ${appDatabase.toUpperCase()} DATA BOX (Initialization...) *****');
    // Directory directory;
    if (kIsWeb) {
      debugPrint('***** Platform is running on the Web *****');
      await Hive.openBox(appDatabase);
      // var path = Directory.current.path;
      // Hive.initFlutter(Directory.current.path);
    } else if (Hive.isBoxOpen(appDatabase)) {
      debugPrint(
          '***** ${appDatabase.toUpperCase()} DATA BOX IS ALREADY OPEN *****');
    } else {
      Directory directory = await getApplicationDocumentsDirectory();
      debugPrint('***** App Directory: $directory *****');
      debugPrint('***** App Absolute Path: ${directory.absolute.path} *****');
      debugPrint('***** App Path: ${directory.path} *****');
      // await Hive.deleteBoxFromDisk(appDatabase);
      await Hive.initFlutter(directory.path);
      await Hive.openBox(appDatabase);
    }

    // Hive.registerAdapter(UserDataAdapter());

    Box userDatabase = Hive.box<dynamic>(appDatabase);

    if (Hive.isBoxOpen(appDatabase)) {
      debugPrint('***** Box is open (Initialize) *****');

      // debugPrint(
      //     '***** Initial Box Data (Initialize): ${userDatabase.toMap().toString()} *****');

      // userDatabase.clear();

      if (userDatabase.toString().isEmpty) {
        debugPrint('***** Box is empty! (Initialize) Setting... *****');
        userDatabase.putAll(initialData);
      }

      // ADD KEY IF MISSING FROM DATABASE
      initialData.keys.forEach((_key) {
        if (!userDatabase.keys.contains(_key)) {
          dynamic _value = initialData.entries
              .firstWhere((element) => element.key == _key)
              .value;
          debugPrint(
              '***** Missing DBase Key: Adding $_key : $_value to DBase *****');
          userDatabase.put(_key, _value);
        }
      });

      // DELETE KEY IF NO LONGER INCLUDED IN DATABASE
      userDatabase.keys.forEach((key) {
        if (!initialData.keys.contains(key)) {
          debugPrint('***** Unused DBase Key: Removing $key from DBase *****');
          userDatabase.delete(key);
        }
      });

      // debugPrint(
      //     '***** Final Box Data (Initialize): ${userDatabase.toMap().toString()} *****');
    } else {
      debugPrint(
          '***** Box was not opened! (Initialize) Trying again... *****');
      try {
        await Hive.openBox(appDatabase);
      } catch (e) {
        debugPrint('***** Could not open box! (Initialize) Exiting... *****');
        throw ('***** Could not open box! (Initialize) Exiting... ${e.toString()} *****');
      }
    }
  }

  static Future<Map<String, dynamic>> getDeviceInfo() async {
    Box userDatabase = Hive.box<dynamic>(appDatabase);
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    Map<String, dynamic> deviceInfo = {};

    Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
      return <String, dynamic>{
        'version.securityPatch': build.version.securityPatch,
        'version.sdkInt': build.version.sdkInt,
        'version.release': build.version.release,
        'version.previewSdkInt': build.version.previewSdkInt,
        'version.incremental': build.version.incremental,
        'version.codename': build.version.codename,
        'version.baseOS': build.version.baseOS,
        'board': build.board,
        'bootloader': build.bootloader,
        'brand': build.brand,
        'device': build.device,
        'display': build.display,
        'fingerprint': build.fingerprint,
        'hardware': build.hardware,
        'host': build.host,
        'id': build.id,
        'manufacturer': build.manufacturer,
        'model': build.model,
        'product': build.product,
        'supported32BitAbis': build.supported32BitAbis,
        'supported64BitAbis': build.supported64BitAbis,
        'supportedAbis': build.supportedAbis,
        'tags': build.tags,
        'type': build.type,
        'isPhysicalDevice': build.isPhysicalDevice,
        'androidId': build.id,
        'systemFeatures': build.systemFeatures,
      };
    }

    try {
      if (Platform.isAndroid) {
        deviceInfo = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
      }

      // debugPrint('***** Device Data: $deviceData *****');
    } on PlatformException {
      deviceInfo = <String, dynamic>{
        'Error:': 'Failed to get platform version.'
      };
    }

    // if (!mounted) return;
    userDatabase.put('deviceInfo', deviceInfo);
    return deviceInfo;
  }

  static Future<PackageInfo> getPackageInfo(BuildContext context) async {
    debugPrint('***** RETREIVING PACKAGE DATA *****');
    Box userDatabase = Hive.box<dynamic>(appDatabase);
    PackageInfo packageData;
    Map<String, dynamic> packageMap;

    try {
      // if (Platform.isAndroid) {
      final data = await PackageInfo.fromPlatform();

      packageData = data;

      debugPrint(
          '***** OLD ***** PACKAGE VERSION FROM DBASE: ${userDatabase.get('packageInfo')['version']} : ${userDatabase.get('packageInfo')['buildNumber']} *****');

      if (packageData.version.isNotEmpty) {
        packageMap = {
          'appName': packageData.appName,
          'packageName': packageData.packageName,
          'version': packageData.version,
          'buildNumber': packageData.buildNumber,
          'buildSignature': packageData.buildSignature,
        };

        debugPrint('***** PACKAGE MAP: $packageMap *****');

        if (userDatabase.get('packageInfo')['version'] == null) {
          userDatabase.put('packageInfo', packageMap);
        } else if (userDatabase.get('packageInfo')['version'] ==
            packageData.version) {
          debugPrint(
              '***** PACKAGE VERSIONS ARE A MATCH. NO ACTIONS TAKEN *****');
        } else if (userDatabase.get('packageInfo')['version'] !=
                packageData.version &&
            userDatabase.get('appOpens') > 1 &&
            userDatabase.get('appUpdates').length > 1) {
          debugPrint('***** PACKAGE DATA MISMATCH... Processing... *****');
          userDatabase.put('appUpdated', true);
          userDatabase.put('packageInfo', packageMap);
        }
        debugPrint(
            '***** NEW ***** PACKAGE VERSION FROM DBASE: ${userDatabase.get('packageInfo')['version']} : ${userDatabase.get('packageInfo')['buildNumber']} *****');
      }
    } on PlatformException {
      packageData = PackageInfo(
        appName: 'Unknown',
        packageName: 'Unknown',
        version: 'Unknown',
        buildNumber: 'Unknown',
        buildSignature: 'Unknown',
      );
    }

    return packageData;
  }

  static Future<FbiWanted> getWantedApi(
      int page, String searchField, String searchString) async {
    debugPrint(
        '***** Fetching page $page of FBI API Data using Field $searchField and String $searchString *****');

    Box<dynamic> userDatabase = Hive.box<dynamic>(appDatabase);
    var apiResponse;
    if (searchField.isEmpty ||
        searchString.isEmpty ||
        !fbiSearchFields.contains(searchField)) {
      apiResponse = await http.get(Uri.parse(fbiWantedListApi + '?page=$page'));
    } else {
      apiResponse = await http.get(Uri.parse(
          fbiWantedListApi + '?page=$page&$searchField=$searchString'));
    }

    if (apiResponse.statusCode == 200) {
      FbiWanted fbiWanted = fbiWantedFromJson(apiResponse.body);

      if (fbiWanted.total > 0) {
        FbiWantedItem latestFugitive = fbiWanted.items.first;
        debugPrint(
            '***** Latest Fugitive [Functions]: ${latestFugitive.toJson()} *****');
        String fugitiveInfo = '''
Field Office: ${latestFugitive.fieldOffices?.length == 0 ? 'No Field Office Listed' : '${latestFugitive.fieldOffices}'}
Name: ${latestFugitive.title}
Age Range: ${latestFugitive.ageRange.toString().isEmpty ? 'Age Not Listed' : '${latestFugitive.ageRange}'}
Race: ${latestFugitive.race.toString().isEmpty ? 'Race Not Listed' : '${latestFugitive.race}'}
Sex: ${latestFugitive.sex.toString().isEmpty ? 'Sex Not Listed' : '${latestFugitive.sex}'}
Weight: ${latestFugitive.weight.toString().isEmpty ? 'Weight Not Listed' : '${latestFugitive.weight}'}
Hair: ${latestFugitive.hair.toString().isEmpty ? 'Hair Not Listed' : '${latestFugitive.hair}'}

Tap notification for more information
''';

        // debugPrint(
        //     '***** Last Fugitive (DBase): ${userDatabase.get('latestFugitive')} *****');
        // debugPrint('***** Latest Fugitive Info:\n$fugitiveInfo *****');

        if (userDatabase.get('fugitiveAlerts') == true &&
            page == 1 &&
            searchString.isEmpty &&
            searchField.isEmpty &&
            userDatabase.get('latestFugitive').toLowerCase() !=
                latestFugitive.title?.toLowerCase()) {
          debugPrint(
              '***** New Fugitive Update: ${latestFugitive.title} *****');
          await NotificationApi.showBigTextNotification(
              0,
              'latestFugitive',
              'Latest Fugitive',
              'Latest Updated Fugitive',
              'Fugitive Update',
              '[WANTED!] ${latestFugitive.title}',
              fugitiveInfo,
              latestFugitive.title.toString().toLowerCase());

          await userDatabase.put(
              'latestFugitive', latestFugitive.title?.toLowerCase());
        }

        return fbiWanted;
      } else {
        return fbiWanted;
      }
    } else {
      throw Exception(
          '***** Failed to load FBI Data: ${apiResponse.statusCode} *****');
    }
  }

  static Future<List<FbiWantedItem>> getLocalizedList(
      List<FbiWantedItem> allFugitives, List<String> searchItems) async {
    late List<FbiWantedItem> localizedList = [];

    allFugitives.forEach((fugitive) {
      searchItems.forEach((item) {
        if (fugitive.description!.toLowerCase().contains(item) ||
            fugitive.title!.toLowerCase().contains(item) ||
            fugitive.warningMessage!.toLowerCase().contains(item) ||
            fugitive.caution!.toLowerCase().contains(item) ||
            fugitive.fieldOffices!.any((office) => office.contains(item))) {
          if (!localizedList.contains(fugitive)) localizedList.add(fugitive);
        }
      });
    });

    if (localizedList.length > 0) {
      localizedList.sort((a, b) => b.publication!.compareTo(a.publication!));
    }
    return localizedList;
  }

  static Future<Position> getPosition() async {
    debugPrint('***** DETRMINING POSITION... *****');

    /// Determine the current position of the device.
    ///
    /// When the location services are not enabled or permissions
    /// are denied the `Future` will return an error.

    Box<dynamic> userDatabase = Hive.box<dynamic>(appDatabase);
    bool serviceEnabled;
    LocationPermission permission;
    Position _currentPositionData;
    // Position? _lastKnownPositionData;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled don't continue
        // accessing the position and request users of the
        // App to enable the location services.

        return Future.error(
          Builder(
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Location Service Not Enabled'),
                content: Text(
                    'Could not enable location services. If the issue persists, reinstalling the app may fix the problem.'),
                actions: <Widget>[
                  new TextButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close),
                      label: Text('Close')),
                  // new ElevatedButton.icon(
                  //     onPressed: () {},
                  //     icon: Icon(Icons.replay),
                  //     label: Text('Try Again'))
                ],
              );
            },
          ),
        );
      }
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error(Builder(
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Location Permissions Denied'),
              content: Text(
                  'Location permissions are permanently denied, we cannot request permissions. If the issue persists, reinstalling the app may fix the problem.'),
              actions: <Widget>[
                new TextButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.close),
                    label: Text('Close')),
                // new ElevatedButton.icon(
                //     onPressed: () {},
                //     icon: Icon(Icons.replay),
                //     label: Text('Try Again'))
              ],
            );
          },
        ));
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(Builder(
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Location Permissions Denied'),
            content: Text(
                'Location permissions are permanently denied, we cannot request permissions. If the issue persists, reinstalling the app may fix the problem.'),
            actions: <Widget>[
              new TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.close),
                  label: Text('Close')),
            ],
          );
        },
      ));
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    _currentPositionData = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);

    debugPrint('***** CURRENT POSITION DATA: $_currentPositionData');

    // if (!kIsWeb)
    //   _lastKnownPositionData = await Geolocator.getLastKnownPosition();

    // StreamSubscription<Position> positionStream =
    //     Geolocator.getPositionStream(locationOptions)
    //         .listen((Position position) {
    //   debugPrint(position == null
    //       ? 'Unknown'
    //       : position.latitude.toString() +
    //           ', ' +
    //           position.longitude.toString());
    // });

    // // To listen for service status changes you can call the getServiceStatusStream.
    // // This will return a Stream<ServiceStatus> which can be listened to, to receive location service status updates.
    // StreamSubscription<ServiceStatus> serviceStatusStream =
    //     Geolocator.getServiceStatusStream().listen((ServiceStatus status) {
    //   debugPrint(status);
    // });

    final String data = '''{
        "latitude": "${_currentPositionData.latitude}",
        "longitude": "${_currentPositionData.longitude}",
        "speed": "${_currentPositionData.speed}",
        "speedAcuracy": "${_currentPositionData.speedAccuracy}",
        "timestamp": "${_currentPositionData.timestamp}",
        "isMock": "${_currentPositionData.isMocked}",
        "heading": "${_currentPositionData.heading}",
        "accuracy": "${_currentPositionData.accuracy}",
        "altitude": "${_currentPositionData.altitude}",
        "floor": "${_currentPositionData.floor}"
      }''';

    userDatabase.put('lastLocationData', data);

    // // GeoLocator Functions
    // // Get Coordinates from Street Address
    // List<Location> locations =
    //     await locationFromAddress("Gronausestraat 710, Enschede");

    if (kIsWeb && userDatabase.get('appOpens') == 0) {
      debugPrint('***** FIRST OPEN *****');
      debugPrint('***** Platform is Web (Position Function) *****');
      await userDatabase.put('lastFullAddress',
          '935 Pennsylvania Avenue NW, Washington, DC 20535-001');
      await userDatabase.put('lastStreet', '935 Pennsylvania Avenue NW');
      await userDatabase.put('lastLocality', 'District of Columbia');
      await userDatabase.put('lastCity', 'District of Columbia');
      await userDatabase.put(
          'lastSubAdministrativeArea', 'District of Columbia');
      await userDatabase.put('lastAdministrativeArea', 'District of Columbia');
      await userDatabase.put('lastPostalCode', '20535');
      await userDatabase.put('lastIsoCountryCode', 'US');
      await userDatabase.put('lastState', 'District of Columbia');
      await userDatabase.put('lastStateCode', 'DC');
      await userDatabase.put('lastCountry', 'United States');
    } else if (!kIsWeb) {
      debugPrint('***** Determining Placemark Address *****');
      List<Placemark> placemarks = [];
      placemarks = await placemarkFromCoordinates(
          _currentPositionData.latitude, _currentPositionData.longitude);
      debugPrint('***** 1st Placemark: ${placemarks.first.locality} *****');
      if (placemarks.length > 0) {
        debugPrint('***** Determining Full Address *****');
        final String lastFullAddress =
            '${placemarks.first.street} ${placemarks.first.locality} ${placemarks.first.subAdministrativeArea} ${placemarks.first.administrativeArea} ${placemarks.first.postalCode} ${placemarks.first.isoCountryCode}';
        debugPrint('***** Placemark Address: $lastFullAddress *****');
        userDatabase.put('lastFullAddress', lastFullAddress);
        userDatabase.put('lastStreet', placemarks.first.street);
        userDatabase.put('lastLocality', placemarks.first.locality);
        userDatabase.put('lastCity', placemarks.first.locality);
        userDatabase.put('lastSubAdministrativeArea',
            placemarks.first.subAdministrativeArea);
        userDatabase.put(
            'lastAdministrativeArea', placemarks.first.administrativeArea);
        userDatabase.put('lastState', placemarks.first.administrativeArea);
        userDatabase.put('lastPostalCode', placemarks.first.postalCode);
        userDatabase.put('lastIsoCountryCode', placemarks.first.isoCountryCode);
        userDatabase.put('userLocalized', true);
      } else {
        debugPrint('***** Full Address Not Determined *****');
      }
    }

    return _currentPositionData;
  }

  static Future<void> askForAddress(
      BuildContext context, FbiFieldOffices fbiFieldOffices) async {
    Box userDatabase = Hive.box<dynamic>(appDatabase);
    List<String> fieldOfficesList =
        fbiFieldOffices.fieldOffices!.map((e) => e.city).toList();
    fieldOfficesList.sort();
    String myFieldOffice = "";

    showModalBottomSheet(
        enableDrag: true,
        context: context,
        builder: (context) {
          return ValueListenableBuilder(
              valueListenable: Hive.box(appDatabase)
                  .listenable(keys: ['fieldOfficeLocation']),
              builder: (context, box, widget) {
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                title: Text('Where Are You?',
                                    style: googleBangersHeader),
                                subtitle: Text(
                                    'Personalize your experience by giving us a general location. Choose the field office closest to you.'),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  children: [
                                    new DropdownButton<String>(
                                      value: "Choose Office",
                                      iconSize:
                                          Theme.of(context).iconTheme.size!,
                                      elevation: 0,
                                      style:
                                          regularStyle.copyWith(fontSize: 13),
                                      underline: Container(
                                        height: 0,
                                      ),
                                      onChanged: (String? val) {
                                        if (val != 'Choose Office') {
                                          myFieldOffice = fbiFieldOffices
                                              .fieldOffices!
                                              .firstWhere((element) =>
                                                  element.city == val)
                                              .office;
                                          userDatabase.put(
                                              'fieldOfficeLocation',
                                              myFieldOffice);
                                          debugPrint(
                                              '***** My Field Office: $myFieldOffice *****');
                                        }
                                      },
                                      items: (<String>["Choose Office"] +
                                              fieldOfficesList)
                                          .map<DropdownMenuItem<String>>(
                                              (String value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value,
                                              style: TextStyle(
                                                  color: Theme.of(context)
                                                      .primaryColorLight)),
                                        );
                                      }).toList(),
                                    ),
                                    SizedBox(width: 20),
                                    Text(
                                        '${fbiFieldOffices.fieldOffices!.firstWhere((element) => element.office == userDatabase.get('fieldOfficeLocation')).city}, ${fbiFieldOffices.fieldOffices!.firstWhere((element) => element.office == userDatabase.get('fieldOfficeLocation')).stateCode}',
                                        style:
                                            googleStyle.copyWith(fontSize: 20))
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 5, right: 5, bottom: 5),
                        child: SizedBox(
                          height: 25,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              OutlinedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    await userDatabase.put(
                                        'fieldOfficeLocation', 'headquarters');
                                  },
                                  child: Text('Later')),
                              SizedBox(width: 10),
                              ElevatedButton(
                                  onPressed: () async {
                                    Navigator.pop(context);
                                    FieldOffice _office = fbiFieldOffices
                                        .fieldOffices!
                                        .firstWhere((element) =>
                                            element.office ==
                                            userDatabase
                                                .get('fieldOfficeLocation'));
                                    await userDatabase.put('lastFullAddress',
                                        '${_office.address}, ${_office.city}, ${_office.state}, ${_office.postalCode}');
                                    await userDatabase.put(
                                        'lastStreet', _office.address);
                                    await userDatabase.put(
                                        'lastCity', _office.city);
                                    await userDatabase.put(
                                        'lastAdministrativeArea',
                                        _office.state);
                                    await userDatabase.put(
                                        'lastPostalCode', _office.postalCode);
                                    await userDatabase.put(
                                        'lastIsoCountryCode', 'US');
                                    await userDatabase.put(
                                        'lastState', _office.state);
                                    await userDatabase.put(
                                        'userLocalized', true);
                                  },
                                  child: Text('Done'))
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              });
        });
  }
}
