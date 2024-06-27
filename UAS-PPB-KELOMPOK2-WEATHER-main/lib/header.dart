import 'package:flutter/material.dart';

class CustomHeader extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onMenuPressed;
  final ValueChanged<String>? onCityChanged;

  const CustomHeader({
    Key? key,
    required this.title,
    required this.onMenuPressed,
    this.onCityChanged,
  }) : super(key: key);

  @override
  _CustomHeaderState createState() => _CustomHeaderState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomHeaderState extends State<CustomHeader> {
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    setState(() {
      _isSearching = false;
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: _isSearching
          ? TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Enter city name...',
                border: InputBorder.none,
              ),
              onSubmitted: (value) {
                if (widget.onCityChanged != null && value.isNotEmpty) {
                  widget.onCityChanged!(value);
                  _stopSearch();
                }
              },
            )
          : Text(widget.title),
      leading: IconButton(
        icon: Icon(_isSearching ? Icons.arrow_back : Icons.menu),
        onPressed: _isSearching ? _stopSearch : widget.onMenuPressed,
      ),
      actions: [
        IconButton(
          icon: Icon(_isSearching ? Icons.close : Icons.search),
          onPressed: _isSearching ? _stopSearch : _startSearch,
        ),
      ],
    );
  }
}
