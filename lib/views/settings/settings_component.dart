import 'package:flutter/material.dart';
import '/utils/app_builder.dart';
import '/utils/colors.dart';
import '/utils/platform_bools.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_linux/shared_preferences_linux.dart';

class SettingsComponent extends StatelessWidget {
  const SettingsComponent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: width * 0.25),
            child: ColorForm(),
          ),
          SizedBox(height: 25.0),
          Container(
            alignment: Alignment.bottomCenter,
            child: ElevatedButton(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Reset to Default Colors',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
              ),
              onPressed: () async {
                if (isLinux) {
                  final prefs = SharedPreferencesLinux.instance;
                  await prefs.setValue('String', 'primaryColor', 'ff006e');
                  await prefs.setValue('String', 'dangerColor', '1976D2');
                  await prefs.setValue('String', 'backgroundColor', '0f1119');
                  await prefs.setValue('String', 'captionColor', 'a6b1bb');
                  setColorsLinux();
                  AppBuilder.of(context)?.rebuild();
                } else {
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setString('primaryColor', 'ff006e');
                  await prefs.setString('dangerColor', '1976D2');
                  await prefs.setString('backgroundColor', '0f1119');
                  await prefs.setString('captionColor', 'a6b1bb');
                  setColorsWeb();
                  AppBuilder.of(context)?.rebuild();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ColorForm extends StatefulWidget {
  const ColorForm({Key? key}) : super(key: key);

  @override
  _ColorFormState createState() => _ColorFormState();
}

class _ColorFormState extends State<ColorForm> {
  final _primaryColorController = TextEditingController();
  final _secondaryColorController = TextEditingController();
  final _backgroundColorController = TextEditingController();
  final _resetColorController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _primaryColorController.dispose();
    _secondaryColorController.dispose();
    _backgroundColorController.dispose();
    _resetColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: _primaryColorController,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Hex Color Code for the Primary Color.',
            ),
            validator: (value) {
              if (value != null &&
                  (value.length > 7 || value.length < 6) &&
                  value.length != 0) {
                return 'Please enter a valid Hex Color Code (#000000)';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _secondaryColorController,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Hex Color Code for the Secondary Color.',
            ),
            validator: (value) {
              if (value != null &&
                  (value.length > 7 || value.length < 6) &&
                  value.length != 0) {
                return 'Please enter a valid Hex Color Code (#000000)';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _backgroundColorController,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Hex Color Code for the Background Color.',
            ),
            validator: (value) {
              if (value != null &&
                  (value.length > 7 || value.length < 6) &&
                  value.length != 0) {
                return 'Please enter a valid Hex Color Code (#000000)';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _resetColorController,
            style: TextStyle(
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: UnderlineInputBorder(),
              labelText: 'Hex Color Code for the Reset Button.',
            ),
            validator: (value) {
              if (value != null &&
                  (value.length > 7 || value.length < 6) &&
                  value.length != 0) {
                return 'Please enter a valid Hex Color Code (#000000)';
              }
              return null;
            },
          ),
          SizedBox(height: 25),
          ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Processing Data')));
                if (isLinux) {
                  final prefs = SharedPreferencesLinux.instance;

                  if (_secondaryColorController.text.length > 0)
                    await prefs.setValue('String', 'primaryColor',
                        _secondaryColorController.text);
                  if (_primaryColorController.text.length > 0)
                    await prefs.setValue(
                        'String', 'dangerColor', _primaryColorController.text);
                  if (_backgroundColorController.text.length > 0)
                    await prefs.setValue('String', 'backgroundColor',
                        _backgroundColorController.text);
                  if (_resetColorController.text.length > 0)
                    await prefs.setValue(
                        'String', 'captionColor', _resetColorController.text);
                  setColorsLinux();
                  AppBuilder.of(context)?.rebuild();
                } else {
                  final prefs = await SharedPreferences.getInstance();

                  if (_secondaryColorController.text.length > 0)
                    await prefs.setString(
                        'primaryColor', _secondaryColorController.text);
                  if (_primaryColorController.text.length > 0)
                    await prefs.setString(
                        'dangerColor', _primaryColorController.text);
                  if (_backgroundColorController.text.length > 0)
                    await prefs.setString(
                        'backgroundColor', _backgroundColorController.text);
                  if (_resetColorController.text.length > 0)
                    await prefs.setString(
                        'captionColor', _resetColorController.text);

                  setColorsWeb();
                  AppBuilder.of(context)?.rebuild();
                }
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Save Colors',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
