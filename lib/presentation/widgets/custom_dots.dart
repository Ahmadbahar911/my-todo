import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:finalproject_pmoif20c_alif/shared/styles/colors.dart';

class CustomDots extends StatelessWidget {
  final int myindex;
  const CustomDots({Key? key, required this.myindex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 16.w,
      height: 10.h,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildDot(0),
          _buildDot(1),
          _buildDot(2),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: index == myindex ? Appcolors.white : Colors.white54),
    );
  }
}
