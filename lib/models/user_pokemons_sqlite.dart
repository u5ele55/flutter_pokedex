import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class UserPokemon extends Equatable {
  final int id;
  final int catched;
  final bool isFavorite;

  const UserPokemon(this.id, this.catched, this.isFavorite);
  const UserPokemon.fromSQL(this.id, this.catched, int isF)
      : isFavorite = isF == 0;

  UserPokemon copyWith({int? id, int? catched, bool? isFavorite}) {
    return UserPokemon(
      id ?? this.id,
      catched ?? this.catched,
      isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'catched': catched,
      'is_favorite': isFavorite ? 1 : 0,
    };
  }

  @override
  String toString() {
    return 'UserPokemon{id: $id, catched: $catched, isFavorite: $isFavorite}';
  }

  @override
  List get props => [id, catched, isFavorite];
}

class UserPokemonsSQLite {
  get _database async => openDatabase(
        join(await getDatabasesPath(), 'user_pokemons.db'),
        onCreate: (db, version) {
          return db.execute(
            'CREATE TABLE user_pokemons(id INTEGER PRIMARY KEY, catched INTEGER, is_favorite INTEGER)',
          );
        },
        version: 1,
      );

  Future<void> insert(UserPokemon pokemon) async {
    final db = await _database;
    await db.insert(
      'user_pokemons',
      pokemon.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<UserPokemon>> getDBasList() async {
    final db = await _database;

    final List<Map<String, dynamic>> maps = await db.query('user_pokemons');
    return List.generate(maps.length, (i) {
      return UserPokemon.fromSQL(
        maps[i]['id'],
        maps[i]['catched'],
        maps[i]['is_favorite'],
      );
    });
  }

  Future<UserPokemon?> getById(int id) async {
    final db = await _database;

    final List<Map<String, dynamic>> raw =
        await db.query('user_pokemons', where: "id = ?", whereArgs: [id]);

    if (raw.isEmpty) return null;
    return UserPokemon.fromSQL(
        raw[0]["id"], raw[0]["catched"], raw[0]["is_favorite"]);
  }

  Future<void> update(UserPokemon userPokemon) async {
    final db = await _database;

    await db.update(
      'user_pokemons',
      userPokemon.toMap(),
      where: 'id = ?',
      whereArgs: [userPokemon.id],
    );
  }

  Future<void> delete(int id) async {
    final db = await _database;

    await db.delete(
      'user_pokemons',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
