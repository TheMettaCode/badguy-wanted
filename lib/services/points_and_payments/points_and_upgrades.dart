// import 'dart:async';
// import 'dart:io';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:intl/intl.dart';

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:in_app_purchase/in_app_purchase.dart';
// import 'package:badguy/services/admob/ad_library.dart';
// import 'package:badguy/constants/constants.dart';

// const bool autoConsume = true;

// // const String msp_pp_100 = 'msp_pp_100';
// // const String msp_pp_500 = 'msp_pp_500';
// // const String msp_pp_1k = 'msp_pp_1k';

// List<String> _consumableProductIds = [];
// List<String> _nonConsumableProductIds = [];
// List<String> _subscriptionProductIds = [];

// DocumentReference _productsReference =
//     FirebaseFirestore.instance.collection('miscellaneous').doc('products');

// CollectionReference _membersCollection =
//     FirebaseFirestore.instance.collection('members');

// // const List<String> _consumableProductIds = <String>[
// //   msp_pp_100,
// //   msp_pp_500,
// //   msp_pp_1k,
// // ];

// class PointsAndUpgrades extends StatefulWidget {
//   PointsAndUpgrades({Key key, this.myData}) : super(key: key);
//   final Map<String,dynamic> myData;

//   @override
//   _PointsAndUpgradesState createState() => _PointsAndUpgradesState();
// }

// Map<String, String> additionalData;

// class _PointsAndUpgradesState extends State<PointsAndUpgrades> {
//   final InAppPurchaseConnection _connection = InAppPurchaseConnection.instance;
//   StreamSubscription<List<PurchaseDetails>> _subscription;
//   List<String> _notFoundIds = [];
//   List<ProductDetails> _products = [];
//   // List<ProductDetails> _consumableProducts = [];
//   // List<ProductDetails> _nonConsumableProducts = [];
//   // List<ProductDetails> _subscriptionProducts = [];
//   List<PurchaseDetails> _purchases = [];
//   // List<String> _consumables = [];
//   // List<String> _nonConsumables = [];
//   // List<String> _subscriptions = [];
//   bool _isAvailable = false;
//   bool _purchasePending = false;
//   bool _loading = true;
//   String _queryProductError;

//   @override
//   void initState() {
//     final Stream<List<PurchaseDetails>> purchaseUpdated =
//         InAppPurchaseConnection.instance.purchaseUpdatedStream;
//     _subscription = purchaseUpdated.listen((purchaseDetailsList) {
//       _listenToPurchaseUpdated(purchaseDetailsList);
//     }, onDone: () {
//       _subscription.cancel();
//     }, onError: (error) {
//       // handle error here.
//       print('***** Subcription Errors: $error *****');
//     });

//     additionalData = ({
//       'myUid': widget.myData.userId,
//       'myPhoto': widget.myData.photoUrl,
//     });

//     initStoreInfo();
//     super.initState();
//   }

//   Future<void> initStoreInfo() async {
//     final bool isAvailable = await _connection.isAvailable();
//     if (!isAvailable) {
//       setState(() {
//         _isAvailable = isAvailable;
//         _products = [];
//         // _consumableProducts = [];
//         // _nonConsumableProducts = [];
//         // _subscriptionProducts = [];
//         _purchases = [];
//         _notFoundIds = [];
//         // _consumables = [];
//         // _nonConsumables = [];
//         // _subscriptions = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       return;
//     }

//     final List<String> _consumableIds = await _productsReference
//             .get()
//             .then((value) => List.from(value.get('consumableProductIds'))) ??
//         [];

//     if (_consumableIds != null) {
//       print('***** Consumable IDs: $_consumableIds *****');
//       setState(() => _consumableProductIds = _consumableIds);
//     }

//     final List<String> _nonConsumableIds = await _productsReference
//             .get()
//             .then((value) => List.from(value.get('nonConsumableProductIds'))) ??
//         [];

//     if (widget.myData.appLevelFull && widget.myData.adsRemoved) {
//       _nonConsumableIds
//           .retainWhere((element) => element.contains('msp_full_upgrade'));
//     } else if (widget.myData.appLevelFull && !widget.myData.adsRemoved) {
//       _nonConsumableIds
//           .retainWhere((element) => element.contains('msp_ads_remove'));
//     } else if (!widget.myData.appLevelFull && widget.myData.adsRemoved) {
//       _nonConsumableIds
//           .retainWhere((element) => element.contains('msp_social_upgrade'));
//     }

//     if (_nonConsumableIds != null) {
//       print('***** Non-Consumable IDs: $_nonConsumableIds *****');
//       setState(() => _nonConsumableProductIds = _nonConsumableIds);
//     }

//     final List<String> _subscriptionIds = await _productsReference
//             .get()
//             .then((value) => List.from(value.get('subscriptionProductIds'))) ??
//         [];

//     if (_subscriptionIds != null) {
//       print('***** Subscription IDs: $_subscriptionIds *****');
//       setState(() => _subscriptionProductIds = _subscriptionIds);
//     }

//     // CONSUMABLE PRODUCTS
//     ProductDetailsResponse consumableProductDetailResponse =
//         await _connection.queryProductDetails(_consumableProductIds.toSet());

