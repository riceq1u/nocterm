import 'package:nocterm/nocterm.dart';

void main() async {
  runApp(SomeTest());
}

class SomeTest extends StatefulComponent {
  SomeTest({super.key});

  @override
  State<SomeTest> createState() => _SomeTestState();
}

class _SomeTestState extends State<SomeTest> {
  int sidebarIndex = 0;
  final List<String> sidebarItems = ['Dashboard', 'Settings'];
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        sidebarIndex++;
      });
    });
  }

  @override
  Component build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int i = 0; i < sidebarItems.length; i++)
          SidebarItem(
            item: sidebarItems[i],
            selected: i == sidebarIndex,
          ),
        /* Text(
            ' ${i == sidebarIndex ? '>' : ' '} ${sidebarItems[i]}',
          ), */
      ],
    );
  }
}

class SidebarItem extends StatelessComponent {
  const SidebarItem({super.key, required this.item, required this.selected});

  final String item;
  final bool selected;

  @override
  Component build(BuildContext context) {
    return Container(
        decoration: selected
            ? BoxDecoration(
                color: Colors.blue,
              )
            : null,
        padding: const EdgeInsets.all(2),
        child: Text(
          ' ${selected ? '>' : ' '} $item',
          style: TextStyle(
            color: selected ? Colors.white : Colors.gray,
          ),
        ));
  }
}
