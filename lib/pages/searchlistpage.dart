import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:whatmedi3/pages/searchmainpage.dart';
import 'package:whatmedi3/pages/medicineinfopage.dart';
import 'package:whatmedi3/backdata/colors.dart';
import 'package:whatmedi3/pages/selectedmedilsit.dart';

class mediListPage extends StatelessWidget {
  mediListPage({
    Key? key,
    required this.medicine,
    required this.searchname,
  }) : super(key: key);

  final List<Medicine> medicine;
  final String searchname;

  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    TextStyle bold = TextStyle(
      color: whatmedicol.kPrimaryColor,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    );
    TextStyle regular = TextStyle(
      color: Colors.black,
      fontSize: 20,
    );

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: MediaQuery.of(context).size.height * 0.12,
        elevation: 0,
        iconTheme: IconThemeData(color: whatmedicol.kPrimaryColor),
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('$searchname에 대한 검색 결과입니다\n약을 탭하여 상세한 정보를 확인하세요'),
        titleTextStyle: bold,
        surfaceTintColor: whatmedicol.kPrimaryColor,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10),
          controller: _scrollController,
          itemCount: medicine.length,
          itemBuilder: (context, index) {
            return Container(
              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: medicine[index].itemImage.isNotEmpty
                      ? Image.network(medicine[index].itemImage,
                          // 이미지를 로드하는 동안 보여줄 placeholder 이미지
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          } else {
                            return CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                          }
                        },
                          // 이미지 로드 실패 시 보여줄 위젯
                          errorBuilder: (BuildContext context, Object error,
                              StackTrace? stackTrace) {
                          return Text('이미지 로드 실패');
                        })
                      : Image.asset(
                          "assets/images/meddefaultimage.png",
                        ),
                ),
                title: Text(medicine[index].itemName),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(medicine[index].entpName),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        height: 1,
                        color: Colors.black12,
                      )
                    ]),

                onTap: () {
                  Map medicineselected = {
                    '품목명': medicine[index].itemName,
                    '제조사': medicine[index].entpName,
                    '효능': medicine[index].efcyQesitm,
                    '사용': medicine[index].useMethodQesitm,
                    '주의': medicine[index].atpnWarnQesitm,
                    '이미지': medicine[index].itemImage
                  };
                  Get.to(SearchedPage(mediinfo: medicineselected));

                },
              ),
            );
          }),
    );
  }
}
