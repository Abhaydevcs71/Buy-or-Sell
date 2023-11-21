import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:second_store/widgets/image_picker.dart';

class PgSellerForm extends StatefulWidget {
  const PgSellerForm({super.key});

  static const String id = 'pg-form';

  @override
  State<PgSellerForm> createState() => _PgSellerFormState();
}

class _PgSellerFormState extends State<PgSellerForm> {
  final _formKey = GlobalKey<FormState>();

  var _nameController = TextEditingController();
  var _descController = TextEditingController();
  var _priceController = TextEditingController();
  var _addressController = TextEditingController();

  validate() {
    if (_formKey.currentState!.validate()) {
      log('validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? countPeople;
    String? countRoom;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: const Text(
          "Add some details",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        shape: Border(
          bottom: BorderSide(
            color: Colors.grey.shade400,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Paying Guest',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name your Ad',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _descController,
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          // borderSide: BorderSide(color: Colors.green)
                          ),
                      labelText: 'Description',
                      hintText: 'Tell something about this place',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    )),
                    hint: const Text('Select the number of persons allowed'),
                    value: countPeople,
                    onChanged: (String? newValue) {
                      setState(() {
                        countPeople = newValue!;
                      });
                    },
                    items: <String>['1', '2', '3', '4', '5', '6', '7', '8']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    hint: const Text('Select the number of rooms'),
                    value: countRoom,
                    onChanged: (String? newValue) {
                      setState(() {
                        countRoom = newValue!;
                      });
                    },
                    items: <String>['1', '2', '3', '4']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _priceController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Price',
                        prefixText: 'INR'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _addressController,
                    minLines: 3,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Required Field';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImagePickerWidget();
                          });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: Colors.grey[400],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 3,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            ),
                          ]),
                      child: const Text(
                        'Upload images',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: ElevatedButton(
                  onPressed: () {
                    validate();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[400],
                      foregroundColor: Colors.black,
                      shadowColor: const Color.fromARGB(255, 109, 106, 105),
                      elevation: 5,
                      fixedSize: const Size(60, 40)),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
