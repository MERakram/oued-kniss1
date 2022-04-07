import 'package:expand_widget/expand_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lorem/flutter_lorem.dart';

import 'agencyMiniProfile2.dart';



class offerDescription2 extends StatelessWidget {
  String text = lorem(paragraphs: 4, words: 70);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(7),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            agencyMiniProfile2(),
            const SizedBox(
              height: 7,
            ),
            Padding(
              padding:
              // EdgeInsets.fromLTRB(left, top, right, bottom)
              const EdgeInsets.fromLTRB(18, 1, 12, 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    'house mda5en in cupirtino ',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  const Text(
                    'house mda5en in cupirtino hello wo ',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 2,
                  ),
                  ExpandText(
                    text,
                    style: const TextStyle(fontSize: 20),
                    textAlign: TextAlign.justify,
                  ),
                ],
              ),
            ),
          ],
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF605F5F).withOpacity(0.2),
              spreadRadius: 4,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        width: 300,
        // height: 300,
      ),
    );
  }
}