//     // NON-CONSUMABLE PRODUCTS
//     ProductDetailsResponse nonConsumableProductDetailResponse =
//         await _connection.queryProductDetails(_nonConsumableProductIds.toSet());

//     // SUBSCRIPTION PRODUCTS
//     ProductDetailsResponse subscriptionProductDetailResponse =
//         await _connection.queryProductDetails(_subscriptionProductIds.toSet());

//     print('***** CHECKING FOR ERRORS OR EMPTIES *****');

//     if (consumableProductDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = consumableProductDetailResponse.error.message;
//         _isAvailable = isAvailable;
//         // _consumableProducts = consumableProductDetailResponse.productDetails;
//         // _products = [];
//         // _purchases = [];
//         _notFoundIds += consumableProductDetailResponse.notFoundIDs;
//         // _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       // return;
//     } else if (consumableProductDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         // _consumableProducts = consumableProductDetailResponse.productDetails;
//         // _purchases = [];
//         _notFoundIds += consumableProductDetailResponse.notFoundIDs;
//         // _consumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       // return;
//     }

//     if (nonConsumableProductDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = nonConsumableProductDetailResponse.error.message;
//         _isAvailable = isAvailable;
//         // _nonConsumableProducts =
//         //     nonConsumableProductDetailResponse.productDetails;
//         // _products = [];
//         // _purchases = [];
//         _notFoundIds += nonConsumableProductDetailResponse.notFoundIDs;
//         // _nonConsumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       // return;
//     } else if (nonConsumableProductDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         // _nonConsumableProducts =
//         //     nonConsumableProductDetailResponse.productDetails;
//         // _purchases = [];
//         _notFoundIds += nonConsumableProductDetailResponse.notFoundIDs;
//         // _nonConsumables = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       // return;
//     }

//     if (subscriptionProductDetailResponse.error != null) {
//       setState(() {
//         _queryProductError = subscriptionProductDetailResponse.error.message;
//         _isAvailable = isAvailable;
//         // _subscriptionProducts =
//         //     subscriptionProductDetailResponse.productDetails;
//         // _products = [];
//         // _purchases = [];
//         _notFoundIds += subscriptionProductDetailResponse.notFoundIDs;
//         // _subscriptions = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       // return;
//     } else if (subscriptionProductDetailResponse.productDetails.isEmpty) {
//       setState(() {
//         _queryProductError = null;
//         _isAvailable = isAvailable;
//         // _subscriptionProducts =
//         //     subscriptionProductDetailResponse.productDetails;
//         // _purchases = [];
//         _notFoundIds += subscriptionProductDetailResponse.notFoundIDs;
//         // _subscriptions = [];
//         _purchasePending = false;
//         _loading = false;
//       });
//       // return;
//     }

//     print('***** NO ERRORS OR EMPTIES *****');

//     final QueryPurchaseDetailsResponse purchaseResponse =
//         await _connection.queryPastPurchases();
//     if (purchaseResponse.error != null) {
//       // handle query past purchase error..
//     }

//     final List<PurchaseDetails> verifiedPurchases = [];

//     for (PurchaseDetails purchase in purchaseResponse.pastPurchases) {
//       if (await _verifyPurchase(purchase)) {
//         print('***** Purchase ${purchase.purchaseID} Verified');
//         verifiedPurchases.add(purchase);
//       }
//     }

//     // List<String> consumables = _consumableProductIds; // await ConsumableStore.load();
//     setState(() {
//       _isAvailable = isAvailable;
//       _products = nonConsumableProductDetailResponse.productDetails +
//           subscriptionProductDetailResponse.productDetails +
//           consumableProductDetailResponse.productDetails;
//       _purchases = verifiedPurchases;
//       _notFoundIds = nonConsumableProductDetailResponse.notFoundIDs +
//           subscriptionProductDetailResponse.notFoundIDs +
//           consumableProductDetailResponse.notFoundIDs;
//       // _consumables = _consumableIds;
//       // _nonConsumables = _nonConsumableIds;
//       // _subscriptions = _subscriptionIds;
//       _purchasePending = false;
//       _loading = false;
//     });
//     print('***** PRODUCTS: ${_products.map((e) => e.id)} *****');
//   }

//   @override
//   void dispose() {
//     _subscription.cancel();
//     super.dispose();
//   }

//   bool adFree = false;
//   Container bannerAdContainer = Container();

//   @override
//   Widget build(BuildContext context) {
//     if (!widget.myData.adsRemoved) {
//       print('***** This Member is AD ENABLED *****');

//       // ADMOB INFORMATION HERE
//       final BannerAd thisBanner = AdMobLibrary().defaultBanner300x50(widget.myData);

//       thisBanner?.load();

//       if (thisBanner != null) {
//         print(
//             '***** This Banner Unit ID: ${thisBanner.adUnitId} - Key Words: ${thisBanner.request.keywords}');

//         bannerAdContainer = AdMobLibrary().bannerContainer(thisBanner, context);

//         print(
//             '***** Points & Upgrades Ad Loaded: ${thisBanner.adUnitId} *****');
//       } else {
//         print('***** Banner Error: Banner is null');

