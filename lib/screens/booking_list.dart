import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/services/tasker_service.dart';

class BookingList extends StatefulWidget {
  const BookingList({super.key});

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
    List<dynamic> services = []; // List service from specific tasker
  List<dynamic> serviceType = []; // List service type
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadTaskerServiceList();
    _loadTaskerServiceType();
  }

  void _loadTaskerServiceType() async {
    try {
      var data = await TaskerService().getTaskerServiceType();
      setState(() {
        serviceType = data;
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _loadTaskerServiceList() async {
    try {
      var data = await TaskerService().getTaskerServiceList();
      setState(() {
        services = data;
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  String getServiceTypeName(int serviceTypeId) {
    final serviceTypeName = serviceType.firstWhere(
      (serviceType) => serviceType['id'] == serviceTypeId,
      orElse: () => {'servicetype_name': '...'},
    );
    return serviceTypeName['servicetype_name'];
  }

  Map<String, dynamic> getServiceStatus(int status) {
    switch (status) {
      case 0:
        return {
          'text': 'Pending',
          'color': Colors.orange[50],
          'textColor': Colors.orange[500]
        };
      case 1:
        return {
          'text': 'Active',
          'color': Colors.green[50],
          'textColor': Colors.green[500]
        };
      case 2:
        return {
          'text': 'Inactive',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 3:
        return {
          'text': 'Rejected',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
      case 4:
        return {
          'text': 'Teminated',
          'color': Colors.purple[50],
          'textColor': Colors.purple[500]
        };
      default:
        return {
          'text': 'Unknown',
          'color': Colors.red[50],
          'textColor': Colors.red[500]
        };
    }
  }

  String capitalizeFirstLetter(String str) {
    List<String> words = str.split(' ');
    for (int i = 0; i < words.length; i++) {
      words[i] =
          words[i][0].toUpperCase() + words[i].substring(1).toLowerCase();
    }
    return words.join(' ');
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
          'Booking List',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Theme(
                data: ThemeData(
                  highlightColor: Colors.grey[300],
                ),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 5.0,
                  radius: Radius.circular(8.0),
                  child: ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      int status = service['service_status'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(7.5)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                capitalizeFirstLetter(getServiceTypeName(
                                    service['service_type_id'])),
                                style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[800]),
                              ),
                              Row(
                                children: [
                                  Text(
                                    'RM ${double.parse(service['service_rate'].toString()).toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    capitalizeFirstLetter(
                                        service['service_rate_type']),
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                service['service_desc'] ??
                                    'No description available.',
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 12,
                                  color: Colors.grey[800],
                                ),
                              ),
                              SizedBox(height: 10),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Container(
                                    width: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: getServiceStatus(status)['color'],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 5),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      getServiceStatus(status)['text'],
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10,
                                        color: getServiceStatus(
                                            status)['textColor'],
                                      ),
                                    ),
                                  ),
                                  Spacer(),
                                  IconButton(
                                      color: service['service_status'] == 0
                                          ? Colors.grey.shade300
                                          : Colors.blueGrey,
                                      style: ButtonStyle(
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap)
                                          .copyWith(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        shadowColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        surfaceTintColor:
                                            WidgetStateProperty.all(
                                                Colors.transparent),
                                      ),
                                      onPressed: () {
                                        if (service['service_status'] != 0) {
                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //     builder: (context) =>
                                          //         ManageService(
                                          //       serviceIdSingle: service['id'],
                                          //       serviceTypeId:
                                          //           service['service_type_id'],
                                          //       serviceTypeSingle:
                                          //           getServiceTypeName(service[
                                          //               'service_type_id']),
                                          //       serviceRateSingle:
                                          //           service['service_rate'],
                                          //       serviceStatusSingle:
                                          //           service['service_status'],
                                          //       serviceDescSingle:
                                          //           service['service_desc'],
                                          //       serviceRateTypeSingle: service[
                                          //           'service_rate_type'],
                                          //     ),
                                          //   ),
                                          // ).then((result) {
                                          //   if (result == true) {
                                          //     _loadTaskerServiceList();
                                          //   }
                                          // });
                                        }
                                      },
                                      icon: FaIcon(
                                        FontAwesomeIcons.pen,
                                        size: 18,
                                      ))
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
