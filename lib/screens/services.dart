import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/screens/add_service.dart';
import 'package:servenow_mobile/screens/manage_service.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
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
        print('Services: $services');
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
        return {'text': 'Pending', 'color': Colors.orange};
      case 1:
        return {'text': 'Active', 'color': Colors.green};
      case 2:
        return {'text': 'Inactive', 'color': Colors.red};
      case 3:
        return {'text': 'Rejected', 'color': Colors.red};
      case 4:
        return {'text': 'Terminated', 'color': Colors.red};
      default:
        return {'text': 'Unknown', 'color': Colors.grey};
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Services',
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
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Task Management'),
              Tab(text: 'Task Service'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
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
                  SizedBox(height: 25),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      children: [
                        Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Total Service : ',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]),
                                  ),
                                  Text(
                                    '${services.length}',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey[600]),
                                  ),
                                ],
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 10),
                                    backgroundColor:
                                        Color.fromRGBO(24, 52, 92, 1),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    side: BorderSide(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => AddService()),
                                    ).then((result) {
                                      if (result == true) {
                                        _loadTaskerServiceList(); // Refresh the service list
                                      }
                                    });
                                  },
                                  child: Text(
                                    '+  Service',
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ))
                            ],
                          ),
                        ),
                        CustomTextField(
                          controller: searchController,
                          labelText: 'Search Service...',
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                  Column(
                    children: services.map((service) {
                      int status = service['service_status'];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    getServiceTypeName(
                                        service['service_type_id']),
                                    style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontSize: 14,
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
                                        service['service_rate_type'],
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
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  SizedBox(height: 15),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(5)),
                                      color: getServiceStatus(status)['color'],
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 7.5),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      getServiceStatus(status)['text'],
                                      style: const TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                icon: FaIcon(FontAwesomeIcons.chevronRight,
                                    color: Colors.grey[600], size: 16),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ManageService(
                                        serviceIdSingle: service['id'],
                                        serviceTypeId:
                                            service['service_type_id'],
                                        serviceTypeSingle: getServiceTypeName(
                                            service['service_type_id']),
                                        serviceRateSingle:
                                            service['service_rate'],
                                        serviceStatusSingle:
                                            service['service_status'],
                                        serviceDescSingle:
                                            service['service_desc'],
                                        serviceRateTypeSingle:
                                            service['service_rate_type'],
                                      ),
                                    ),
                                  ).then((result) {
                                    if (result == true) {
                                      _loadTaskerServiceList();
                                    }
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Center(child: Text('Lorem Ipsum Content')),
          ],
        ),
      ),
    );
  }
}
