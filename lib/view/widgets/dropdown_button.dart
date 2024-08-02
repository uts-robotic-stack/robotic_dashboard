import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class CustomDropdownButton extends StatefulWidget {
  final List<DropdownItem> dropDownItems;
  final Widget header;

  const CustomDropdownButton(
      {super.key, required this.dropDownItems, required this.header});

  @override
  // ignore: library_private_types_in_public_api
  _DropdownButtonState createState() => _DropdownButtonState();
}

class _DropdownButtonState extends State<CustomDropdownButton> {
  String dropdownValue = 'Option 1';

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 90, 90, 90),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: widget.header,
        ),
        items: [
          ...widget.dropDownItems.map(
            (item) => DropdownMenuItem<DropdownItem>(
              value: item,
              child: DropdownItemBuilder.buildItem(item),
            ),
          ),
        ],
        onChanged: (value) {
          DropdownItemBuilder.onChanged(context, value!);
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: const Color.fromARGB(255, 90, 90, 90),
          ),
          offset: const Offset(0, -5),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: [
            ...List<double>.filled(widget.dropDownItems.length, 48),
            // 8,
            // ...List<double>.filled(DropdownItemBuilder.secondItems.length, 48),
          ],
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}

class DropdownHeader extends StatelessWidget {
  const DropdownHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.settings,
          size: 25,
          color: Colors.white,
        ),
        SizedBox(
          width: 10,
        ),
        Text("Action", style: TextStyle(color: Colors.white)),
      ],
    );
  }
}

class DropdownItem {
  const DropdownItem({
    required this.text,
    required this.icon,
    required this.onSelected,
  });

  final String text;
  final IconData icon;
  final VoidCallback onSelected;
}

abstract class DropdownItemBuilder {
  static Widget buildItem(DropdownItem item) {
    return Row(
      children: [
        Icon(item.icon, color: Colors.white, size: 22),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: Text(
            item.text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  static void onChanged(BuildContext context, DropdownItem item) {
    item.onSelected();
  }
}
