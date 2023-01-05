import 'dart:collection';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:harcapp_core_own_song/song_raw.dart';
import 'package:harcapp_web/articles/article_editor/common.dart';

Future<HashMap<String, List<SongRaw>>> decodeSongs(String allSongsCode) async{

  Map allSongsJSONMap = jsonDecode(allSongsCode);

  // OFFICIAL SONGS
  HashMap<String, List<SongRaw>> songsMap = HashMap(
    equals: (str1, str2) => str1 == str2,
    hashCode: (str) => str.hashCode,
  );

  for(String fileName in allSongsJSONMap['official'].keys) {
    try {
      Map songMap = allSongsJSONMap['official'][fileName]['song'];
      SongRaw song = SongRaw.fromRespMap(fileName, songMap);
      String title = remSpecChars(remPolChars(song.title.toLowerCase())).trim();
      if(!songsMap.containsKey(title)) songsMap[title] = [];
      songsMap[title]!.add(song);
      for(String hidTitle in song.hidTitles){
        hidTitle = remSpecChars(remPolChars(hidTitle.toLowerCase())).trim();
        if(!songsMap.containsKey(hidTitle))
          songsMap[hidTitle] = [];
        songsMap[hidTitle]!.add(song);
      }
    } on Error catch(e){}
  }

  // CONFIDENTIAL SONGS
  for(String fileName in allSongsJSONMap['conf'].keys) {
    try {
      Map songMap = allSongsJSONMap['conf'][fileName]['song'];
      SongRaw song = SongRaw.fromRespMap(fileName, songMap);
      String title = remSpecChars(remPolChars(song.title.toLowerCase())).trim();
      if(!songsMap.containsKey(title)) songsMap[title] = [];
      songsMap[title]!.add(song);
      for(String hidTitle in song.hidTitles){
        hidTitle = remSpecChars(remPolChars(hidTitle.toLowerCase())).trim();
        if(!songsMap.containsKey(hidTitle))
          songsMap[hidTitle] = [];
        songsMap[hidTitle]!.add(song);
      }
    } on Error catch(e){}
  }

  return songsMap;

}

Future<HashMap<String, List<SongRaw>>> loadSongs()async{
  String allSongsCode = await rootBundle.loadString('assets/songs/all_songs.hrcpsng');
  return await compute(decodeSongs, allSongsCode);
}