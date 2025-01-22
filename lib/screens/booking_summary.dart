import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/screens/booking_list.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';

class BookingSummary extends StatefulWidget {
  const BookingSummary({super.key});

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
  List<dynamic> data = [];
  Map<String, dynamic> monthlyChartData = {};
  Map<String, dynamic> yearlyChartData = {};

  dynamic totalBooking = 0;
  dynamic totalUnpaid = 0;
  dynamic totalConfirmed = 0;
  dynamic totalCompleted = 0;
  dynamic totalCancelled = 0;
  dynamic totalCompletedAmount = 0;
  dynamic totalCancelledAmount = 0;
  dynamic totalFloatingAmount = 0;
  dynamic totalCompletedAmountThisMonth = 0;

  Future<void> _loadTaskerBookingList() async {
    try {
      var response = await TaskerBooking().getBookingList();
      if (response['statusCode'] == 200) {
        setState(() {
          data = response['data'];
          monthlyChartData = response['monthlyChartData'];
          yearlyChartData = response['yearlyChartData'];
          totalBooking = response['totalBooking'];
          totalUnpaid = response['totalUnpaid'];
          totalConfirmed = response['totalConfirmed'];
          totalCompleted = response['totalCompleted'];
          totalCancelled = response['totalCancelled'];
          totalCompletedAmount = response['totalCompletedAmount'];
          totalCancelledAmount = response['totalCancelledAmount'];
          totalFloatingAmount = response['totalFloatingAmount'];
          totalCompletedAmountThisMonth =
              response['totalCompletedAmountThisMonth'];
        });
      } else {
        print('Failed to load booking list: ${response['statusCode']}');
      }
      print('monthlyChartData');

      print(monthlyChartData);
      print(yearlyChartData);
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTaskerBookingList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Booking Summary',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Total Booking',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade700),
                          ),
                          Text(
                            '$totalBooking',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BookingList(
                                bookingData: data,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation:
                              2, // Adjust this value to control shadow intensity
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              vertical: 12, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          shadowColor: Colors.grey.withOpacity(
                              0.5), // Shadow color and transparency
                        ).copyWith(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Booking List',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            SizedBox(width: 10),
                            FaIcon(
                              FontAwesomeIcons.solidEye,
                              color: Colors.blue,
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete Booking',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.green.shade700),
                            ),
                            Text(
                              '$totalCompleted',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Confirmed Booking',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.greenAccent.shade700),
                            ),
                            Text(
                              '$totalConfirmed',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Unpaid Booking',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.orange.shade700),
                            ),
                            Text(
                              '$totalUnpaid',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Cancelled Booking',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.red.shade800),
                            ),
                            Text(
                              '$totalCancelled',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade600),
                            ),
                          ],
                        )),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Monthly Booking Amounts by Status',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Floating',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Cancelled',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      axisNameWidget: SizedBox(
                                        child: Text(
                                          'Amount (RM)',
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 35,
                                        getTitlesWidget: (value, meta) {
                                          return Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: Text(
                                              value.toInt().toString(),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 12,
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles:
                                        AxisTitles(axisNameWidget: Container()),
                                    topTitles: AxisTitles(
                                      axisNameWidget: Container(),
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      axisNameWidget: Container(),
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.shade300,
                                        strokeWidth: 1,
                                      );
                                    },
                                    drawVerticalLine: false,
                                  ),
                                  barGroups: [
                                    BarChartGroupData(
                                      x: 0,
                                      barRods: [
                                        BarChartRodData(
                                          borderRadius: BorderRadius.only(),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.red),
                                          width: 50,
                                          fromY: 0,
                                          toY: (monthlyChartData['cancelled']
                                                      is List &&
                                                  monthlyChartData['cancelled']
                                                      .isNotEmpty
                                              ? monthlyChartData['cancelled'][0]
                                              : 0.0),
                                          color: Colors.red.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 1,
                                      barRods: [
                                        BarChartRodData(
                                          borderRadius: BorderRadius.only(),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.green),
                                          width: 50,
                                          fromY: 0,
                                          toY: (monthlyChartData['completed']
                                                      is List &&
                                                  monthlyChartData['completed']
                                                      .isNotEmpty
                                              ? monthlyChartData['completed'][0]
                                              : 0.0),
                                          color: Colors.green.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 2,
                                      barRods: [
                                        BarChartRodData(
                                          borderRadius: BorderRadius.only(),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.orange),
                                          width: 50,
                                          fromY: 0,
                                          toY: (monthlyChartData['floating']
                                                      is List &&
                                                  monthlyChartData['floating']
                                                      .isNotEmpty
                                              ? monthlyChartData['floating'][0]
                                              : 0.0),
                                          color: Colors.orange.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              monthlyChartData['labels']?.join(', ') ?? '',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7.5),
                        ),
                        child: Column(
                          children: [
                            Center(
                              child: Text(
                                'Yearly Booking Amounts by Status',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Floating',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Cancelled',
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red.shade700,
                                  ),
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: BarChart(
                                BarChartData(
                                  alignment: BarChartAlignment.spaceAround,
                                  barTouchData: BarTouchData(enabled: false),
                                  titlesData: FlTitlesData(
                                    leftTitles: AxisTitles(
                                      axisNameWidget: SizedBox(
                                        child: Text(
                                          'Amount (RM)',
                                          style: TextStyle(
                                            color: Colors.grey.shade800,
                                            fontFamily: 'Inter',
                                            fontSize: 12,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 35,
                                        getTitlesWidget: (value, meta) {
                                          return Text(
                                            value.toInt().toString(),
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles:
                                        AxisTitles(axisNameWidget: Container()),
                                    topTitles: AxisTitles(
                                      axisNameWidget: Container(),
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                    rightTitles: AxisTitles(
                                      axisNameWidget: Container(),
                                      sideTitles: SideTitles(showTitles: false),
                                    ),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  gridData: FlGridData(
                                    getDrawingHorizontalLine: (value) {
                                      return FlLine(
                                        color: Colors.grey.shade300,
                                        strokeWidth: 1,
                                      );
                                    },
                                    drawVerticalLine: false,
                                  ),
                                  barGroups: [
                                    BarChartGroupData(
                                      x: 0,
                                      barRods: [
                                        BarChartRodData(
                                          borderRadius: BorderRadius.only(),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.red),
                                          width: 50,
                                          fromY: 0,
                                          toY: (yearlyChartData['cancelled']
                                                      is List &&
                                                  yearlyChartData['cancelled']
                                                      .isNotEmpty
                                              ? yearlyChartData['cancelled'][0]
                                              : 0.0),
                                          color: Colors.red.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 1,
                                      barRods: [
                                        BarChartRodData(
                                          borderRadius: BorderRadius.only(),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.green),
                                          width: 50,
                                          fromY: 0,
                                          toY: (yearlyChartData['completed']
                                                      is List &&
                                                  yearlyChartData['completed']
                                                      .isNotEmpty
                                              ? yearlyChartData['completed'][0]
                                              : 0.0),
                                          color: Colors.green.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                    BarChartGroupData(
                                      x: 2,
                                      barRods: [
                                        BarChartRodData(
                                          borderRadius: BorderRadius.only(),
                                          borderSide: BorderSide(
                                              width: 1, color: Colors.orange),
                                          width: 50,
                                          fromY: 0,
                                          toY: (yearlyChartData['floating']
                                                      is List &&
                                                  yearlyChartData['floating']
                                                      .isNotEmpty
                                              ? yearlyChartData['floating'][0]
                                              : 0.0),
                                          color: Colors.orange.withOpacity(0.5),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              yearlyChartData['labels']?.join(', ') ?? '',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Text(
                        'Total Completed Amount',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade700),
                      ),
                      Spacer(),
                      Text(
                        '(+) RM $totalCompletedAmount',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade600),
                      ),
                    ],
                  )),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Text(
                        'Total Floating Amount',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade700),
                      ),
                      Spacer(),
                      Text(
                        '(~) RM $totalCancelledAmount',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange.shade600),
                      ),
                    ],
                  )),
              SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(7.5)),
                  child: Row(
                    children: [
                      Text(
                        'Total Cancelled Amount',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey.shade700),
                      ),
                      Spacer(),
                      Text(
                        '(-) RM $totalFloatingAmount',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade600),
                      ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
