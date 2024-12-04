// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  List<dynamic> services = [];
  List<dynamic> serviceType = [];
  final TextEditingController serachController = TextEditingController();
  dynamic taskerServiceType;
  dynamic taskerServiceRate;
  dynamic taskerServiceRateType;
  dynamic taskerServiceDescription;

  dynamic serviceTypeId;

  @override
  void initState() {
    _loadTaskerServiceList();
    _loadTaskerServiceType();
    super.initState();
  }

  void _loadTaskerServiceType() async {
    TaskerService taskerServiceType = TaskerService();
    try {
      var data = await taskerServiceType.getTaskerServiceType();
      setState(() {
        serviceType = data;
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  void _loadTaskerServiceList() async {
    TaskerService taskerServiceList = TaskerService();
    try {
      var data = await taskerServiceList.getTaskerServiceList();
      setState(() {
        services = data;
      });
    } catch (e) {
      print('Error occurred: $e');
    }
  }

  String getServiceTypeName(int serviceTypeId) {
    final match = serviceType.firstWhere(
      (type) => type['id'] == serviceTypeId,
      orElse: () => null,
    );
    return match != null ? match['servicetype_name'] : 'Unknown';
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
          centerTitle: true,
          elevation: 0,
          title: const Text(
            'Service',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: TabBar(
            overlayColor: WidgetStateProperty.all(Colors.transparent),
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[500],
            labelStyle: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.0,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 13.0,
              fontFamily: 'Inter',
            ),
            tabs: const [
              Tab(text: 'Service Management'),
              Tab(text: 'Lorem Ipsum'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  CustomCard(
                    cardColor: Colors.white,
                    child: Column(
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
                              '$serviceTypeId',
                              style: TextStyle(
                                  color: Colors.blue[600],
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
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
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: CustomTextField(
                        controller: serachController,
                        labelText: 'Search',
                      )),
                      const SizedBox(width: 15),
                      IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/add_service');
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.circlePlus,
                            color: Color.fromRGBO(24, 52, 92, 1),
                          ))
                    ],
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(12.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.white),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Text(
                                  'No',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                  ),
                                )),
                            Expanded(
                                flex: 10,
                                child: Text(
                                  'Service Name',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                  ),
                                )),
                            Expanded(
                                flex: 3,
                                child: Text(
                                  'Status',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Inter',
                                    fontSize: 12,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        color: Colors.grey[100]),
                    child: Column(
                      children: [
                        for (var i = 0; i < services.length; i++)
                          Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Text(
                                        (i + 1).toString(),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 10,
                                      child: Text(
                                        getServiceTypeName(
                                            services[i]['service_type_id']),
                                        style: TextStyle(
                                          fontFamily: 'Inter',
                                          fontSize: 12,
                                        ),
                                      )),
                                  Expanded(
                                      flex: 3,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(7.5)),
                                          color: Colors.orange,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5, vertical: 3),
                                        child: Text(
                                          textAlign: TextAlign.center,
                                          getServiceStatus(services[i]
                                              ['service_status'])['text'],
                                          style: TextStyle(
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 25,
                                child: Divider(
                                  color: Colors.grey[500],
                                  thickness: 0.5,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Center(child: Text('Lorem Ipsum Content')),
          ],
        ),
      ),
    );
  }
}
