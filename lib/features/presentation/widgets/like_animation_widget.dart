import 'package:flutter/material.dart';

class LikeAnimationWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final bool isLikeAnimating;
  final VoidCallback? onLikeFinish;
  const LikeAnimationWidget(
      {super.key,
      required this.child,
      required this.duration,
      required this.isLikeAnimating,
      this.onLikeFinish});

  @override
  State<LikeAnimationWidget> createState() => _LikeAnimationWidgetState();
}

class _LikeAnimationWidgetState extends State<LikeAnimationWidget> with SingleTickerProviderStateMixin {
  late  AnimationController controller;
  late Animation<double> scale;   

  @override
  void initState() {
    controller=AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration.inMilliseconds));
    scale=Tween<double>(begin: 1,end: 1.2).animate(controller);
    super.initState();
  }
  @override
  void didUpdateWidget(covariant LikeAnimationWidget oldWidget) {
    if(widget.isLikeAnimating!=oldWidget.isLikeAnimating){
      beginLikeAnimation();
    }
    super.didUpdateWidget(oldWidget);
  }
  beginLikeAnimation()async{
    if(widget.isLikeAnimating){
      await controller.forward();
      await controller.reverse();
      await Future.delayed(Duration(milliseconds: 200));
      if(widget.onLikeFinish!=null){
        widget.onLikeFinish!();
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: scale,child: widget.child,);
  }
}
