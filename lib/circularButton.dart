import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class circularButton extends StatelessWidget{
  final double width;
  final double height;
  final Color color;
  final Function onClick;
  final Icon icon;


  circularButton({this.width, this.height, this.color, this.icon, this.onClick});




  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color,shape: BoxShape.circle),
      width: width,height: height,
      child: IconButton(icon: icon,enableFeedback:true, onPressed: onClick,),
    );
  }

}