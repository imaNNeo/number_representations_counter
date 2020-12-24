import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        textTheme: GoogleFonts.robotoMonoTextTheme(
          Theme.of(context).textTheme,
        ),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

List<Representation> representations = [
  Representation(title: 'Decimal', converter: (number) => number.toString().padLeft(8, '0')),
  Representation(title: 'Binary', converter: (number) => number.toRadixString(2).padLeft(8, '0')),
  Representation(title: 'Octal', converter: (number) => number.toRadixString(8).padLeft(8, '0')),
  Representation(title: 'Hexadecimal', converter: (number) => number.toRadixString(16).padLeft(8, '0')),
];

class MyHomePage extends StatefulWidget {
  MyHomePage({
    Key key,
  }) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF191636),
      body: Center(
        child: Container(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: representations.map((representer) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: RepresentationRow(
                  title: representer.title,
                  letters: representer.converter(
                    _counter,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Representation {
  final String title;
  final String Function(int) converter;

  Representation({
    @required this.title,
    @required this.converter,
  });
}

class RepresentationRow extends StatelessWidget {
  final String title;
  final String letters;

  const RepresentationRow({
    Key key,
    @required this.title,
    @required this.letters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            '$title:',
            style: TextStyle(color: Colors.white),
          ),
          Expanded(child: Container()),
          LettersWidget(
            '$letters',
          )
        ],
      ),
    );
  }
}

final colors = [
  Colors.purpleAccent,
  Colors.greenAccent,
  Colors.redAccent,
  Colors.cyanAccent,
  Colors.yellowAccent,
];

class LettersWidget extends StatelessWidget {
  final String letters;

  const LettersWidget(
    this.letters, {
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int numberStartPos = findStartingPoint(letters);
    return Row(
      children: letters.characters.toList().asMap().entries.map((entry) {
        final index = entry.key;
        final letter = entry.value;
        return LetterWidget(
          letter: letter,
          opacity: index >= numberStartPos ? 1.0 : 0.1,
        );
      }).toList(),
    );
  }
}

int findStartingPoint(String letters) {
  for (int i = 0; i < letters.length; i++) {
    if (letters[i] != '0') {
      return i;
    }
  }
  return letters.length;
}

class LetterWidget extends StatelessWidget {
  final String letter;
  final double opacity;

  const LetterWidget({
    @required this.letter,
    this.opacity = 1.0,
    Key key,
  })  : assert(letter.length == 1),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      // transitionBuilder: (Widget child, Animation<double> animation) {
      //   return ScaleUpTransition(child: child, scale: animation);
      // },
      child: Text(
        letter.toUpperCase(),
        key: ValueKey<String>(letter),
        style: TextStyle(
          color: colors[letter.codeUnitAt(0) % colors.length].withOpacity(opacity),
          fontSize: 28,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class ScaleUpTransition extends AnimatedWidget {
  const ScaleUpTransition({
    Key key,
    @required Animation<double> scale,
    this.child,
  })  : assert(scale != null),
        super(key: key, listenable: scale);

  Animation<double> get scale => listenable as Animation<double>;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final double scaleValue = scale.value;
    final Matrix4 transform = Matrix4.identity()..scale(scaleValue, scaleValue, 1.0);
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }
}
