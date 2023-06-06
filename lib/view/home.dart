import 'package:flutter/material.dart';
import 'package:quran/controller/ApiController.dart';
import 'package:quran/model/SuraListmodel.dart';
import 'package:quran/view/single_quran.dart';
import 'package:shimmer/shimmer.dart';

import '../app_colors.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List suraModelListName=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    suraList = ApiController.suraListController();
    rendomVerse = ApiController.rendomVerse();
  }

  late Future<SuraListModel> suraList;
  late Future rendomVerse;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            automaticallyImplyLeading: false,
          backgroundColor: AppColors.mainColor,
          title: Text("Al Quran"),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.mainColor
                  
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width:size.width*.60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("అల్ ఖురాన్",
                                style: TextStyle(
                                  fontSize: 28,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold
                                ),
                              ),

                              SizedBox(height: 15,),

                              FutureBuilder(
                                future: rendomVerse,
                                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                                  if(snapshot.connectionState == ConnectionState.waiting){
                                    return Shimmer.fromColors(
                                      baseColor:  Colors.grey,
                                      highlightColor: Colors.white,
                                      child: Container(
                                        height: 15,
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor.withOpacity(0.5),
                                          borderRadius: BorderRadius.circular(100)
                                        ),
                                      ),
                                    );
                                  }else if(snapshot.hasData){
                                    return Text("${snapshot.data["quote"]["telegu_verse"]}",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400
                                      ),
                                    );
                                  }else{
                                    return Text("No date found here.",
                                      overflow: TextOverflow.clip,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400
                                      ),
                                    );
                                  }

                                }
                              ),

                              // SizedBox(height: 20,),
                              // Container(
                              //  height: 40, width: 150,
                              //   padding: EdgeInsets.only(left: 10),
                              //   decoration: BoxDecoration(
                              //     color: Colors.transparent,
                              //     borderRadius: BorderRadius.circular(5),
                              //     border: Border.all(width: 1, color: Colors.white)
                              //   ),
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.start,
                              //     children: [
                              //       Icon(Icons.play_arrow_outlined, color: Colors.white,),
                              //       SizedBox(width: 10,),
                              //       Text("Read Quran",
                              //         style: TextStyle(
                              //             fontSize: 15,
                              //             color: Colors.white,
                              //             fontWeight: FontWeight.bold
                              //         ),
                              //       ),
                              //
                              //     ],
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        Image.asset("assets/images/quran.png", height: 70, width: 70, opacity: const AlwaysStoppedAnimation(.5),)
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 30,),

              FutureBuilder<SuraListModel>(
                future: suraList,
                builder: (context,AsyncSnapshot<SuraListModel> snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return  Expanded(
                    child: ListView.builder(
                      itemCount: 10,
                      itemBuilder: (_, index){
                        return Shimmer.fromColors(
                          baseColor:  Colors.white,
                          highlightColor: Colors.grey.shade100,
                          child: Container(
                            margin: EdgeInsets.all(10),
                            height: 60,
                            width: size.width,
                            color: AppColors.white,
                          ),
                        );
                       }
                      )
                    );
                  }else if(snapshot.hasData){
                    return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.data.length,
                          itemBuilder: (_, index){
                            var data = snapshot.data!.data[index];
                            return InkWell(
                              onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>SingleQuran(suraId: "${data.id}", suraName: data.teleguName,))),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(0),
                                    decoration: BoxDecoration(
                                      color: AppColors.white,
                                      //border: Border.all(width: 1, color: AppColors.mainColor),
                                    ),
                                    child: ListTile(
                                      horizontalTitleGap: 10,

                                      leading: Container(
                                        width: 40,
                                        height:40,
                                        decoration: BoxDecoration(
                                          color: AppColors.mainColor,
                                          borderRadius: BorderRadius.circular(5)
                                        ),
                                        child: Center(child: Text("${data.surahNumber}", style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white
                                        ),),),
                                      ),
                                      title: Text("${data.teleguName}",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.mainColor
                                        ),
                                      ),
                                      subtitle: Padding(
                                        padding: const EdgeInsets.only(top: 0.0),
                                        child: Text("${data.englishName}",
                                          style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                      trailing: Icon(Icons.double_arrow_outlined, color: AppColors.mainColor,),
                                    ),
                                  ),
                                  Divider(height: 2, color: Colors.grey.shade300,)
                                ],
                              ),
                            );
                          },
                        )
                    );
                  }else{
                    return Padding(
                      padding: EdgeInsets.only(top: size.height*.30),
                      child: Center(child: Text("No Sura foun.")),
                    );
                  }

                }
              )
            ],
          ),
        ),
      ),
    );
  }

}
