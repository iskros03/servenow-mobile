import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
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
          content: Text('Loading...'),
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
      backgroundColor: Colors.grey[50],
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
            Navigator.pop(context, true);
          },
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: _createService,
            child: Text(
              'Add',
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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'State',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                        CustomDropdownMenu(
                          titleValue: serviceTypeTitle,
                          titleSelect: 'Service Type',
                          items: serviceType
                              .map((serviceTypeName) =>
                                  serviceTypeName['servicetype_name']
                                      .toString())
                              .toList(),
                          onSelected: (selectedValue) {
                            setState(() {
                              selectedServiceTypeId = serviceType.firstWhere(
                                      (service) =>
                                          service['servicetype_name'] ==
                                          selectedValue)[
                                  'id']; // Get the ID based on selected name
                              serviceTypeTitle =
                                  selectedValue; // Update the title
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Row(children: [
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Rate',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800]),
                              ),
                            ),
                            const SizedBox(height: 2.5),
                            CustomTextField(
                              controller: serviceRateController,
                              obscureText: false,
                              prefixText: 'RM ',
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}')),
                              ],
                            ),
                          ],
                        )),
                    const SizedBox(width: 15),
                    Expanded(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(width: 12.5),
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Rate Type',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey[800]),
                            ),
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
                          ),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
            ),
            const SizedBox(height: 15),
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Service Description',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.normal,
                                    color: Colors.grey[800]),
                              ),
                            ],
                          ),
                        ),
                        CustomTextField(
                          labelText: 'Enter your description ...',
                          controller: serviceDescriptionController,
                          obscureText: false,
                          maxLines: 4,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
