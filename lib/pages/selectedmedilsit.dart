import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:whatmedi3/pages/selectpagemediinfo.dart';

class SelectedMedi extends StatefulWidget {
  const SelectedMedi({super.key});

  @override
  State<SelectedMedi> createState() => _SelectedMediState();
}


class _SelectedMediState extends State<SelectedMedi> {
  Future<List<Map<String, String>>>? selectedmediFuture;

  Future<List<Map<String, String>>> loadDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? selectedJson = prefs.getString('selected_data');

    if (selectedJson != null) {
      List<dynamic> selectedList = json.decode(selectedJson);
      List<Map<String, String>> selectedData = [];

      for (var item in selectedList) {
        if (item is Map<String, dynamic>) {
          Map<String, String> stringMap = {};
          item.forEach((key, value) {
            if (value is String) {
              stringMap[key] = value;
            } else if (value != null) {
              stringMap[key] = value.toString();
            }
          });
          selectedData.add(stringMap);
        } else {
          print('JSON 데이터가 Map<String, dynamic> 형식이 아닙니다.');
        }
      }

      return selectedData;
    } else {
      return []; // 기본값 또는 데이터가 없을 경우 빈 리스트 반환
    }
  }

  @override
  void initState() {
    super.initState();
    selectedmediFuture = loadDataFromSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Medicines'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Map<String, String>>>(
          future: selectedmediFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('에러 발생: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('선택된 약품이 없습니다.'));
            } else {
              List<Map<String, String>> selectedmedi = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.fromLTRB(0,10,0,0),
                itemCount: selectedmedi.length,
                itemBuilder: (context, index) {
                  // 각 항목을 ListTile 또는 원하는 다른 위젯으로 표시
                  return Container(
                    child: ListTile(
                      leading: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        child: selectedmedi[index]['이미지']!.isNotEmpty
                            ? Image.network(selectedmedi[index]['이미지'] ??'',
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
                      title: Text(selectedmedi[index]['제품명'] ?? ''),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(selectedmedi[index]['제조사']??''),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 1,
                              color: Colors.black12,
                            )
                          ]),
                      trailing: IconButton(
                        icon: Icon(Icons.playlist_remove),
                        onPressed: () async {
                          selectedmedi.removeAt(index);
                          String selectedJson = json.encode(selectedmedi);
                          Future<void> saveDataToSharedPreferences() async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            await prefs.setString('selected_data', selectedJson);
                          }

                          await saveDataToSharedPreferences();
                          setState(() {
                            selectedmedi = selectedmedi;
                          });
                        },
                      ),
                      onTap: () {
                        Map mediinfo={
                          '품목명':selectedmedi[index]['제품명'],
                          '제조사':selectedmedi[index]['제조사'],
                          '효능':selectedmedi[index]['효과'],
                          '사용':selectedmedi[index]['사용법'],
                          '주의':selectedmedi[index]['주의사항'],
                          '이미지':selectedmedi[index]['이미지'],
                        };
                        Get.to(SelectedMediinfo(mediinfo: mediinfo));
                      },
                    ),
                  );

                },
              );
            }
          },
        ),
      ),
    );
  }
}