//         bannerAdContainer = Container();
//       }
//     } else {
//       adFree = true;
//     }

//     List<Widget> stack = [];
//     if (_queryProductError == null) {
//       stack.add(
//         new Theme(
//           data: ThemeData(accentColor: ThemeColor().mainColor),
//           child: Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             decoration: BoxDecoration(
//               image: DecorationImage(
//                 image: AssetImage('assets/sgm_bg.jpg'),
//                 fit: BoxFit.cover,
//               ),
//             ),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.symmetric(vertical: 5),
//                   child: bannerAdContainer,
//                 ),
//                 new Expanded(
//                   child: ListView(
//                     padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
//                     physics: BouncingScrollPhysics(),
//                     children: [
//                       _buildAppLevelCheck(),
//                       _buildProductList(),
//                       _buildPastPurchases(),
//                       // _buildConsumableBox(),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     } else {
//       stack.add(Center(
//         child: Text(_queryProductError),
//       ));
//     }
//     if (_purchasePending) {
//       stack.add(
//         Theme(
//           data: ThemeData(accentColor: ThemeColor().mainColor),
//           child: Stack(
//             children: [
//               Opacity(
//                 opacity: 0.3,
//                 child:
//                     const ModalBarrier(dismissible: false, color: Colors.grey),
//               ),
//               Center(
//                 child: CircularProgressIndicator(
//                     color: ThemeColor().mainColor,
//                     backgroundColor: ThemeColor().accentColor),
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//         // appBar: AppBar(
//         //   title: const Text('IAP Example'),
//         // ),
//         body: Stack(
//           children: stack,
//         ),
//       ),
//     );
//   }

//   Card _buildConnectionCheckTile() {
//     if (_loading) {
//       return Card(
//           color: Colors.transparent,
//           elevation: 0,
//           child: ListTile(
//               title: new Text('Trying to connect...',
//                   style: GoogleFonts.sairaStencilOne(
//                       textStyle: TextStyle(
//                           height: 1.25,
//                           fontSize: 20.0,
//                           color: ThemeColor().mainColor,
//                           fontWeight: FontWeight.normal)))));
//     }

//     final Widget storeHeader = ListTile(
//       leading: Icon(_isAvailable ? Icons.storefront : Icons.block,
//           color: _isAvailable
//               ? ThemeColor().mainColor
//               : ThemeData.light().errorColor),
//       title: Text(
//           'The store is ' + (_isAvailable ? 'available' : 'unavailable') + '.',
//           style: GoogleFonts.sairaStencilOne(
//               textStyle: TextStyle(
//                   height: 1.25,
//                   fontSize: 20.0,
//                   color: ThemeColor().mainColor,
//                   fontWeight: FontWeight.normal))),
//     );

//     final List<Widget> children = <Widget>[storeHeader];

//     if (!_isAvailable) {
//       children.addAll([
//         Divider(),
//         ListTile(
//           title: Text('Not connected',
//               style: TextStyle(color: ThemeData.light().errorColor)),
//           subtitle: const Text(
//               'Our list of services is currently unavailable. Please check back later.'),
//         ),
//       ]);
//     }
//     return Card(
//         color: Colors.transparent,
//         elevation: 0,
//         child: Column(children: children));
//   }

//   Card _buildProductList() {
//     if (_loading) {
//       return Card(
//           color: Colors.transparent,
//           elevation: 0,
//           child: ListTile(
//               // tileColor: Colors.transparent,
//               leading: SizedBox(
//                 height: 20,
//                 width: 20,
//                 child: CircularProgressIndicator(
//                     color: ThemeColor().mainColor,
//                     backgroundColor: ThemeColor().accentColor),
//               ),
//               title: Text('Loading Products...')));
//     }

//     if (!_isAvailable) {
//       return Card();
//     }

//     // final ListTile productHeader = ListTile(title: Text('Products for Sale'));
//     List<ListTile> productList = <ListTile>[];
//     if (_notFoundIds.isNotEmpty) {
//       productList.add(ListTile(
//           title: Text('[${_notFoundIds.join(", ")}] not found',
//               style: TextStyle(color: ThemeData.light().errorColor)),
//           subtitle:
//               Text('DEVELOPER: The following product ids were not found.')));
//     }

//     // This loading previous purchases code is just a demo. Please do not use this as it is.
//     // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
//     // We recommend that you use your own server to verify the purchase data.
//     Map<String, PurchaseDetails> purchases =
//         Map.fromEntries(_purchases.map((PurchaseDetails purchase) {
//       if (purchase.pendingCompletePurchase) {
//         InAppPurchaseConnection.instance.completePurchase(purchase);
//       }

//       return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
//     }));

