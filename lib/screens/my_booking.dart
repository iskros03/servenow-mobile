import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';

class MyBooking extends StatefulWidget {
  const MyBooking({super.key});

  @override
  State<MyBooking> createState() => _MyBookingState();
}

class _MyBookingState extends State<MyBooking> {
  final List<String> viewType = ['Day', 'Month', 'List'];
  String? viewTypeTitle;

  String selectedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

  final List<String> timeSlots = [];
  String? startTimeSlot;
  String? endTimeSlot;
  int? hoverStartIndex;

  List<dynamic> bookingsList = [];
  List<dynamic> filteredBookings = [];
  bool isLoadingBookingList = false;

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
        for (var booking in filteredBookings) {
          print(booking);
          startTimeSlot = booking['startTime'];
          endTimeSlot = booking['endTime'];
        }
      } else {
        print('No bookings found for $targetDate.');
      }
    } catch (e) {
      print('Error occurred: $e');
    } finally {
      setState(() {
        isLoadingBookingList = false;
      });
    }
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
        if (index + (endIndex - startIndex) < timeSlots.length) {
          startTimeSlot = timeSlots[index];
          endTimeSlot = timeSlots[index + (endIndex - startIndex)];
        }
      } else {
        if (data == startTimeSlot && index < endIndex) {
          startTimeSlot = timeSlots[index];
        } else if (data == endTimeSlot && index > startIndex) {
          endTimeSlot = timeSlots[index];
        }
      }
    });
    print('Start Time Slot: $startTimeSlot');
    print('End Time Slot: $endTimeSlot');
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
            const SizedBox(height: 25),
            Text(
              'Date',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Inter',
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 5),
            WeekButtons(
              initialDate: selectedDate,
              onDateSelected: (date) {
                setState(() {
                  selectedDate = date;
                });
                _loadTaskerBookingDetails(date);
              },
            ),
            const SizedBox(height: 25),
            Draggable<String>(
              data: 'range',
              feedback: SizedBox.shrink(),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Column(
                  children: [
                    Text(
                      textAlign: TextAlign.center,
                      '${startTimeSlot?.substring(0, 5) ?? '-'} - ${endTimeSlot?.substring(0, 5) ?? '-'}',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 14,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      'Iskandar - Flooring',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            Expanded(
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
                              builder: (context, candidateData, rejectedData) {
                                int rangeSize =
                                    timeSlots.indexOf(endTimeSlot!) -
                                        timeSlots.indexOf(startTimeSlot!);
                                bool isInRange = _isInRange(index);
                                bool isHovered = hoverStartIndex != null &&
                                    index >= hoverStartIndex! &&
                                    index <= hoverStartIndex! + rangeSize;

                                return Draggable<String>(
                                  data: (startTimeSlot == timeSlots[index] ||
                                          endTimeSlot == timeSlots[index])
                                      ? timeSlots[index]
                                      : 'range',
                                  feedback: SizedBox.shrink(),
                                  child: Container(
                                    height: 25,
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 1),
                                    decoration: BoxDecoration(
                                      color: isHovered
                                          ? Colors.green.withOpacity(0.5)
                                          : isInRange
                                              ? Colors.green
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: isHovered
                                            ? Colors.transparent
                                            : isInRange ||
                                                    candidateData.isNotEmpty
                                                ? Colors.green
                                                : Colors.transparent,
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 50,
                                          child: Text(
                                            textAlign: TextAlign.right,
                                            timeSlots[index].substring(0, 5),
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontFamily: 'Inter',
                                              color: isInRange || isHovered
                                                  ? Colors.white
                                                  : Colors.grey[800],
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        if (timeSlots[index] == startTimeSlot)
                                          Expanded(
                                            child: Icon(Icons.drag_handle,
                                                size: 16, color: Colors.white),
                                          ),
                                        if (timeSlots[index] == endTimeSlot)
                                          Expanded(
                                            child: Icon(Icons.drag_handle,
                                                size: 16, color: Colors.white),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[100],
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'No Booking found.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
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
