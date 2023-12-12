import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:second_store/constants/constants.dart';
import 'package:provider/provider.dart';
import 'package:second_store/forms/hostel/form_class.dart';
import 'package:second_store/provider/category_provider.dart';
import 'package:second_store/services/firebase_services.dart';

class FormsScreen extends StatefulWidget {
  const FormsScreen({super.key});

  static const String id = 'forms-screen';

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  FormClass _formClass = FormClass();
  var _genderController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);

    showFormDialog(list, _textController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(children: [
                _formClass.appBar(_provider),
                Expanded(
                  child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int i) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _textController.text = list[i];
                            });
                            Navigator.pop(context);
                          },
                          title: Text(_provider.doc!['Hostel for'][i]),
                        );
                      }),
                )
              ]),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.whiteColor,
        iconTheme: IconThemeData(color: AppColors.blackColor),
        elevation: 0.0,
        title: const Text(
          'Add some details',
          style: TextStyle(color: AppColors.blackColor),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('${_provider.selectedCategory}'),
          InkWell(
            onTap: () {
              // we need to show the grender
              showFormDialog(_provider.doc?['Hostel for'], _genderController);
            },
            child: TextFormField(
              controller: _genderController,
              enabled: false,
              decoration: InputDecoration(labelText: 'Hostel For*'),
            ),
          )
        ]),
      ),
    );
  }
}
