import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
import 'package:servenow_mobile/widgets/custom_ele_button.dart';
import 'package:servenow_mobile/widgets/custom_text_field.dart';

class ManageService extends StatefulWidget {
  final dynamic serviceStatusSingle;
  final dynamic serviceDescSingle;
  final dynamic serviceTypeSingle;
  final dynamic serviceRateTypeSingle;
  final dynamic serviceRateSingle;
  final dynamic serviceIdSingle;
  final dynamic serviceTypeId;
  const ManageService(
      {super.key,
      this.serviceTypeSingle,
      this.serviceStatusSingle,
      this.serviceDescSingle,
      this.serviceRateTypeSingle,
      this.serviceRateSingle,
      this.serviceIdSingle,
      this.serviceTypeId});

  @override
  State<ManageService> createState() => _ManageServiceState();
}

class _ManageServiceState extends State<ManageService> {
  final TextEditingController serviceRateController = TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();

  dynamic selectedRateType;
  dynamic selectedServiceTypeId;
  dynamic selectedServiceTypeName;
  dynamic serviceId;
  dynamic serviceStatus;

  final List<String> rateType = [
    'Per Job',
    'Per Hour',
  ];

  @override
  void initState() {
    super.initState();
    serviceId = '${widget.serviceIdSingle}';
    selectedServiceTypeId = '${widget.serviceTypeId}';
    selectedServiceTypeName = widget.serviceTypeSingle;
    serviceStatus = '${widget.serviceStatusSingle}';
    selectedRateType = '${widget.serviceRateTypeSingle}';
    serviceDescriptionController.text = widget.serviceDescSingle ?? '';
    serviceRateController.text = '${widget.serviceRateSingle}';
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

  void _updateService() async {
    final updateService = {
      'service_status': serviceStatus,
      'service_rate': serviceRateController.text,
      'service_desc': serviceDescriptionController.text,
      'service_type_id': selectedServiceTypeId,
      'service_rate_type': selectedRateType,
    };
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Update service...'),
          duration: Duration(seconds: 2),
        ),
      );

      TaskerService taskerService = TaskerService();
      final response =
          await taskerService.updateTaskerService(serviceId, updateService);
      // print(response['data']['message']);

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

  void _deleteService() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Delete service...'),
          duration: Duration(seconds: 2),
        ),
      );

      TaskerService taskerService = TaskerService();
      final response = await taskerService.deleteTaskerService(serviceId);
      print(response['data']['message']);
      if (response['statusCode'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['data']['message']),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop();
        Navigator.pop(context, true);

        // Navigator.pushReplacementNamed(context, '/services');
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

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text(
            'Are you sure you want to delete this service?',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                color: Colors.grey[800],
                fontWeight: FontWeight.normal),
          ),
          content: Text(
            'This action cannot be undone.',
            style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text(
                'Cancel',
                style: TextStyle(
                    fontFamily: 'Inter', fontSize: 14, color: Colors.grey[800]),
              ),
            ),
            CustomEleButton(
                text: 'Delete',
                onPressed: _deleteService,
                bgColor: Colors.red,
                borderColor: Colors.red,
                fgColor: Colors.white)
          ],
        );
      },
    );
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
          'Service Management',
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
            // Navigator.pushReplacementNamed(context, '/services');
            Navigator.pop(context, true);
          },
        ),
        actions: [
          TextButton(
            style: const ButtonStyle(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: _updateService,
            child: Text(
              'Save',
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Service Type',
                            style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                color: Colors.grey[800]),
                          ),
                        ),
                        CustomDropdownMenu(
                          titleValue: selectedServiceTypeName,
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
                                      selectedValue)['id'];
                              selectedServiceTypeName = selectedValue;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Row(children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            'Rate',
                            style: TextStyle(
                                color: Colors.grey[800],
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.normal,
                                fontSize: 12),
                          ),
                        ),
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
                      ],
                    )),
                    SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            child: Text(
                              'Rate Type',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: 'Inter',
                                  fontWeight: FontWeight.normal,
                                  fontSize: 12),
                            ),
                          ),
                          CustomDropdownMenu(
                            titleSelect: 'Rate Type',
                            items: rateType,
                            titleValue: selectedRateType,
                            onSelected: (selectedValue) {
                              setState(() {
                                selectedRateType = selectedValue;
                              });
                            },
                            // isEnabled: selectedServiceTypeId?.isNotEmpty ?? false,
                          ),
                        ],
                      ),
                    ),
                  ]),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'Service Description',
                          style: TextStyle(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.normal,
                              fontFamily: 'Inter',
                              fontSize: 12),
                        ),
                      ),
                      CustomTextField(
                        labelText: 'Enter your description ...',
                        controller: serviceDescriptionController,
                        obscureText: false,
                        maxLines: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                
                SizedBox(
                  width: double.infinity,
                  child: CustomEleButton(
                      text: 'Delete',
                      onPressed: _showDeleteConfirmation,
                      bgColor: Colors.red[50],
                      borderWidth: 0,
                      borderColor: Colors.white,
                      fgColor: Colors.red),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
