//import 'dart:convert';

enum PlayerType { hitter, pitcher }

extension showPlayerType on PlayerType {
  String toShortString() {
    String shortString;
    shortString = this.toString().split('.').last;
    return shortString;
  }
}

class Player {
  String id;
  //String bats;
  //String throws;
  String firstName;
  String lastName;
  //String twitterHandler;
  //String email;
  //int weight;
  //String weightUnit;
  //int height;
  //String heightUnit;
  //String positions;

  Player({this.id, this.firstName, this.lastName});
  /*Player({this.id, this.bats, this.throws, this.firstName, this.lastName,
  this.twitterHandler, this.email, this.weight, this.height, this.positions});*/

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] as String,
      //bats: json['bats'] as String,
      //throws: json['throws'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      /*twitterHandler: json['twitterHandler'] as String,
      email: json['email'] as String,
      weight : json["weight"] == null ? null : json["weight"],
      weightUnit: json["weightUnit"] == null ? null : json["weightUnit"],
      height : json["height"] == null ? null : json["height"],
      heightUnit: json["heightUnit"] == null ? null : json["heightUnit"],
      positions : json["positions"],*/
    );
  }

  /// Returns a String containing the first and last name.
  String getFullName() {
    String fullName = firstName + ' ' + lastName;
    return fullName;
  }

  String getAbbreviatedName() {
    String firstInitial = firstName[0];
    String abbreviatedName = '$firstInitial. $lastName';
    return abbreviatedName;
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        //"bats" : bats,
        //"throws" : throws,
        "firstName": firstName,
        "lastName": lastName,
        /*"twitterHandler" : twitterHandler,
    "email" : email,
    "weight": weight == null ? null : weight,
    "weightUnit": weightUnit == null ? null : weightUnit,
    "height": height == null ? null : height,
    "heightUnit": heightUnit == null ? null : heightUnit,
    "positions" : positions,*/
      };

  @override
  String toString() {
    String toStr = '[';
    toStr += 'Player Id: $id, ';
    toStr += 'First Name: $firstName, ';
    toStr += 'Last Name: $lastName';
    toStr += ']';
    return toStr;
  }
}
