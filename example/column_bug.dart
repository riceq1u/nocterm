import 'package:nocterm/nocterm.dart';

void main() {
  runApp(const ColumnBugDemo());
}

class ColumnBugDemo extends StatefulComponent {
  const ColumnBugDemo();

  @override
  State<ColumnBugDemo> createState() => _ColumnBugDemoState();
}

class _ColumnBugDemoState extends State<ColumnBugDemo> {
  bool first = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        first = true;
      });
    });
  }

  @override
  Component build(BuildContext context) {
    return Column(
      children: [
        first ? FirstWidget() : SecondWidget(),
      ],
    );
  }
}

class FirstWidget extends StatelessComponent {
  const FirstWidget();

  @override
  Component build(BuildContext context) {
    return Text('9');
  }
}

class SecondWidget extends StatelessComponent {
  const SecondWidget();

  @override
  Component build(BuildContext context) {
    return Text('2');
  }
}
