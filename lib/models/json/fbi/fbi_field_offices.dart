// To parse this JSON data, do
//
//     final fbiFieldOffices = fbiFieldOfficesFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

FbiFieldOffices fbiFieldOfficesFromJson(String str) =>
    FbiFieldOffices.fromJson(json.decode(str));

String fbiFieldOfficesToJson(FbiFieldOffices data) =>
    json.encode(data.toJson());

class FbiFieldOffices {
  FbiFieldOffices({
    required this.total,
    required this.updated,
    required this.fieldOffices,
  });

  final int total;
  final String updated;
  final List<FieldOffice>? fieldOffices;

  factory FbiFieldOffices.fromJson(Map<String, dynamic> json) =>
      FbiFieldOffices(
        total: json["total"] ?? 0,
        updated: json["updated"] ?? '',
        fieldOffices: List<FieldOffice>.from(
            json["field_offices"].map((x) => FieldOffice.fromJson(x))),
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["total"] = total;
    data["updated"] = updated;
    data["field_offices"] =
        List<dynamic>.from(fieldOffices!.map((x) => x.toJson()));
    return data;
  }
}

class FieldOffice {
  FieldOffice({
    required this.office,
    required this.city,
    required this.address,
    required this.state,
    required this.stateCode,
    required this.postalCode,
    required this.website,
    required this.phone,
    required this.counties,
    required this.photoUrl,
  });

  String office;
  final String city;
  final String address;
  final String state;
  final String stateCode;
  final String postalCode;
  final String website;
  final String phone;
  final List<String>? counties;
  final String photoUrl;

  factory FieldOffice.fromJson(Map<String, dynamic> json) => FieldOffice(
        office: json["office"] == null ? null : json["office"],
        city: json["city"] == null ? null : json["city"],
        address: json["address"] == null ? null : json["address"],
        state: json["state"] == null ? null : json["state"],
        stateCode: json["state_code"] == null ? null : json["state_code"],
        postalCode: json["postal_code"] == null ? null : json["postal_code"],
        website: json["website"] == null ? null : json["website"],
        phone: json["phone"] == null ? null : json["phone"],
        counties: json["counties"] == null
            ? null
            : List<String>.from(json["counties"].map((x) => x)),
        photoUrl: json["photo_url"] == null ? null : json["photo_url"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["office"] = office;
    data["city"] = city;
    data["address"] = address;
    data["state"] = state;
    data["state_code"] = stateCode;
    data["postal_code"] = postalCode;
    data["website"] = website;
    data["phone"] = phone;
    data["counties"] = List<dynamic>.from(counties!.map((x) => x));
    data["photo_url"] = photoUrl;
    return data;
  }
}
