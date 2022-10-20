import 'dart:async';
import 'dart:math';
import 'package:badguy/constants/sharedWidgets.dart';
import 'package:badguy/factory/sharedFunctions.dart';
import 'package:badguy/models/json/fbi/fbi_field_offices.dart';
import 'package:badguy/services/admob/ad_library.dart';
import 'package:badguy/services/notifications/notification_api.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:geocoding/geocoding.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'constants/app_constants.dart';
import 'constants/fbi_constants.dart';
import 'constants/styles.dart';
import 'models/json/fbi/fbi_wanted.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key? key,
    required this.title,
    required this.userDeviceInfo,
    required this.appPackageInfo,
    required this.fbiFieldOffices,
  }) : super(key: key);

  final String title;
  final Map<String, dynamic> userDeviceInfo;
  final PackageInfo appPackageInfo;
  final FbiFieldOffices fbiFieldOffices;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<dynamic> userDatabase = Hive.box<dynamic>(appDatabase);
  bool loading = true;
  bool pageLoading = false;

  late Map<String, dynamic> userDeviceInfo;
  late PackageInfo appPackageInfo;
  late bool appUpdated = false;

  late LocationData userLocationData;
  late List<FieldOffice> _userFieldOffices;
  late Placemark userAddressInfo;
  late String userCountry;
  late String userCountryCode;
  late String userRegion;
  late String userState = '';
  late String userCity;

  late List<String> localizationOptions;
  bool isLocalized = false;

  late FbiFieldOffices fbiFieldOffices = FbiFieldOffices.fromJson(fieldOffices);
  late List<FieldOffice> userFieldOffices;
  FbiWanted fbiWantedData = FbiWanted.fromJson(initialFbiWantedJson);
  late List<FbiWantedItem> fbiWantedDataList = fbiWantedData.items;
  late List<FbiWantedItem> rewardList = fbiWantedData.items;
  late List<FbiWantedItem> localizedList = fbiWantedData.items;
  late FbiWantedItem _randomFugitive = fbiWantedData.items.first;

  int nextPage = 1;
  bool noMorePages = false;
  String initSearchField = '';
  String initSearchString = '';
  String searchString = '';
  String displayString = '';
  String searchField = 'choose';
  bool searching = false;

  late Timer everyMinute;
  late Timer everyThreeMinutes;

  ScrollController scrollController = new ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool bannerLoaded = false;
  Container bannerAdContainer = Container();

  @override
  void initState() {
    // debugPrint('***** INITIALIZING FBI FUGITIVE APP *****');
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _init();
    });
    // debugPrint('***** INITIALIZATION COMPLETE! *****');
    setState(() => loading = false);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void clearSearch() async {
    setState(() {
      searching = false;
      searchString = '';
      displayString = '';
      searchField = 'choose';
      nextPage = 1;
      noMorePages = false;
      isLocalized = false;
      animatedHeight = 33;
    });
    await getFugitives(nextPage, searchField, searchString);
  }

  Future<void> _init() async {
    debugPrint('***** INITIALIZING FBI FUGITIVE APP *****');

    // Future.delayed(Duration(seconds: 30), () async {
    //   // Do something
    //   if (!kIsWeb && ModalRoute.of(context)!.isCurrent) {
    //     await AdMobLibrary().defaultInterstitial();
    //   }
    // });

    // defines a timer
    everyMinute = Timer.periodic(Duration(minutes: 1), (Timer timer) {
      int _randomInt = Random().nextInt(fbiWantedDataList.length);
      setState(() => _randomFugitive = fbiWantedDataList[_randomInt]);
    });

    // everyThreeMinutes = Timer.periodic(Duration(minutes: 3), (Timer timer) {
    // showRewardAdPopUp(context, 'Avertisements will go here', 30, 'Action',
    //     null);
    // });

    setState(() {
      userDeviceInfo = widget.userDeviceInfo;
      appPackageInfo = widget.appPackageInfo;
      fbiFieldOffices = widget.fbiFieldOffices;
    });

    if (kIsWeb &&
        (userDatabase.get('appOpens') <= 1 ||
            (userDatabase.get('fieldOfficeLocation') == 'headquarters' &&
                userDatabase.get('appOpens') % 7 == 0)))
      await Functions.askForAddress(context, fbiFieldOffices);

    _userFieldOffices = widget.fbiFieldOffices.fieldOffices!
        .where((office) =>
            office.state.toLowerCase() ==
            userDatabase.get('lastState').toLowerCase())
        .toList();

    String _fieldOffices = _userFieldOffices
        .map((e) => e.office)
        .toString()
        .replaceAll('(', '')
        .replaceAll(')', '')
        .replaceAll(' ', '');

    setState(() {
      userCountry = userDatabase.get('lastCountry');
      userCountryCode = userDatabase.get('lastCountryCode');
      userState = userDatabase.get('lastState');
      userCity = userDatabase.get('lastLocality');
      localizationOptions = [
        // userDatabase.get('lastAdministrativeArea').toLowerCase().trim(),
        // userDatabase.get('lastSubAdministrativeArea').toLowerCase().trim(),
        userDatabase.get('lastCity').toLowerCase().trim(),
        userDatabase.get('lastState').toLowerCase().trim(),
        _fieldOffices.toLowerCase().trim()
      ];
    });

    await getFugitives(nextPage, searchField, searchString).whenComplete(
      () => setState(
        // () => _randomFugitive = fbiWantedDataList.first,
        () => _randomFugitive =
            fbiWantedDataList[Random().nextInt(fbiWantedDataList.length)],
      ),
    );

    listenNotifications();

    await Functions.checkAppLoyalty(context);

    if (userDatabase.get('appUpdated') == true)
      showModalBottomSheet(
          backgroundColor: Colors.transparent,
          context: context,
          builder: (context) {
            return SharedWidgets.appUpdates(context);
          }).whenComplete(() => userDatabase.put('appUpdated', false));

    debugPrint('***** INITIALIZATION COMPLETE! *****');
  }

  void listenNotifications() =>
      NotificationApi.onNotifications.stream.listen(onClickedNotification);

  void onClickedNotification(String payload) {
    debugPrint(
        '***** Notification Click [Home Page] - Payload: $payload *****');
    // FbiWanted _wanted = fbiWantedFromJson(payload);
    FbiWantedItem _alertFugitive = fbiWantedDataList.firstWhere(
        (fugitive) => fugitive.title.toString().toLowerCase() == payload);
    // debugPrint(
    //     '***** Alert Fugitive (Home Page Listener): ${_alertFugitive[0]} *****');

    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      isScrollControlled: true,
      enableDrag: true,
      context: context,
      builder: (context) => showDetails(_alertFugitive),
    );
  }

  Future<void> getFugitives(
      int page, String searchField, String searchString) async {
    setState(() => pageLoading = true);
    if (page > 1) {
      if (fbiWantedData.total > fbiWantedDataList.length) {
        await Functions.getWantedApi(page, searchField, searchString)
            .then((value) {
          value.items.forEach((fugitive) => fbiWantedDataList.add(fugitive));
        }).whenComplete(() => refreshRandomFugitive());
      } else {
        debugPrint('***** There are no more pages to load! *****');
        setState(() => noMorePages = true);
      }
    } else {
      await Functions.getWantedApi(page, searchField, searchString).then(
        (value) async {
          if (value.items.length > 0) {
            setState(() {
              fbiWantedData = value;
              fbiWantedDataList = value.items;
            });
            if (searchField.isNotEmpty) refreshRandomFugitive();
          } else {
            Messages.popMessage(context, 'No fugitives located');
          }
        },
      );
    }

    if (fbiWantedData.total <= fbiWantedDataList.length) {
      setState(() => noMorePages = true);
    }

    setState(() => rewardList = fbiWantedDataList
        .where((element) =>
            element.rewardText!.isNotEmpty && element.rewardText != null)
        .toList());

    setState(() => localizedList = []);
    await Functions.getLocalizedList(fbiWantedDataList, localizationOptions)
        .then((value) {
      if (value.length > 0) {
        setState(() {
          localizedList = value;
          isLocalized = true;
        });
      }
    });

    setState(() {
      pageLoading = false;
      nextPage += 1;
    });
  }

  Future<void> refreshRandomFugitive() async {
    setState(() => pageLoading = true);
    setState(() => _randomFugitive =
        fbiWantedDataList[Random().nextInt(fbiWantedDataList.length)]);
    setState(() => pageLoading = false);
  }

  double animatedHeight = 33;
  Duration animatedDuration = Duration(milliseconds: 100);

  @override
  Widget build(BuildContext context) {
    debugPrint('***** User City: ${userDatabase.get('lastCity')} *****');
    debugPrint('***** User City: ${userDatabase.get('lastState')} *****');

    if (!kIsWeb) {
      // ADMOB INFORMATION HERE
      if (!bannerLoaded) {
        BannerAd thisBanner = AdMobLibrary().defaultBanner();
        thisBanner.load();

        bannerAdContainer = AdMobLibrary().bannerContainer(thisBanner, context);

        // debugPrint('***** Ad Loaded: ${thisBanner.adUnitId} *****');
        setState(() => bannerLoaded = true);
      }
    }

    List<FbiWantedItem> finalFugitiveList = [];
    List<String> fieldOfficesList =
        fbiFieldOffices.fieldOffices!.map((e) => e.city).toList();
    fieldOfficesList.sort();
    // debugPrint('***** FIELD OFFICES (HOME): $fieldOfficesList *****');

    if (!fbiSearchFields.contains(searchField) || searchString.isEmpty) {
      finalFugitiveList = fbiWantedDataList;
    } else {
      switch (searchField) {
        case "title":
          finalFugitiveList = fbiWantedDataList
              .where((element) => element.title! == searchString)
              .toList();
          break;
        // case "uid":
        //   finalFugitiveList = fbiWantedDataList
        //       .where((element) => element.uid! == searchString)
        //       .toList();
        //   break;
        case "hair":
          finalFugitiveList = fbiWantedDataList
              .where((element) => element.hair! == searchString)
              .toList();
          break;
        // case "status":
        //   finalFugitiveList = fbiWantedDataList
        //       .where((element) => element.status! == searchString)
        //       .toList();
        //   break;
        case "eyes":
          finalFugitiveList = fbiWantedDataList
              .where((element) => element.eyes! == searchString)
              .toList();
          break;
        case "race":
          finalFugitiveList = fbiWantedDataList
              .where((element) => element.race! == searchString)
              .toList();
          break;
        case "field_offices":
          finalFugitiveList = fbiWantedDataList
              .where((element) => element.fieldOffices!.contains(searchString))
              .toList();
          break;
        default:
          finalFugitiveList = fbiWantedDataList;
      }
    }

    return loading || fbiWantedData.total < 0
        ? Center(
            child: Center(
                child: new CircularProgressIndicator(
            backgroundColor: Theme.of(context).highlightColor,
          )))
        : OrientationBuilder(builder: (context, orientation) {
            return new SafeArea(
              // top: true,
              // maintainBottomViewPadding: true,
              child: new RefreshIndicator(
                onRefresh: refreshRandomFugitive,
                child: new Scaffold(
                  body: new Container(
                    color: Theme.of(context).primaryColorDark,
                    alignment: Alignment.topCenter,
                    child: new Stack(
                      alignment: Alignment.topRight,
                      children: [
                        new AppBackground(randomFugitive: _randomFugitive),
                        new Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                          child: new Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                new Card(
                                    elevation: 0,
                                    color: Colors.transparent,
                                    child: new Column(
                                      children: <Widget>[
                                        new SizedBox(height: 5),
                                        new InkWell(
                                          onTap: () => showModalBottomSheet(
                                            backgroundColor: Colors.transparent,
                                            constraints: BoxConstraints(
                                              maxHeight: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.75,
                                              maxWidth: orientation ==
                                                      Orientation.landscape
                                                  ? MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.5
                                                  : MediaQuery.of(context)
                                                      .size
                                                      .width,
                                            ),
                                            isScrollControlled: true,
                                            enableDrag: true,
                                            context: context,
                                            builder: (context) =>
                                                showDetails(_randomFugitive),
                                          ),
                                          // onTap: () => showDialog(
                                          //   context: context,
                                          //   builder: (context) =>
                                          //       showDetails(_randomFugitive),
                                          // ),
                                          child: new Stack(
                                            alignment: Alignment.bottomRight,
                                            children: [
                                              new Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  new Container(
                                                    alignment: Alignment.center,
                                                    height: 130,
                                                    width: 90,
                                                    decoration: BoxDecoration(
                                                      boxShadow: boxShadow,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              3),
                                                      color: Colors.transparent,
                                                      image: DecorationImage(
                                                          image:
                                                              new NetworkImage(
                                                                  _randomFugitive
                                                                      .images
                                                                      .first
                                                                      .large!),
                                                          fit:
                                                              BoxFit.fitHeight),
                                                    ),
                                                    child: Container(
                                                      height: 130,
                                                      width: 90,
                                                      child: new FadeInImage(
                                                        placeholder: AssetImage(
                                                            'assets/no_photo.png'),
                                                        image: NetworkImage(
                                                            _randomFugitive
                                                                .images
                                                                .first
                                                                .large!),
                                                        fit: BoxFit.fitHeight,
                                                        imageErrorBuilder:
                                                            (context, object,
                                                                stacktrace) {
                                                          return Image(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            colorBlendMode:
                                                                BlendMode.color,
                                                            image: AssetImage(
                                                                'assets/no_photo.png'),
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  new Expanded(
                                                    flex: 4,
                                                    child: new Container(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          20, 0, 10, 0),
                                                      child: new Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    bottom:
                                                                        5.0),
                                                            child: new Text(
                                                                _randomFugitive
                                                                    .title!,
                                                                style: googleStyle.copyWith(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .highlightColor,
                                                                    shadows:
                                                                        StrokeText()
                                                                            .shadowStrokeTextBlack,
                                                                    fontSize:
                                                                        25)),
                                                          ),
                                                          new Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                _randomFugitive
                                                                            .status!
                                                                            .isEmpty ||
                                                                        _randomFugitive.status! ==
                                                                            'na'
                                                                    ? new SizedBox
                                                                        .shrink()
                                                                    : new Text(
                                                                        'Status: ${_randomFugitive.status!.toUpperCase()}',
                                                                        style: regularStyle.copyWith(
                                                                            fontWeight:
                                                                                FontWeight.bold)),
                                                                _randomFugitive
                                                                        .warningMessage!
                                                                        .isNotEmpty
                                                                    ? new Text(
                                                                        _randomFugitive
                                                                            .warningMessage!,
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: regularStyle.copyWith(
                                                                            color:
                                                                                Theme.of(context).highlightColor,
                                                                            fontWeight: FontWeight.bold),
                                                                      )
                                                                    : new Text(
                                                                        _randomFugitive
                                                                            .description!,
                                                                        style: regularStyle.copyWith(
                                                                            fontSize:
                                                                                14,
                                                                            fontWeight:
                                                                                FontWeight.normal),
                                                                        maxLines:
                                                                            3,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                              ]),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              new Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  _randomFugitive.status!
                                                          .toLowerCase()
                                                          .contains('located')
                                                      ? new Text('📍 ',
                                                          style: regularStyle.copyWith(
                                                              fontSize: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor,
                                                              shadows: StrokeText()
                                                                  .shadowStrokeTextBlack))
                                                      : new SizedBox.shrink(),
                                                  _randomFugitive.status!
                                                              .toLowerCase()
                                                              .contains(
                                                                  'captured') ||
                                                          _randomFugitive
                                                              .status!
                                                              .toLowerCase()
                                                              .contains(
                                                                  'arrested')
                                                      ? new Text('👮 ',
                                                          style: regularStyle.copyWith(
                                                              fontSize: 20,
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor,
                                                              shadows: StrokeText()
                                                                  .shadowStrokeTextBlack))
                                                      : new SizedBox.shrink(),
                                                  _randomFugitive
                                                          .caution!.isNotEmpty
                                                      ? new Text('! ',
                                                          style: googleStyle.copyWith(
                                                              fontSize: 35,
                                                              color: Theme.of(
                                                                      context)
                                                                  .highlightColor,
                                                              shadows: StrokeText()
                                                                  .shadowStrokeTextBlack))
                                                      : new SizedBox.shrink(),
                                                  rewardList.contains(
                                                          _randomFugitive)
                                                      ? new Text('\$ ',
                                                          style: googleStyle.copyWith(
                                                              fontSize: 35,
                                                              color:
                                                                  Colors.green,
                                                              shadows: StrokeText()
                                                                  .shadowStrokeTextBlack))
                                                      : new SizedBox.shrink(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        new Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: new AnimatedContainer(
                                            duration: animatedDuration,
                                            decoration: BoxDecoration(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .secondary
                                                    .withOpacity(0.65),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            height: animatedHeight,
                                            child: new Column(
                                              children: [
                                                SizedBox(
                                                  height: Theme.of(context)
                                                          .iconTheme
                                                          .size! +
                                                      15,
                                                  child: new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceAround,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      new TextButton.icon(
                                                          onPressed: null,
                                                          icon: Icon(
                                                              Icons.group,
                                                              size: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .size!),
                                                          label: Text(
                                                              fbiWantedData
                                                                  .total
                                                                  .toString())),
                                                      new TextButton.icon(
                                                          onPressed: null,
                                                          icon: Icon(
                                                              Icons.dashboard,
                                                              size: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .size!),
                                                          label: Text(
                                                              finalFugitiveList
                                                                  .length
                                                                  .toString())),
                                                      new TextButton.icon(
                                                          onPressed: null,
                                                          icon: Icon(
                                                              Icons.article,
                                                              size: Theme.of(
                                                                      context)
                                                                  .iconTheme
                                                                  .size!),
                                                          label: Text(
                                                              '${nextPage - 1}')),
                                                      new Expanded(
                                                          child: new Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          new IconButton(
                                                            iconSize: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .size!,
                                                            onPressed: searching
                                                                ? null
                                                                : () {
                                                                    setState(() =>
                                                                        searching =
                                                                            true);
                                                                    setState(() =>
                                                                        animatedHeight =
                                                                            animatedHeight *
                                                                                2);
                                                                  },
                                                            icon: Icon(
                                                                Icons.search),
                                                            // label: Text(''),
                                                          ),
                                                        ],
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                searching
                                                    ? new Form(
                                                        key: _formKey,
                                                        child: new SizedBox(
                                                          height:
                                                              Theme.of(context)
                                                                      .iconTheme
                                                                      .size! +
                                                                  10,
                                                          child: new Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            children: <Widget>[
                                                              Padding(
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      horizontal:
                                                                          10),
                                                                  child:
                                                                      new DropdownButton<
                                                                          String>(
                                                                    value:
                                                                        searchField,
                                                                    iconSize: Theme.of(
                                                                            context)
                                                                        .iconTheme
                                                                        .size!,
                                                                    elevation:
                                                                        0,
                                                                    style: regularStyle.copyWith(
                                                                        fontSize:
                                                                            13),
                                                                    underline:
                                                                        Container(
                                                                      height: 0,
                                                                    ),
                                                                    onChanged:
                                                                        (String?
                                                                            newValue) {
                                                                      setState(
                                                                        () {
                                                                          searchField =
                                                                              newValue!;
                                                                          displayString =
                                                                              '';
                                                                          // debugPrint(
                                                                          //     '***** Search Field: $searchField *****');
                                                                        },
                                                                      );
                                                                    },
                                                                    items: (<String>[
                                                                              "choose"
                                                                            ] +
                                                                            fbiSearchFields)
                                                                        .map<
                                                                            DropdownMenuItem<
                                                                                String>>((String
                                                                            value) {
                                                                      String realValue = value ==
                                                                              'choose'
                                                                          ? 'Choose Field'
                                                                          : value == 'title'
                                                                              ? 'Name'
                                                                              : value == 'hair'
                                                                                  ? 'Hair Color'
                                                                                  : value == 'eyes'
                                                                                      ? 'Eye Color'
                                                                                      : value == 'race'
                                                                                          ? 'Race'
                                                                                          : value == 'field_offices'
                                                                                              ? 'Field Office'
                                                                                              : '';
                                                                      return DropdownMenuItem<
                                                                          String>(
                                                                        value:
                                                                            value,
                                                                        child: Text(
                                                                            realValue,
                                                                            style:
                                                                                TextStyle(color: Theme.of(context).primaryColorLight)),
                                                                      );
                                                                    }).toList(),
                                                                  )),
                                                              new Expanded(
                                                                child:
                                                                    new Container(
                                                                  child: searchField ==
                                                                          'field_offices'
                                                                      ? new DropdownButton<
                                                                          String>(
                                                                          value: displayString.isEmpty
                                                                              ? "Choose Office"
                                                                              : displayString,
                                                                          iconSize: Theme.of(context)
                                                                              .iconTheme
                                                                              .size!,
                                                                          elevation:
                                                                              0,
                                                                          style:
                                                                              regularStyle.copyWith(fontSize: 13),
                                                                          underline:
                                                                              Container(
                                                                            height:
                                                                                0,
                                                                          ),
                                                                          onChanged:
                                                                              (String? newValue) {
                                                                            searchString =
                                                                                newValue!;
                                                                            // debugPrint(
                                                                            //     '***** Search String: $searchString *****');
                                                                            setState(
                                                                              () {
                                                                                searchString = ''; // This setState seems to be needed for search results to show in the gridview
                                                                                displayString = newValue;
                                                                                // debugPrint('***** Display String: $displayString *****');
                                                                                nextPage = 1;
                                                                                noMorePages = false;
                                                                                isLocalized = false;
                                                                              },
                                                                            );
                                                                            getFugitives(
                                                                                nextPage,
                                                                                searchField,
                                                                                displayString.replaceAll(' ', '').replaceAll('.', '').trim().toLowerCase());
                                                                          },
                                                                          items: (<String>[
                                                                                    "Choose Office"
                                                                                  ] +
                                                                                  fieldOfficesList)
                                                                              .map<DropdownMenuItem<String>>((String value) {
                                                                            return DropdownMenuItem<String>(
                                                                              value: value,
                                                                              child: Text(value, style: TextStyle(color: Theme.of(context).primaryColorLight)),
                                                                            );
                                                                          }).toList(),
                                                                        )
                                                                      : searchField ==
                                                                              'choose'
                                                                          ? new SizedBox
                                                                              .shrink()
                                                                          : new TextFormField(
                                                                              autovalidateMode: AutovalidateMode.always,
                                                                              maxLines: 1,
                                                                              autocorrect: true,
                                                                              enableSuggestions: true,
                                                                              decoration: InputDecoration(isCollapsed: true, border: InputBorder.none, hintText: 'Enter Text', hintStyle: regularStyle.copyWith(fontSize: 13)),
                                                                              onChanged: (val) {
                                                                                searchString = val.trim().toLowerCase();
                                                                                // displayString = val.trim().toLowerCase();
                                                                                setState(() => displayString = val);
                                                                                // debugPrint('***** Search String: $searchString *****');
                                                                                // debugPrint('***** Display String: $displayString *****');
                                                                              },
                                                                            ),
                                                                ),
                                                              ),
                                                              displayString
                                                                          .isEmpty ||
                                                                      searchField ==
                                                                          'field_offices'
                                                                  ? new SizedBox
                                                                      .shrink()
                                                                  : new SizedBox(
                                                                      width: Theme.of(context)
                                                                              .iconTheme
                                                                              .size! +
                                                                          10,
                                                                      child:
                                                                          new IconButton(
                                                                        icon: Icon(
                                                                            Icons.send),
                                                                        iconSize:
                                                                            Theme.of(context).iconTheme.size! -
                                                                                3,
                                                                        onPressed: pageLoading ||
                                                                                displayString.isEmpty
                                                                            ? null
                                                                            : () {
                                                                                // debugPrint('***** Search Field: $searchField *****');
                                                                                // debugPrint('***** Search String: $searchString *****');
                                                                                if (_formKey.currentState!.validate() && displayString.isNotEmpty) {
                                                                                  setState(() {
                                                                                    searchString = ''; // This setState seems to be needed for search results to show in the gridview
                                                                                    nextPage = 1;
                                                                                    noMorePages = false;
                                                                                    isLocalized = false;
                                                                                  });
                                                                                  getFugitives(nextPage, searchField, displayString);

                                                                                  FocusManager.instance.primaryFocus?.unfocus();
                                                                                } else {
                                                                                  // debugPrint('***** No Search String Entered');
                                                                                }
                                                                              },
                                                                      ),
                                                                    ),
                                                              new SizedBox(
                                                                child:
                                                                    new IconButton(
                                                                  iconSize: Theme.of(
                                                                          context)
                                                                      .iconTheme
                                                                      .size!,
                                                                  onPressed: () =>
                                                                      clearSearch(),
                                                                  icon: Icon(Icons
                                                                      .cancel),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : new SizedBox.shrink()
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                                new Expanded(
                                  child: new ListView(
                                      physics: BouncingScrollPhysics(),
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      primary: false,
                                      children: <Widget>[
                                        new GridView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          scrollDirection: Axis.vertical,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            childAspectRatio: 0.75,
                                            crossAxisCount: 5,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                          ),
                                          itemCount: finalFugitiveList.length,
                                          itemBuilder: (context, index) {
                                            final FbiWantedItem _thisFugitive =
                                                finalFugitiveList[index];
                                            return new GestureDetector(
                                              // onTap: () => showDialog(
                                              //   context: context,
                                              //   builder: (context) =>
                                              //       showDetails(_thisFugitive),
                                              // ),
                                              onTap: () => showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                constraints: BoxConstraints(
                                                  maxHeight:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height *
                                                          0.75,
                                                  maxWidth: orientation ==
                                                          Orientation.landscape
                                                      ? MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.5
                                                      : MediaQuery.of(context)
                                                          .size
                                                          .width,
                                                ),
                                                isScrollControlled: true,
                                                enableDrag: true,
                                                context: context,
                                                builder: (context) =>
                                                    showDetails(_thisFugitive),
                                              ),
                                              child: new Stack(
                                                alignment:
                                                    Alignment.bottomRight,
                                                children: [
                                                  new GridTile(
                                                    footer: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 3,
                                                              bottom: 3),
                                                      child: new Row(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: <Widget>[
                                                          _randomFugitive
                                                                  .status!
                                                                  .toLowerCase()
                                                                  .contains(
                                                                      'located')
                                                              ? new Text('📍 ',
                                                                  style: regularStyle.copyWith(
                                                                      fontSize:
                                                                          15,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor,
                                                                      shadows:
                                                                          StrokeText()
                                                                              .shadowStrokeTextBlack))
                                                              : new SizedBox
                                                                  .shrink(),
                                                          _thisFugitive.status!
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          'captured') ||
                                                                  _thisFugitive
                                                                      .status!
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          'arrested') ||
                                                                  _thisFugitive
                                                                      .status!
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          'surrendered')
                                                              ? new Text('👮 ',
                                                                  style: regularStyle.copyWith(
                                                                      fontSize:
                                                                          15,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor,
                                                                      shadows:
                                                                          StrokeText()
                                                                              .shadowStrokeTextBlack))
                                                              : new SizedBox
                                                                  .shrink(),
                                                          _thisFugitive.caution!
                                                                  .isNotEmpty
                                                              ? new Text('! ',
                                                                  style: googleStyle.copyWith(
                                                                      fontSize:
                                                                          20,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .highlightColor,
                                                                      shadows:
                                                                          StrokeText()
                                                                              .shadowStrokeTextBlack))
                                                              : new SizedBox
                                                                  .shrink(),
                                                          rewardList.contains(
                                                                  _thisFugitive)
                                                              ? new Text('\$ ',
                                                                  style: googleStyle.copyWith(
                                                                      fontSize:
                                                                          20,
                                                                      color: Colors
                                                                          .green,
                                                                      shadows:
                                                                          StrokeText()
                                                                              .shadowStrokeTextBlack))
                                                              : new SizedBox
                                                                  .shrink(),
                                                        ],
                                                      ),
                                                    ),
                                                    child: new Container(
                                                      height: 50,
                                                      decoration:
                                                          _thisFugitive !=
                                                                  _randomFugitive
                                                              ? null
                                                              : BoxDecoration(
                                                                  boxShadow:
                                                                      boxShadow,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              3),
                                                                  border: Border
                                                                      .all(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .highlightColor,
                                                                    width: 5,
                                                                  ),
                                                                ),
                                                      child: new ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(3),
                                                          child: FadeInImage(
                                                            placeholder: AssetImage(
                                                                'assets/no_photo.png'),
                                                            image: NetworkImage(
                                                                _thisFugitive
                                                                    .images
                                                                    .first
                                                                    .large!),
                                                            fit: BoxFit.cover,
                                                            imageErrorBuilder:
                                                                (context,
                                                                    object,
                                                                    stacktrace) {
                                                              return Image(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                colorBlendMode:
                                                                    BlendMode
                                                                        .color,
                                                                image: AssetImage(
                                                                    'assets/no_photo.png'),
                                                                fit: BoxFit
                                                                    .cover,
                                                              );
                                                            },
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                        new Container(
                                          height: Theme.of(context)
                                                  .iconTheme
                                                  .size! *
                                              2,
                                          child: Center(
                                            child: noMorePages
                                                ? new SizedBox.shrink()
                                                : new OutlinedButton.icon(
                                                    onPressed: () {
                                                      // debugPrint(
                                                      //     '***** Search String: $searchString *****');
                                                      // debugPrint(
                                                      //     '***** Display String: $displayString *****');
                                                      getFugitives(
                                                          nextPage,
                                                          searchField,
                                                          displayString
                                                                  .isNotEmpty
                                                              ? displayString
                                                                  .replaceAll(
                                                                      ' ', '')
                                                                  .trim()
                                                                  .toLowerCase()
                                                              : searchString);
                                                    },
                                                    icon: pageLoading
                                                        ? SizedBox(
                                                            width: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .size!,
                                                            height: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .size!,
                                                            child:
                                                                new CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                              backgroundColor:
                                                                  Theme.of(
                                                                          context)
                                                                      .highlightColor,
                                                            ))
                                                        : Icon(Icons.add,
                                                            size: Theme.of(
                                                                    context)
                                                                .iconTheme
                                                                .size!),
                                                    label: Text('Next Page')),
                                          ),
                                        ),
                                      ]),
                                ),
                              ]),
                        ),
                      ],
                    ),
                  ),
                  bottomNavigationBar: new BottomAppBar(
                    color: Theme.of(context).bottomAppBarColor,
                    elevation: 3,
                    child: new Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 5.0, horizontal: 5),
                      child: new Column(
                        mainAxisSize: MainAxisSize.min,
                        // crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          userDatabase.get('userLocalized') == false ||
                                  !isLocalized
                              ? kIsWeb
                                  ? SizedBox(
                                      height: 30,
                                      child: TextButton(
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Text(
                                            'Advertise Here',
                                            style: googleStyle,
                                          ),
                                        ),
                                        onPressed: () => Functions.linkLaunch(
                                            context, developerWebLink),
                                      ),
                                    )
                                  : bannerAdContainer
                              : new Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    new Text(
                                        'Fugitive Radar (${userDatabase.get('lastState')})',
                                        style: googleStyle.copyWith(
                                            shadows: StrokeText()
                                                .shadowStrokeTextBlack,
                                            color: Theme.of(context)
                                                .highlightColor,
                                            fontSize: 25)),
                                    new Container(
                                        alignment: Alignment.centerLeft,
                                        height: 80,
                                        color: Colors.transparent,
                                        child: new GridView.builder(
                                            physics: BouncingScrollPhysics(),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10),
                                            scrollDirection: Axis.horizontal,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                              childAspectRatio: 1,
                                              crossAxisCount: 1,
                                              crossAxisSpacing: 10.0,
                                              mainAxisSpacing: 10.0,
                                            ),
                                            itemCount: localizedList.length,
                                            itemBuilder: (context, index) {
                                              // debugPrint(
                                              //     '***** LOCALIZED LIST (footer): ${localizedList.length} *****');
                                              FbiWantedItem _thisFugitive =
                                                  localizedList[index];

                                              late String _rewardAmount = '';

                                              if (_thisFugitive
                                                  .rewardText!.isNotEmpty) {
                                                _rewardAmount = _thisFugitive
                                                    .rewardText!
                                                    .replaceAll(
                                                        'million', ',000,000')
                                                    .replaceAll(
                                                        new RegExp(
                                                            r'([^0-9]+[^,0-9]+)'),
                                                        '<|:|>');
                                              }
                                              return new GridTile(
                                                  footer:
                                                      _rewardAmount.isNotEmpty
                                                          ? Row(
                                                              children: [
                                                                new Text('\$',
                                                                    style: googleStyle.copyWith(
                                                                        color: Colors
                                                                            .green,
                                                                        shadows:
                                                                            StrokeText().shadowStrokeTextBlack)),
                                                                new Text(
                                                                    _rewardAmount
                                                                        .split('<|:|>')[
                                                                            1]
                                                                        .replaceFirst(
                                                                            ',000,000',
                                                                            'M')
                                                                        .replaceFirst(
                                                                            ',000',
                                                                            'K'),
                                                                    style: googleStyle.copyWith(
                                                                        color: Theme.of(context)
                                                                            .highlightColor,
                                                                        shadows:
                                                                            StrokeText().shadowStrokeTextBlack)),
                                                              ],
                                                            )
                                                          : new SizedBox
                                                              .shrink(),
                                                  child: new GestureDetector(
                                                    child: Container(
                                                      width: 50,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            Colors.transparent,
                                                        border: Border.all(
                                                            width: 3,
                                                            color: Theme.of(
                                                                    context)
                                                                .colorScheme
                                                                .secondary),
                                                        shape: BoxShape.circle,
                                                        boxShadow: boxShadow,
                                                      ),
                                                      child: new ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      150),
                                                          child:
                                                              new FadeInImage(
                                                            placeholder: AssetImage(
                                                                'assets/no_photo.png'),
                                                            image: NetworkImage(
                                                                _thisFugitive
                                                                    .images
                                                                    .first
                                                                    .large!),
                                                            fit: BoxFit
                                                                .fitHeight,
                                                            imageErrorBuilder:
                                                                (context,
                                                                    object,
                                                                    stacktrace) {
                                                              return Image(
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                                colorBlendMode:
                                                                    BlendMode
                                                                        .color,
                                                                image: AssetImage(
                                                                    'assets/no_photo.png'),
                                                              );
                                                            },
                                                          )),
                                                    ),
                                                    onTap: () =>
                                                        showModalBottomSheet(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      constraints:
                                                          BoxConstraints(
                                                        maxHeight:
                                                            MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height *
                                                                0.75,
                                                        maxWidth: orientation ==
                                                                Orientation
                                                                    .landscape
                                                            ? MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                0.5
                                                            : MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width,
                                                      ),
                                                      isScrollControlled: true,
                                                      enableDrag: true,
                                                      context: context,
                                                      builder: (context) =>
                                                          showDetails(
                                                              _thisFugitive),
                                                    ),
                                                  ));
                                            })),
                                  ],
                                ),
                          // isLocalized ? new SizedBox.shrink() : bannerAdContainer,
                          new Container(
                            alignment: Alignment.center,
                            height: 30,
                            child: Column(
                              children: [
                                // SizedBox(
                                //   height: 30,
                                //   child: Container(
                                //     alignment: Alignment.center,
                                //     child: ListView(
                                //       shrinkWrap: true,
                                //       scrollDirection: Axis.horizontal,
                                //       physics: const BouncingScrollPhysics(),
                                //       // mainAxisAlignment: MainAxisAlignment.center,
                                //       children: [
                                //         TextButton.icon(
                                //             icon: const Icon(
                                //                 Icons.volunteer_activism,
                                //                 size: 13,
                                //                 color: Color(
                                //                     0xffffffff)), // Image.asset('assets/instagram.png', height: 16, width: 16, color: const Color(0xffffffff)),
                                //             onPressed: () => showModalBottomSheet(
                                //                 backgroundColor:
                                //                     Colors.transparent,
                                //                 enableDrag: true,
                                //                 isScrollControlled: true,
                                //                 context: context,
                                //                 builder: (context) {
                                //                   return bottomCard(
                                //                       context,
                                //                       'Support Options',
                                //                       supportOptions(context));
                                //                 }),
                                //             label: Text(
                                //               'Support',
                                //               style: regularText.copyWith(
                                //                   color: const Color(0xffffffff)),
                                //             )),
                                //         TextButton.icon(
                                //             onPressed: () => launch(devGitHubUrl),
                                //             icon: Image.asset('assets/github.png',
                                //                 height: 12,
                                //                 width: 12,
                                //                 color: const Color(0xffffffff)),
                                //             label: Text(
                                //               'GitHub',
                                //               style: regularText.copyWith(
                                //                   color: const Color(0xffffffff)),
                                //             )),
                                //         TextButton.icon(
                                //             icon: Image.asset(
                                //                 'assets/twitter.png',
                                //                 height: 12,
                                //                 width: 12,
                                //                 color: const Color(0xffffffff)),
                                //             onPressed: () =>
                                //                 launch(devTwitterUrl),
                                //             label: Text(
                                //               'Twitter',
                                //               style: regularText.copyWith(
                                //                   color: const Color(0xffffffff)),
                                //             )),
                                //         TextButton.icon(
                                //             icon: Image.asset(
                                //                 'assets/instagram.png',
                                //                 height: 16,
                                //                 width: 16,
                                //                 color: const Color(0xffffffff)),
                                //             onPressed: () =>
                                //                 launch(devInstagramUrl),
                                //             label: Text(
                                //               'Instagram',
                                //               style: regularText.copyWith(
                                //                   color: const Color(0xffffffff)),
                                //             )),
                                //         TextButton.icon(
                                //             icon: const Icon(Icons.mail,
                                //                 size: 13,
                                //                 color: Color(
                                //                     0xffffffff)), // Image.asset('assets/instagram.png', height: 16, width: 16, color: const Color(0xffffffff)),
                                //             onPressed: () => launch(
                                //                 'mailto:$devEmail?subject=App%20Inquiry%20[Wanted!]&body=Enter%20your%20question%20here...'),
                                //             label: Text(
                                //               'Email',
                                //               style: regularText.copyWith(
                                //                   color: const Color(0xffffffff)),
                                //             )),
                                //       ],
                                //     ),
                                //   ),
                                // ),
                                SizedBox(
                                  height: 30,
                                  child: new TextButton.icon(
                                      icon: Icon(Icons.launch, size: 14),
                                      label: new Text(
                                          'Created by $developerName',
                                          style: regularStyle.copyWith(
                                              fontSize: 12),
                                          overflow: TextOverflow.ellipsis),
                                      onPressed: () => Functions.linkLaunch(
                                          context, developerWebLink)),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
  }

  Widget showDetails(
    FbiWantedItem fugitive,
  ) {
    List<String> rapsheet = [];

    if (fugitive.caution!.isNotEmpty) {
      String strippedDescription = fugitive.description!
          .replaceAll('<b>', '')
          .replaceAll('</b>', '')
          .replaceAll('<p>', '')
          .replaceAll('</p>', '')
          .replaceAll('<ul>', '')
          .replaceAll('</ul>', '')
          .replaceAll('<strong>', '')
          .replaceAll('</strong>', '')
          .replaceAll('<li>', '')
          .replaceAll('</li>', '')
          .replaceAll('<i>', '')
          .replaceAll('</i>', '')
          .replaceAll('<em>', '')
          .replaceAll('</em>', '')
          .replaceAll('<br />', '')
          .replaceAll(RegExp(r'(?=<a)(.*)(?=<\/a>)'), '')
          .replaceAll('</a>', '');
      if (strippedDescription.contains(';')) {
        rapsheet = strippedDescription.split(';');
      } else if (strippedDescription.contains(',')) {
        rapsheet = strippedDescription.split(',');
      } else {
        rapsheet = [strippedDescription];
      }
    }

    // debugPrint('***** RAP SHEET: $rapsheet *****');

    List<FieldOffice> _fieldOffices = fbiFieldOffices.fieldOffices!
            .where((office) => fugitive.fieldOffices!.contains(office.office))
            .toList() +
        [
          fbiFieldOffices.fieldOffices!
              .firstWhere((element) => element.office == 'headquarters')
        ];

    // debugPrint(
    //     '***** Field Offices for ${fugitive.title}: ${_fieldOffices.map((e) => e.office)} *****');

    final String fugitiveShareSubject = 'WANTED! by FBI';
    final String fugitiveShareData =
        'The FBI is searching for information concerning ${fugitive.title}'
        '\n\nHere are the details:\n\n${fugitive.rewardText!.replaceAll('<b>', '').replaceAll('</b>', '').replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<ul>', '').replaceAll('</ul>', '').replaceAll('<strong>', '').replaceAll('</strong>', '').replaceAll('<li>', '').replaceAll('</li>', '').replaceAll('<i>', '').replaceAll('</i>', '').replaceAll('<em>', '').replaceAll('</em>', '').replaceAll('<br />', '')}'
        '\n\n${fugitive.caution!.replaceAll('<b>', '').replaceAll('</b>', '').replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<ul>', '').replaceAll('</ul>', '').replaceAll('<strong>', '').replaceAll('</strong>', '').replaceAll('<li>', '').replaceAll('</li>', '').replaceAll('<i>', '').replaceAll('</i>', '').replaceAll('<em>', '').replaceAll('</em>', '').replaceAll('<br />', '')}'
        '\n\n${fugitive.details!.replaceAll('<b>', '').replaceAll('</b>', '').replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<ul>', '').replaceAll('</ul>', '').replaceAll('<strong>', '').replaceAll('</strong>', '').replaceAll('<li>', '').replaceAll('</li>', '').replaceAll('<i>', '').replaceAll('</i>', '').replaceAll('<em>', '').replaceAll('</em>', '').replaceAll('<br />', '')}'
        '\n\nView and report fugitives wanted by the FBI with the Wanted! Android App created by MettaCode. Download at https://play.google.com/store/apps/dev?id=8815266571161032386';

    return Container(
      alignment: Alignment.topCenter,
      // margin: const EdgeInsets.all(30.0),
      decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          border:
              Border.all(color: Theme.of(context).highlightColor, width: 8)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              fugitive.title!,
              style: googleStyle.copyWith(fontSize: 30),
            ),
          ),
          Expanded(
            child: new ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              // mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  child: new Column(
                    // title: new Text(
                    //   fugitive.title!,
                    //   style: googleStyle.copyWith(fontSize: 30),
                    // ),
                    // titlePadding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    // contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    // insetPadding: const EdgeInsets.all(0),
                    // shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5)),
                    // elevation: 0,
                    children: [
                      new Stack(
                        alignment: Alignment.bottomCenter,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                                image: (DecorationImage(
                                    colorFilter: ColorFilter.mode(
                                        Colors.white, BlendMode.color),
                                    image: NetworkImage(
                                        fugitive.images.first.large!),
                                    fit: BoxFit.cover))),
                            foregroundDecoration: BoxDecoration(
                                image: (DecorationImage(
                                    image: NetworkImage(
                                        fugitive.images.first.large!),
                                    fit: BoxFit.fitHeight))),
                            child: new Stack(
                              alignment: Alignment.center,
                              children: [
                                new Container(
                                  foregroundDecoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor,
                                      backgroundBlendMode: BlendMode.color),
                                  child: new FadeInImage(
                                    placeholder:
                                        AssetImage('assets/no_photo.png'),
                                    image: NetworkImage(
                                        fugitive.images.first.large!),
                                    fit: BoxFit.fitHeight,
                                    imageErrorBuilder:
                                        (context, object, stacktrace) {
                                      return Image(
                                        image:
                                            AssetImage('assets/no_photo.png'),
                                      );
                                    },
                                  ),
                                ),
                                fugitive.status!.isNotEmpty &&
                                        fugitive.status!.toLowerCase() != 'na'
                                    // && fugitive.status!.toLowerCase() != ''
                                    ? Column(
                                        children: [
                                          Container(
                                            alignment: Alignment.center,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .secondary,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: new Text(
                                                'Status: ' +
                                                    fugitive.status!
                                                        .replaceAll('<b>', '')
                                                        .replaceAll('</b>', '')
                                                        .replaceAll('<p>', '')
                                                        .replaceAll('</p>', '')
                                                        .replaceAll('<ul>', '')
                                                        .replaceAll('</ul>', '')
                                                        .replaceAll(
                                                            '<strong>', '')
                                                        .replaceAll(
                                                            '</strong>', '')
                                                        .replaceAll('<li>', '')
                                                        .replaceAll('</li>', '')
                                                        .replaceAll('<i>', '')
                                                        .replaceAll('</i>', '')
                                                        .replaceAll('<em>', '')
                                                        .replaceAll('</em>', '')
                                                        .replaceAll(
                                                            '<br />', ''),
                                                style: googleStyle.copyWith(
                                                    fontSize: 30,
                                                    shadows: StrokeText()
                                                        .shadowStrokeTextBlack),
                                              ),
                                            ),
                                          ),
                                          new SizedBox(height: 10),
                                        ],
                                      )
                                    : new SizedBox.shrink(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      new Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          // borderRadius: BorderRadius.circular(3),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: new Wrap(
                          spacing: 5,
                          alignment: WrapAlignment.spaceEvenly,
                          children: <Widget>[
                            fugitive.ageRange!.isEmpty
                                ? new SizedBox.shrink()
                                : new Text('Age: ${fugitive.ageRange}'),
                            fugitive.sex!.isEmpty
                                ? new SizedBox.shrink()
                                : new Text('Sex: ${fugitive.sex}'),
                            fugitive.race!.isEmpty
                                ? new SizedBox.shrink()
                                : new Text('Race: ${fugitive.race}'),
                            fugitive.weight!.isEmpty
                                ? new SizedBox.shrink()
                                : new Text('Weight: ${fugitive.weight}')
                          ],
                        ),
                      ),
                      new Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 10.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            fugitive.modified!.toString().isNotEmpty &&
                                    fugitive.modified.toString() !=
                                        fugitive.publication.toString()
                                ? textSectionColumn(
                                    'Modified: ${formatter.format(DateTime.parse(fugitive.modified!.toString()))}',
                                    regularStyle.copyWith(
                                        fontWeight: FontWeight.normal))
                                : new SizedBox.shrink(),
                            fugitive.publication!.toString().isNotEmpty
                                ? textSectionColumn(
                                        'Published: ${formatter.format(DateTime.parse(fugitive.publication!.toString()))}',
                                        regularStyle.copyWith(
                                            fontWeight: FontWeight.normal))
                                    .children
                                    .elementAt(0)
                                : new SizedBox.shrink(),
                            fugitive.warningMessage!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: textSectionColumn(
                                          fugitive.warningMessage!
                                              .replaceAll('<b>', '')
                                              .replaceAll('</b>', '')
                                              .replaceAll('<p>', '')
                                              .replaceAll('</p>', '')
                                              .replaceAll('<ul>', '')
                                              .replaceAll('</ul>', '')
                                              .replaceAll('<strong>', '')
                                              .replaceAll('</strong>', '')
                                              .replaceAll('<li>', '')
                                              .replaceAll('</li>', '')
                                              .replaceAll('<i>', '')
                                              .replaceAll('</i>', '')
                                              .replaceAll('<em>', '')
                                              .replaceAll('</em>', '')
                                              .replaceAll('<br />', '')
                                              .replaceAll(
                                                  RegExp(
                                                      r'(?=<a)(.*)(?=<\/a>)'),
                                                  '')
                                              .replaceAll('</a>', ''),
                                          regularStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: Color(0xffffffff),
                                            // shadows: StrokeText().shadowStrokeTextWhite,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : new SizedBox.shrink(),
                            new SizedBox(height: 10),
                            fugitive.rewardText!.isNotEmpty
                                ? textSectionColumn(
                                    fugitive.rewardText!
                                        .replaceAll('<b>', '')
                                        .replaceAll('</b>', '')
                                        .replaceAll('<p>', '')
                                        .replaceAll('</p>', '')
                                        .replaceAll('<ul>', '')
                                        .replaceAll('</ul>', '')
                                        .replaceAll('<strong>', '')
                                        .replaceAll('</strong>', '')
                                        .replaceAll('<li>', '')
                                        .replaceAll('</li>', '')
                                        .replaceAll('<i>', '')
                                        .replaceAll('</i>', '')
                                        .replaceAll('<em>', '')
                                        .replaceAll('</em>', '')
                                        .replaceAll('<br />', '')
                                        .replaceAll(
                                            RegExp(r'(?=<a)(.*)(?=<\/a>)'), '')
                                        .replaceAll('</a>', ''),
                                    regularStyle.copyWith(
                                        fontWeight: FontWeight.bold))
                                : new SizedBox.shrink(),
                            fugitive.caution!.isNotEmpty
                                ? textSectionColumn(
                                    fugitive.caution!
                                        .replaceAll('<b>', '')
                                        .replaceAll('</b>', '')
                                        .replaceAll('<p>', '')
                                        .replaceAll('</p>', '')
                                        .replaceAll('<ul>', '')
                                        .replaceAll('</ul>', '')
                                        .replaceAll('<strong>', '')
                                        .replaceAll('</strong>', '')
                                        .replaceAll('<li>', '')
                                        .replaceAll('</li>', '')
                                        .replaceAll('<i>', '')
                                        .replaceAll('</i>', '')
                                        .replaceAll('<em>', '')
                                        .replaceAll('</em>', '')
                                        .replaceAll('<br />', '')
                                        .replaceAll(
                                            RegExp(r'(?=<a)(.*)(?=<\/a>)'), '')
                                        .replaceAll('</a>', ''),
                                    regularStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).highlightColor))
                                : new SizedBox.shrink(),
                            rapsheet.length > 0
                                ? Column(
                                    children: [
                                      new Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: rapsheet
                                              .map((e) =>
                                                  new Text('- ${e.trim()}'))
                                              .toList()),
                                      new SizedBox(height: 10),
                                    ],
                                  )
                                : new SizedBox.shrink(),
                            fugitive.details!.isNotEmpty
                                ? textSectionColumn(
                                    fugitive.details!
                                        .replaceAll('<b>', '')
                                        .replaceAll('</b>', '')
                                        .replaceAll('<p>', '')
                                        .replaceAll('</p>', '')
                                        .replaceAll('<ul>', '')
                                        .replaceAll('</ul>', '')
                                        .replaceAll('<strong>', '')
                                        .replaceAll('</strong>', '')
                                        .replaceAll('<li>', '')
                                        .replaceAll('</li>', '')
                                        .replaceAll('<i>', '')
                                        .replaceAll('</i>', '')
                                        .replaceAll('<em>', '')
                                        .replaceAll('</em>', '')
                                        .replaceAll('<br />', '')
                                        .replaceAll(
                                            RegExp(r'(?=<a)(.*)(?=<\/a>)'), '')
                                        .replaceAll('</a>', ''),
                                    regularStyle)
                                : new SizedBox.shrink(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          new Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                new TextButton.icon(
                  onPressed: () => Share.share(fugitiveShareData,
                      subject: fugitiveShareSubject),
                  icon: Icon(Icons.share,
                      size: Theme.of(context).iconTheme.size!),
                  label: Text('Share'),
                ),
                _fieldOffices.length == 0
                    ? new SizedBox.shrink()
                    : new TextButton.icon(
                        onPressed: _fieldOffices.first.phone.isNotEmpty
                            ? () => UrlLauncher.launchUrl(
                                Uri.parse('tel:${_fieldOffices.first.phone}'))
                            : () => UrlLauncher.launchUrl(Uri.parse(
                                'tel:${fbiFieldOffices.fieldOffices!.first.phone}')),
                        icon: Icon(Icons.call,
                            size: Theme.of(context).iconTheme.size!),
                        label: Text('Tip'),
                      ),
                fugitive.files.length == 0
                    ? new SizedBox.shrink()
                    : new TextButton.icon(
                        onPressed: () => Functions.linkLaunch(
                            context, fugitive.files.first.url!),
                        icon: Icon(Icons.article,
                            size: Theme.of(context).iconTheme.size!),
                        label: Text('Poster'),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Column textSectionColumn(String textString, TextStyle style) {
    return Column(
      children: [
        new Text(
          textString,
          style: style,
        ),
        new SizedBox(height: 10),
      ],
    );
  }

  // Widget Options(BuildContext context) {
  //   return ListView(
  //     shrinkWrap: true,
  //     physics: BouncingScrollPhysics(),
  //     // primary: false,
  //     children: <Widget>[
  //       ListTile(
  //         enabled: true,
  //         leading: Image.asset('assets/github.png',
  //             height: 30, width: 30, color: const Color(0xffffffff)),
  //         title: const Text('Support with GitHub'),
  //         subtitle: const Text('Visit The Official Wanted! GitHub Page'),
  //         trailing: const Icon(Icons.launch, size: iconSize + 4),
  //         onTap: () async {
  //           Navigator.pop(context);
  //           Functions.linkLaunch(context, siteGitHubUrl);
  //         },
  //       ),
  //       !kIsWeb
  //           ? SizedBox.shrink()
  //           : Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 const Divider(),
  //                 ListTile(
  //                   enabled: true,
  //                   leading: Image.asset('assets/cashapp.png',
  //                       height: 30, width: 30),
  //                   title: const Text('Support with \$Cashapp'),
  //                   subtitle: const Text('Tap For CashApp Code'),
  //                   trailing: const Icon(Icons.launch, size: iconSize + 4),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Functions.linkLaunch(context, devCashApp);
  //                   },
  //                 ),
  //                 ListTile(
  //                   enabled: true,
  //                   leading:
  //                       Image.asset('assets/venmo.png', height: 30, width: 30),
  //                   title: const Text('Support with Venmo'),
  //                   subtitle: const Text('Tap For Venmo Code'),
  //                   trailing: const Icon(Icons.launch, size: iconSize + 4),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Functions.linkLaunch(context, devVenmo);
  //                   },
  //                 ),
  //                 const Divider(),
  //                 ListTile(
  //                   enabled: true,
  //                   leading: Image.asset('assets/bitcoin.png',
  //                       height: 35, width: 35),
  //                   title: const Text('Support with Bitcoin'),
  //                   subtitle: const Text('Tap to copy BTC address'),
  //                   trailing: const Icon(Icons.copy, size: iconSize + 4),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Clipboard.setData(const ClipboardData(text: devBtcAddr));
  //                     Messages.showQuickSnackBar(
  //                         context, 'Bitcoin address copied to clipboard');
  //                   },
  //                 ),
  //                 ListTile(
  //                   enabled: true,
  //                   leading: Image.asset('assets/ethereum.png',
  //                       height: 30, width: 30),
  //                   title: const Text('Support with Ethereum'),
  //                   subtitle: const Text('Tap to copy ETH address'),
  //                   trailing: const Icon(Icons.copy, size: iconSize + 4),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Clipboard.setData(const ClipboardData(text: devBtcAddr));
  //                     Messages.showQuickSnackBar(
  //                         context, 'Ethereum address copied to clipboard');
  //                   },
  //                 ),
  //                 ListTile(
  //                   enabled: true,
  //                   leading: Image.asset('assets/litecoin.png',
  //                       height: 27, width: 27),
  //                   title: const Text('Support with LiteCoin'),
  //                   subtitle: const Text('Tap to copy LTC address'),
  //                   trailing: const Icon(Icons.copy, size: iconSize + 4),
  //                   onTap: () {
  //                     Navigator.pop(context);
  //                     Clipboard.setData(const ClipboardData(text: devBtcAddr));
  //                     Messages.showQuickSnackBar(
  //                         context, 'Litecoin address copied to clipboard');
  //                   },
  //                 ),
  //               ],
  //             ),
  //     ],
  //   );
  // }
}

class CustomHeader extends StatelessWidget {
  const CustomHeader({
    Key? key,
    required this.userAddressInfo,
  }) : super(key: key);

  // final Address userAddressInfo;
  final Placemark userAddressInfo;

  @override
  Widget build(BuildContext context) {
    return new Container(
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new GestureDetector(
            onTap: () {},
            child: new CircleAvatar(
              backgroundImage: kIsWeb
                  ? new AssetImage('bg_logo.png')
                  : new AssetImage('assets/bg_logo.png'),
              // backgroundColor: Colors.white,
            ),
          ),
          new SizedBox(width: 10),
          new Text(appTitle, style: googleStyle),
          new Expanded(child: new Container(height: 10)),
          new Text(
              '${userAddressInfo.street}\n${userAddressInfo.locality}, ${userAddressInfo.administrativeArea} ${userAddressInfo.postalCode}')
        ],
      ),
    );
  }
}

class AppBackground extends StatelessWidget {
  const AppBackground({
    Key? key,
    required FbiWantedItem randomFugitive,
  })  : _randomFugitive = randomFugitive,
        super(key: key);

  final FbiWantedItem _randomFugitive;

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_randomFugitive.images.first.large!),
          repeat: ImageRepeat.repeat,
          colorFilter: ColorFilter.mode(
            Theme.of(context).colorScheme.secondary,
            BlendMode.multiply,
          ),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
