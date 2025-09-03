import 'dart:async';
import 'package:nocterm/nocterm.dart';

void main() async {
  await runApp(const DecorationBugDemo());
}

/// Simple demo to test a bug where BoxDecoration changes from non-null to null
class DecorationBugDemo extends StatefulComponent {
  const DecorationBugDemo({super.key});

  @override
  State<DecorationBugDemo> createState() => _DecorationBugDemoState();
}

class _DecorationBugDemoState extends State<DecorationBugDemo> {
  BoxDecoration? decoration = BoxDecoration(
    border: BoxBorder.all(color: Colors.red),
    color: Color.fromRGB(64, 0, 0),
  );

  bool switchIt = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        // Keep decoration non-null for testing
        decoration = BoxDecoration(
          border: BoxBorder.all(color: Colors.green),
          color: Color.fromRGB(0, 64, 0),
        );
        switchIt = true;
      });
    });
  }

  @override
  Component build(BuildContext context) {
    // Works
    /*return Center(
      child: Container(decoration: decoration),
    );*/
    // THis does not work
    return Column(
      children: [
        !switchIt
            ? Text('Hello')
            : DecoratedBox(
                decoration: decoration!,
                child: Text('Hello2'),
              ),
        /*Container(
          decoration: decoration,
          //margin: EdgeInsets.all(10),
          child: Text('Hello'),
        ),*/
      ],
    );
  }
}
