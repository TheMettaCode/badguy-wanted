import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

// Formatting
final DateFormat formatter = DateFormat('E, M/d/y h:m a');
final DateFormat timeFormatter = DateFormat('h:mm a');
final DateFormat localTimeFormatter = DateFormat.jm();
final DateFormat dateWithTimeFormatter = DateFormat('E, M/d h:mm a');

// App Constants
const String appTitle = 'Wanted!';
// const String appDatabaseName = 'wanted.db';
const String appDatabase = 'wanted';
const String developerLink =
    'https://play.google.com/store/apps/dev?id=8815266571161032386';

// DEVELOPER CONSTANTS
const String developerName = 'MettaCode';
const String developerAndroidLink =
    'https://play.google.com/store/apps/dev?id=8815266571161032386';
const String developerWebLink = 'https://mettacode.dev';
const String devGitHubUrl = 'https://github.com/TheMettaCode';
const String devTwitterUrl = 'https://twitter.com/mettacodedev';
const String devInstagramUrl = 'https://instagram.com/mettacodedev';
const String devEmail = 'mettacode@gmail.com';
const String devTitle = 'MettaCode';
const String devAbout =
    'MettaCode\'s lead developer, MettaMan, is a novice application developer currently developing Android and Web applications using Flutter/Dart';

const String developerEmail = 'mettacode@gmail.com';
const String devCashApp = 'https://cash.app/mettamancrypto';
const String devVenmo = 'https://venmo.com/mettacodedev';
const String devBtcAddr = '38fDpK17cuZdjRCjcfVgHdzwyuf3Rp6vzb';
const String devEthAddr = '0x382f9C0f2611ab6a6484BF12e1Ce3dA7838660B0';
const String devLtcAddr = 'M7xc1CH7me4Bnmvtfe2erBtb9WVL9fFTwR';

// APPLICATION CONSTANTS
// const String siteTitle = "MettaCode";
const String siteGitHubUrl =
    'https://github.com/TheMettaCode/fbi_wanted_web.git';
const String siteAddress = "https://github.com/TheMettaCode/fbi_wanted_web.git";
const String siteLogoImageFileWhite = "assets/bg_logo.png";
const String siteLogoImageFileOrange = "assets/bg_logo.png";
const String appLink =
    'https://play.google.com/store/apps/details?id=com.mettacode.badguy';

// FONT STYLES
TextStyle googleBangersHeader =
    GoogleFonts.bangers(fontSize: 30, letterSpacing: 1);
TextStyle googleBangersHeader2 =
    GoogleFonts.bangers(fontSize: 15, letterSpacing: 0);
TextStyle regularTextHeader = const TextStyle(fontWeight: FontWeight.bold);
TextStyle regularText = const TextStyle(fontSize: 11);

List<Shadow> textShadowHeaderDark = [
  const Shadow(offset: Offset(3, 3), blurRadius: 2)
];
List<Shadow> textShadowRegularDark = [
  const Shadow(offset: Offset(2, 2), blurRadius: 2)
];

// ICON STYLES
const double iconSize = 14;

// ADSENSE CONSTANTS
const String adSenseClientId = 'ca-pub-9188084311019420';

// ADMOB Defaults
const String adMobAppId = 'ca-app-pub-3834929667159972~9762427187';
const String defaultBannerUnitId = 'ca-app-pub-3834929667159972/8262283882';
const String defaultInterstitialUnitId =
    'ca-app-pub-3834929667159972/7556503039';

// DATABASE INFO
Map<String, dynamic> initialData = {
  "userId": "user_${Random().nextInt(99999999)}",
  "deviceInfo": {},
  "packageInfo": {},
  "latitude": 0,
  "longitude": 0,
  "fieldOfficeLocation": "headquarters",
  "lastCountry": "United States",
  "lastCountryCode": "US",
  "lastCounty": "",
  "lastRegion": "",
  "lastState": "Washington DC",
  "lastStateCode": "DC",
  "lastCity": "District of Columbia",
  "lastFullAddress": "935 Pennsylvania Avenue NW, Washington, DC 20535",
  "lastStreet": "935 Pennsylvania Avenue NW",
  "lastLocality": "District of Columbia",
  "lastSubAdministrativeArea": "District of Columbia",
  "lastAdministrativeArea": "District of Columbia",
  "lastPostalCode": "20535",
  "lastIsoCountryCode": "US",
  "lastLocationData": "",
  "userLocalized": false,
  "fugitiveAlerts": true,
  "latestFugitive": "",
  "advertise": true,
  "credits": 0,
  "appOpens": 0,
  "appUpdated": false,
  "appUpdates": [
    "This is a sample title<|:|>This is a sample subtitle, use the word none if none<|:|>high/normal",
    // "This is the first update<|:|>This is the subtitle<|:|>high",
    // "This is the second update<|:|>none<|:|>normal",
    // "This is the third update<|:|>This is another subtitle<|:|>normal"
  ],
  "appRated": false,
  "darkTheme": false,
  "termsAgreed": true,
  "cautionDismissed": true
};

// ADMOB Test DATA
const List<String> adMobTestDevices = ['bb0847f0-9df1-4b02-86f6-09ef4c36af0f'];
const String testBanner = 'ca-app-pub-3940256099942544/6300978111';
const String testInterstitial = 'ca-app-pub-3940256099942544/1033173712';
const String testInterstitialVideo = 'ca-app-pub-3940256099942544/8691691433';
const String testRewarded = 'ca-app-pub-3940256099942544/5224354917';
const String testRewardedInterstitial =
    'ca-app-pub-3940256099942544/5354046379';
const String testNativeAdvanced = 'ca-app-pub-3940256099942544/2247696110';
const String testNativeAdvancedVideo = 'ca-app-pub-3940256099942544/1044960115';
const List<String> adMobKeyWords = [
  'background',
  'criminal',
  'arrest',
  'jail',
  'inmate',
  'offender',
  'mugshot',
  'police',
  'warrant',
  'sex offender',
  'safety',
  'most wanted',
  'dating',
  'marriage',
  'boyfriend',
  'girlfriend',
  'hookup',
  'fbi',
  'fugitive',
  'missing person',
  'arson',
  'murder',
];