import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final regularStyle = TextStyle(
  // textStyle: TextStyle(
  // color: Colors.white,
  fontSize: 16,
  fontWeight: FontWeight.normal,
  // ),
  fontStyle: FontStyle.normal,
  // shadows: [
  //   Shadow(
  //       color: Colors.black.withOpacity(0.5),
  //       offset: Offset(5, 5),
  //       blurRadius: 5),
  // ],
);

final googleStyle = GoogleFonts.bangers(
  textStyle: TextStyle(
      // color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.normal),
  fontStyle: FontStyle.normal,
  // shadows: [
  //   Shadow(
  //       color: Colors.black.withOpacity(0.5),
  //       offset: Offset(5, 5),
  //       blurRadius: 5),
  // ],
);

final boxShadow = [
  BoxShadow(
    color: Colors.black.withOpacity(0.3),
    spreadRadius: 3,
    blurRadius: 3,
    offset: Offset(3, 3), // changes position of shadow
  )
];

class StrokeText {
  final List<Shadow> shadowStrokeTextBlack = [
    Shadow(
        // bottomLeft
        offset: Offset(-1.5, -1.5),
        blurRadius: 2.5,
        color: Colors.black),
    Shadow(
        // bottomRight
        offset: Offset(1.5, -1.5),
        blurRadius: 2.5,
        color: Colors.black),
    Shadow(
        // topRight
        offset: Offset(1.5, 1.5),
        blurRadius: 2.5,
        color: Colors.black),
    Shadow(
      // topLeft
      offset: Offset(-1.5, 1.5),
        blurRadius: 2.5,
      color: Colors.black,
    )
  ];

  final List<Shadow> shadowStrokeTextAmber = [
    Shadow(
        // bottomLeft
        offset: Offset(-1.5, -1.5),
        blurRadius: 2.5,
        color: Colors.amber),
    Shadow(
        // bottomRight
        offset: Offset(1.5, -1.5),
        blurRadius: 2.5,
        color: Colors.amber),
    Shadow(
        // topRight
        offset: Offset(1.5, 1.5),
        blurRadius: 2.5,
        color: Colors.amber),
    Shadow(
      // topLeft
      offset: Offset(-1.5, 1.5),
        blurRadius: 2.5,
      color: Colors.amber,
    )
  ];

  final List<Shadow> shadowStrokeTextWhite = [
    Shadow(
        // bottomLeft
        offset: Offset(-1.5, -1.5),
        blurRadius: 2.5,
        color: Color(0xffffffff)),
    Shadow(
        // topRight
        offset: Offset(1.5, -1.5),
        blurRadius: 2.5,
        color: Color(0xffffffff)),
    Shadow(
        // topRight
        offset: Offset(1.5, 1.5),
        blurRadius: 2.5,
        color: Color(0xffffffff)),
    Shadow(
      // topLeft
      offset: Offset(-1.5, 1.5),
        blurRadius: 2.5,
      color: Color(0xffffffff),
    )
  ];
}
