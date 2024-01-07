import 'package:flutter/material.dart';

import '../backdata/colors.dart';


class SelectedMediinfo extends StatefulWidget {
  const SelectedMediinfo({super.key, required this.mediinfo});
  final Map mediinfo;
  @override
  State<SelectedMediinfo> createState() => _SelectedMediinfoState();
}

class _SelectedMediinfoState extends State<SelectedMediinfo> {

  @override
  void initState() {
    super.initState();
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