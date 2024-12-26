import 'package:flutter/material.dart';

class DragDrop extends StatefulWidget {
  const DragDrop({super.key});

  @override
  State<DragDrop> createState() => _DragDropState();
}

class _DragDropState extends State<DragDrop> {
  final List<String> timeSlots = [];
  String? startTimeSlot;
  String? endTimeSlot;

  @override
  void initState() {
    super.initState();
    for (int hour = 7; hour <= 19; hour++) {
      timeSlots.add('${hour.toString().padLeft(2, '0')}:00');
    }
    startTimeSlot = timeSlots[3];
    endTimeSlot = timeSlots[5];
  }

  bool _isInRange(int index) {
    if (startTimeSlot == null || endTimeSlot == null) return false;
    int startIndex = timeSlots.indexOf(startTimeSlot!);
    int endIndex = timeSlots.indexOf(endTimeSlot!);
    return index >= startIndex && index <= endIndex;
  }

  void _updateTimeSlots(String data, int index) {
    setState(() {
      int startIndex = timeSlots.indexOf(startTimeSlot!);
      int endIndex = timeSlots.indexOf(endTimeSlot!);

      if (data == 'range') {
        // Move the entire range
        startTimeSlot = timeSlots[index];
        endTimeSlot = timeSlots[index + (endIndex - startIndex)];
      } else {
        // Move individual time slots
        if (data == startTimeSlot && index < endIndex) {
          startTimeSlot = timeSlots[index];
        } else if (data == endTimeSlot && index > startIndex) {
          endTimeSlot = timeSlots[index];
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Drag Drop'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              'Selected Time: ${startTimeSlot ?? '-'} to ${endTimeSlot ?? '-'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: timeSlots.length,
                itemBuilder: (context, index) {
                  return DragTarget<String>(
                    onAcceptWithDetails: (details) =>
                        _updateTimeSlots(details.data, index),
                    builder: (context, candidateData, rejectedData) {
                      bool isInRange = _isInRange(index);
                      return Draggable<String>(
                        data: (startTimeSlot == timeSlots[index] ||
                                endTimeSlot == timeSlots[index])
                            ? timeSlots[index]
                            : 'range',
                        feedback: const Material(color: Colors.transparent),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isInRange
                                ? Colors.blueAccent.withOpacity(0.7)
                                : Colors.grey[100],
                            border: candidateData.isNotEmpty
                                ? Border.all(color: Colors.blue, width: 2)
                                : null,
                            boxShadow: [
                              if (candidateData.isNotEmpty)
                                const BoxShadow(color: Colors.blue, blurRadius: 0),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(7.5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  timeSlots[index],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.normal),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
