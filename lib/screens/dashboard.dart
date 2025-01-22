import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/screens/booking_details.dart';
import 'package:servenow_mobile/services/tasker_booking.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void dispose() {
    super.dispose();
  }

  List<dynamic> confirmBookingData = [];
  List<dynamic> books = [];
  List<dynamic> filteredBooks = [];

  dynamic totalearningsAll = '0.0';
  dynamic totalearningsThisMonth = '0.0';
  dynamic totalearningsThisYear = '0.0';
  dynamic totalBookingCount = 0;
  dynamic totalPenaltyCount = 0;
  dynamic totalAVGrating = '0.0';

  dynamic thismonthcompleted = 0;
  dynamic thismonthfloating = 0;
  dynamic thismonthCancelled = 0;
  dynamic thisyearcompleted = 0;
  dynamic thisyearfloating = 0;
  dynamic thisyearCancelled = 0;

  Future<void> _loadTaskerDashboard() async {
    try {
      var response = await TaskerBooking().getDashboard();
      if (response['statusCode'] == 200) {
        setState(() {
          confirmBookingData = response['confirmBookingData'];
          books = response['books'];

          totalearningsAll = response['totalearningsAll'];
          totalearningsThisMonth = response['totalearningsThisMonth'];
          totalearningsThisYear = response['totalearningsThisYear'];
          totalBookingCount = response['totalBookingCount'];
          totalPenaltyCount = response['totalPenaltyCount'];
          totalAVGrating = response['totalAVGrating'];

          thismonthcompleted = response['thismonthcompleted'];
          thismonthfloating = response['thismonthfloating'];
          thismonthCancelled = response['thismonthCancelled'];
          thisyearcompleted = response['thisyearcompleted'];
          thisyearfloating = response['thisyearfloating'];
          thisyearCancelled = response['thisyearCancelled'];

          for (var book in books) {
            if (confirmBookingData.any((confirm) =>
                confirm['booking_order_id'] == book['booking_order_id'])) {
              filteredBooks.add(book);
            }
          }
        });
      } else {
        print('Failed to load booking list: ${response['statusCode']}');
      }
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadTaskerDashboard();
  }

  Future<void> _refresh() async {
    setState(() {
      _loadTaskerDashboard();
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
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: TextButton(
          style: const ButtonStyle(
            splashFactory: NoSplash.splashFactory,
          ),
          onPressed: () {},
          child: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.user,
              size: 16,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, size: 20, color: Colors.white),
            onPressed: _refresh,
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Total Earnings',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Inter',
                                    color: Colors.grey.shade800)),
                            Text('RM $totalearningsAll',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Your Rank Level',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Inter',
                                    color: Colors.grey.shade800)),
                            Text('Elite Tasker',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 100,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Satisfication',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Inter',
                                    color: Colors.grey.shade800)),
                            SizedBox(height: 15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                5,
                                (index) => FaIcon(
                                  FontAwesomeIcons.solidStar,
                                  color: index <
                                          double.parse(totalAVGrating).round()
                                      ? Colors.orange
                                      : Colors.grey.shade300,
                                  size: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7.5),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: Colors.white),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                Text('RM $totalearningsThisMonth',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600])),
                                Text('This Month',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[800])),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                Text('RM $totalearningsThisYear',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600])),
                                Text('This Year',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[800])),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                Text('$totalBookingCount / 20',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600])),
                                Text('Bookings',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[800])),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                Text('0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red[700])),
                                Text('Penalty',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[800])),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                Text('$totalAVGrating / 5.0',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.orange[700])),
                                Text('Average Rating',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[800])),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 100,
                            child: Column(
                              children: [
                                Text('Happy',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[700])),
                                Text('Verdict',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.normal,
                                        fontFamily: 'Inter',
                                        color: Colors.grey[800])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 7.5),
                Expanded(
                  child: Container(
                    height: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7.5),
                      color: Colors.white,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Confirm Booking',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 5),
                        confirmBookingData.isEmpty
                            ? Expanded(
                                child: Center(
                                child: Text(
                                  "You don't have confirm booking.",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Inter',
                                    color: Colors.grey[800],
                                  ),
                                ),
                              ))
                            : Expanded(
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  radius: Radius.circular(7.5),
                                  thickness: 2.5,
                                  child: ListView.builder(
                                    itemCount: filteredBooks.length,
                                    itemBuilder: (context, index) {
                                      final booking = filteredBooks[index];
                                      return Column(
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 1,
                                              backgroundColor: Colors.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 20),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              shadowColor:
                                                  Colors.grey.withOpacity(0.5),
                                            ).copyWith(
                                              overlayColor:
                                                  WidgetStateProperty.all(
                                                      Colors.transparent),
                                            ),
                                            onPressed: () {
                                              var matchingBooking =
                                                  confirmBookingData.firstWhere(
                                                (confirm) =>
                                                    confirm[
                                                        'booking_order_id'] ==
                                                    booking['booking_order_id'],
                                                orElse: () => null,
                                              );
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      BookingDetails(
                                                    bookingId: booking[
                                                        'booking_order_id'],
                                                    bookingTask: booking[
                                                        'servicetype_name'],
                                                    bookingEmail:
                                                        booking['client_email'],
                                                    bookingStatus: booking[
                                                        'booking_status'],
                                                    bookingClientName: booking[
                                                            'client_firstname'] +
                                                        ' ' +
                                                        booking[
                                                            'client_lastname'],
                                                    bookingCLientPhone: booking[
                                                        'client_phoneno'],
                                                    bookingClientAddress:
                                                        booking[
                                                            'booking_address'],
                                                    bookingDate:
                                                        booking['booking_date'],
                                                    bookingStartTime: booking[
                                                        'booking_time_start'],
                                                    bookingEndTime: booking[
                                                        'booking_time_end'],
                                                    bookingRate:
                                                        booking['booking_rate'],
                                                    bookingLat: matchingBooking[
                                                        'booking_latitude'],
                                                    bookingLong: matchingBooking[
                                                        'booking_longitude'],
                                                    bookingNote: booking[
                                                            'booking_note'] ??
                                                        'Unavailable Note.',
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Row(
                                              children: [
                                                Text(
                                                  '${index + 1}.',
                                                  style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontFamily: 'Inter',
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      booking['booking_order_id']!
                                                          .toString(),
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Inter',
                                                        color: Colors.blue,
                                                      ),
                                                    ),
                                                    Text(
                                                      booking[
                                                          'servicetype_name']!,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Inter',
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Spacer(),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Text(
                                                      booking['booking_date']!,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Inter',
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${booking['booking_time_start']} - ${booking['booking_time_end']}',
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontFamily: 'Inter',
                                                        color: Colors
                                                            .grey.shade800,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (index != filteredBooks.length - 1)
                                            SizedBox(height: 7.5),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 7.5),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Montly Revenue by Status',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 7.5),
                        SingleChildScrollView(
                          primary: false,
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                width: 175,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Complete Booking',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600),
                                        ),
                                        SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.solidCircleCheck,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$thismonthcompleted',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 175,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Floating Booking',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600),
                                        ),
                                        SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.ghost,
                                          size: 18,
                                          color: Colors.orange,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$thismonthfloating',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 175,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Cancelled Booking',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600),
                                        ),
                                        SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.solidCircleXmark,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$thismonthCancelled',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/booking_summary');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  shadowColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  surfaceTintColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: Text(
                                  'View More',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue.shade600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                SizedBox(height: 10),
                Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(7.5)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yearly Revenue by Status',
                          style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade700),
                        ),
                        SizedBox(height: 7.5),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              Container(
                                width: 175,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Complete Booking',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600),
                                        ),
                                        SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.solidCircleCheck,
                                          size: 18,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$thisyearcompleted',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 175,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Floating Booking',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600),
                                        ),
                                        SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.ghost,
                                          size: 18,
                                          color: Colors.orange,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$thisyearfloating',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              Container(
                                width: 175,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(7.5),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Cancelled Booking',
                                          style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.grey.shade600),
                                        ),
                                        SizedBox(width: 10),
                                        FaIcon(
                                          FontAwesomeIcons.solidCircleXmark,
                                          size: 18,
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      '$thisyearCancelled',
                                      style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                      context, '/booking_summary');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 20),
                                ).copyWith(
                                  overlayColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  shadowColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                  surfaceTintColor: WidgetStateProperty.all(
                                      Colors.transparent),
                                ),
                                child: Text(
                                  'View More',
                                  style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.blue.shade600),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
