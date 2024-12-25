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
    startTimeSlot = timeSlots[3]; // 10:00
    endTimeSlot = timeSlots[5]; // 12:00
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Drag and Drop Time Slots')),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.blueAccent.withOpacity(0.1),
            child: Text(
              'Selected Time: ${startTimeSlot ?? '-'} to ${endTimeSlot ?? '-'}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: timeSlots.length,
              itemBuilder: (context, index) {
                return DragTarget<String>(
                  onAcceptWithDetails: (data) {
                    setState(() {
                      int startIndex = timeSlots.indexOf(startTimeSlot!);
                      int endIndex = timeSlots.indexOf(endTimeSlot!);
                      // Check if dragging the entire range
                      if (data.data == 'range') {
                        // Move the entire range
                        startTimeSlot = timeSlots[index];
                        endTimeSlot =
                            timeSlots[index + (endIndex - startIndex)];
                      } else {
                        // Move individual time slots
                        if (data.data == startTimeSlot) {
                          if (index < endIndex) {
                            startTimeSlot = timeSlots[index];
                          }
                        } else if (data.data == endTimeSlot) {
                          if (index > startIndex) {
                            endTimeSlot = timeSlots[index];
                          }
                        }
                      }
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    bool isInRange = false;
                    if (startTimeSlot != null && endTimeSlot != null) {
                      int startIndex = timeSlots.indexOf(startTimeSlot!);
                      int endIndex = timeSlots.indexOf(endTimeSlot!);
                      isInRange = index >= startIndex && index <= endIndex;
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: isInRange
                            ? Colors.blueAccent.withOpacity(0.7)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          if (candidateData.isNotEmpty)
                            const BoxShadow(
                                color: Colors.blue, blurRadius: 6.0),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            timeSlots[index],
                            style: const TextStyle(fontSize: 18),
                          ),
                          if (startTimeSlot != null &&
                              endTimeSlot != null &&
                              index == timeSlots.indexOf(startTimeSlot!))
                            Draggable<String>(
                              data: 'range',
                              feedback: Material(
                                elevation: 4.0,
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: const Text(
                                    'Drag Range',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              childWhenDragging:
                                  Container(), // Hide the original widget
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: const Text(
                                  'Drag Range',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          if (startTimeSlot == timeSlots[index] ||
                              endTimeSlot == timeSlots[index])
                            Draggable<String>(
                              data: timeSlots[index],
                              feedback: Material(
                                elevation: 4.0,
                                color: Colors.transparent,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12.0, vertical: 6.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                  child: Text(
                                    timeSlots[index],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              childWhenDragging:
                                  Container(), // Hide the original widget
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0, vertical: 6.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(4.0),
                                ),
                                child: Text(
                                  timeSlots[index],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
