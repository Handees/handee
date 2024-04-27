import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:handees/generated/assets.dart';

import '../../../../../shared/utils/utils.dart';
import '../../../../artisan_app/features/handee/ui/screens/handee_concluded.screen.dart';
import '../../../../artisan_app/features/handee/ui/widgets/dashes.dart';
import '../../../../artisan_app/features/handee/ui/widgets/stars.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({super.key});

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  int _rating = 0;
  final Map<String, bool> _feedback = {
    'Poor repairs': false,
    'Arrived late': false,
    'Rude': false,
    'Missing item': false,
  };
  Widget buildClickableText(String key) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _feedback[key] = !_feedback[key]!;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            color:
                _feedback[key] == true ? Colors.black : const Color(0xffF2F3F4),
            borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Text(
          key,
          style: TextStyle(
            color:
                _feedback[key] == true ? Colors.white : const Color(0xffA4A1A1),
          ),
        ),
      ),
    );
  }

  final horizontalPadding = 24;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Stack(
              children: [
                Column(
                  children: [
                    HandeeInfoRow(
                      infoName: Text(
                        'Handee Fee',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      infoValue: Text(
                        '₦7,500',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    HandeeInfoRow(
                      infoName: Text(
                        'Time Spent',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      infoValue: Text(
                        '1 Hour, 3 Mins',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    HandeeInfoRow(
                      infoName: Text(
                        'Handee ID',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      infoValue: Text(
                        'KH9212924',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 4.25,
                  top: 15,
                  child: Column(
                    children: [
                      Dashes(
                        height: 70,
                        color: getHexColor('14161c'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Dashes(
                        height: 70,
                        color: getHexColor('14161c'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: Text(
              'Please rate your service provider.',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: getHexColor('a4a1a1'),
                  ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Stars(
              count: _rating,
              changeCount: (int newCount) {
                setState(() {
                  _rating = newCount;
                });
              }),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width - (horizontalPadding * 2),
            child: Wrap(
              spacing: 8,
              children: _feedback.keys.map(buildClickableText).toList(),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          constraints: const BoxConstraints(minWidth: double.infinity),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: TextButton(
            child: const Text(
              'Done',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              //TODO: Handle Submission logic
            },
          ),
        ),
      ),
    );
  }
}
