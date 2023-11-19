import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class PgSellerForm extends StatefulWidget {
  PgSellerForm({super.key});

  static const String id = 'pg-form';

  @override
  State<PgSellerForm> createState() => _PgSellerFormState();
}

class _PgSellerFormState extends State<PgSellerForm> {
  final _formKey = GlobalKey<FormState>();

  validate() {
    if (_formKey.currentState!.validate()) {
      print('validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    String? count;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        elevation: 0.0,
        title: Text(
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
            child: Column(
              children: [
                Text(
                  'Paying Guest',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name your Ad',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                     // borderSide: BorderSide(color: Colors.green)
                    ),
                    labelText: 'Description',
                    hintText: 'Tell something about this place',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(border: OutlineInputBorder(borderRadius: BorderRadius.circular(8),)),
                  hint: const Text('Select the number of persons allowed'),
                  value: count,
                  onChanged: (String? newValue) {
                    setState(() {
                      count = newValue!;
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
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Price',
                    hintText: 'Expected amount in Rupees',
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  minLines: 3,
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Address',
                  ),
                ),
              ],
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
                      primary: Colors.teal[400],
                      onPrimary: Colors.black,
                      shadowColor: const Color.fromARGB(255, 109, 106, 105),
                      elevation: 5,
                      fixedSize: const Size(60, 40)),
                  child: Text(
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
