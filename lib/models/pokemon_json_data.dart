import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class PokemonOnlineData extends Equatable {
  String? number;
  String? name;
  String? species;
  List<String>? types;
  Abilities? abilities;
  List<String>? eggGroups;
  List<double>? gender;
  String? height;
  String? weight;
  bool? starter;
  bool? legendary;
  bool? mythical;
  bool? ultraBeast;
  bool? mega;
  int? gen;
  String? sprite;
  String? description;

  PokemonOnlineData(
      {this.number,
      this.name,
      this.species,
      this.types,
      this.abilities,
      this.eggGroups,
      this.gender,
      this.height,
      this.weight,
      this.starter,
      this.legendary,
      this.mythical,
      this.ultraBeast,
      this.mega,
      this.gen,
      this.sprite,
      this.description});

  PokemonOnlineData.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    species = json['species'];
    types = json['types'].cast<String>();
    abilities = json['abilities'] != null
        ? Abilities.fromJson(json['abilities'])
        : null;
    eggGroups = json['eggGroups'].cast<String>();
    gender = json['gender'].cast<double>();
    height = json['height'];
    weight = json['weight'];
    starter = json['starter'];
    legendary = json['legendary'];
    mythical = json['mythical'];
    ultraBeast = json['ultraBeast'];
    mega = json['mega'];
    gen = json['gen'];
    sprite = json['sprite'];
    description = json['description'];
  }

  @override
  String toString() {
    return "<POD | $number - $name>";
  }

  @override
  List<Object?> get props =>
      [number, name, starter, legendary, mythical, ultraBeast, mega];
}

class Abilities {
  List<String>? normal;
  List<String>? hidden;

  Abilities({this.normal, this.hidden});

  Abilities.fromJson(Map<String, dynamic> json) {
    normal = json['normal'].cast<String>();
    hidden = json['hidden'].cast<String>();
  }
}
