// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_mesa/src/data/game_data.dart';
import 'package:project_mesa/src/model/navigator_args.dart';
import 'package:project_mesa/src/page/item/index.dart';
import 'package:project_mesa/src/theme/theme.dart';

/// Displays a list of SampleItems.
class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  static const routeName = '/';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<String> itemNames = GameData.items.map((e) => e.itemName).toList();
  final TextEditingController _textEditingController = TextEditingController();

  // FOR OCR
  bool textScanning = false;

  XFile? imageFile;

  List<String> scannedText = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 10 / 100),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Container(),
              ),
              SearchBoxRow(context),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: ElevatedButton.icon(
                        onPressed: () {
                          getImage(ImageSource.camera);
                        },
                        icon: Icon(Icons.camera_alt_rounded),
                        label: Text('OCR'),
                        style: ButtonStyle(
                        
                          backgroundColor:
                              MaterialStateProperty.all(Themes.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Row SearchBoxRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: SearchBox()),
        SizedBox(
          width: 64,
          child: IconButton(
            icon: Icon(Icons.search_rounded),
            onPressed: goToSelectedItem,
          ),
        )
      ],
    );
  }

  // SEARCH AND GOTO ITEM
  goToSelectedItem() {
    if (_textEditingController.text == '') return;

    Navigator.pushNamed(
      context,
      ItemDetail.routeName,
      arguments: ItemDetailNavigatorArgs(_textEditingController.text),
    );
  }

  // ignore: non_constant_identifier_names
  TypeAheadField<String> SearchBox() {
    return TypeAheadField<String>(
      suggestionsCallback: (pattern) {
        if (pattern == '') {
          return const Iterable<String>.empty();
        } else {
          List<String> matches = <String>[];
          matches.addAll(itemNames);

          matches.retainWhere((s) {
            return s.toLowerCase().contains(pattern.toLowerCase());
          });
          return matches;
        }
      },
      onSuggestionSelected: (suggestion) {
        // Set text to input
        _textEditingController.text = suggestion;

        goToSelectedItem();
      },
      itemBuilder: ((context, itemData) {
        return ListTile(
          title: Text(itemData),
        );
      }),
      textFieldConfiguration: TextFieldConfiguration(
        controller: _textEditingController,
        cursorColor: Themes.textColor,
        decoration: InputDecoration(
          hintText: 'Search...',
          focusColor: Themes.primaryColorHighlighted,
          hoverColor: Themes.primaryColorHighlighted,
          fillColor: Themes.primaryColorHighlighted,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Themes.primaryColorHighlighted),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Themes.primaryColor),
          ),
        ),
      ),
      suggestionsBoxDecoration: SuggestionsBoxDecoration(color: Themes.card),
    );
  }

  // OCR LOGIC
  void getImage(ImageSource source) async {
    try {
      final pickedImage = await ImagePicker().pickImage(source: source);
      if (pickedImage != null) {
        textScanning = true;
        imageFile = pickedImage;
        setState(() {});
        getRecognizedText(pickedImage);
      }
    } catch (e) {
      textScanning = false;
      imageFile = null;
      scannedText = [];
      setState(() {});
    }
  }

  void getRecognizedText(XFile image) async {
    final inputImage = InputImage.fromFilePath(image.path);
    final textDetector = TextRecognizer();
    RecognizedText recognizedText = await textDetector.processImage(inputImage);
    await textDetector.close();
    scannedText = [];
    for (TextBlock block in recognizedText.blocks) {
      for (TextLine line in block.lines) {
        scannedText.add(line.text);
      }
    }
    textScanning = false;
    setState(() {});
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => scannedTextDialog(context),
    );
  }

  // OCR RESULT DIALOG
  Dialog scannedTextDialog(BuildContext context) {
    return Dialog(
      child: ListView(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        children: scannedText
            .map(
              (option) => ListTile(
                title: Text(option),
                onTap: () async {
                  _textEditingController.text = option;
                  Navigator.of(context).pop(false);
                },
              ),
            )
            .toList(),
      ),
    );
  }
}

class GoogleMlKit {}
