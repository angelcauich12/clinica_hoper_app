import 'package:flutter/material.dart';

import 'package:skeleton_text/skeleton_text.dart';

class SkeletonHome extends StatelessWidget {
  const SkeletonHome({super.key});

  @override
  Widget build(BuildContext context) {
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
                        width:  60,
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
                        width: 190,
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
              height: 13,
            ),
            SkeletonAnimation(
              child: Container(
                width: 365,
                height: 135,
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
                width: 250,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 26,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  SkeletonAnimation(
                    child: Container(
                      width: 305,
                      height: 182,
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
                      width: 305,
                      height: 182,
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
                width: 250,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            const SizedBox(
              height: 13 ,
            ),
            SkeletonAnimation(
              child: Container(
                width: 365,
                height: 200,
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
