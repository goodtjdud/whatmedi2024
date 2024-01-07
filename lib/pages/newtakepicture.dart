import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isCameraInitialized = false;
  late final List<CameraDescription> _cameras;

  //bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    initCamera();
  }

  Future<void> initCamera() async {
    _cameras =
        await availableCameras(); // Initialize the camera with the first camera in the list
    await onNewCameraSelected(_cameras.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    final CameraController? cameraController = _controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      // Free up memory when camera not active
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      // Reinitialize the camera with same properties
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<XFile?> capturePhoto() async {
    final CameraController? cameraController = _controller;
    if (cameraController!.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }
    try {
      await cameraController.setFlashMode(FlashMode.off);
      XFile file = await cameraController.takePicture();
      return file;
    } on CameraException catch (e) {
      debugPrint('Error occured while taking picture: $e');
      return null;
    }
  }

  void _onTakePhotoPressed() async {
    final navigator = Navigator.of(context);
    final xFile = await capturePhoto();
    if (xFile != null) {
      if (xFile.path.isNotEmpty) {
        // navigator.push(
        //   MaterialPageRoute(
        //     builder: (context) => PreviewPage(
        //       imagePath: xFile.path,
        //     ),
        //   ),
        // );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCameraInitialized) {
      return SafeArea(
        child: Scaffold(
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return Stack(
                children: [
                  Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(color: Colors.black),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: IconButton(
                                icon: Icon(Icons.arrow_back_ios_new),
                                onPressed: () {Get.off(CameraPage());},
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )),
                  Positioned.fill(
                      top: 50,
                      child: AspectRatio(
                        aspectRatio: _controller!.value.aspectRatio,
                        child: CameraPreview(_controller!),
                      )),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      right: 0,
                      child: Container(
                        height: 150,
                        decoration:
                            BoxDecoration(color: Colors.black.withOpacity(0.5)),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '사진',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Expanded(child: Container()),
                                    Expanded(
                                      child: Center(
                                        child: Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.transparent,
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              border: Border.all(
                                                  width: 4,
                                                  color: Colors.white,
                                                  style: BorderStyle.solid)),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        child: GestureDetector(
                                      onTap: () {},
                                      child: Icon(
                                        Icons.flash_off,
                                        color: Colors.white,
                                        size: 40,
                                      ),
                                    )),
                                  ],
                                )
                              ],
                            ))
                          ],
                        ),
                      )),
                ],
              );
            },
          ),
        ),
      );
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  Future<void> onNewCameraSelected(CameraDescription description) async {
    final previousCameraController = _controller;

    // Instantiating the camera controller
    final CameraController cameraController = CameraController(
      description,
      ResolutionPreset.max,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    // Initialize controller
    try {
      await cameraController.initialize();
    } on CameraException catch (e) {
      debugPrint('Error initializing camera: $e');
    }
    // Dispose the previous controller
    await previousCameraController?.dispose();

    // Replace with the new controller
    if (mounted) {
      setState(() {
        _controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    // Update the Boolean
    if (mounted) {
      setState(() {
        _isCameraInitialized = _controller!.value.isInitialized;
      });
    }
  }
}

// class PreviewPage extends StatefulWidget {
//   final String? imagePath;
//   final String? videoPath;
//
//   const PreviewPage({Key? key, this.imagePath, this.videoPath})
//       : super(key: key);
//
//   @override
//   State<PreviewPage> createState() => _PreviewPageState();
// }
//
// class _PreviewPageState extends State<PreviewPage> {
//   VideoPlayerController? controller;
//
//   Future<void> _startVideoPlayer() async {
//     if (widget.videoPath != null) {
//       controller = VideoPlayerController.file(File(widget.videoPath!));
//       await controller!.initialize().then((_) {
//         // Ensure the first frame is shown after the video is initialized,
//         // even before the play button has been pressed.
//         setState(() {});
//       });
//       await controller!.setLooping(true);
//       await controller!.play();
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     if (widget.videoPath != null) {
//       _startVideoPlayer();
//     }
//   }
//
//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: widget.imagePath != null
//             ? Image.file(
//           File(widget.imagePath ?? ""),
//           fit: BoxFit.cover,
//         )
//             : AspectRatio(
//           aspectRatio: controller!.value.aspectRatio,
//           child: VideoPlayer(controller!),
//         ),
//       ),
//     );
//   }
// }

//구체적으로 WidgetsBindingObserver와 didChangeAppLifecycleState 메서드는 다음과 같은 역할을 합니다:
//
//WidgetsBindingObserver: 이 클래스는 Flutter 앱의 생명주기 이벤트를 관찰하고 처리하기 위한 인터페이스입니다. 앱의 상태 변경에 대한 감지 및 처리를 가능하게 합니다.
//
//didChangeAppLifecycleState 메서드: 이 메서드는 WidgetsBindingObserver 인터페이스에서 상속되는 메서드로, 앱의 생명주기 상태가 변경될 때 호출됩니다. 즉, 앱이 활성화된 상태에서 비활성화로 전환하거나 다시 활성화로 전환될 때 등의 경우에 호출됩니다.
//
//따라서 위의 코드는 현재 클래스(_CameraPageState)가 WidgetsBindingObserver 인터페이스를 구현하고, didChangeAppLifecycleState 메서드를 오버라이드하여 앱의 생명주기 변경을 감지하고 이에 대응하는 동작을 정의할 수 있도록 합니다. 일반적으로 이를 사용하여 앱의 생명주기에 따라 카메라 초기화 및 해제와 같은 작업을 수행합니다.
// import 'package:flutter/material.dart';
// import 'package:camera/camera.dart';
// import 'package:fluttertoast/fluttertoast.dart'; // Flutter 카메라 패키지를 가져옵니다.
//
// class CameraPage extends StatefulWidget {
//   const CameraPage({super.key, required this.camera});
//
//   final CameraDescription camera;
//
//   @override
//   State<CameraPage> createState() => _CameraPageState();
// }
//
// class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
//   //with WidgetsBindingObserver 이게 중요ㅕ!
//   late CameraController _controller;
//   late Future<void> _initializeControllerFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance?.addObserver(this);
//     _controller = CameraController(widget.camera, ResolutionPreset.max);
//     _initializeControllerFuture = _controller.initialize();
//     _controller.setFlashMode(FlashMode.auto); //자동으로 플래쉬모드는 오토로 설정.
//   }
//
//   @override
//   void dispose() {
//     _disposeController();
//     WidgetsBinding.instance?.removeObserver(this);
//     super.dispose();
//   }
//
//   // 앱 생명주기 변경을 처리하는 메서드 추가
//   // void didChangeAppLifecycleState(AppLifecycleState state) {
//   //   if (state == AppLifecycleState.resumed) {
//   //     _controller = CameraController(widget.camera, ResolutionPreset.max);
//   //     _controller.initialize();
//   //     _controller.buildPreview();
//   //
//   //   } else if (state == AppLifecycleState.inactive) {
//   //     _disposeController();
//   //   }
//   // }
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     ///크롬에 북마크해놓은거 확인해보기
//     if (state == AppLifecycleState.resumed || !_controller.value.isInitialized) {
//
//       _controller.value.isPreviewPaused
//           ?
//       _initializeControllerFuture = _controller.initialize()
//           : null; //on pause camera disposed so we need call again "issue is only for android"
//     }
//     if(state == AppLifecycleState.inactive || state ==AppLifecycleState.paused){
//       _controller.pausePreview();
//     }
//     //이거는 되기는 하는데 지금 dispose가 제대로 되고 있는지를 모름.
//   }
//
//   // 카메라 컨트롤러 초기화
//   void _initializeController() async {
//     if (!_controller.value.isInitialized) {
//       await _initializeControllerFuture;
//     }
//   }
//
//   // 카메라 컨트롤러 해제
//   void _disposeController() {
//     if (_controller.value.isInitialized) {
//       //Fluttertoast.showToast(msg: '잘 종료되었습니다');
//       _controller.dispose();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Stack(
//           children: [
//             Container(
//               width: size.width,
//               child: FutureBuilder<void>(
//                 future: _initializeControllerFuture,
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.done) {
//                     return CameraPreview(_controller);
//                   } else {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                 },
//               ),
//             ),
//             Positioned(
//               top: 0,
//               left: 0,
//               child: IconButton(
//                 icon: Icon(Icons.arrow_back_ios_new, color: Colors.white,),
//                 onPressed: () {
//                   Navigator.pop(context);
//                   _disposeController(); // 앱에서 뒤로 이동 시 카메라 리소스 해제
//                 },
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 0,
//               child: Container(
//                 color: Colors.black.withOpacity(0.5),
//                 width: MediaQuery.of(context).size.width,
//                 height: MediaQuery.of(context).size.height * 0.2,
//               ),
//             ),
//             Positioned(
//               bottom: MediaQuery.of(context).size.height * 0.1 - 50,
//               left: MediaQuery.of(context).size.width * 0.5 - 50,
//               child: IconButton(
//                 iconSize: 100,
//                 icon: Icon(Icons.circle),
//                 onPressed: () async {
//                   if (!_controller.value.isInitialized) {
//                     return null;
//                   }
//                   if (_controller.value.isTakingPicture) {
//                     return null;
//                   }
//                   try {
//                     await _initializeControllerFuture;
//
//                     final image = await _controller.takePicture();
//                     if (!mounted) return;
//                   } catch (e) {
//                     print(e);
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// await Navigator.of(context).push(
// MaterialPageRoute(
// builder: (context) => DisplayPictureScreen(
// imagePath: image.path,
// ),
// ),
// );
// class DisplayPictureScreen extends StatelessWidget {
//   final String imagePath;
//
//   const DisplayPictureScreen({super.key, required this.imagePath});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Display the Picture')),
//       // The image is stored as a file on the device. Use the `Image.file`
//       // constructor with the given path to display the image.
//       body: Image.file(File(imagePath)),
//     );
//   }
// }
