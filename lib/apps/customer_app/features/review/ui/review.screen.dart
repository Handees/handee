import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
            color: _feedback[key] == true ? Colors.black : Colors.black54,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            key,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        margin: EdgeInsets.only(left: 5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Service Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text('Service fee'), SizedBox(

                child: CustomDottedLine(),
              ), Text(" N7,500")],
            ),
            const SizedBox(
              height: 10,
            ),CustomDottedLine(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Time spent'), const Text("-----")],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Service ID'), const Text("KH921924")],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 100,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: const Text('Please rate your service provider.')),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.black,
                    size: 35.0,
                  ),
                  onPressed: () {
                    setState(() {
                      _rating = index + 1;
                    });
                  },
                );
              }),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _feedback.keys.map(buildClickableText).toList()),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          constraints: BoxConstraints(minWidth: double.infinity),
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
              // Handle submission logic
            },
          ),
        ),
      ),
    );
  }
}

Widget CustomDottedLine() => Column(
      children: List.generate(
          400 ~/ 10,
          (index) => Expanded(
                  child: Container(
                width: 0.2,
                color: index % 2 == 0
                    ? Colors.transparent
                    : const Color.fromRGBO(
                        23,
                        48,
                        86,
                        1,
                      ),
              ))),
    );