//     productList.addAll(_products.map(
//       (ProductDetails productDetails) {
//         PurchaseDetails previousPurchase = purchases[productDetails.id];
//         return ListTile(
//             tileColor: Colors.transparent,
//             contentPadding: const EdgeInsets.all(8),
//             title: Text(productDetails.title.split('(').first,
//                 style: GoogleFonts.sairaStencilOne(
//                     textStyle: TextStyle(
//                         height: 1.25,
//                         fontSize: 15.0,
//                         color: ThemeColor().mainColor,
//                         fontWeight: FontWeight.normal))),
//             subtitle: Text(
//               productDetails.description,
//             ),
//             trailing: previousPurchase != null
//                 ? IconButton(
//                     icon: Icon(Icons.check),
//                     onPressed: !widget.myData.status.contains('Admin')
//                         ? null
//                         : () async {
//                             await _connection
//                                 .consumePurchase(previousPurchase); // FIXME
//                           })
//                 : TextButton(
//                     child: Text(productDetails.price),
//                     style: TextButton.styleFrom(
//                       backgroundColor: Colors.green[800],
//                       primary: Colors.white,
//                     ),
//                     onPressed: () {
//                       // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
//                       // verify the latest status of you your subscription by using server side receipt validation
//                       // and update the UI accordingly. The subscription purchase status shown
//                       // inside the app may not be accurate.
//                       // final oldSubscription =
//                       //     _getOldSubscription(productDetails, purchases);
//                       PurchaseParam purchaseParam = PurchaseParam(
//                         productDetails: productDetails,
//                         // applicationUserName: widget.myData.userId,
//                         // changeSubscriptionParam: Platform.isAndroid &&
//                         //         oldSubscription != null
//                         //     ? ChangeSubscriptionParam(
//                         //         oldPurchaseDetails: oldSubscription,
//                         //         prorationMode:
//                         //             ProrationMode.immediateWithTimeProration)
//                         //     : null,
//                       );
//                       if (_consumableProductIds.contains(productDetails.id)) {
//                         _connection.buyConsumable(
//                             purchaseParam: purchaseParam,
//                             autoConsume: autoConsume);
//                       } else if (_nonConsumableProductIds
//                           .contains(productDetails.id)) {
//                         _connection.buyNonConsumable(
//                             purchaseParam: purchaseParam);
//                       } else {
//                         print('***** Selected Product Not Listed in Store');
//                       }
//                     },
//                   ));
//       },
//     ));

//     return Card(
//         color: Colors.transparent,
//         elevation: 0,
//         child: Column(
//             children: <Widget>[/*productHeader, Divider()*/] + productList));
//   }

//   Card _buildPastPurchases() {
//     final DateFormat formatter = DateFormat('E, M/d/y h:mm a');
//     return widget.myData.purchaseHistory.isEmpty
//         ? new Card(elevation: 0, color: Colors.transparent)
//         : new Card(
//             elevation: 0,
//             color: Colors.transparent,
//             child: Column(
//               children: [
//                 new Divider(thickness: 5, color: Colors.grey[600]),
//                 new Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                   child: new Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: <Widget>[
//                       new Text('Past Purchases',
//                           style: GoogleFonts.sairaStencilOne(
//                               textStyle: TextStyle(
//                                   height: 1.25,
//                                   fontSize: 20.0,
//                                   color: Colors.grey[600],
//                                   fontWeight: FontWeight.normal)))
//                     ],
//                   ),
//                 ),
//                 new ListView.builder(
//                     primary: false,
//                     reverse: true,
//                     padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
//                     physics: BouncingScrollPhysics(),
//                     shrinkWrap: true,
//                     itemCount: widget.myData.purchaseHistory.length,
//                     itemBuilder: (context, index) {
//                       final String _thisPurchase =
//                           widget.myData.purchaseHistory[index];
//                       // final String _purchaseId =
//                       //     _thisPurchase.split('<|:|>')[0];
//                       final String _productName =
//                           _thisPurchase.split('<|:|>')[1];
//                       // final String _productId = _thisPurchase.split('<|:|>')[2];
//                       // final String _memberId = _thisPurchase.split('<|:|>')[3];
//                       final String _dateTime = _thisPurchase.split('<|:|>')[4];

//                       return new ListTile(
//                         visualDensity: VisualDensity.compact,
//                         isThreeLine: false,
//                         leading: Icon(Icons.workspaces_filled),
//                         title: Text('$_productName'),
//                         subtitle: Text(
//                             'Purchased: ${formatter.format(DateTime.parse(_dateTime).toLocal())}'),
//                         trailing: Icon(Icons.check),
//                       );
//                     }),
//               ],
//             ));
//   }

//   // Card _buildConsumableBox() {
//   //   if (_loading) {
//   //     return Card(
//   //         child: (ListTile(
//   //             leading: CircularProgressIndicator(color: ThemeColor().mainColor,
//   // backgroundColor: ThemeColor().accentColor),
//   //             title: Text('Fetching consumables...'))));
//   //   }
//   //   if (!_isAvailable || _notFoundIds.contains('msp_pp_100')) {
//   //     return Card();
//   //   }
//   //   final ListTile consumableHeader =
//   //       ListTile(title: Text('Purchased consumables'));
//   //   final List<Widget> tokens = _consumables.map((String id) {
//   //     return GridTile(
//   //       child: IconButton(
//   //         icon: Icon(
//   //           Icons.stars,
//   //           size: 42.0,
//   //           color: Colors.orange,
//   //         ),
//   //         splashColor: Colors.yellowAccent,
//   //         // onPressed: () => consume(id),
//   //       ),
//   //     );
//   //   }).toList();
//   //   return Card(
//   //       child: Column(children: <Widget>[
//   //     // consumableHeader,
//   //     // Divider(),
//   //     GridView.count(
//   //       crossAxisCount: 5,
//   //       children: tokens,
//   //       shrinkWrap: true,
//   //       padding: EdgeInsets.all(16.0),
//   //     )
//   //   ]));
//   // }

