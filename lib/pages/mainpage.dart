import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:whatmedi3/pages/newtakepicture.dart';
import 'package:whatmedi3/pages/searchmainpage.dart';
import 'package:whatmedi3/pages/settingpage.dart';
import 'package:whatmedi3/backdata/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CameraDescription _camera = CameraDescription(
      name: '초기설정',
      lensDirection: CameraLensDirection.back,
      sensorOrientation: 0);


  cameraA() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _camera = firstCamera;
    return _camera;
  }

  int _currentIndex = 0;
  List<Widget> _pages = [];
  bool _isKeyboardVisible = false;

  @override
  void initState() {
    super.initState();
    cameraA();
    _pages.add(SearchPage());
    _pages.add(SettingPage());
    KeyboardVisibilityController().onChange.listen((bool visible) {
      if (visible) {
        setState(() {
          _isKeyboardVisible = true;
        });
      } else {
        setState(() {
          _isKeyboardVisible = false;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return KeyboardDismissOnTap(
        child: Scaffold(
      body: SafeArea(child: _pages[_currentIndex]),
      bottomNavigationBar: SafeArea(
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          notchMargin: 2,
          clipBehavior: Clip.antiAlias,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              child: BottomNavigationBar(
                  backgroundColor: whatmedicol.kPrimaryColor,
                  currentIndex: _currentIndex,
                  selectedItemColor: Colors.white,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  items: [
                    BottomNavigationBarItem(
                        icon: Icon(Icons.search), label: '검색'),
                    //BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: ''),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings_rounded), label: '설정')
                  ]),
            ),
          ),
        ),
      ),
      // persistentFooterButtons: [Padding(padding: const EdgeInsets.all(0),child: IconButton(onPressed:(){}, icon: Icon(Icons.add)),)],
      // persistentFooterAlignment: AlignmentDirectional.bottomCenter,
      floatingActionButtonLocation: _isKeyboardVisible
          ? null
          : FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: _isKeyboardVisible
          ? null
          : Padding(
              padding: const EdgeInsets.all(0),
              child: FloatingActionButton.large(
                child: Icon(Icons.add,size: 60,),
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraPage(),//CameraPage(camera: _camera)
                    ),
                  );
                },
              ),
            ),

    ));
  }
}
