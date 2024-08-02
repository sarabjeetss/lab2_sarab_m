// lib/calculator.dart

import 'package:flutter/material.dart';
import 'calculator_state.dart'; // Import the state management file

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final CalculatorState _calculatorState = CalculatorState();
  String _display = '';
  String _operation = '';
  double _firstOperand = 0.0;
  double _secondOperand = 0.0;
  bool _isFirstOperand = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadLastValue();
  }

  Future<void> _loadLastValue() async {
    String lastValue = await _calculatorState.loadLastValue();
    setState(() {
      _display = lastValue;
    });
  }

  void _clearEntry() {
    setState(() {
      _display = '';
      _isFirstOperand = true;
      _hasError = false;
    });
  }

  void _clearAll() {
    setState(() {
      _display = '';
      _operation = '';
      _firstOperand = 0.0;
      _secondOperand = 0.0;
      _isFirstOperand = true;
      _hasError = false;
    });
  }

  void _setOperand(String value) {
    setState(() {
      if (_display.length < 8 && !_hasError) {
        _display += value;
      }
    });
  }

  void _setOperation(String operation) {
    setState(() {
      if (_operation.isEmpty && !_hasError) {
        _firstOperand = double.tryParse(_display) ?? 0.0;
        _display = '';
        _operation = operation;
      }
    });
  }

  void _calculateResult() {
    setState(() {
      if (_hasError) return;

      _secondOperand = double.tryParse(_display) ?? 0.0;
      double result;
      switch (_operation) {
        case '+':
          result = _firstOperand + _secondOperand;
          break;
        case '-':
          result = _firstOperand - _secondOperand;
          break;
        case '*':
          result = _firstOperand * _secondOperand;
          break;
        case '/':
          if (_secondOperand != 0) {
            result = _firstOperand / _secondOperand;
          } else {
            _display = 'ERROR';
            _hasError = true;
            return;
          }
          break;
        default:
          result = _secondOperand;
      }
      _display = result.toStringAsFixed(2).replaceAll(RegExp(r'\.0*$'), '');
      _operation = '';
      _firstOperand = result;
      _isFirstOperand = true;
      _calculatorState.saveLastValue(_display); // Save the last value
    });
  }

  Widget _buildButton(String text, VoidCallback onPressed, {Color color = Colors.grey}) {
    return Container(
      margin: EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0), // Sets the height of the AppBar to 0
        child: AppBar(
          backgroundColor: Colors.transparent, // Makes the AppBar background transparent
          elevation: 0, // Removes the shadow
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width, // Full width
            height: MediaQuery.of(context).size.height, // Full height
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black87,
              border: Border.all(color: Colors.white, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  alignment: Alignment.centerRight,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _display,
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
                SizedBox(height: 20),
                Expanded(
                  child: Table(
                    children: [
                      TableRow(
                        children: [
                          _buildButton('1', () => _setOperand('1'), color: Colors.blueGrey),
                          _buildButton('2', () => _setOperand('2'), color: Colors.blueGrey),
                          _buildButton('3', () => _setOperand('3'), color: Colors.blueGrey),
                          _buildButton('+', () => _setOperation('+'), color: Colors.orange),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildButton('4', () => _setOperand('4'), color: Colors.blueGrey),
                          _buildButton('5', () => _setOperand('5'), color: Colors.blueGrey),
                          _buildButton('6', () => _setOperand('6'), color: Colors.blueGrey),
                          _buildButton('-', () => _setOperation('-'), color: Colors.orange),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildButton('7', () => _setOperand('7'), color: Colors.blueGrey),
                          _buildButton('8', () => _setOperand('8'), color: Colors.blueGrey),
                          _buildButton('9', () => _setOperand('9'), color: Colors.blueGrey),
                          _buildButton('*', () => _setOperation('*'), color: Colors.orange),
                        ],
                      ),
                      TableRow(
                        children: [
                          _buildButton('CE', _clearEntry, color: Colors.red),
                          _buildButton('0', () => _setOperand('0'), color: Colors.blueGrey),
                          _buildButton('C', _clearAll, color: Colors.red),
                          _buildButton('/', () => _setOperation('/'), color: Colors.orange),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: _buildButton('=', _calculateResult, color: Colors.green),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
