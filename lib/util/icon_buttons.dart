import 'package:flutter/material.dart';

class AIconButtons extends StatefulWidget {
  AIconButtons(this.show,
      {@required this.actImageUrl,
      @required this.inactImageUrl,
      this.onTap,
      this.initAct = false});
  final String actImageUrl;
  final String inactImageUrl;
  final Function(bool) onTap;
  final bool initAct;
  final bool show;
  @override
  _AIconButtonsState createState() => _AIconButtonsState(show,
      actImageUrl: actImageUrl,
      inactImageUrl: inactImageUrl,
      onTap: onTap);
}

class _AIconButtonsState extends State<AIconButtons> {
  _AIconButtonsState(this.show,
      {@required this.actImageUrl,
      @required this.inactImageUrl,
      this.onTap});
  final String actImageUrl;
  final String inactImageUrl;
  final Function(bool) onTap;
  final bool show;
  String _currentImage;
  @override
  void initState() {
    if (widget.initAct) {
      _currentImage = actImageUrl;
    } else {
      _currentImage = inactImageUrl;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image(image: AssetImage(_currentImage)),
      onTap: show
          ? null
          : () {
              setState(() {
                if (_currentImage == actImageUrl) {
                  _currentImage = inactImageUrl;
                  onTap(false);
                } else {
                  _currentImage = actImageUrl;
                  onTap(true);
                }
              });
            },
    );
  }
}