//   Card _buildAppLevelCheck() {
//     return widget.myData.appLevelFull
//         ? new Card()
//         : new Card(
//             // color: ThemeColor().accentColor,
//             // margin: const EdgeInsets.all(3),
//             child: new Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                   // color: ThemeColor().accentColor,
//                   border: Border.all(color: ThemeColor().mainColor),
//                   borderRadius: BorderRadius.circular(5)),
//               child: new Column(
//                 children: [
//                   new ListTile(
//                     // title: Text(
//                     //     'Upgrade for full app access: ($upgradePrice points)',
//                     //     style: TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: upgradeDialog,
//                     ),
//                     // trailing:
//                     //     Icon(Icons.monetization_on, color: Colors.green[800]),
//                     // onTap: () {},
//                   ),
//                   new Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: <Widget>[
//                       widget.myData.pubPoints < upgradePrice
//                           ? new Row(
//                               children: <Widget>[
//                                 new TextButton.icon(
//                                     label: Text(
//                                         'View Points/Upgrade options below',
//                                         style: TextStyle(
//                                             color: ThemeColor().mainColor)),
//                                     icon: Icon(
//                                       Icons.arrow_circle_down,
//                                       size: iconButtonSize,
//                                       color: ThemeColor().mainColor,
//                                     ),
//                                     onPressed: () {})
//                               ],
//                             )
//                           : new Padding(
//                               padding:
//                                   const EdgeInsets.symmetric(horizontal: 8.0),
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.end,
//                                 children: [
//                                   new ElevatedButton.icon(
//                                       style: ButtonStyle(
//                                           backgroundColor:
//                                               MaterialStateProperty.all<Color>(
//                                                   ThemeColor().mainColor)),
//                                       icon: Icon(Icons.workspaces_filled,
//                                           color: Colors.white,
//                                           size: iconButtonSize),
//                                       label: Text('${upgradePrice.toString()}',
//                                           style:
//                                               TextStyle(color: Colors.white)),
//                                       onPressed: () {
//                                         showDialog(
//                                           barrierColor:
//                                               ThemeColor().dialogBarrierColor,
//                                           context: context,
//                                           builder: (context) {
//                                             return new Dialog(
//                                                 shape: RoundedRectangleBorder(
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             5)),
//                                                 elevation: 2.0,
//                                                 child: new Padding(
//                                                   padding: const EdgeInsets.all(
//                                                       10.0),
//                                                   child: new ListView(
//                                                       shrinkWrap: true,
//                                                       children: [
//                                                         new ListTile(
//                                                           // dense: true,
//                                                           tileColor:
//                                                               ThemeColor()
//                                                                   .accentColor,
//                                                           // leading: Icon(Icons
//                                                           //     .monetization_on_outlined),
//                                                           title: Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Text(
//                                                                   'Member Account Upgrade',
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold)),
//                                                               Text(
//                                                                   'Cost: $upgradePrice Pub Points'),
//                                                             ],
//                                                           ),

