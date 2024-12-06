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
      orElse: () => {'servicetype_name': 'Unknown'},
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
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          bottom: const TabBar(
            indicatorColor: Colors.transparent,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey,
            labelStyle: TextStyle(
                fontFamily: 'Inter',
                fontSize: 13.0,
                fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(
                fontSize: 13.0,
                fontFamily: 'Inter',
                fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: 'Service Management'),
              Tab(text: 'Task Management'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  CustomTextField(
                    controller: searchController,
                    labelText: 'Search...',
                  ),
                  Container(
                    padding: EdgeInsets.all(15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Service : ',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600]),
                            ),
                            Text(
                              '13',
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/add_service');
                          },
                          icon: Icon(
                            Icons.add_circle,
                            size: 30,
                            color: Color.fromRGBO(24, 52, 92, 1),
                          ),
                        )
                      ],
                    ),
                  ),
                  Column(
                    children: services.map((service) {
                      int status = service['service_status'];
                      return CustomCard(
                        cardColor: Colors.grey[100],
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              getServiceTypeName(service['service_type_id']),
                              style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[800]),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 12,
                                color: Colors.grey[500],
                              ),
                            ),
                            SizedBox(height: 5),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(5)),
                                    color: getServiceStatus(status)['color'],
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 5, vertical: 3),
                                  child: Text(
                                    textAlign: TextAlign.center,
                                    getServiceStatus(status)['text'],
                                    style: const TextStyle(
                                      fontFamily: 'Inter',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: FaIcon(FontAwesomeIcons.chevronRight,
                                      color: Colors.grey[400], size: 16),
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, '/manage_service');
                                  },
                                ),
                              ],
                            )
                          ],
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
