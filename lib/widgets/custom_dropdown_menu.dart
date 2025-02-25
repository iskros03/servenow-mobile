import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomDropdownMenu extends StatelessWidget {
  final List<String> items;
  final ValueChanged<String> onSelected;
  final String? titleSelect;
  final String? titleValue;
  final bool isEnabled; // New parameter to control enabling/disabling

  const CustomDropdownMenu({
    super.key,
    required this.items,
    required this.onSelected,
    this.titleSelect,
    this.titleValue,
    this.isEnabled = true, // Default to enabled
  });

  String capitalizeFirstLetter(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] =
          words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    return words.join(' ');
  }

  void _showBottomSheet(BuildContext context) {
    if (!isEnabled) return; // Do nothing if not enabled

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                  width: 50, // Set width to 50
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Apply border radius
                    color: Colors.grey[200], // Line color
                  ),
                  child: Divider(
                    color: Colors.transparent, // Make divider transparent
                    thickness: 1, // Line thickness
                    height: 3, // Space around the line
                  )),
              SizedBox(height: 10),
              Text(
                '$titleSelect',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity, // Set width to 50
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(10), // Apply border radius
                    color: Colors.grey[300], // Line color
                  ),
                  child: Divider(
                    color: Colors.transparent, // Make divider transparent
                    thickness: 1, // Line thickness
                    height: 1, // Space around the line
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        items[index],
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey[800]),
                      ),
                      onTap: () {
                        onSelected(items[index]);
                        Navigator.pop(context);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEnabled
          ? () => _showBottomSheet(context)
          : null, // Open bottom sheet only if enabled
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(7.5),
          border: Border.all(
            width: 1, // Use the borderWidth parameter
            color: isEnabled
                ? Colors.grey[300]!
                : Colors.grey[100]!, // Change color if disabled
          ),
        ),
        child: Row(
          children: [
            Text(capitalizeFirstLetter('$titleValue'),
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: 'Inter',
                    color: isEnabled
                        ? Colors.grey[800]
                        : Colors.grey[400])), // Change text color if disabled
            Spacer(),
            FaIcon(
              FontAwesomeIcons.chevronDown,
              size: 14,
              color: Colors.grey.shade500,
            ),
          ],
        ),
      ),
    );
  }
}