//                                                           subtitle: Text(
//                                                               'Points Available: ${widget.myData.pubPoints}',
//                                                               style: TextStyle(
//                                                                   fontWeight:
//                                                                       FontWeight
//                                                                           .bold,
//                                                                   color: widget
//                                                                               .myData
//                                                                               .pubPoints >=
//                                                                           upgradePrice
//                                                                       ? Colors
//                                                                           .green
//                                                                       : Colors.red[
//                                                                           900])),
//                                                           trailing: Icon(
//                                                               Icons
//                                                                   .workspaces_filled,
//                                                               color: ThemeColor()
//                                                                   .mainColor),
//                                                         ),
//                                                         new Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(8.0),
//                                                           child: new Column(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               new Text(
//                                                                   'After completing your upgrade, $upgradePrice points will be deducted from your current balance. Your remaining balance will be ${widget.myData.pubPoints - upgradePrice}.\n'),
//                                                               new Text(
//                                                                   'Upgrade includes:',
//                                                                   style: TextStyle(
//                                                                       fontWeight:
//                                                                           FontWeight
//                                                                               .bold)),
//                                                               new Text(
//                                                                   ' • Full access to all areas'),
//                                                               new Text(
//                                                                   ' • Ability to create event posts'),
//                                                             ],
//                                                           ),
//                                                         ),
//                                                         new Row(
//                                                           mainAxisAlignment:
//                                                               MainAxisAlignment
//                                                                   .end,
//                                                           children: [
//                                                             new TextButton.icon(
//                                                               icon: Icon(
//                                                                   Icons.cancel,
//                                                                   size:
//                                                                       iconButtonSize),
//                                                               label: Text(
//                                                                 'Cancel',
//                                                                 style: TextStyle(
//                                                                     color: ThemeColor()
//                                                                         .mainColor),
//                                                               ),
//                                                               onPressed: () {
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               },
//                                                             ),
//                                                             new ElevatedButton
//                                                                 .icon(
//                                                               icon: Icon(
//                                                                   Icons
//                                                                       .workspaces_filled,
//                                                                   size:
//                                                                       iconButtonSize),
//                                                               label: Text(
//                                                                 'Upgrade',
//                                                               ),
//                                                               onPressed:
//                                                                   () async {
//                                                                 try {
//                                                                   await FirebaseFirestore
//                                                                       .instance
//                                                                       .collection(
//                                                                           'members')
//                                                                       .doc(widget
//                                                                           .myData
//                                                                           .userId)
//                                                                       .update({
//                                                                     'pubPoints':
//                                                                         FieldValue.increment(
//                                                                             -upgradePrice),
//                                                                     'appLevelFull':
//                                                                         true,
//                                                                   });
//                                                                 } catch (e) {
//                                                                   print(e
//                                                                       .toString());
//                                                                 }
//                                                                 Navigator.pop(
//                                                                     context);
//                                                               },
//                                                             ),
//                                                           ],
//                                                         )
//                                                       ]),
//                                                 ));
//                                           },
//                                         );
//                                       }),
//                                   Text('Balance: ${widget.myData.pubPoints}'),
//                                 ],
//                               ),
//                             ),
//                       // new Text(' or '),
//                       // new Padding(
//                       //   padding:
//                       //       const EdgeInsets.symmetric(horizontal: 8.0),
//                       //   child: new ElevatedButton.icon(
//                       //       icon: Icon(Icons.monetization_on, size: iconButtonSize),
//                       //       onPressed: null,
//                       //       label: Text('Buy')),
//                       // )
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           );
//   }

//   // Future<void> consume(String id) async {
//   //   // await ConsumableStore.consume(id);
//   //   final List<String> consumables = [
//   //     'msp_pp_100'
//   //   ]; // await ConsumableStore.load();
//   //   setState(() {
//   //     _consumables = consumables;
//   //   });
//   // }

//   void showPendingUI(PurchaseDetails purchaseDetails) async {
//     await showDialog(
//         barrierColor: ThemeColor().dialogBarrierColor,
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//               title: Text('Purchase Pending'),
//               content: Text(
//                   'We\'ve received your order but your purchase is taking a bit longer to process than expected. We\'ll let you know if there are any problems.'),
//               actions: <Widget>[
//                 new ElevatedButton.icon(
//                     onPressed: () async {
//                       print('***** Purchase is pending}');
//                       setState(() {
//                         _purchasePending = true;
//                       });
//                       Navigator.pop(context);
//                       // await InAppPurchaseConnection.instance
//                       //     .completePurchase(purchaseDetails);
//                     },
//                     icon: Icon(Icons.pending, size: iconButtonSize),
//                     label: Text('Okay'))
//               ]);
//         });
//   }

//   void deliverProduct(PurchaseDetails purchaseDetails) async {
//     // IMPORTANT!! Always verify purchase details before delivering the product.
//     if (_consumableProductIds.contains(purchaseDetails.productID)) {
//       print('***** Consumable Purchase Point: Update all database fields');

//       String _productName;
//       // String _productPrice;
//       int _numPoints;

//       switch (purchaseDetails.productID) {
//         case "msp_pp_100":
//           {
//             _numPoints = 100;
//             _productName = '100 Pub Points';
//             // _productPrice = '';

//             final String thisPurchaseData =
//                 '${purchaseDetails.purchaseID}<|:|>$_productName<|:|>${purchaseDetails.productID}<|:|>${widget.myData.userId}<|:|>${DateTime.now().toUtc().toString()}';

//             await _productsReference.update({
//               'totalPurchasesLedger': FieldValue.arrayUnion([thisPurchaseData])
//             });

//             await _membersCollection.doc(widget.myData.userId).update({
//               'purchaseHistory': FieldValue.arrayUnion([thisPurchaseData])
//             });
//             await FirebaseFieldUpdate()
//                 .updatePubPoints(widget.myData.userId, _numPoints);
//           }
//           break;
//         case "msp_pp_500":
//           {
//             _numPoints = 500;
//             _productName = '500 Pub Points';
//             // _productPrice = '';

//             final String thisPurchaseData =
//                 '${purchaseDetails.purchaseID}<|:|>$_productName<|:|>${purchaseDetails.productID}<|:|>${widget.myData.userId}<|:|>${DateTime.now().toUtc().toString()}';

//             await _productsReference.update({
//               'totalPurchasesLedger': FieldValue.arrayUnion([thisPurchaseData])
//             });

//             await _membersCollection.doc(widget.myData.userId).update({
//               'purchaseHistory': FieldValue.arrayUnion([thisPurchaseData])
//             });
//             await FirebaseFieldUpdate()
//                 .updatePubPoints(widget.myData.userId, _numPoints);
//           }
//           break;
//         case "msp_pp_1000":
//           {
//             _numPoints = 1000;
//             _productName = '1000 Pub Points';
//             // _productPrice = '';

