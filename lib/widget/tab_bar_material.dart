import 'package:flutter/material.dart';

class TabbarMaterialWidget extends StatefulWidget {
  final int index;
  final ValueChanged<int> onChangedTab;

  const TabbarMaterialWidget({
    required this.index,
    required this.onChangedTab,
     Key? key,
  }) : super(key: key);
  @override
  State<TabbarMaterialWidget> createState() => _TabbarMaterialWidgetState();
}

class _TabbarMaterialWidgetState extends State<TabbarMaterialWidget> {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Color(0xfff1f1f5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildTabItem(
            index: 0,
            icon: Icon(Icons.home),
          ),
          buildTabItem(
            index: 1,
            icon: Icon(Icons.history),
          ),
          buildTabItem(
            index: 2,
            icon: Icon(Icons.shopping_cart),
          ),
          buildTabItem(
            index: 3,
            icon: Icon(Icons.people_alt),
          ),
        ],
      ),
    );
  }

  Widget buildTabItem({
    required int index,
    required Icon icon,
  }) {
    final isSelected = index == widget.index;
    return IconTheme(
      data: IconThemeData(size: 28,
        color: isSelected ? Colors.blue : Color.fromARGB(255, 100, 98, 98),
      ),
      child: IconButton(
        icon: icon,
        onPressed: () => widget.onChangedTab(index),
      ),
    );
  }
}
