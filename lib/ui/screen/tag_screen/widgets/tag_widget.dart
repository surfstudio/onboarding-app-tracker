import 'package:flutter/material.dart';
import 'package:time_tracker/domain/tag/tag.dart';

class TagWidget extends StatelessWidget {
  final Tag tag;

  const TagWidget({required this.tag, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(tag.title),
            const SizedBox(
              width: 5,
            ),
            DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color(tag.color),
              ),
              child: const SizedBox(
                width: 10,
                height: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
