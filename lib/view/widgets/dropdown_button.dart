import 'package:flutter/material.dart';
import 'package:robotic_dashboard/utils/constants.dart';

class CustomHamburgerDropdown extends StatefulWidget {
  final List<DropdownItem> items;
  final double dropdownWidth;
  final Color dropdownColor;

  const CustomHamburgerDropdown({
    Key? key,
    required this.items,
    this.dropdownWidth = 10.0, // Default width for the dropdown
    this.dropdownColor =
        secondaryColor, // Default color for dropdown background
  }) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CustomHamburgerDropdownState createState() =>
      _CustomHamburgerDropdownState();
}

class _CustomHamburgerDropdownState extends State<CustomHamburgerDropdown> {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();

  void _toggleDropdown() {
    if (_overlayEntry == null) {
      _showDropdown();
    } else {
      _hideDropdown();
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: widget.dropdownWidth,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(-widget.dropdownWidth + size.width, size.height),
          child: Material(
            elevation: 0.0,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
            color: borderColor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: widget.items.map((DropdownItem item) {
                return InkWell(
                  onTap: () {
                    item.onChanged();
                    _hideDropdown();
                  },
                  child: Container(
                    width: widget.dropdownWidth,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      item.label,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontSize: 14.0), // Text color
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: IconButton(
        icon: const Icon(Icons.menu, size: 30),
        onPressed: _toggleDropdown,
      ),
    );
  }
}

class DropdownItem {
  final String label;
  final VoidCallback onChanged;

  DropdownItem({
    required this.label,
    required this.onChanged,
  });
}
