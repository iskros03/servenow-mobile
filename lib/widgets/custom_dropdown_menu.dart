import 'package:flutter/material.dart';

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

  void _showBottomSheet(BuildContext context) {
    if (!isEnabled) return; // Do nothing if not enabled

    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: Colors.white,
          ),
          height: MediaQuery.of(context).size.height * 0.5,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                '$titleSelect',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[500],
                ),
              ),
  
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                        items[index],
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1, // Use the borderWidth parameter
            color: isEnabled ? Colors.grey[300]! : Colors.grey[300]!, // Change color if disabled
          ),
        ),
        child: Row(
          children: [
            Text('${titleValue?.substring(0, 1).toUpperCase()}${titleValue?.substring(1)}',
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: 'Inter',
                    color: isEnabled
                        ? Colors.grey[600]
                        : Colors.grey[400])), // Change text color if disabled
            Spacer(),
            Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }
}
