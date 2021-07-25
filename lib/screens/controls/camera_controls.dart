import 'package:flutter/material.dart';

class CameraControls extends StatelessWidget {
  final Function takePicture;
  final Function toggleCameraMode;
  final Function switchCameras;

  const CameraControls({
    Key key,
    @required this.takePicture,
    @required this.toggleCameraMode,
    @required this.switchCameras,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SwitchCamerasButton(onSwitchCamerasBtnPressed: switchCameras),
          SizedBox(
            width: 20,
          ),
          RawMaterialButton(
            child: Icon(
              Icons.fiber_manual_record,
              color: Colors.white,
              size: 60,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(15.0),
            onPressed: () {
              takePicture();
            },
          ),
          SizedBox(
            width: 20,
          ),
          RawMaterialButton(
            child: Icon(
              Icons.videocam,
              color: Colors.black,
            ),
            shape: new CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(15.0),
            onPressed: () {
              toggleCameraMode();
            },
          ),
        ],
      ),
    );
  }
}

class SwitchCamerasButton extends StatelessWidget {
  const SwitchCamerasButton({
    Key key,
    @required this.onSwitchCamerasBtnPressed,
  }) : super(key: key);

  final Function onSwitchCamerasBtnPressed;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        Icons.switch_camera,
        color: Colors.black,
      ),
      shape: new CircleBorder(),
      elevation: 2.0,
      fillColor: Colors.white,
      padding: const EdgeInsets.all(15.0),
      onPressed: () {
        onSwitchCamerasBtnPressed();
      },
    );
  }
}