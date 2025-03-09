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
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<bool> _isCodeCorrect = List.generate(6, (index) => false);

  final List<bool?> _interestSelections = List.generate(6, (index) => null);

  final List<String> _correctCodes = [
    "1344",
    "1375",
    "1269",
    "1200",
    "2215",
    "2108"
  ];
  final List<String> _pageTitles = [
    "Welcome to the Patrick F. Taylor Scavenger Hunt.",
    "Please enter the correct room number to proceed.\nYou must go to the room of robotics, with an orange glow",
    "Welcome to the home of the Bengal Bots, LSU's Robotics Club!",
    "Need a quick bite, where coffee is in sight",
    "Welcome to Panera Bread, the proud food service of choice at PFT",
    "Where blue and red meet, and no gas leaks.",
    "Welcome to the Chevron Center",
    "Near an entrance door, find sponsors galore (Room # to the right).",
    "These are the proud sponsors of our beloved PFT",
    "On the second floor, we drive and we floor",
    "Here we find the Traffic Research and Visualization Engineering Lab",
    "For building your resume with pros who care, near studying people in a quiet chair",
    "Welcome to Lisa Hibner's office, where you can troubleshoot career problems and build your resume",
    "Final Interest Summary"
  ];

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

  void _setInterest(int index, bool interested) {
    if ((index - 1) ~/ 2 < _interestSelections.length) {
      setState(() {
        _interestSelections[(index - 1) ~/ 2] = interested;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 14,
        itemBuilder: (context, index) {
          if (index == 13) {
            return InterestSummaryPage(
              interestSelections: _interestSelections,
            );
          }

          return PageContent(
            index: index,
            title: _pageTitles[index],
            controller: _controller,
            inputController: index % 2 == 1 ? _controllers[index ~/ 2] : null,
            isCodeCorrect: index % 2 == 1 ? _isCodeCorrect[index ~/ 2] : true,
            onCodeChanged:
                index % 2 == 1 ? (value) => _validateCode(index, value) : null,
            selectedInterest: ((index - 1) ~/ 2 < _interestSelections.length &&
                    index % 2 == 0 &&
                    index != 0)
                ? _interestSelections[(index - 1) ~/ 2]
                : null,
            onInterestSelected:
                ((index - 1) ~/ 2 < _interestSelections.length &&
                        index % 2 == 0 &&
                        index != 0)
                    ? (interested) => _setInterest(index, interested)
                    : null,
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
  final ValueChanged<bool>? onInterestSelected;
  final bool? selectedInterest; 

  const PageContent({
    super.key,
    required this.index,
    required this.title,
    required this.controller,
    this.inputController,
    required this.isCodeCorrect,
    this.onCodeChanged,
    this.onInterestSelected,
    this.selectedInterest,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          'assets/page_${index + 1}.jpg',
          fit: BoxFit.cover,
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
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
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
                      hintText: 'Enter 4-digit room number',
                      hintStyle: const TextStyle(color: Colors.white70),
                    ),
                    onChanged: onCodeChanged,
                  ),
                ),
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
                  if (isCodeCorrect || index == 0)
                    ElevatedButton(
                      onPressed: () {
                        controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: const Text('Continue'),
                    ),
                ],
              ),
              if (onInterestSelected != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up,
                          color: selectedInterest == true
                              ? Colors.green
                              : Colors.white),
                      onPressed: () => onInterestSelected!(true),
                    ),
                    const Text('Interested',
                        style: TextStyle(color: Colors.white)),
                    IconButton(
                      icon: Icon(Icons.thumb_down,
                          color: selectedInterest == false
                              ? Colors.red
                              : Colors.white),
                      onPressed: () => onInterestSelected!(false),
                    ),
                    const Text('Not Interested',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class InterestSummaryPage extends StatelessWidget {
  final List<bool?> interestSelections;

  final List<String> interestPageNames = [
    "Bengal Bots",
    "Panera Bread",
    "Chevron Center",
    "PFT Sponsors",
    "Traffic Research Lab",
    "LSU Career Center Office",
  ];

  InterestSummaryPage({super.key, required this.interestSelections});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/page_14.jpg', 
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Interest Summary",
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                    )),
                for (int i = 0; i < interestSelections.length; i++)
                  Text(
                    "${interestPageNames[i]}: ${interestSelections[i] == null ? 'No Selection' : interestSelections[i]! ? 'Interested' : 'Not Interested'}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(height: 20),
                const Text(
                  "Thank you for participating in the scavenger hunt!",
                  style: TextStyle(
                    fontSize: 20, 
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
