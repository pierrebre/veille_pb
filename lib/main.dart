import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  _cameras = await availableCameras();
  runApp(const CameraApp());
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    controller = CameraController(_cameras[0], ResolutionPreset.max);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            // Gérer les erreurs d'accès à la caméra ici.
            break;
          default:
            // Gérer d'autres erreurs ici.
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container();
    }

    // Ajuster la taille de l'aperçu de la caméra
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    // Calculer la taille de l'aperçu de la caméra pour qu'il soit d'environ 30% de la largeur de l'écran
    final double cameraHeight = size.width * 0.3;
    final double cameraWidth = cameraHeight * deviceRatio;

    // Créer un conteneur pour l'aperçu de la caméra
    final cameraWidget = SizedBox(
      width: cameraWidth,
      height: cameraHeight,
      child: CameraPreview(controller),
    );

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Camera App'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Afficher l'aperçu de la caméra dans le conteneur spécifié
              cameraWidget,
            ],
          ),
        ),
      ),
    );
  }
}
