import 'dart:async';
import 'dart:convert';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:whatmedi3/pages/searchlistpage.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:flutter/services.dart';
import 'package:whatmedi3/pages/selectedmedilsit.dart';

class Medicine {
  final String entpName;
  final String itemName;
  final String efcyQesitm;
  final String useMethodQesitm;
  final String atpnWarnQesitm;
  final String depositMethodQesitm;
  final String itemImage;

  Medicine({
    required this.entpName,
    required this.itemName,
    required this.efcyQesitm,
    required this.useMethodQesitm,
    required this.atpnWarnQesitm,
    required this.depositMethodQesitm,
    required this.itemImage,
  });

  factory Medicine.fromJson(Map<String, dynamic> json) {
    return Medicine(
      entpName: json['entpName'] ?? "",
      itemName: json['itemName'] ?? "",
      efcyQesitm: json['efcyQesitm'] ?? "",
      useMethodQesitm: json['useMethodQesitm'] ?? "",
      atpnWarnQesitm: json['atpnWarnQesitm'] ?? "",
      depositMethodQesitm: json['depositMethodQesitm'] ?? "",
      itemImage: json['itemImage'] ?? "",
    );
  }
}

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FlutterTts tts = FlutterTts();

  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tts.stop();
    super.dispose();
  } //일단 넣어본것

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Searchpageappbar(),
      body: SearchPageBody(),
    );
  }

  AppBar Searchpageappbar() {
    return AppBar(
      toolbarHeight: MediaQuery
          .of(context)
          .size
          .height * 0.2,
      backgroundColor: whatmedicol.kPrimaryColor,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  SelectedMedi(),
            ),
          );
        },
      ),
      centerTitle: true,
      title: Image.asset("assets/images/whatmedi.png",
          fit: BoxFit.contain,
          height: AppBar().preferredSize.height * 1.5, //어느 핸드폰이든 보일 수 있도록.
          width: AppBar().preferredSize.height * 1.5),
    );
  }
}

