import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

void main() {
  runApp(const MyCalc());
}

class MyCalc extends StatelessWidget{
  const MyCalc({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(primaryColor: Colors.blue),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget{
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: const Center(
          child: Text('Calculator'),
        ),
        backgroundColor: Colors.blueGrey,
      ),
      body: const Center(
        child: Column(
          children: [
            DisplayScreen(),
          ],
        ),
      ),
    );
  }
}

class DisplayScreen extends StatefulWidget{
  const DisplayScreen({super.key});

  @override
  State<DisplayScreen> createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  String _currEq = '';

  void updateEq(String eq){
    setState(() {
      if (eq == 'AC'){
        _currEq = '';
      }
      else{
        _currEq = _currEq + eq;
      }
    });
  }

  void evaluateExpression(){
    try {
      final expression = Expression.parse(_currEq);
      const evaluator = ExpressionEvaluator();

      var result = evaluator.eval(expression, {});
      setState(() {
        _currEq = result.toString();
      });
    }
    catch(e){
      setState(() {
        _currEq = 'Error.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.blueAccent,
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black38,
                blurRadius: 10,
                offset: Offset(0, 5),
              )
            ]
          ),
          child: Text(
            _currEq,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            )
          ),
        ),
        const SizedBox(height: 20,),
        Keyboard(updateEq: updateEq, onEqualsPressed: evaluateExpression),
      ],
    );
  }
}

class Keyboard extends StatelessWidget{
  final void Function(String)? updateEq;
  final VoidCallback onEqualsPressed;
  const Keyboard({super.key, required this.updateEq, required this.onEqualsPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonCard(number: '9', updateEq: updateEq),
            ButtonCard(number: '8', updateEq: updateEq),
            ButtonCard(number: '7', updateEq: updateEq),
            ButtonCard(number: '+', updateEq: updateEq),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonCard(number: '6', updateEq: updateEq),
            ButtonCard(number: '5', updateEq: updateEq),
            ButtonCard(number: '4', updateEq: updateEq),
            ButtonCard(number: '-', updateEq: updateEq),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonCard(number: '3', updateEq: updateEq),
            ButtonCard(number: '2', updateEq: updateEq),
            ButtonCard(number: '1', updateEq: updateEq),
            ButtonCard(number: '*', updateEq: updateEq),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonCard(number: 'AC', updateEq: updateEq),
            ButtonCard(number: '0', updateEq: updateEq),
            ButtonCard(number: '=', updateEq: (String value) {}, onPressed: onEqualsPressed,),
            ButtonCard(number: '/', updateEq: updateEq),
          ],
        )
      ],
    );
  }
}

class ButtonCard extends StatelessWidget {
  final String number;
  final void Function(String)? updateEq;
  final VoidCallback? onPressed;
  const ButtonCard({
    super.key,
    required this.number,
    required this.updateEq,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.blueAccent,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 5,
            offset: Offset(0, 2)
          )
        ]
      ),
      child: IconButton(
        onPressed: (){
          if (onPressed != null){
            onPressed!();
          }
          else{
            updateEq!(number);
          }
        },
        icon: Text(
          number,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          )
        ),
      ),
    );
  }
}
