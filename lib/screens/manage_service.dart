import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:servenow_mobile/services/tasker_service.dart';
import 'package:servenow_mobile/widgets/custom_dropdown_menu.dart';
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
        SnackBar(
          backgroundColor: Colors.grey.shade200,
          content: Center(
            child: Text(
              'Loading...',
              style: TextStyle(
                fontFamily: 'Inter',
                color: Colors.grey.shade800,
                fontWeight: FontWeight.normal,
                fontSize: 13,
              ),
            ),
          ),
          duration: Duration(seconds: 3),
        ),
      );

      TaskerService taskerService = TaskerService();
      final response =
          await taskerService.updateTaskerService(serviceId, updateService);

      if (response['statusCode'] == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Center(
              child: Text(
                response['data']['message'],
                style: TextStyle(
                  fontFamily: 'Inter',
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                  fontSize: 13,
                ),
              ),
            ),
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

  // void _deleteService() async {
  //   try {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('Delete service...'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     TaskerService taskerService = TaskerService();
  //     final response = await taskerService.deleteTaskerService(serviceId);
  //     print(response['data']['message']);
  //     if (response['statusCode'] == 201) {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(response['data']['message']),
  //           backgroundColor: Colors.green,
  //           duration: Duration(seconds: 3),
  //         ),
  //       );
  //       Navigator.of(context).pop();
  //       Navigator.pop(context, true);

  //       // Navigator.pushReplacementNamed(context, '/services');
  //     } else if (response['statusCode'] == 301) {
  //       throw Exception(response['data']['message']);
  //     } else {
  //       throw Exception(response['data']['message']);
  //     }
  //   } catch (error) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text('Error: ${error.toString()}'),
  //         backgroundColor: Colors.red,
  //         duration: const Duration(seconds: 3),
  //       ),
  //     );
  //   }
  // }

  // void _showDeleteConfirmation() {
  //   print(serviceId);
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return Dialog(
  //         backgroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(16.0),
  //         ),
  //         child: Padding(
  //           padding: const EdgeInsets.all(20.0),
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Text(
  //                 'Delete Confirmation',
  //                 style: TextStyle(
  //                   fontFamily: 'Inter',
  //                   fontSize: 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: Colors.grey[700],
  //                 ),
  //               ),
  //               SizedBox(height: 8),
  //               Text(
  //                 'This action cannot be undone. Are you sure you want to delete this service?',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   fontFamily: 'Inter',
  //                   fontSize: 13,
  //                   color: Colors.grey[600],
  //                 ),
  //               ),
  //               SizedBox(height: 20),
  //               Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         Navigator.of(context).pop();
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         elevation: 0,
  //                         backgroundColor: Colors.grey[200],
  //                         foregroundColor: Colors.grey[800],
  //                         padding: const EdgeInsets.symmetric(vertical: 12),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0),
  //                         ),
  //                       ).copyWith(
  //                         overlayColor:
  //                             WidgetStateProperty.all(Colors.transparent),
  //                         shadowColor:
  //                             WidgetStateProperty.all(Colors.transparent),
  //                         surfaceTintColor:
  //                             WidgetStateProperty.all(Colors.transparent),
  //                       ),
  //                       child: Text(
  //                         'Cancel',
  //                         style: TextStyle(
  //                           fontFamily: 'Inter',
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.grey[700],
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                   SizedBox(width: 12),
  //                   Expanded(
  //                     child: ElevatedButton(
  //                       onPressed: _deleteService,
  //                       style: ElevatedButton.styleFrom(
  //                         elevation: 0,
  //                         backgroundColor: Colors.red[50],
  //                         foregroundColor: Colors.white,
  //                         padding: const EdgeInsets.symmetric(vertical: 12),
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8.0),
  //                         ),
  //                       ).copyWith(
  //                         overlayColor:
  //                             WidgetStateProperty.all(Colors.transparent),
  //                         shadowColor:
  //                             WidgetStateProperty.all(Colors.transparent),
  //                         surfaceTintColor:
  //                             WidgetStateProperty.all(Colors.transparent),
  //                       ),
  //                       child: Text(
  //                         'Delete',
  //                         style: TextStyle(
  //                           fontFamily: 'Inter',
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.bold,
  //                           color: Colors.red,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

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
            fontSize: 16,
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
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    child: Text(
                      'Service Type',
                      style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.normal,
                          color: Colors.grey[700]),
                    ),
                  ),
                  CustomDropdownMenu(
                    titleValue: selectedServiceTypeName,
                    titleSelect: 'Service Type',
                    items: serviceType
                        .map((serviceTypeName) =>
                            serviceTypeName['servicetype_name'].toString())
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
                            color: Colors.grey[700],
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.normal,
                            fontSize: 13),
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
                              color: Colors.grey[700],
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.normal,
                              fontSize: 13),
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
                          color: Colors.grey[700],
                          fontWeight: FontWeight.normal,
                          fontFamily: 'Inter',
                          fontSize: 13),
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
            // const SizedBox(height: 30),
            // SizedBox(
            //   width: double.infinity,
            //   child: CustomEleButton(
            //       text: 'Delete',
            //       onPressed: _showDeleteConfirmation,
            //       bgColor: Colors.red[50],
            //       borderWidth: 0,
            //       borderColor: Colors.white,
            //       fgColor: Colors.red),
            // ),
          ],
        ),
      ),
    );
  }
}
