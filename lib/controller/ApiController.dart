import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app_config.dart';
import 'package:quran/model/SuraListmodel.dart';
import 'package:quran/model/singleSuraModel.dart';

class ApiController{

  //sura list controller
  static Future<SuraListModel> suraListController()async{
    var res = await http.get(Uri.parse(AppConfig.SURA_LIST));
    var data = jsonDecode(res.body) as Map<String, dynamic>;
    debugPrint("sura list ====== $data");
    debugPrint("sura list status code ====== ${res.statusCode}");
    if(res.statusCode == 200) {
      return SuraListModel.fromJson(data);
    } else {
      return SuraListModel.fromJson(data);
    }
  }
  //sura list controller
  static Future rendomVerse()async{
    var res = await http.get(Uri.parse(AppConfig.RANDOM_DERSE));
    var data = jsonDecode(res.body);
    debugPrint("rendomVerse list ====== $data");
    debugPrint("rendomVerse list status code ====== ${res.statusCode}");
    if(res.statusCode == 200) {
      return data;
    } else {
      return data;
    }
  }


  //Single list controller
  static Future<SingleSuraModel> singleSura({required String suraId, required String verse})async{
    List list = [];
    var res = await http.get(Uri.parse("${AppConfig.SURA_VERSE_LIST}$suraId/$verse"));
    var data = jsonDecode(res.body);
    debugPrint("singleSura==== $data");
    debugPrint("singleSura==== ${res.statusCode}");
    debugPrint("singleSura==== ${AppConfig.SURA_VERSE_LIST}$suraId/$verse");
    if(res.statusCode == 200) {
      return SingleSuraModel.fromJson(data);
    } else {
      return SingleSuraModel.fromJson(data);
    }
  }

}