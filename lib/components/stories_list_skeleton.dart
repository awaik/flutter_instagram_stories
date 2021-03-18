import 'package:flutter/material.dart';

class StoriesListSkeleton extends StatelessWidget {
  final double width;
  final double height;

  StoriesListSkeleton({
    this.width = 140.0,
    this.height = 178.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20),
      child: InkWell(
        child: Container(
          height: 178,
          width: 140,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoriesListSkeletonAlone extends StatelessWidget {
  final double width;
  final double height;

  StoriesListSkeletonAlone({
    this.width = 140,
    this.height = 178,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
    );
  }
}