class SearchPageBody extends StatefulWidget {
  const SearchPageBody({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchPageBody> createState() => _SearchPageBodyState();
}

class _SearchPageBodyState extends State<SearchPageBody> {
  TextEditingController editingController = TextEditingController();

  List<Medicine> _medicine = [];
  bool showingtextbool = true;

  Future<List<Medicine>> fetchmedicine(String query) async {
    final response = await http.get(Uri.parse(
        'https://apis.data.go.kr/1471000/DrbEasyDrugInfoService/getDrbEasyDrugList?serviceKey=1seDo%2B5IFGgwzsks7oQt9Ti4ZqqBvlSqD6eBdMj667Y8tVglw63uYN%2FMKikNxCa8VboXyB2shoOfIgmfyieMfg%3D%3D&pageNo=1&numOfRows=20&itemName=$query&type=json'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> items = data['body']['items'] ?? [];
      if (items == []) {
        _medicine = [];
        return _medicine; // 빈 리스트나 다른 기본값을 반환
      }
      final int totalnum = data['body']['totalCount'];
      toast = totalnum;
      // Medicine 객체의 리스트로 변환
      List<Medicine> medicines =
      items.map((item) => Medicine.fromJson(item)).toList();
      _medicine = medicines;
      return _medicine;
    } else {
      Fluttertoast.showToast(
        msg: '약품 정보를 가져오는데 실패하였습니다. 다시 검색해주세요',
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(0.7),
        textColor: Colors.white,
      );
      throw Exception('약 정보를 가져오는데 실패하였습니다.');
    }
  }

  int toast = 0;
  String medinametext = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Container(
        margin: EdgeInsets.only(bottom: 20 * 2.5),
        // It will cover 20% of our total height
        height: size.height * 0.3,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 36 + 20,
              ),
              height: size.height * 0.3 - 27,
              decoration: BoxDecoration(
                border: Border.all(color: whatmedicol.kPrimaryColor),
                color: whatmedicol.kPrimaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Row(
                children: <Widget>[
                  Text(
                    '안녕하세요\n아래의 검색탭을 이용해서\n찾고싶은 약을 검색해보세요',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headline5
                        ?.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Spacer(),
                  // Image.asset(
                  //   "assets/images/whatmedi2.png",
                  //   width: size.width * 0.2,
                  //   height: size.width * 0.2,
                  // )
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Semantics(child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: 54,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        offset: Offset(0, 20),
                        blurRadius: 50,
                        color: whatmedicol.kPrimaryColor.withOpacity(0.23),
                      ),
                    ],
                  ),
                  child: Semantics( //일단은 여기서 semantics를 wrapping해줬는데 안되면 하나 위의 container 위에서 wrapping 해주는게 좋을듯
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            onChanged: (value) {
                              medinametext = value;
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                              hintText: "Search",
                              hintStyle: TextStyle(
                                color:
                                whatmedicol.kPrimaryColor.withOpacity(0.5),
                              ),
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  Icons.search,
                                  color: whatmedicol.kPrimaryColor,
                                ),
                                onPressed: () async {
                                  if (medinametext.isEmpty) {
                                    Fluttertoast.showToast(msg: '입력값이 없습니다');
                                  } else {
                                    if (medinametext.isNotEmpty) {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        // 다이얼로그 바깥을 터치해도 닫히지 않도록 설정
                                        builder: (BuildContext context) {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                      );
                                      try {
                                        await fetchmedicine(medinametext);
                                      } catch (e) {
                                        print(e);
                                      }
                                      Navigator.of(context).pop();
                                    }
                                    //시간 재는 기능 시작
                                    if (toast == 0) {
                                      Fluttertoast.showToast(
                                        msg: '찾으시는 약품이 없습니다',
                                        gravity: ToastGravity.CENTER,
                                        // 화면에 표시될 위치 (TOP, CENTER, BOTTOM)
                                        timeInSecForIosWeb: 1,
                                        // iOS 및 웹에서 표시될 시간 (초 단위)
                                        backgroundColor:
                                        Colors.black.withOpacity(0.7),
                                        // 배경 색상 및 투명도
                                        textColor: Colors.white, // 텍스트 색상
                                      );
                                    } else {
                                      if (_medicine != []) {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    mediListPage(
                                                        medicine: _medicine,
                                                        searchname:
                                                        medinametext)));
                                      }
                                    }
                                  }
                                },
                              ),
                            ),
                            onSubmitted: (value) async {
                              if (medinametext.isEmpty) {
                                Fluttertoast.showToast(msg: '입력값이 없습니다');
                              } else {
                                if (medinametext.isNotEmpty) {
                                  showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    // 다이얼로그 바깥을 터치해도 닫히지 않도록 설정
                                    builder: (BuildContext context) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    },
                                  );
                                  try {
                                    await fetchmedicine(medinametext);
                                  } catch (e) {
                                    print(e);
                                  }
                                  Navigator.of(context).pop();
                                }
                                //시간 재는 기능 시작
                                if (toast == 0) {
                                  Fluttertoast.showToast(
                                    msg: '찾으시는 약품이 없습니다',
                                    gravity: ToastGravity.CENTER,
                                    // 화면에 표시될 위치 (TOP, CENTER, BOTTOM)
                                    timeInSecForIosWeb: 1,
                                    // iOS 및 웹에서 표시될 시간 (초 단위)
                                    backgroundColor:
                                    Colors.black.withOpacity(0.7),
                                    // 배경 색상 및 투명도
                                    textColor: Colors.white, // 텍스트 색상
                                  );
                                } else {
                                  if (_medicine != []) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                mediListPage(
                                                    medicine: _medicine,
                                                    searchname: medinametext)));
                                  }
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  )),),
            ),
          ],
        ),
      ),
    );
  }
}
