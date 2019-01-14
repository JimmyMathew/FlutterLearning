import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: "SI Calculator App",
    home: SIForm(),
    theme: ThemeData(
        //brightness: Brightness.dark,
        primaryColor: Colors.indigo,
        accentColor: Colors.indigoAccent),
  ));
}

class SIForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SIFormState();
  }
}

class _SIFormState extends State<SIForm> {
  var _currencies = ['Rupees', 'Dollars', 'Pounds'];
  final _minimumPadding = 5.0;
  String _currentlySelectedItem = '';
  TextEditingController prinicpalController = new TextEditingController();
  TextEditingController roiController = new TextEditingController();
  TextEditingController termController = new TextEditingController();
  String displayResult = '';
  var _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _currentlySelectedItem = _currencies[0];
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    // TODO: implement build
    return Scaffold(
        //resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("SI Calculator"),
        ),
        body: Form(
          key: _formKey,
            child: Padding(
                padding: EdgeInsets.all(_minimumPadding * 2),
                child: ListView(children: <Widget>[
                  getImageWidget(),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: TextFormField(
                        style: textStyle,
                        controller: prinicpalController,
                        validator: (String value){
                          if(value == "")
                            return "Please enter the principle amount";
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Principal',
                            labelStyle: textStyle,
                            hintText: 'Enter the principal e.g 1200',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: TextFormField(
                        controller: roiController,
                        validator: (String value){
                          if(value == "")
                            return "Please enter the ROI value";
                        },
                        style: textStyle,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Rate of Interest',
                            labelStyle: textStyle,
                            hintText: 'In Percent',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            )),
                      )),
                  Padding(
                      padding: EdgeInsets.only(
                          top: _minimumPadding, bottom: _minimumPadding),
                      child: Row(children: <Widget>[
                        Expanded(
                            child: TextFormField(
                          style: textStyle,
                          controller: termController,
                              validator: (String value){
                                if(value == "")
                                  return "Please enter the term value";
                              },
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              labelText: 'Term',
                              labelStyle: textStyle,
                              hintText: 'Time in years',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              )),
                        )),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                            child: DropdownButton<String>(
                                items: _currencies.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: _currentlySelectedItem,
                                onChanged: (String newValueSelected) {
                                  onDropDownSelected(newValueSelected);
                                }))
                      ])),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                              child: Text(
                                'Calculate',
                                style: textStyle,
                              ),
                              onPressed: () {
                                  setState(() {
                                    if(_formKey.currentState.validate()) {
                                      this.displayResult =
                                          calculateTotalReturns();
                                    }
                                  });

                              }),
                        ),
                        Container(
                          width: _minimumPadding * 5,
                        ),
                        Expanded(
                          child: RaisedButton(
                              child: Text(
                                'Reset',
                                style: textStyle,
                              ),
                              onPressed: () {
                                setState(() {
                                  resetAll();
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Text(this.displayResult, style: textStyle),
                  )
                ]))));
  }

  Widget getImageWidget() {
    AssetImage assetImage = AssetImage('images/money.png');
    Image image = Image(image: assetImage, width: 125.0, height: 125.0);
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void onDropDownSelected(String value) {
    setState(() {
      this._currentlySelectedItem = value;
    });
  }

  String calculateTotalReturns() {
    double principal = double.parse(prinicpalController.text);
    double roi = double.parse(roiController.text);
    double term = double.parse(termController.text);

    double totalAmountPayable = principal + (principal * roi * term) / 100;
    String result =
        'After $term years, your investment will be worth $totalAmountPayable $_currentlySelectedItem';
    return result;
  }

  resetAll() {
    prinicpalController.text = '';
    roiController.text = '';
    termController.text = '';
    displayResult = '';
    _currentlySelectedItem = _currencies[0];
  }
}
