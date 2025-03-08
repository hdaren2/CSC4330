import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PFT Scavenger Hunt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PageNavigator(),
    );
  }
}

class PageNavigator extends StatefulWidget {
  const PageNavigator({super.key});

  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  final PageController _controller = PageController();
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<bool> _isCodeCorrect = List.generate(6, (index) => false);
<<<<<<< HEAD
  final List<String> _correctCodes = ["1344", "1375", "1269", "1200", "2215", "2108"];
=======
  final List<String> _correctCodes = [
    "1234",
    "5678",
    "9101",
    "1121",
    "3141",
    "5161"
  ];
>>>>>>> f92f68ba7f1e7e72aefdb5a7cca16eabb29a635b
  final List<String> _pageTitles = [
    "Welcome to the Patrick F Taylor Scavenger Hunt. \nPlease enter the room number for the SECRET CODE\nas we procced.",
    "For Place #1, you must go to the room of robotics, with a orange hue",
    "Welcome to the home of the Bengal Bots!",
    "Need a quick bite, where coffee is in sight",
    "Welcome to Panera, our proud food service of choice here in the mechanical building",
    "Where blue and red meet, and no gas leaks.",
    "Welcome to the chevron center",
    "Near a entrance door, find sponsors galore.",
    "These are the proud sponsors of our beloved pft",
    "On the second floor, we drive and we floor",
    "Here we find a car that is tested for VR",
    "For building your resume with pro's who care, near studying poeple in a quite lare",
    "Welcome to Lisa Hibners office, where you can troubleshoot career problems and build your resume"
  ];

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _validateCode(int index, String value) {
    if (value == _correctCodes[index ~/ 2]) {
      setState(() {
        _isCodeCorrect[index ~/ 2] = true;
      });
    } else {
      setState(() {
        _isCodeCorrect[index ~/ 2] = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        physics:
            const NeverScrollableScrollPhysics(), // Disable swipe navigation
        itemCount: 13,
        itemBuilder: (context, index) {
          return PageContent(
            index: index,
            title: _pageTitles[index],
            controller: _controller,
            inputController: index % 2 == 1 ? _controllers[index ~/ 2] : null,
            isCodeCorrect: index % 2 == 1 ? _isCodeCorrect[index ~/ 2] : true,
            onCodeChanged:
                index % 2 == 1 ? (value) => _validateCode(index, value) : null,
          );
        },
      ),
    );
  }
}

class PageContent extends StatelessWidget {
  final int index;
  final String title;
  final PageController controller;
  final TextEditingController? inputController;
  final bool isCodeCorrect;
  final ValueChanged<String>? onCodeChanged;

  const PageContent({
    super.key,
    required this.index,
    required this.title,
    required this.controller,
    this.inputController,
    required this.isCodeCorrect,
    this.onCodeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/page_${index + 1}.jpg', // Ensure you have 13 different images named page_1.jpg to page_13.jpg
          fit: BoxFit.contain,
        ),
        Container(
          color: Colors.black.withOpacity(0.3),
        ),
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (index == 0)
                ElevatedButton(
                  onPressed: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Next'),
                ),
              if (inputController != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: inputController,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.3),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Enter 4-digit code',
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    onChanged: onCodeChanged,
                  ),
                ),
              if (index != 0)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (index > 0)
                      ElevatedButton(
                        onPressed: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Previous'),
                      ),
                    if (index < 12 && (index % 2 == 0 || isCodeCorrect))
                      ElevatedButton(
                        onPressed: () {
                          controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Text('Next'),
                      ),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}
