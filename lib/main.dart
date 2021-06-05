import 'package:flutter/material.dart';
import 'portrait.dart';

const double INITIAL_SIZE = 120;
const double EXPANDED_SIZE = 250;
const Color INITIAL_COLOR = Colors.white;
const Color EXPANDED_COLOR = Colors.red;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget with PortraitModeMixin {
  static const String _title = 'Animation Example';
  const MyApp();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter animation exemple'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Curve _curve = Curves.bounceIn;
  Color _cor = INITIAL_COLOR;
  double _tamanho = INITIAL_SIZE;

  late List<CurveItem> _curveOptions;
  late String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    this._curveOptions = _initCurveSelection();
    this._dropdownValue = _curveOptions.elementAt(0).value;
  }

  @override
  void dispose() {
     super.dispose();
  }

  List<DropdownMenuItem<String>> _getDropDownItems() {
    List<DropdownMenuItem<String>> items =
        _curveOptions.map<DropdownMenuItem<String>>((CurveItem ci) {
      return DropdownMenuItem<String>(
        value: ci.value,
        child: Text(ci.text),
      );
    }).toList();

    return items;
  }

  String _getDropDownCurrentDescription() {
    int index = _getDropDownIndexByValue(this._dropdownValue);
    return index >= 0 ? _curveOptions[index].text : "<Undefined>";
  }

  int _getDropDownIndexByValue(String? value) {
    return _curveOptions.indexWhere((ci) => ci.value == value);
  }

  void _doPlayAnimation() {
    int index = _getDropDownIndexByValue(this._dropdownValue);
    this._curve = index >= 0 ? _curveOptions[index].curve : Curves.bounceIn;

    setState(() {
      if (this._cor == INITIAL_COLOR && this._tamanho == INITIAL_SIZE) {
        this._cor = EXPANDED_COLOR;
        this._tamanho = EXPANDED_SIZE;
      } else {
        this._cor = INITIAL_COLOR;
        this._tamanho = INITIAL_SIZE;
      }
    });
  }

  void _handleCurveChange(String? newValue) {
    setState(() {
      _dropdownValue = newValue!;
    });
    _doPlayAnimation();
  }

  Widget _buildAnimatedBox() {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: AnimatedContainer(
            duration: Duration(seconds: 2),
            curve: this._curve,
            width: this._tamanho,
            height: this._tamanho,
            color: this._cor,
          ),
        ),
      ],
    );
  }

  Widget _buildCurveSelection() {
    return new Column(
      children: <Widget>[
        Text(
          "Select animation curve:",
          style: TextStyle(color: Colors.white),
        ),
        Container(
          child: DropdownButton<String>(
            //value: _dropdownValue,
            hint: this._dropdownValue == null
                ? Text(
                    "Select one:",
                    style: TextStyle(color: Colors.white54),
                  )
                : Text(
                    _getDropDownCurrentDescription(),
                    style: TextStyle(color: Colors.white),
                  ),
            icon: const Icon(
              Icons.arrow_downward,
              color: Colors.white70,
            ),
            iconSize: 24,
            elevation: 16,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 2,
              color: Colors.white70,
            ),
            onChanged: _handleCurveChange,
            items: _getDropDownItems(),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(color: Colors.lightBlue[100]),
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(15),
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(color: Colors.blue),
              width: double.infinity,
              child: _buildCurveSelection(),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(color: Colors.transparent),
                width: double.infinity,
                child: _buildAnimatedBox(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.beach_access),
        tooltip: 'Play',
        onPressed: _doPlayAnimation,
      ),
    );
  }
}

/// Curve Item: defines a class to represente a curve selection item
///
/// Contains: value, text and corresponding curve
class CurveItem {
  late String value;
  late String text;
  late Curve curve;

  CurveItem(
      {required String value, required String text, required Curve curve}) {
    this.value = value;
    this.text = text;
    this.curve = curve;
  }
}

List<CurveItem> _initCurveSelection() {
  List<CurveItem> list = [];
  list.add(
      CurveItem(value: "bouncein", text: "Bounce In", curve: Curves.bounceIn));
  list.add(CurveItem(
      value: "bounceout", text: "Bounce Out", curve: Curves.bounceOut));
  list.add(CurveItem(
      value: "easeinquart", text: "Ease In Quart", curve: Curves.easeInQuart));
  list.add(CurveItem(
      value: "easeinoutback",
      text: "Ease In Outback",
      curve: Curves.easeInOutBack));
  list.add(CurveItem(
      value: "elasticinout",
      text: "Elastic InOut",
      curve: Curves.elasticInOut));

  return list;
}
