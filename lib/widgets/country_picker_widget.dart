import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CountryPickerWidget extends StatefulWidget {
  final String initialCountry;
  final Map<String, String> timeZones;

  CountryPickerWidget({required this.initialCountry, required this.timeZones});

  @override
  _CountryPickerWidgetState createState() => _CountryPickerWidgetState();
}

class _CountryPickerWidgetState extends State<CountryPickerWidget> {
  late int _selectedIndex;
  late List<String> _countries;

  @override
  void initState() {
    super.initState();
    _countries = widget.timeZones.keys.toList();
    _selectedIndex = _countries.indexOf(widget.initialCountry);
    if (_selectedIndex == -1) _selectedIndex = 0; // Default to first item
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      padding: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        children: [
          Expanded(
            child: CupertinoPicker(
              scrollController:
                  FixedExtentScrollController(initialItem: _selectedIndex),
              itemExtent: 40,
              magnification: 1.2,
              useMagnifier: true,
              backgroundColor: Colors.white,
              onSelectedItemChanged: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              children: _countries
                  .map((country) => Center(child: Text(country)))
                  .toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close modal without selection
                },
                child: Text("Cancel", style: TextStyle(color: Colors.red)),
              ),
              TextButton(
                onPressed: () {
                  String selectedCountry = _countries[_selectedIndex];
                  String selectedTimeZone = widget.timeZones[selectedCountry]!;
                  Navigator.pop(context, {
                    'country': selectedCountry,
                    'timeZone': selectedTimeZone
                  });
                },
                child: Text("Confirm", style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
