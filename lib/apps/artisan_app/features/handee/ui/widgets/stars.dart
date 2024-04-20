import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Stars extends StatelessWidget {
  final int count;
  final void Function(int newCount) changeCount;
  const Stars({required this.count, required this.changeCount, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 50,
          width: MediaQuery.of(context).size.width * 0.63,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              int filled = count - 1;
              if (index <= filled) {
                return InkWell(
                  onTap: () {
                    changeCount(index + 1);
                  },
                  child: SvgPicture.asset('assets/svg/filled_star.svg'),
                );
              } else {
                return InkWell(
                  onTap: () {
                    changeCount(index + 1);
                  },
                  child: SvgPicture.asset('assets/svg/star.svg'),
                );
              }
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                width: index < 5 ? 15 : 0,
              );
            },
            itemCount: 5,
          ),
        ),
      ],
    );
  }
}

class HandeeStars extends StatelessWidget {
  final int count;
  final double height;
  final double width;
  final int filledCount;
  const HandeeStars(
      {required this.count,
      this.filledCount = 5,
      required this.height,
      required this.width,
      super.key});

  final double starGap = 5;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: (width * 5) + (starGap * 4),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          if (index <= (filledCount - 1)) {
            return SvgPicture.asset(
              'assets/svg/small_gold_star.svg',
              width: 18,
              height: 18,
            );
          } else {
            return SvgPicture.asset(
              'assets/svg/small_empty_star.svg',
              width: 18,
              height: 18,
            );
          }
        },
        separatorBuilder: (context, index) {
          return SizedBox(
            width: index < 5 ? starGap : 0,
          );
        },
        itemCount: 5,
      ),
    );
  }
}
