import 'package:flutter/material.dart';

class KHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const KHeader({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _KHeaderState createState() => _KHeaderState();
}

class _KHeaderState extends State<KHeader> {
  bool _isSearchOpen = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.black),
              onPressed: () {
                widget.scaffoldKey.currentState?.openDrawer();
              },
            ),
          ),
          AnimatedContainer(
            alignment: Alignment.centerRight,
            duration: Duration(milliseconds: 300),
            width: _isSearchOpen ? MediaQuery.of(context).size.width * 0.6 : 0,
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: _isSearchOpen
                ? TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Type Location',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  )
                : null,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              icon: Icon(_isSearchOpen ? Icons.close : Icons.search, color: Colors.black),
              onPressed: () {
                setState(() {
                  _isSearchOpen = !_isSearchOpen;
                  if (!_isSearchOpen) {
                    _searchController.clear();
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
