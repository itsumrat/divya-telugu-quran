import 'package:flutter/material.dart';
import 'package:quran/view/home.dart';

class Flash extends StatefulWidget {
  const Flash({Key? key}) : super(key: key);

  @override
  State<Flash> createState() => _FlashState();
}

class _FlashState extends State<Flash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      // Do something
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>Home()), (route) => false);
    });
  }
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        height: size.height,
        width: size.width,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("assets/images/logo.png",
                height: 100, width: 100,
              ),
            ),
            SizedBox(height: 30,),
            Text("సరిగ్గా 2 డెమో డిజైన్‌లు.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60, width: 60,
        margin: EdgeInsets.only(bottom: 50),
        child: Image.asset("assets/images/sponser.jpeg", height: 40, width: 40,),
      ),
    );
  }
}
