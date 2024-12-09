import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/widgets/custom_card.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class AddService extends StatefulWidget {
  const AddService({super.key});

  @override
  State<AddService> createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final TextEditingController serviceRateController = TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();

  dynamic selectedRateType;
  int? selectedServiceTypeId;
  String rateTypeTitle = 'Select Rate Type';
  String serviceTypeTitle = 'Select Service Type';

  final List<String> rateType = [
    'Per Job',
    'Per Hour',
  ];

  @override
  void initState() {
    super.initState();
    fetchServiceTypeName();
  }

  List<Map<String, dynamic>> serviceType = [];

  void fetchServiceTypeName() async {
    TaskerService taskerService = TaskerService();
    try {
      final listServiceType = await taskerService.getTaskerServiceType();
      setState(() {
        serviceType = listServiceType;
      });
      print(serviceType);
    } catch (e) {
      print('Error: $e');
    }
  }

  void _createService() async {
    final createService = {
      'service_rate': serviceRateController.text,
      'service_desc': serviceDescriptionController.text,
      'service_type_id': selectedServiceTypeId,
      'service_rate_type': selectedRateType,
    };
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saving profile...'),
          duration: Duration(seconds: 2),
        ),
      );

      TaskerService taskerService = TaskerService();
      final response = await taskerService.createTaskerService(createService);
      print(response['message']);

      if (response['statusCode'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['data']['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      } else if (response['statusCode'] == 301) {
        throw Exception(response['data']['message']);
      } else {
        throw Exception(response['data']['message']);
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(24, 52, 92, 1),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          'Add Service',
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
            Navigator.pop(context,true);
          },
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: _createService,
            child: Text(
              'Create',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.orange[300],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
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
                        'Note',
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    SizedBox(width: 12.5),
                    Text(
                      'Service Type',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 2.5),
                CustomDropdownMenu(
                  titleValue: serviceTypeTitle,
                  titleSelect: 'Service Type',
                  items: serviceType
                      .map((serviceTypeName) =>
                          serviceTypeName['servicetype_name'].toString())
                      .toList(),
                  onSelected: (selectedValue) {
                    setState(() {
                      selectedServiceTypeId = serviceType.firstWhere(
                              (service) =>
                                  service['servicetype_name'] == selectedValue)[
                          'id']; // Get the ID based on selected name
                      serviceTypeTitle = selectedValue; // Update the title
                    });
                  },
                ),
                const SizedBox(height: 15),
                Row(children: [
                  Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(width: 12.5),
                              Text(
                                'Rate',
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2.5),
                          CustomTextField(
                            controller: serviceRateController,
                            obscureText: false,
                            prefixText: 'RM ',
                            keyboardType:
                                TextInputType.numberWithOptions(decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d+\.?\d{0,2}')),
                            ],
                          ),
                          const SizedBox(height: 15),
                        ],
                      )),
                  const SizedBox(width: 15),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: 12.5),
                            Text(
                              'Rate Type',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2.5),
                        CustomDropdownMenu(
                          titleSelect: 'Rate Type',
                          items: rateType,
                          titleValue: rateTypeTitle,
                          onSelected: (selectedValue) {
                            setState(() {
                              selectedRateType = selectedValue;
                              rateTypeTitle = selectedValue;
                            });
                          },
                          // isEnabled: selectedServiceTypeId?.isNotEmpty ?? false,
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ]),
                Row(
                  children: [
                    SizedBox(width: 12.5),
                    Text(
                      'Service Description',
                      style: TextStyle(
                          color: Colors.grey[800],
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Inter',
                          fontSize: 12),
                    ),
                  ],
                ),
                const SizedBox(height: 2.5),
                CustomTextField(
                  labelText: 'Enter your description ...',
                  controller: serviceDescriptionController,
                  obscureText: false,
                  maxLines: 4,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
