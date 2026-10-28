import 'package:flutter/material.dart';

import 'package:skeleton_text/skeleton_text.dart';

class SkeletonHome extends StatelessWidget {
  const SkeletonHome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(top: 52, left: 13, right: 14),
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
                        width: size.width * 0.20,
                        height: size.height * 0.025,
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
                        width: size.width * 0.60,
                        height: size.height * 0.03,
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
              height: 20,
            ),
            SkeletonAnimation(
              child: Container(
                width: size.width * 0.93,
                height: size.height * 0.15,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            SkeletonAnimation(
              child: Container(
                width: size.width * 0.60,
                height: size.height * 0.03,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SkeletonAnimation(
                    child: Container(
                      width: size.width * 0.73,
                      height: size.height * 0.21,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  SkeletonAnimation(
                    child: Container(
                       width: size.width * 0.73,
                       height: size.height * 0.21,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 22,
            ),
            SkeletonAnimation(
              child: Container(
                width: size.width * 0.60,
                height: size.height * 0.03,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 13,
            ),
            SkeletonAnimation(
              child: Container(
                width: size.width * 0.94,
                height: size.height * 0.25,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
