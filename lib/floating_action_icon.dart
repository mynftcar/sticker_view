
import 'package:flutter/material.dart';
import 'constants.dart';


class FloatingActionIcon extends StatelessWidget {

  const FloatingActionIcon({
    Key? key,
    required this.iconData,
    this.onTap,
  }) : super(key: key);

  final IconData iconData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {


    return Material(
      color: Colors.white,
      clipBehavior: Clip.hardEdge,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: Constants.floatingActionDiameter,
          width: Constants.floatingActionDiameter,
          child: Center(
            child: Icon(
              iconData,
              color: Colors.blue,
              size: 12,
            ),
          ),
        ),
      ),
    );
  }
}