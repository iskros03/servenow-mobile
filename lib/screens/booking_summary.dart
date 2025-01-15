import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookingSummary extends StatefulWidget {
  const BookingSummary({super.key});

  @override
  State<BookingSummary> createState() => _BookingSummaryState();
}

class _BookingSummaryState extends State<BookingSummary> {
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
              fontSize: 18,
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
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                            '2',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/booking_list');
                        },
                        icon: FaIcon(FontAwesomeIcons.eye),
                        color: Colors.blue,
                        style: IconButton.styleFrom().copyWith(
                          overlayColor:
                              WidgetStateProperty.all(Colors.transparent),
                          shadowColor:
                              WidgetStateProperty.all(Colors.transparent),
                          surfaceTintColor:
                              WidgetStateProperty.all(Colors.transparent),
                        ),
                      )
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
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
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
                              '2',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
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
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
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
                              '2',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
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
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
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
                              '2',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
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
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
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
                              '2',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 22,
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
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          children: [
                            Center(
                                child: Text(
                              'Monthly Booking Amounts by Status',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            )),
                            Row(
                              children: [
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.green.shade700),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Floating',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.orange.shade700),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Cancelled',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red.shade700),
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              width: 275,
                              height: 225,
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
                                            color: Colors.grey.shade600,
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
                                    bottomTitles: AxisTitles(
                                      axisNameWidget: Container(),
                                    ),
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
                                    BarChartGroupData(x: 0, barRods: [
                                      BarChartRodData(
                                        borderRadius: BorderRadius.only(),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.red),
                                        width: 50,
                                        fromY: 0,
                                        toY: 20,
                                        color: Colors.red.withOpacity(0.35),
                                      )
                                    ]),
                                    BarChartGroupData(x: 1, barRods: [
                                      BarChartRodData(
                                        borderRadius: BorderRadius.only(),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                        width: 50,
                                        fromY: 0,
                                        toY: 30,
                                        color: Colors.green.withOpacity(0.35),
                                      )
                                    ]),
                                    BarChartGroupData(x: 2, barRods: [
                                      BarChartRodData(
                                        borderRadius: BorderRadius.only(),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.orange),
                                        width: 50,
                                        fromY: 0,
                                        toY: 13,
                                        color: Colors.orange.withOpacity(0.35),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'January 2025',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 1, color: Colors.grey.shade300),
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(7.5)),
                        child: Column(
                          children: [
                            Center(
                                child: Text(
                              'Yearly Booking Amounts by Status',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            )),
                            Row(
                              children: [
                                Text(
                                  'Completed',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.green.shade700),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Floating',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.orange.shade700),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'Cancelled',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.red.shade700),
                                ),
                              ],
                            ),
                            Spacer(),
                            SizedBox(
                              width: 275,
                              height: 225,
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
                                            color: Colors.grey.shade600,
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
                                    bottomTitles: AxisTitles(
                                      axisNameWidget: Container(),
                                    ),
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
                                    BarChartGroupData(x: 0, barRods: [
                                      BarChartRodData(
                                        borderRadius: BorderRadius.only(),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.red),
                                        width: 50,
                                        fromY: 0,
                                        toY: 20,
                                        color: Colors.red.withOpacity(0.35),
                                      )
                                    ]),
                                    BarChartGroupData(x: 1, barRods: [
                                      BarChartRodData(
                                        borderRadius: BorderRadius.only(),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.green),
                                        width: 50,
                                        fromY: 0,
                                        toY: 30,
                                        color: Colors.green.withOpacity(0.35),
                                      )
                                    ]),
                                    BarChartGroupData(x: 2, barRods: [
                                      BarChartRodData(
                                        borderRadius: BorderRadius.only(),
                                        borderSide: BorderSide(
                                            width: 1, color: Colors.orange),
                                        width: 50,
                                        fromY: 0,
                                        toY: 13,
                                        color: Colors.orange.withOpacity(0.35),
                                      )
                                    ]),
                                  ],
                                ),
                              ),
                            ),
                            Text(
                              'Year 2025',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            )
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
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                        '(+) RM 0.00',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
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
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                        '(~) RM 10.00',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
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
                      border: Border.all(width: 1, color: Colors.grey.shade300),
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
                        '(-) RM 0.00',
                        style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 18,
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
