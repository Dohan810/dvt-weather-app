import 'package:flutter/material.dart';
import 'package:weather_wise/core/api/location_api.dart';
import 'dart:async';

class KHeader extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;

  const KHeader({Key? key, required this.scaffoldKey}) : super(key: key);

  @override
  _KHeaderState createState() => _KHeaderState();
}

class _KHeaderState extends State<KHeader> {
  bool _isSearchOpen = false;
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  final LocationApi _locationApi = LocationApi();
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(seconds: 2), () async {
      setState(() {
        _isLoading = true;
      });
      if (_searchController.text.isNotEmpty) {
        final suggestions = await _locationApi.getLocationSuggestions(_searchController.text);
        setState(() {
          _suggestions = suggestions;
          _isLoading = false;
        });
      } else {
        setState(() {
          _suggestions = [];
          _isLoading = false;
        });
      }
    });
  }

  void _onSuggestionTap(Map<String, dynamic> suggestion) {
    // Handle location selection
    print('Selected location: ${suggestion['display_name']}');
    setState(() {
      _isSearchOpen = false;
      _searchController.clear();
      _suggestions = [];
    });
  }

  Future<void> _saveLocation(String displayName) async {
    await _locationApi.saveLocation(displayName);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Location saved: $displayName')),
    );
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _isSearchOpen ? 275 : 75,
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
      child: Column(
        children: [
          Row(
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
                        _suggestions = [];
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          if (_isSearchOpen)
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(top: 8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: _suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = _suggestions[index];
                          return ListTile(
                            title: Text(suggestion['display_name']),
                            onTap: () => _onSuggestionTap(suggestion),
                            trailing: PopupMenuButton<String>(
                              onSelected: (value) {
                                if (value == 'set_active') {
                                  _onSuggestionTap(suggestion);
                                } else if (value == 'save') {
                                  _saveLocation(suggestion['display_name']);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'set_active',
                                  child: Text('Set Active Location'),
                                ),
                                PopupMenuItem(
                                  value: 'save',
                                  child: Text('Save Location'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
        ],
      ),
    );
  }
}
