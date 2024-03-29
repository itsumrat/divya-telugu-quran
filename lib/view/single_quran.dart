import 'dart:convert';
import 'dart:developer';

import 'package:audioplayers/audioplayers.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:quran/app_colors.dart';
import 'package:quran/model/SuraListmodel.dart';
import 'package:quran/model/singleSuraModel.dart';
import 'package:shimmer/shimmer.dart';

import '../app_config.dart';

class SingleQuran extends StatefulWidget {
  final String suraId;
  final String suraName;
  const SingleQuran({
    Key? key,
    required this.suraId,
    required this.suraName,
  }) : super(key: key);

  @override
  State<SingleQuran> createState() => _SingleQuranState();
}

class _SingleQuranState extends State<SingleQuran> {
  var i = 0;
  var iA = 0;

  //audio play
  final audioPlayer = AudioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlay = false;

  //
  FlutterTts flutterTts = FlutterTts();
  var selectVoiceLanguage;

  List<Map<String, dynamic>> suraListName = [];
  var suraName;
  List suraList = [];

  final List suraAyatList = [];
  List ayatList = [];
  String? selectedSura;
  String? selectedAyat;

  Future? suraVerseFuture;
  getSuraVerse(id) async {
    suraAyatList.clear();
    debugPrint("${AppConfig.VERSE_LIST}$id");
    var res = await http.get(Uri.parse("${AppConfig.VERSE_LIST}$id"));
    var data = jsonDecode(res.body);
    debugPrint("suraAyatList === ${jsonDecode(res.body)}");
    debugPrint("suraAyatList === ${res.statusCode}");
    if (res.statusCode == 200) {
      for (var i = 0; i < data.length; i++) {
        setState(() {
          suraAyatList.add(data[i]);
        });
      }

      debugPrint("suraAyatList === ${jsonDecode(res.body)}");
      singleSuraVarsFuture = singleSura(suraId: id, verse: suraAyatList[0]);
      return suraAyatList;
    } else {
      debugPrint("something went wrong");
    }
  }

