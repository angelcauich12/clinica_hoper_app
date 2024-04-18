
import 'package:flutter/material.dart';

import 'package:skeleton_text/skeleton_text.dart';

class SkeletonHome extends StatelessWidget {
  const SkeletonHome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 13, right: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonAnimation(
                    child: Container(
                      width: size.width * 0.2,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  SkeletonAnimation(
                    child: Container(
                      width: size.width * 0.7,
                      height: 38,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              SkeletonAnimation(
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  radius: 30,
                ),
              )
            ],
          ),
          const SizedBox(
            height: 160,
          ),
          SkeletonAnimation(
            child: Container(
              width: size.width * 0.93,
              height: 182,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          SkeletonAnimation(
            child: Container(
              width: size.width * 0.6,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
          const SizedBox(
            height: 28,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SkeletonAnimation(
                  child: Container(
                    width: size.width * 0.74,
                    height: 182,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                SkeletonAnimation(
                  child: Container(
                    width: size.width * 0.74,
                    height: 182,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
