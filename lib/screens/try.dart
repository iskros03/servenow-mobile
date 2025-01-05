import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';


class Try extends StatefulWidget {
  const Try({super.key});

  @override
  State<Try> createState() => _TryState();
}

class _TryState extends State<Try> {
  final List<String> viewType = ['Day', 'Month', 'List'];
  String? viewTypeTitle;

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final List<String> timeSlots = [];
  List<String> startTime = [];
  List<String> endTime = [];
  int? hoverStartIndex;

  List<dynamic> bookingsList = [];
  List<dynamic> filteredBookings = [];
  bool isLoadingBookingList = false;

  List<List<String>> startTimeSlots = [];
  List<List<String>> endTimeSlots = [];

  @override
  void initState() {
    super.initState();
    _loadTaskerBookingDetails(selectedDate);

    for (int hour = 7; hour <= 19; hour++) {
      timeSlots.add('${hour.toString().padLeft(2, '0')}:00:00');
    }
  }

  void _loadTaskerBookingDetails(String targetDate) async {
    setState(() {
      isLoadingBookingList = true;
    });
    try {
      var data = await TaskerBooking().getTaskerBookingDetails();
      bookingsList = data['booking'];

      filteredBookings = bookingsList.where((booking) {
        return booking['date'] == targetDate;
      }).toList();

      if (filteredBookings.isNotEmpty) {
        startTimeSlots.clear();
        endTimeSlots.clear();
        for (var booking in filteredBookings) {
          startTimeSlots.add([booking['startTime']]);
          endTimeSlots.add([booking['endTime']]);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error occurred: $e')),
      );
    } finally {
      setState(() {
        isLoadingBookingList = false;
      });
    }
  }

  void _updateTimeSlots(String data, int index) {
    setState(() {
      if (data.startsWith('start-')) {
        String draggedStartTime = data.split('-')[1];
        for (int i = 0; i < startTimeSlots.length; i++) {
          if (startTimeSlots[i][0] == draggedStartTime) {
            String newStartTime = timeSlots[index];

            for (int j = 0; j < startTimeSlots.length; j++) {
              if (i == j) continue;
              int otherStartIndex = timeSlots.indexOf(startTimeSlots[j][0]);
              int otherEndIndex = timeSlots.indexOf(endTimeSlots[j][0]);
              int newStartIndex = timeSlots.indexOf(newStartTime);
              int currentEndIndex = timeSlots.indexOf(endTimeSlots[i][0]);

              if ((newStartIndex < otherEndIndex &&
                      currentEndIndex > otherStartIndex) ||
                  (newStartIndex >= otherStartIndex &&
                      newStartIndex < otherEndIndex)) {
                return;
              }
            }

            int newStartIndex = timeSlots.indexOf(newStartTime);
            int currentEndIndex = timeSlots.indexOf(endTimeSlots[i][0]);
            if (newStartIndex >= currentEndIndex) {
              return;
            }

            startTimeSlots[i][0] = newStartTime;
          }
        }
      } else if (data.startsWith('end-')) {
        String draggedEndTime = data.split('-')[1];
        for (int i = 0; i < endTimeSlots.length; i++) {
          if (endTimeSlots[i][0] == draggedEndTime) {
            String newEndTime = timeSlots[index];

            for (int j = 0; j < startTimeSlots.length; j++) {
              if (i == j) continue;
              int otherStartIndex = timeSlots.indexOf(startTimeSlots[j][0]);
              int otherEndIndex = timeSlots.indexOf(endTimeSlots[j][0]);
              int newEndIndex = timeSlots.indexOf(newEndTime);
              int currentStartIndex = timeSlots.indexOf(startTimeSlots[i][0]);

              if ((newEndIndex > otherStartIndex &&
                      currentStartIndex < otherEndIndex) ||
                  (newEndIndex > otherStartIndex &&
                      newEndIndex <= otherEndIndex)) {
                return;
              }
            }

            int currentStartIndex = timeSlots.indexOf(startTimeSlots[i][0]);
            int newEndIndex = timeSlots.indexOf(newEndTime);
            if (newEndIndex <= currentStartIndex) {
              return;
            }
            endTimeSlots[i][0] = newEndTime;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          title: const Text(
            'My Booking',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      FaIcon(
                        FontAwesomeIcons.circleInfo,
                        color: Colors.blue[600],
                        size: 20,
                      ),
                      const SizedBox(width: 7.5),
                      Text(
                        'Note',
                        style: TextStyle(
                          color: Colors.blue[600],
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    'Change will take up to 5 minutes',
                    style: TextStyle(
                      color: Colors.red,
                      fontFamily: 'Inter',
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              _buildDateSelector(),
              const SizedBox(height: 10),
              WeekButtons(
                initialDate: selectedDate,
                onDateSelected: (date) {
                  setState(() {
                    selectedDate = date;
                  });
                  _loadTaskerBookingDetails(date);
                },
              ),
              const SizedBox(height: 10),
              Expanded(
                  child: isLoadingBookingList
                      ? Center(
                          child: Text(
                            'Loading...',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        )
                      : filteredBookings.isNotEmpty
                          ? SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: filteredBookings.map((booking) {
                                  return Draggable<Map<String, String>>(
                                    data: {
                                      'startTime': booking['startTime'],
                                      'endTime': booking['endTime'],
                                    },
                                    feedback: Container(
                                      width: 325,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 1,
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(5),
                                        color:
                                            Colors.blueAccent.withOpacity(0.7),
                                      ),
                                      child: Opacity(
                                        opacity: 0.8,
                                        child: Text(
                                          booking['title'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(right: 10.0),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              width: 1,
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.white,
                                        ),
                                        width: 325,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              booking['title'],
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                                fontFamily: 'Inter',
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              '${booking['startTime'].substring(0, 5)} - ${booking['endTime'].substring(0, 5)}',
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              '${booking['address']}',
                                              style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 12,
                                                fontFamily: 'Inter',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          : SizedBox.shrink()),
              SizedBox(height: 10),
              Expanded(
                flex: 4,
                child: isLoadingBookingList
                    ? Center(
                        child: Text(
                        'Loading...',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            color: Colors.grey[600]),
                      ))
                    : filteredBookings.isNotEmpty
                        ? ListView.builder(
                            itemCount: timeSlots.length,
                            itemBuilder: (context, index) {
                              bool isInBookingRange = false;
                              Color bookingColor = Colors.transparent;

                              for (int i = 0; i < startTimeSlots.length; i++) {
                                int startIndex =
                                    timeSlots.indexOf(startTimeSlots[i][0]);
                                int endIndex =
                                    timeSlots.indexOf(endTimeSlots[i][0]);

                                if (index > startIndex && index < endIndex) {
                                  isInBookingRange = true;
                                  bookingColor = _getBookingColor(i);
                                  break;
                                }
                              }

                              return DragTarget<String>(
                                onAcceptWithDetails: (details) {
                                  _updateTimeSlots(details.data, index);
                                  hoverStartIndex = null;
                                },
                                onMove: (details) {
                                  if (details.data == 'range') {
                                    setState(() {
                                      hoverStartIndex = index;
                                    });
                                  }
                                },
                                onLeave: (data) {
                                  if (data == 'range') {
                                    setState(() {
                                      hoverStartIndex = null;
                                    });
                                  }
                                },
                                builder:
                                    (context, candidateData, rejectedData) {
                                  bool isHovered = candidateData.isNotEmpty;
                                  return Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    decoration: BoxDecoration(
                                      color: isHovered
                                          ? Colors.grey[100]
                                          : (isInBookingRange
                                              ? bookingColor
                                              : Colors.white),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 75,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[100],
                                            borderRadius:
                                                const BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                    topLeft:
                                                        Radius.circular(5)),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2.5),
                                          child: Text(
                                            textAlign: TextAlign.center,
                                            timeSlots[index].substring(0, 5),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              color: Colors.grey[800],
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        for (int i = 0;
                                            i < startTimeSlots.length;
                                            i++)
                                          if (timeSlots[index] ==
                                              startTimeSlots[i][0]) ...[
                                            Expanded(
                                              child: Draggable<String>(
                                                data:
                                                    'start-${timeSlots[index]}',
                                                feedback: Container(
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: _getBookingColor(i),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                childWhenDragging:
                                                    const SizedBox.shrink(),
                                                child: Container(
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: _getBookingColor(i),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        for (int i = 0;
                                            i < endTimeSlots.length;
                                            i++)
                                          if (timeSlots[index] ==
                                              endTimeSlots[i][0]) ...[
                                            Expanded(
                                              flex: 1,
                                              child: Draggable<String>(
                                                data: 'end-${timeSlots[index]}',
                                                feedback: Container(
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: _getBookingColor(i),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                                childWhenDragging:
                                                    const SizedBox.shrink(),
                                                child: Container(
                                                  height: 20,
                                                  decoration: BoxDecoration(
                                                    color: _getBookingColor(i),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                      ],
                                    ),
                                  );
                                },
                              );
                            },
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[100],
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'No task available.',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
              )
            ],
          ),
        ));
  }

  Color _getBookingColor(int index) {
    List<Color> colors = [
      Colors.purpleAccent,
      Colors.redAccent,
      Colors.blue,
      Colors.white,
      Colors.orange,
    ];
    return colors[index % colors.length];
  }

  Widget _buildDateSelector() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(
              selectedDate,
              style: TextStyle(
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            child: CustomDropdownMenu(
              items: viewType,
              titleSelect: 'Select View Type',
              titleValue: viewTypeTitle ?? 'Day',
              onSelected: (selectedValue) {
                setState(() {
                  viewTypeTitle = selectedValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}


class WeekButtons extends StatefulWidget {
  final Function(String) onDateSelected;
  final String initialDate;

  const WeekButtons({
    super.key,
    required this.onDateSelected,
    required this.initialDate,
  });

  @override
  WeekButtonsState createState() => WeekButtonsState();
}

class WeekButtonsState extends State<WeekButtons> {
  late String selectedDate;

  @override
  void initState() {
    super.initState();
    selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> weekDates =
        List.generate(7, (index) => DateTime.now().add(Duration(days: index)));

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: weekDates.map((date) {
          String dayMonthYearLabel = DateFormat('d MMMM yyyy').format(date);
          String dayNameLabel = DateFormat('EEEE').format(date);
          String formattedDate = DateFormat('yyyy-MM-dd').format(date);
          bool isSelected = formattedDate == selectedDate;

          return Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: SizedBox(
              width: 165,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(
                      color: isSelected
                          ? const Color.fromRGBO(24, 52, 92, 1)
                          : Colors.grey.shade300,
                      width: 1,
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  elevation: 0,
                ),
                onPressed: () {
                  setState(() {
                    selectedDate = formattedDate;
                  });
                  widget.onDateSelected(formattedDate);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(dayNameLabel,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12,
                          color: Colors.grey[800],
                        )),
                    Text(
                      dayMonthYearLabel,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