  late Future<SingleSuraModel> singleSuraModel;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSuraList();
    log("widget.suraName === ${widget.suraId}");
    suraName = widget.suraName;
    suraVerseFuture = getSuraVerse(widget.suraId.toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.mainColor,
        title: Text("$suraName"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            flutterTts.stop();
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder(
        future: suraVerseFuture,
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColors.mainColor,
              ),
            );
          } else if (snapshot.hasData) {
            return suraAyatList.isNotEmpty
                ? SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        suraAyatList.isNotEmpty
                            ? Container(
                                width: size.width,
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 15, bottom: 15),
                                color: Colors.grey.shade100,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        log("i===== $i");
                                        if (i > 0) {
                                          i--;
                                          setState(() {
                                            suraVerseFuture = getSuraVerse(
                                                suraListName[i]["id"]
                                                    .toString());
                                            suraName = suraListName[i]["name"];
                                            selectedSura = suraListName[i]["id"]
                                                .toString();
                                          });
                                        }
                                        setState(() {});
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white),
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_back_ios,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      child: Container(
                                        width: size.width * .65,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white),
                                        child: Center(
                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton2(
                                              isExpanded: true,
                                              hint: Text(
                                                '$suraName',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                              ),
                                              items: [
                                                for (var i = 0;
                                                    i < suraListName.length;
                                                    i++)
                                                  DropdownMenuItem<String>(
                                                    value: suraListName[i]["id"]
                                                        .toString(),
                                                    child: Text(
                                                      suraListName[i]["name"]
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  )
                                              ],
                                              value: selectedSura,
                                              onChanged: (value) {
                                                setState(() {
                                                  selectedSura =
                                                      value.toString();
                                                  for (var map
                                                      in suraListName) {
                                                    if (map.containsKey("id")) {
                                                      if (map["id"]
                                                              .toString() ==
                                                          value.toString()) {
                                                        // your list of map contains key "id" which has value 3
                                                        suraName = map["name"];
                                                        i = int.parse(
                                                                "${map["index"]}") -
                                                            1;
                                                      }
                                                    }
                                                  }
                                                });
                                                suraVerseFuture = getSuraVerse(
                                                    value.toString());
                                              },
                                              buttonStyleData:
                                                  const ButtonStyleData(
                                                height: 30,
                                                width: 200,
                                              ),
                                              menuItemStyleData:
                                                  const MenuItemStyleData(
                                                height: 40,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        i++;
                                        setState(() {
                                          suraName = suraListName[i]["name"];
                                          selectedSura =
                                              suraListName[i]["id"].toString();
                                          suraVerseFuture = getSuraVerse(
                                              suraListName[i]["id"].toString());
                                        });
                                        log("suraListName == ${suraListName[i]}");
                                        log("suraListName == $i");
                                      },
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white),
                                        child: const Center(
                                          child: Icon(
                                            Icons.arrow_forward_ios,
                                            color: Colors.black,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : const Text("No Verse available"),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: size.width * .70,
                          height: 50,
                          margin: const EdgeInsets.only(left: 30, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  if (iA > 0) {
                                    iA--;
                                    setState(() {
                                      selectedAyat = suraAyatList[iA];
                                      singleSuraVarsFuture = singleSura(
                                          suraId: widget.suraId,
                                          verse: selectedAyat!);
                                    });
                                  }
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  padding: const EdgeInsets.only(left: 8),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 1, color: Colors.black)),
                                  child: const Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              Container(
                                width: size.width * .40,
                                height: 40,
                                padding:
                                    const EdgeInsets.only(left: 15, right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        width: 1, color: Colors.black)),
                                child: Center(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton2(
                                      isExpanded: true,
                                      hint: Text(
                                        '${suraAyatList[0]}',
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: Theme.of(context).hintColor,
                                        ),
                                      ),
                                      items: suraAyatList.map((item) {
                                        return DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(
                                            item,
                                            style: const TextStyle(
                                              fontSize: 14,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      value: selectedAyat,
                                      onChanged: (value) {
                                        log("this is value ===${value!.length}");
                                        setState(() {
                                          selectedAyat = value;
                                          singleSuraVarsFuture = singleSura(
                                              suraId: widget.suraId,
                                              verse: selectedAyat!);
                                          iA = suraAyatList.indexOf(value);
                                        });
                                      },
                                      buttonStyleData: const ButtonStyleData(
                                        height: 40,
                                        width: 140,
                                      ),
                                      menuItemStyleData:
                                          const MenuItemStyleData(
                                        height: 40,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  iA++;
                                  setState(() {
                                    selectedAyat = suraAyatList[iA];
                                    singleSuraVarsFuture = singleSura(
                                        suraId: widget.suraId,
                                        verse: selectedAyat!);
                                  });
                                },
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(100),
                                      border: Border.all(
                                          width: 1, color: Colors.black)),
                                  child: const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 5, bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Arabic",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Container(
                                    width: size.width,
                                    height: size.height * .35,
                                    padding: const EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        // border: Border.all(width: 1, color: AppColors.mainColor),
                                        borderRadius: BorderRadius.circular(10),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/border-img.png"),
                                            fit: BoxFit.fill)),
                                    child: isSuraLoading == false
                                        ? SingleChildScrollView(
                                            child: Html(
                                              data: '''
                                ${suravarse["arabic_all"]} 
                                ''',
                                              style: {
                                                "h3": Style(
                                                  fontSize: const FontSize(20),
                                                  textAlign: TextAlign.right,
                                                  lineHeight:
                                                      const LineHeight(1.4),
                                                ),
                                                "span": Style(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20),
                                                    width: 50,
                                                    fontSize:
                                                        const FontSize(20),
                                                    color: AppColors.mainColor,
                                                    // backgroundColor: AppColors.mainColor,
                                                    border: Border.all(
                                                        width: 30,
                                                        color: AppColors.white),
                                                    fontWeight: FontWeight.w500,
                                                    before: " ❬",
                                                    after: "❭ ")
                                              },
                                            ),
                                          )
                                        : Column(
                                            children: [
                                              for (var i = 0; i < 6; i++)
                                                Container(
                                                  width: size.width,
                                                  height: 18,
                                                  margin: const EdgeInsets.only(
                                                      bottom: 5),
                                                  child: buildTextShimmer(),
                                                ),
                                            ],
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "భావానువాదం",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.green),
                                  ),
                                  suravarse != null
                                      ? Html(
                                          data: '''
                                ${suravarse["telegu_all"]}
                                ''',
                                          style: {
                                            "h3": Style(
                                                fontSize: const FontSize(20),
                                                fontWeight: FontWeight.w400),
                                            "span": Style(
                                                padding: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                margin: const EdgeInsets.only(
                                                    left: 20, right: 20),
                                                width: 50,
                                                fontSize: const FontSize(20),
                                                color: AppColors.mainColor,
                                                // backgroundColor: AppColors.mainColor,
                                                border: Border.all(
                                                    width: 30,
                                                    color: AppColors.white),
                                                fontWeight: FontWeight.w500,
                                                before: " ❬",
                                                after: "❭ ")
                                          },
                                        )
                                      : Column(
                                          children: [
                                            for (var i = 0; i < 6; i++)
                                              Container(
                                                width: size.width,
                                                height: 18,
                                                margin: const EdgeInsets.only(
                                                    bottom: 5),
                                                child: buildTextShimmer(),
                                              ),
                                          ],
                                        ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  )
                : const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.mainColor),
                  );
          } else {
            return const Center(child: Text("Verse number is empty."));
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton:
          suravarse != null && suravarse["item"]["path"] != null
              ? FloatingActionButton(
                  backgroundColor: AppColors.mainColor,
                  onPressed: () {
                    if (isPlay) {
                      audioPlayer.pause();
                    } else {
                      audioPlayer.play(UrlSource(
                          "https://app.tiptrust.in/storage/app/${suravarse["item"]["path"]}"));
                    }
                    setState(() => isPlay = !isPlay);

                    log("isPlay === $isPlay");
                  },
                  child: Icon(
                    isPlay ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 30,
                  ),
                )
              : const SizedBox(),
    );
  }

  Shimmer buildTextShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.white,
      child: Container(
        color: Colors.white,
      ),
    );
  }

  left() {
    var i = 0;

    if (i > 0) {
      i = i - 1;
    }
    setState(() {
      selectedSura = suraListName[i]["name"];
    });
  }

  right() {
    if (i > 0) {
      i + 1;
    }
    log(" this is i $i");
    setState(() {
      selectedSura = suraListName[i]["name"];
    });

    log(" this is i $suraListName");
  }

  Future? singleSuraVarsFuture;
  List singleSuraVerseList = [];
  bool isSuraLoading = false;
  var suravarse;
  singleSura({required String suraId, required String verse}) async {
    singleSuraVerseList.clear();
    setState(() => isSuraLoading = true);
    var res =
        await http.get(Uri.parse("${AppConfig.SURA_VERSE_LIST}$suraId/$verse"));
    var data = jsonDecode(res.body);
    log("singleSuraVerseList data ==== $data");
    if (res.statusCode == 200) {
      suravarse = data;
      log('suravarse["arabic_all"] ${suravarse["item"]["path"]}');

      // list.forEach((singleSuraVerseList){
      //   arbi_text.write(singleSuraVerseList["arabic_verse"]);
      // });
      setState(() => isSuraLoading = false);
      return data;
    } else {
      return data;
    }
  }

  //sura lsit
  Future getSuraList() async {
    var res = await http.get(Uri.parse(AppConfig.SURA_LIST));
    var data = jsonDecode(res.body)["data"];
    debugPrint("sura list ====== ${data.length}");
    debugPrint("sura list status code ====== ${res.statusCode}");
    if (res.statusCode == 200) {
      for (var i = 0; i < data.length; i++) {
        suraListName.addAll([
          {
            "name": data[i]["telegu_name"],
            "id": data[i]["id"],
            "index": data[i]["surah_number"]
          }
        ]);
        log("suraListName === ${data[i]}");
      }
      log("suraListName === $suraListName");
      return;
    } else {
      return SuraListModel.fromJson(data);
    }
  }

  voiceStart(text, lng) async {
    // setState(() =>  isPlay = true);
    // flutterTts.setLanguage("$lng");
    // flutterTts.speak("$text");
    // flutterTts.setEngine("com.google.android.tts");
    //
    // flutterTts.setCompletionHandler(() {
    //   setState(() =>  isPlay = false);
    //   flutterTts.stop();
    // });
    // tts.pause();
  }

  voiceStop() {
    setState(() => isPlay = false);
    flutterTts.pause();
  }

  showLang(text) async {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              const Text(
                "Select Language",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Arabic'),
                onTap: () {
                  voiceStart(text, "ar");
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.play_arrow),
                title: const Text('Tamil'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }
}
