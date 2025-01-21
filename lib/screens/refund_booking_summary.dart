import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/screens/refund_booking_list.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';

class RefundBookingSummary extends StatefulWidget {
  const RefundBookingSummary({super.key});

  @override
  State<RefundBookingSummary> createState() => _RefundBookingSummaryState();
}

class _RefundBookingSummaryState extends State<RefundBookingSummary> {
  List<dynamic> data = [];

  dynamic totalRefund = 0;
  dynamic totalPendingRefund = 0;
  dynamic totalSelfRefund = 0;
  dynamic totalApprovedAmount = '0.0';
  dynamic totalPenalizedAmount = '0.0';
  dynamic totalPendingAmount = '0.0';

  Future<void> _loadTaskerBookingList() async {
    try {
      var response = await TaskerBooking().getRefundBookingList();
      if (response['statusCode'] == 200) {
        setState(() {
          data = response['data'];

          totalRefund = response['totalRefund'] ?? 0;
          totalPendingRefund = response['totalPendingRefund'] ?? 0;
          totalSelfRefund = response['totalSelfRefund'] ?? 0;
          totalApprovedAmount = response['totalApprovedAmount'] ?? '';
          totalPenalizedAmount = response['totalPenalizedAmount'] ?? '';
          totalPendingAmount = response['totalPendingAmount'] ?? '';
        });
        print(totalRefund);
      } else {
        print('Failed to load booking list: ${response['statusCode']}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    _loadTaskerBookingList();
    super.initState();
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
            'Refund Summary',
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
                            'Total Refunds',
                            style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 13,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey.shade700),
                          ),
                          Text(
                            totalRefund.toString(),
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
                              builder: (context) => RefundBookingList(
                                bookingRefundData: data,
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
                              'Refund List',
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
                              'Pending Refunds',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              totalPendingRefund.toString(),
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
                              'Self-Refunds',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              totalSelfRefund.toString(),
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
                              'Total Refunds Amount (RM)',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '(-) ${double.parse(totalApprovedAmount).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600,
                              ),
                            )
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
                              'Total Self-Refunded Amount RM)',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '(-) ${double.parse(totalPenalizedAmount).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red.shade600,
                              ),
                            )
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
                              'Total Pending Amount (RM)',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '(~) ${double.parse(totalPendingAmount).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange.shade600,
                              ),
                            )
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