//             final String thisPurchaseData =
//                 '${purchaseDetails.purchaseID}<|:|>$_productName<|:|>${purchaseDetails.productID}<|:|>${widget.myData.userId}<|:|>${DateTime.now().toUtc().toString()}';

//             await _productsReference.update({
//               'totalPurchasesLedger': FieldValue.arrayUnion([thisPurchaseData])
//             });

//             await _membersCollection.doc(widget.myData.userId).update({
//               'purchaseHistory': FieldValue.arrayUnion([thisPurchaseData])
//             });
//             await FirebaseFieldUpdate()
//                 .updatePubPoints(widget.myData.userId, _numPoints);
//           }
//           break;
//         default: // No Item
//           {
//             _numPoints = 0;
//             print('***** No such item found *****');
//           }
//           break;
//       }

//       // if (_numPoints > 0) {
//       await FirebaseFieldUpdate().updateLatestActivity(widget.myData.userId,
//           'Points Purchase', 'You purchased $_numPoints points');
//       // }
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//         // _consumables = consumables;
//       });

//       // Navigator.pop(context);

//     } else if (_nonConsumableProductIds.contains(purchaseDetails.productID)) {
//       print('***** Non-Consumable Purchase Point: Update all database fields');

//       String _productName;
//       // String _productPrice;
//       int _numPoints;

//       switch (purchaseDetails.productID) {
//         case "msp_ads_removed":
//           {
//             _numPoints = 50;
//             _productName = 'Remove Ads';
//             // _productPrice = '';

//             final String thisPurchaseData =
//                 '${purchaseDetails.purchaseID}<|:|>$_productName<|:|>${purchaseDetails.productID}<|:|>${widget.myData.userId}<|:|>${DateTime.now().toUtc().toString()}';

//             await _productsReference.update({
//               'totalPurchasesLedger': FieldValue.arrayUnion([thisPurchaseData])
//             });

//             await _membersCollection.doc(widget.myData.userId).update({
//               'purchaseHistory': FieldValue.arrayUnion([thisPurchaseData]),
//               'adsRemoved': true,
//             });

//             await FirebaseFieldUpdate()
//                 .updatePubPoints(widget.myData.userId, _numPoints);
//           }
//           break;
//         case "msp_full_upgrade":
//           {
//             _numPoints = 100;
//             _productName = 'Full App Upgrade';
//             // _productPrice = '';

//             final String thisPurchaseData =
//                 '${purchaseDetails.purchaseID}<|:|>$_productName<|:|>${purchaseDetails.productID}<|:|>${widget.myData.userId}<|:|>${DateTime.now().toUtc().toString()}';

//             await _productsReference.update({
//               'totalPurchasesLedger': FieldValue.arrayUnion([thisPurchaseData])
//             });

//             await _membersCollection.doc(widget.myData.userId).update({
//               'purchaseHistory': FieldValue.arrayUnion([thisPurchaseData]),
//               'appLevelFull': true,
//               'adsRemoved': true,
//             });

//             await FirebaseFieldUpdate()
//                 .updatePubPoints(widget.myData.userId, _numPoints);
//           }
//           break;
//         case "msp_social_upgrade":
//           {
//             _numPoints = 50;
//             _productName = 'Social Upgrade';
//             // _productPrice = '';

//             final String thisPurchaseData =
//                 '${purchaseDetails.purchaseID}<|:|>$_productName<|:|>${purchaseDetails.productID}<|:|>${widget.myData.userId}<|:|>${DateTime.now().toUtc().toString()}';

//             await _productsReference.update({
//               'totalPurchasesLedger': FieldValue.arrayUnion([thisPurchaseData])
//             });

//             await _membersCollection.doc(widget.myData.userId).update({
//               'purchaseHistory': FieldValue.arrayUnion([thisPurchaseData]),
//               'appLevelFull': true,
//             });

//             await FirebaseFieldUpdate()
//                 .updatePubPoints(widget.myData.userId, _numPoints);
//           }
//           break;
//         default: // No Item
//           {
//             _numPoints = 0;
//             print('***** No such item found *****');
//           }
//           break;
//       }

//       // if (_numPoints > 0) {
//       await FirebaseFieldUpdate().updateLatestActivity(widget.myData.userId,
//           'App Upgraded', 'You purchased an app upgrade!');
//       // }
//       setState(() {
//         _purchases.add(purchaseDetails);
//         _purchasePending = false;
//         // _consumables = consumables;
//       });

//       // Navigator.pop(context);
//     }
//   }

//   void _handleError(PurchaseDetails purchaseDetails) async {
//     print('***** Purchase Error: ${purchaseDetails.error.message}');

//     // final String _errorMessage = purchaseDetails.error.message;
//     // final String _errorCode = purchaseDetails.error.code;
//     // final String _errorSource = purchaseDetails.error.source.toString();

//     setState(() {
//       _purchasePending = false;
//     });

