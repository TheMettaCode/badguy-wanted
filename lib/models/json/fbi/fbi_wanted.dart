// To parse this JSON data, do
//
//     final fbiWanted = fbiWantedFromJson(jsonString);

// import 'package:meta/meta.dart';
import 'dart:convert';

FbiWanted fbiWantedFromJson(String str) => FbiWanted.fromJson(json.decode(str));

String fbiWantedToJson(FbiWanted data) => json.encode(data.toJson());

class FbiWanted {
  FbiWanted({
    required this.total,
    required this.items,
    required this.page,
  });

  final int total;
  final List<FbiWantedItem> items;
  final int page;

  factory FbiWanted.fromJson(Map<String, dynamic> json) => FbiWanted(
        total: json["total"] == null ? 0 : json["total"],
        items: json["items"] == null
            ? []
            : List<FbiWantedItem>.from(
                json["items"].map((x) => FbiWantedItem.fromJson(x))),
        page: json["page"] == null ? 0 : json["page"],
      );

  Map<String, dynamic> toJson() => {
        "total": this.total,
        "items": List<dynamic>.from(this.items.map((x) => x.toJson())),
        "page": this.page,
      };
}

class FbiWantedItem {
  FbiWantedItem({
    required this.files,
    required this.ageRange,
    required this.uid,
    required this.weight,
    required this.occupations,
    required this.fieldOffices,
    required this.locations,
    required this.rewardText,
    required this.hair,
    required this.ncic,
    required this.datesOfBirthUsed,
    required this.caution,
    required this.nationality,
    required this.ageMin,
    required this.ageMax,
    required this.scarsAndMarks,
    required this.subjects,
    required this.aliases,
    required this.raceRaw,
    required this.suspects,
    required this.publication,
    required this.title,
    required this.coordinates,
    required this.hairRaw,
    required this.languages,
    required this.complexion,
    required this.build,
    required this.details,
    required this.status,
    required this.legatNames,
    required this.eyes,
    required this.personClassification,
    required this.description,
    required this.images,
    required this.possibleCountries,
    required this.weightMin,
    required this.additionalInformation,
    required this.remarks,
    required this.path,
    required this.sex,
    required this.eyesRaw,
    required this.weightMax,
    required this.rewardMin,
    required this.url,
    required this.possibleStates,
    required this.modified,
    required this.rewardMax,
    required this.race,
    required this.heightMax,
    required this.placeOfBirth,
    required this.heightMin,
    required this.warningMessage,
    required this.id,
  });

  final List<FileElement> files;
  final String? ageRange;
  final String? uid;
  final String? weight;
  final dynamic occupations;
  final List<String>? fieldOffices;
  final dynamic locations;
  final String? rewardText;
  final String? hair;
  final String? ncic;
  final List<String>? datesOfBirthUsed;
  final String? caution;
  final String? nationality;
  final int? ageMin;
  final int? ageMax;
  final String? scarsAndMarks;
  final List<String>? subjects;
  final List<String>? aliases;
  final String? raceRaw;
  final dynamic suspects;
  final DateTime? publication;
  final String? title;
  final List<dynamic>? coordinates;
  final String? hairRaw;
  final List<String>? languages;
  final dynamic complexion;
  final String? build;
  final String? details;
  final String? status;
  final dynamic legatNames;
  final String? eyes;
  final String? personClassification;
  final String? description;
  final List<FbiImage> images;
  final dynamic possibleCountries;
  final int? weightMin;
  final dynamic additionalInformation;
  final String? remarks;
  final String? path;
  final String? sex;
  final String? eyesRaw;
  final int? weightMax;
  final int? rewardMin;
  final String? url;
  final List<String>? possibleStates;
  final DateTime? modified;
  final int? rewardMax;
  final String? race;
  final int? heightMax;
  final String? placeOfBirth;
  final int? heightMin;
  final String? warningMessage;
  final String? id;

