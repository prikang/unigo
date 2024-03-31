import 'package:flutter/material.dart';
import 'package:unigo/const/app_colors_const.dart';

class AlertButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  final BorderRadiusGeometry? borderRadius;
  final double? width;
  final double? height;

  final Gradient? gradient;
  final Color? color;

  const AlertButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.borderRadius,
    this.width,
    this.height,
    this.gradient,
    this.color,
  }) : super(key: key);

  setColor() {
    if (color != null) {
      return color!;
    } else if (gradient != null) {
      return Colors.transparent;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height ?? 30,
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: MaterialButton(
        onPressed: () => onPressed(),
        textColor: AppColorConst.kappscafoldbggrey,
        color: setColor(),
        elevation: 5,
        height: 50,
        minWidth: 200,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        child: Text(text),
      ),
    );
  }
}