//     if (purchaseDetails.error.message.toString() !=
//         'BillingResponse.userCanceled') {
//       await showDialog(
//           barrierColor: ThemeColor().dialogBarrierColor,
//           context: context,
//           builder: (context) {
//             return AlertDialog(
//                 title: Text('Purchase Cancelled'),
//                 content: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                         'There was an error processing your purchase. Our Admin has been notified. Please feel free to try your purchase again and if the problem continues, please contact support (@mspsupport)'),
//                   ],
//                 ),
//                 actions: <Widget>[
//                   TextButton.icon(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       icon: Icon(Icons.close),
//                       label: Text('Close'))
//                 ]);
//           });

//       FirebaseFieldUpdate().alertMembers(
//           widget.myData,
//           'support',
//           'Product Purchase Error: ${widget.myData.userName} (${widget.myData.userId}) encountered a problem purchasing ${purchaseDetails.productID}.\nPurchase Details: ${purchaseDetails.error.code}\n${purchaseDetails.error.source}\n${purchaseDetails.error.message}',
//           true,
//           additionalData);
//     }
//   }

//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
//     if (purchaseDetails.status == PurchaseStatus.purchased &&
//         purchaseDetails.verificationData.source.toString() ==
//             'IAPSource.GooglePlay') {
//       print('***** Purchase is Valid *****');
//       return Future<bool>.value(true);
//     } else {
//       return Future<bool>.value(false);
//     }
//   }

//   void _handleInvalidPurchase(PurchaseDetails purchaseDetails) async {
//     // handle invalid purchase here if  _verifyPurchase` failed.
//     print('***** Handle invalid purchase here... *****');
//     await showDialog(
//         barrierColor: ThemeColor().dialogBarrierColor,
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//               title: Text('Invalid Purchase'),
//               content: Column(
//                 children: [
//                   Text(
//                       'There was an error processing your purchase. If the problem continues, please contact support (@mspsupport)'),

//                   // Text(purchaseDetails.productID),
//                   // Text(purchaseDetails.status.toString()),
//                   // Text(purchaseDetails.verificationData.source.toString())
//                 ],
//               ),
//               actions: <Widget>[
//                 TextButton.icon(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     icon: Icon(Icons.close),
//                     label: Text('Close'))
//               ]);
//         });
//     setState(() {
//       _purchasePending = false;
//     });
//   }

//   void _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) {
//     if (purchaseDetailsList.isNotEmpty) {
//       print(
//           '***** Updateing Purchases: ${purchaseDetailsList.map((e) => e.productID)}');
//       purchaseDetailsList.forEach((PurchaseDetails purchaseDetails) async {
//         if (purchaseDetails.status == PurchaseStatus.pending) {
//           showPendingUI(purchaseDetails);
//         } else {
//           if (purchaseDetails.status == PurchaseStatus.error) {
//             _handleError(purchaseDetails);
//             // return null;
//           } else if (purchaseDetails.status == PurchaseStatus.purchased) {
//             print(
//                 '***** Purchase Status: ${purchaseDetails.status.toString()}');
//             print(
//                 '***** Source: ${purchaseDetails.verificationData.source.toString()} *****');
//             print(
//                 '***** Local Verification: ${purchaseDetails.verificationData.localVerificationData.toString()} *****');
//             print(
//                 '***** Server Verification: ${purchaseDetails.verificationData.serverVerificationData.toString()} *****');
//             bool valid = await _verifyPurchase(purchaseDetails);
//             if (valid) {
//               print('***** Delivering Product');
//               deliverProduct(purchaseDetails);

//               if (Platform.isAndroid) {
//                 print('***** Platform is Android: Completing Purchase');
//                 if (!autoConsume &&
//                     _consumableProductIds.contains(purchaseDetails.productID)) {
//                   print('***** Consuming Purchase');
//                   await InAppPurchaseConnection.instance
//                       .consumePurchase(purchaseDetails);
//                 } else if (purchaseDetails.pendingCompletePurchase ||
//                     !purchaseDetails.billingClientPurchase.isAcknowledged) {
//                   print('***** Purchase is pending... Completing Purchase}');
//                   await InAppPurchaseConnection.instance
//                       .completePurchase(purchaseDetails);
//                 }
//               }
//             } else {
//               print('***** Invalid purchase... *****');
//               _handleInvalidPurchase(purchaseDetails);
//             }
//           }
//         }
//       });
//     } else {
//       print('***** No Purchase Details Found! *****');
//     }
//   }

//   // PurchaseDetails _getOldSubscription(
//   //     ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
//   //   // This is just to demonstrate a subscription upgrade or downgrade.
//   //   // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
//   //   // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
//   //   // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
//   //   // Please remember to replace the logic of finding the old subscription Id as per your app.
//   //   // The old subscription is only required on Android since Apple handles this internally
//   //   // by using the subscription group feature in iTunesConnect.
//   //   PurchaseDetails oldSubscription;
//   //   // if (productDetails.id == _kSilverSubscriptionId &&
//   //   //     purchases[_kGoldSubscriptionId] != null) {
//   //   //   oldSubscription = purchases[_kGoldSubscriptionId];
//   //   // } else if (productDetails.id == _kGoldSubscriptionId &&
//   //   //     purchases[_kSilverSubscriptionId] != null) {
//   //   //   oldSubscription = purchases[_kSilverSubscriptionId];
//   //   // }
//   //   return oldSubscription;
//   // }
// }
