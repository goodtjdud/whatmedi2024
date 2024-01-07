import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:flutter/services.dart';

class SearchedPage extends StatefulWidget {
  const SearchedPage({super.key, required this.mediinfo});
  final Map mediinfo;
  static List<Map<String, String>> selected = [];
  @override
  State<SearchedPage> createState() => _SearchedPageState();
}

class _SearchedPageState extends State<SearchedPage> {


  @override
  void initState() {
    super.initState();
    if (SearchedPage.selected.isEmpty) {
      SearchedPage.selected = [];
    }
  }
  ///widget.mediinfo 이런방식이 상위 위젯의 변수를 가져오는 올바른 방법.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상세정보'),
        titleTextStyle: TextStyle(
            color: whatmedicol.kPrimaryColor,
            fontSize: 20,
            fontWeight: FontWeight.w600),
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: whatmedicol.kPrimaryColor),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              Future<void> saveDataToSharedPreferences() async {
                SearchedPage.selected.add(
                  {
                    '제품명': widget.mediinfo['품목명'],
                    '제조사': widget.mediinfo['제조사'],
                    '효과': widget.mediinfo['효능'],
                    '사용법': widget.mediinfo['사용'],
                    '주의사항': widget.mediinfo['주의'],
                    '이미지': widget.mediinfo['이미지'],
                  },
                );
                String selectedJson = json.encode(SearchedPage.selected);
                SharedPreferences prefs =
                await SharedPreferences.getInstance();
                await prefs.setString('selected_data', selectedJson);
              }
              await saveDataToSharedPreferences();
            },
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
          child: ListView(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                padding: EdgeInsets.all(30),
                child: ClipRRect(
                  child: widget.mediinfo['이미지'].isNotEmpty
                      ? Image.network(widget.mediinfo['이미지'])
                      : Image.asset(
                    "assets/images/meddefaultimage.png",
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
              Container(child: InfoBox(infotitle: '제품명', info: widget.mediinfo['품목명'], titlelength: 3)),
              Container(child: InfoBox(infotitle: '제조사', info: widget.mediinfo['제조사'], titlelength: 3)),
              Container(child: InfoBox(infotitle: '효과', info: widget.mediinfo['효능'], titlelength: 2)),
              Container(child: InfoBox(infotitle: '사용법', info: widget.mediinfo['사용'], titlelength: 3)),
              Container(child: InfoBox(infotitle: '주의사항', info: widget.mediinfo['주의'], titlelength: 4)),
            ],
          )),
    );
  }
}

class InfoBox extends StatelessWidget {
  InfoBox({super.key, required this.infotitle, required this. info, required this.titlelength});
  final String infotitle;
  final String info;
  final int titlelength;

  TextStyle bold = TextStyle(
    color: Colors.black,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  TextStyle regular = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            infotitle,
            style: bold,
          ),
          Container(
            height: 3,
            width: titlelength * 19,
            color: whatmedicol.kPrimaryColor.withOpacity(0.3),
          ),
          RichText(
            text: TextSpan(text: info, style: regular),
          ),
          Divider(
            color: whatmedicol.kPrimaryColor.withOpacity(0.1),
          )
        ],
      ),
    );
  }
}



//
// class SearchedPage extends StatefulWidget {
//   const SearchedPage({Key? key, required this.mediinfo}) : super(key: key);
//   final Map mediinfo;
//   static List<Map<String, String>> selected = [];
//
//   //final double speechRateInt;
//   @override
//   State<SearchedPage> createState() => _SearchedPageState();
// }
//
// class _SearchedPageState extends State<SearchedPage> {
//
//   @override
//   void initState() {
//     super.initState();
//     if (SearchedPage.selected.isEmpty) {
//       SearchedPage.selected = [];
//     }
//   }
//   ///widget.mediinfo 이런방식이 상위 위젯의 변수를 가져오는 올바른 방법.
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('상세정보'),
//         titleTextStyle: TextStyle(
//             color: whatmedicol.kPrimaryColor,
//             fontSize: 20,
//             fontWeight: FontWeight.w600),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         iconTheme: IconThemeData(color: whatmedicol.kPrimaryColor),
//         elevation: 0,
//         actions: <Widget>[
//           IconButton(
//               icon: Icon(Icons.add),
//               onPressed: () async {
//                 Future<void> saveDataToSharedPreferences() async {
//                   SearchedPage.selected.add(
//                     {
//                       '제품명': widget.mediinfo['품목명'],
//                       '제조사': widget.mediinfo['제조사'],
//                       '효과': widget.mediinfo['효능'],
//                       '사용법': widget.mediinfo['사용'],
//                       '주의사항': widget.mediinfo['주의'],
//                       '이미지': widget.mediinfo['이미지'],
//                     },
//                   );
//                   String selectedJson = json.encode(SearchedPage.selected);
//                   SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                   await prefs.setString('selected_data', selectedJson);
//                 }
//                 await saveDataToSharedPreferences();
//               },
//               )
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: SafeArea(
//           child: ListView(
//         children: [
//           Container(
//             width: MediaQuery.of(context).size.width * 0.5,
//             padding: EdgeInsets.all(30),
//             child: ClipRRect(
//               child: widget.mediinfo['이미지'].isNotEmpty
//                   ? Image.network(widget.mediinfo['이미지'])
//                   : Image.asset(
//                       "assets/images/meddefaultimage.png",
//                     ),
//               borderRadius: BorderRadius.all(Radius.circular(10)),
//             ),
//           ),
//           infoBox('제품명', widget.mediinfo['품목명'] ?? '값이없음'),
//           infoBox('제조사', widget.mediinfo['제조사'] ?? '값이없음'),
//           infoBox('효과', widget.mediinfo['효능'] ?? '값이없음'),
//           infoBox('사용법', widget.mediinfo['사용'] ?? '값이없음'),
//           infoBox('주의사항', widget.mediinfo['주의'] ?? '값이없음'),
//         ],
//       )),
//     );
//   }
// }


///기존 ui
