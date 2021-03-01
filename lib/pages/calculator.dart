import 'package:decimal/decimal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalculatorPage extends StatefulWidget {
  CalculatorPage({Key key}) : super(key: key);

  @override
  _CalculatorPageState createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {

  final TextEditingController _screenTextTop = TextEditingController();
  final TextEditingController _screenTextMid = TextEditingController();
  final TextEditingController _screenText = TextEditingController();
  List _operation = List();


  @override
  void initState() {
    _screenText.text = '0';
    super.initState();
  }

  @override
  void dispose() {
    _screenTextTop?.dispose();
    _screenTextMid?.dispose();
    _screenText?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _screen( context ),
          Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.0),
            child: Divider(
              color: Colors.black26,
              height: 1,
            )
          ),
        ),
          _buttons( context )
        ],
      ),
    );
  }

  _screen( BuildContext context ) {
    final height = MediaQuery.of(context).size.height;
    final width  = MediaQuery.of(context).size.width;

    return Container(
      height: height/2,
      decoration: BoxDecoration(
        //color: Colors.red
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            width: width*0.9,
            child: TextField(
              controller: _screenTextTop,
              readOnly: true,
              style: TextStyle(
                fontSize: 50.0
              ),
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: width*0.9,
            child: TextField(
              controller: _screenTextMid,
              readOnly: true,
              style: TextStyle(
                fontSize: 50.0
              ),
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: width*0.9,
            child: TextField(
              controller: _screenText,
              readOnly: true,
              style: TextStyle(
                fontSize: 50.0
              ),
              textAlign: TextAlign.end,
              decoration: InputDecoration(
                border: InputBorder.none,
              ),
            ),
          )
        ],
      ),
    );
  }

  _button({double height, double width, String text, Icon icon, VoidCallback onTap}) {
    return GestureDetector(
      onTap: ( ) {
        //_screenText.text = _screenText.text + text;
        switch ( text ) {
          case 'C' :
            _operation = [];
            _screenText.text = '0';
            _screenTextTop.text = '';
            _screenTextMid.text = '';
            break;
          case 'r' :
            print(_screenText.text.length);
            if ( _screenText.text.length == 1 ) {
              _screenText.text = '0';
            } else {
              _screenText.text = _screenText.text.substring(0, _screenText.text.length-1); 
            }
            break;
          case '0' :
            if ( _screenText.text != '0' ){
              _screenText.text = _screenText.text + text;
            }
            break; 
          case '.' : 
            if ( !_screenText.text.contains('.') ) {
              _screenText.text = _screenText.text + text;
            }
            break;
          case '1' : 
          case '2' : 
          case '3' : 
          case '4' : 
          case '5' : 
          case '6' : 
          case '7' : 
          case '8' : 
          case '9' : 
            if ( _screenText.text == '0' ) {
              _screenText.text = text;
            } else {
              _screenText.text = _screenText.text + text;
            }
            break;
          case '%' :
          case '÷' :
          case 'x' :
          case '-' :
          case '+' :
            if ( _operation.length == 0 && _screenText.text != '0' ) {
              _operation.add( _screenText.text );
              _operation.add( text );
              _screenText.text = '0';
            } else if ( _operation.length == 2 && _screenText.text == '0' ) {
              _operation.removeLast();
              _operation.add( text );
            } else if ( _operation.length == 2 && _screenText.text != '0' ) {

            }
            _screenTextTop.text = _operation[0];
            _screenTextMid.text = _operation[1];
            break;
          case '=' :
            Decimal operation;
            Decimal operandA = Decimal.parse(_operation[0]);
            Decimal operandB = Decimal.parse(_screenText.text);
            if ( _operation.length == 2 && _screenText.text != '0' ) {
              switch ( _operation[1] ) {
                case '+' :
                  operation = operandA + operandB; 
                  break;
                case '-' :
                  operation = operandA - operandB;
                  break;
                case 'x' :
                  operation = operandA * operandB;
                  break;
                case '÷' :
                  if ( operandB == 0 ) {
                    showDialog(
                      context: context,
                      builder: ( _ ) => CupertinoAlertDialog(
                        title: Text( 'Error' ),
                        content: Text('La division por cero no es posible'),
                        actions: <Widget>[
                          CupertinoDialogAction(
                            child: Text('Ok'),
                            onPressed: (  ) => Navigator.of(context).pop(),
                          )
                        ],
                      )
                    );
                    operation = Decimal.parse('0');
                    _operation = [];
                  } else {
                    operation = operandA / operandB;
                  }
                  break;
              }
              _screenTextTop.text = '';
              _screenTextMid.text = '${_operation.join(' ')} ${_screenText.text}';
              _operation = [];
              _screenText.text = operation.toString();
            }
            break;

        }
      },
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(

        ),
        child: Center(
          child: icon == null ? Text(
            text,
            style: TextStyle(
              fontSize: 23.0,
              fontWeight: FontWeight.w300
            ),
          ) : icon
        )
      ),
    );
  }

  _buttons( BuildContext context ) {
    final height = MediaQuery.of(context).size.height;
    final width  = MediaQuery.of(context).size.width;

    return Container(
      height: height/2,
      decoration: BoxDecoration(
        //color: Colors.blue
      ),
      child: Column(
        children: [
          Row(
            children: [
              _button(height: height/10, width: width/4, text: 'C'),
              _button(height: height/10, width: width/2, text: 'r', icon: Icon(Icons.backspace_outlined)),
              _button(height: height/10, width: width/4, text: '÷'),
            ],
          ),
          Row(
            children: [
              _button(height: height/10, width: width/4, text: '7'),
              _button(height: height/10, width: width/4, text: '8'),
              _button(height: height/10, width: width/4, text: '9'),
              _button(height: height/10, width: width/4, text: 'x'),
            ],
          ),
          Row(
            children: [
              _button(height: height/10, width: width/4, text: '4'),
              _button(height: height/10, width: width/4, text: '5'),
              _button(height: height/10, width: width/4, text: '6'),
              _button(height: height/10, width: width/4, text: '-'),
            ],
          ),
          Row(
            children: [
              _button(height: height/10, width: width/4, text: '1'),
              _button(height: height/10, width: width/4, text: '2'),
              _button(height: height/10, width: width/4, text: '3'),
              _button(height: height/10, width: width/4, text: '+'),
            ],
          ),
          Row(
            children: [
              _button(height: height/10, width: width/2, text: '0'),
              _button(height: height/10, width: width/4, text: '.'),
              _button(height: height/10, width: width/4, text: '='),
            ],
          )
        ],
      ),
    );
  }
}