  factory FbiWantedItem.fromJson(Map<String, dynamic> json) => FbiWantedItem(
        files: List<FileElement>.from(
            json["files"].map((x) => FileElement.fromJson(x))),
        ageRange: json["age_range"] == null ? "" : json["age_range"],
        uid: json["uid"] == null ? "" : json["uid"],
        weight: json["weight"] == null ? "" : json["weight"],
        occupations: json["occupations"] == null ? [] : json["occupations"],
        fieldOffices: json["field_offices"] == null
            ? []
            : List<String>.from(json["field_offices"].map((x) => x)),
        locations: json["locations"] == null ? [] : json["locations"],
        rewardText: json["reward_text"] == null ? "" : json["reward_text"],
        hair: json["hair"] == null ? "" : json["hair"],
        ncic: json["ncic"] == null ? "" : json["ncic"],
        datesOfBirthUsed: json["dates_of_birth_used"] == null
            ? []
            : List<String>.from(json["dates_of_birth_used"].map((x) => x)),
        caution: json["caution"] == null ? "" : json["caution"],
        nationality: json["nationality"] == null ? "" : json["nationality"],
        ageMin: json["age_min"] == null ? 0 : json["age_min"],
        ageMax: json["age_max"] == null ? 0 : json["age_max"],
        scarsAndMarks:
            json["scars_and_marks"] == null ? "" : json["scars_and_marks"],
        subjects: json["subjects"] == null
            ? []
            : List<String>.from(json["subjects"].map((x) => x)),
        aliases: json["aliases"] == null
            ? []
            : List<String>.from(json["aliases"].map((x) => x)),
        raceRaw: json["race_raw"] == null ? "" : json["race_raw"],
        suspects: json["suspects"] == null ? [] : json["suspects"],
        publication: json["publication"] == null
            ? DateTime.now()
            : DateTime.parse(json["publication"]),
        title: json["title"] == null ? "" : json["title"],
        coordinates: json["coordinates"] == null
            ? []
            : List<dynamic>.from(json["coordinates"].map((x) => x)),
        hairRaw: json["hair_raw"] == null ? "" : json["hair_raw"],
        languages: json["languages"] == null
            ? []
            : List<String>.from(json["languages"].map((x) => x)),
        complexion: json["complexion"] == null ? "" : json["complexion"],
        build: json["build"] == null ? "" : json["build"],
        details: json["details"] == null ? "" : json["details"],
        status: json["status"] == null ? "" : json["status"],
        legatNames: json["legat_names"] == null ? [] : json["legat_names"],
        eyes: json["eyes"] == null ? "" : json["eyes"],
        personClassification: json["person_classification"] == null
            ? ""
            : json["person_classification"],
        description: json["description"] == null ? "" : json["description"],
        images: json["images"] == null
            ? []
            : List<FbiImage>.from(json["images"].map((x) => FbiImage.fromJson(x))),
        possibleCountries: json["possible_countries"] == null
            ? []
            : json["possible_countries"],
        weightMin: json["weight_min"] == null ? 0 : json["weight_min"],
        additionalInformation: json["additional_information"] == null
            ? ""
            : json["additional_information"],
        remarks: json["remarks"] == null ? "" : json["remarks"],
        path: json["path"] == null ? "" : json["path"],
        sex: json["sex"] == null ? "" : json["sex"],
        eyesRaw: json["eyes_raw"] == null ? "" : json["eyes_raw"],
        weightMax: json["weight_max"] == null ? 0 : json["weight_max"],
        rewardMin: json["reward_min"] == null ? 0 : json["reward_min"],
        url: json["url"] == null ? "" : json["url"],
        possibleStates: json["possible_states"] == null
            ? []
            : List<String>.from(json["possible_states"].map((x) => x)),
        modified: json["modified"] == null
            ? DateTime.now()
            : DateTime.parse(json["modified"]),
        rewardMax: json["reward_max"] == null ? 0 : json["reward_max"],
        race: json["race"] == null ? "" : json["race"],
        heightMax: json["height_max"] == null ? 0 : json["height_max"],
        placeOfBirth:
            json["place_of_birth"] == null ? "" : json["place_of_birth"],
        heightMin: json["height_min"] == null ? 0 : json["height_min"],
        warningMessage:
            json["warning_message"] == null ? "" : json["warning_message"],
        id: json["@id"] == null ? "" : json["@id"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["files"] = files; //List<dynamic>.from(files.map((x) => x.toJson()));
    data["age_range"] = ageRange; //ageRange;
    data["uid"] = uid; //uid;
    data["weight"] = weight; //weight;
    data["occupations"] = occupations;
    data["field_offices"] =
        fieldOffices; //List<dynamic>.from(fieldOffices.map((x) => x));
    data["locations"] = locations;
    data["reward_text"] = rewardText; //rewardText;
    data["hair"] = hair; //hair;
    data["ncic"] = ncic; //ncic;
    data["dates_of_birth_used"] =
        datesOfBirthUsed; //List<dynamic>.from(datesOfBirthUsed.map((x) => x));
    data["caution"] = caution; //caution;
    data["nationality"] = nationality; //nationality;
    data["age_min"] = ageMin; //ageMin;
    data["age_max"] = ageMax; //ageMax;
    data["scars_and_marks"] = scarsAndMarks; //scarsAndMarks;
    data["subjects"] = subjects; //List<dynamic>.from(subjects.map((x) => x));
    data["aliases"] = aliases; //List<dynamic>.from(aliases.map((x) => x));
    data["race_raw"] = raceRaw; //raceRaw;
    data["suspects"] = suspects;
    data["publication"] = publication; //publication.toIso8601String();
    data["title"] = title; //title;
    data["coordinates"] =
        coordinates; //List<dynamic>.from(coordinates.map((x) => x));
    data["hair_raw"] = hairRaw; //hairRaw;
    data["languages"] =
        languages; //List<dynamic>.from(languages.map((x) => x));
    data["complexion"] = complexion;
    data["build"] = build; //build;
    data["details"] = details; //details;
    data["status"] = status; //status;
    data["legat_names"] = legatNames;
    data["eyes"] = eyes; //eyes;
    data["person_classification"] =
        personClassification; //personClassification;
    data["description"] = description; //description;
    data["images"] =
        images; //List<dynamic>.from(images.map((x) => x.toJson()));
    data["possible_countries"] = possibleCountries;
    data["weight_min"] = weightMin; //weightMin;
    data["additional_information"] = additionalInformation;
    data["remarks"] = remarks; //remarks;
    data["path"] = path; //path;
    data["sex"] = sex; //sex;
    data["eyes_raw"] = eyesRaw; //eyesRaw;
    data["weight_max"] = weightMax; //weightMax;
    data["reward_min"] = rewardMin; //rewardMin;
    data["url"] = url; //url;
    data["possible_states"] =
        possibleStates; //List<dynamic>.from(possibleStates.map((x) => x));
    data["modified"] = modified; //modified?.toIso8601String();
    data["reward_max"] = rewardMax; //rewardMax;
    data["race"] = race; //race;
    data["height_max"] = heightMax; //heightMax;
    data["place_of_birth"] = placeOfBirth; //placeOfBirth;
    data["height_min"] = heightMin; //heightMin;
    data["warning_message"] = warningMessage; //warningMessage;
    data["@id"] = id; //id;
    return data;
  }
}

class FileElement {
  FileElement({
    required this.url,
    required this.name,
  });

  final String? url;
  final String? name;

  factory FileElement.fromJson(Map<String, dynamic> json) => FileElement(
        url: json["url"] == null ? "" : json["url"],
        name: json["name"] == null ? "" : json["name"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["name"] = this.name;
    return data;
  }
}

class FbiImage {
  FbiImage({
    required this.large,
    required this.caption,
    required this.thumb,
    required this.original,
  });

  final String? large;
  final String? caption;
  final String? thumb;
  final String? original;

  factory FbiImage.fromJson(Map<String, dynamic> json) => FbiImage(
        large: json["large"] == null ? "" : json["large"],
        caption: json["caption"] == null ? "" : json["caption"],
        thumb: json["thumb"] == null ? "" : json["thumb"],
        original: json["original"] == null ? "" : json["original"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["large"] = large;
    data["caption"] = caption;
    data["thumb"] = thumb;
    data["original"] = original;
    return data;
  }
}
