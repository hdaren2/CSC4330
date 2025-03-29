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
      title: 'Patrick F. Taylor Hall Scavenger Hunt',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  int _currentHuntPage = 0;

  // Hunt state variables
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<bool> _isCodeCorrect = List.generate(6, (index) => false);
  final List<bool?> _interestSelections = List.generate(6, (index) => null);
  DateTime? _startTime;
  Duration? _elapsedTime;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
  }

  @override
  void dispose() {
    // Dispose of all text controllers
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  final List<Widget> _pages = [
    const MapPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onHuntPageChanged(int page) {
    setState(() {
      _currentHuntPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex == 0
          ? _pages[0]
          : PageNavigator(
              controllers: _controllers,
              isCodeCorrect: _isCodeCorrect,
              interestSelections: _interestSelections,
              startTime: _startTime,
              initialPage: _currentHuntPage,
              onPageChanged: _onHuntPageChanged,
              onCodeCorrectChanged: (index, value) {
                setState(() {
                  _isCodeCorrect[index] = value;
                });
              },
              onInterestSelectionChanged: (index, value) {
                setState(() {
                  _interestSelections[index] = value;
                });
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Hunt',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: const Color(0xFF461D7C),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? action;

  const CustomAppBar({super.key, this.action});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF461D7C),
      leadingWidth: 150,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: SizedBox(
          width: 150,
          height: 75,
          child: Image.asset(
            'assets/LSUlogo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: const Text(
        'Patrick F. Taylor Hall Scavenger Hunt',
        style: TextStyle(color: Colors.white),
      ),
      centerTitle: true,
      actions: action != null ? [action!] : null,
    );
  }
}

class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        action: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF461D7C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const SecondFloorMapPage()),
              );
            },
            child: const Text(
              'Go to Floor 2',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/pftmap.png',
            fit: BoxFit.contain,
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Floor 1 Map',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SecondFloorMapPage extends StatelessWidget {
  const SecondFloorMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        action: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF461D7C),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Go to Floor 1',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            'assets/pftmap2.png',
            fit: BoxFit.contain,
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: const Text(
                'Floor 2 Map',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PageNavigator extends StatefulWidget {
  final List<TextEditingController> controllers;
  final List<bool> isCodeCorrect;
  final List<bool?> interestSelections;
  final DateTime? startTime;
  final int initialPage;
  final Function(int) onPageChanged;
  final Function(int, bool) onCodeCorrectChanged;
  final Function(int, bool?) onInterestSelectionChanged;

  const PageNavigator({
    super.key,
    required this.controllers,
    required this.isCodeCorrect,
    required this.interestSelections,
    required this.startTime,
    required this.initialPage,
    required this.onPageChanged,
    required this.onCodeCorrectChanged,
    required this.onInterestSelectionChanged,
  });

  @override
  _PageNavigatorState createState() => _PageNavigatorState();
}

class _PageNavigatorState extends State<PageNavigator> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialPage);
  }

  @override
  void didUpdateWidget(PageNavigator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialPage != widget.initialPage) {
      _controller.jumpToPage(widget.initialPage);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  final List<String> _correctCodes = [
    "1344",
    "1375",
    "1269",
    "1200",
    "2215",
    "2108"
  ];
  final List<String> _pageTitles = [
    "Welcome to the Patrick F. Taylor Hall Scavenger Hunt.",
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
      widget.onCodeCorrectChanged(index ~/ 2, true);
    } else {
      widget.onCodeCorrectChanged(index ~/ 2, false);
    }
  }

  void _setInterest(int index, bool interested) {
    if ((index - 1) ~/ 2 < widget.interestSelections.length) {
      widget.onInterestSelectionChanged((index - 1) ~/ 2, interested);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 14,
        onPageChanged: widget.onPageChanged,
        itemBuilder: (context, index) {
          if (index == 13) {
            Duration elapsedTime = DateTime.now().difference(widget.startTime!);
            return InterestSummaryPage(
              interestSelections: widget.interestSelections,
              elapsedTime: elapsedTime,
            );
          }

          return PageContent(
            index: index,
            title: _pageTitles[index],
            controller: _controller,
            inputController:
                index % 2 == 1 ? widget.controllers[index ~/ 2] : null,
            isCodeCorrect:
                index % 2 == 1 ? widget.isCodeCorrect[index ~/ 2] : true,
            onCodeChanged:
                index % 2 == 1 ? (value) => _validateCode(index, value) : null,
            selectedInterest:
                ((index - 1) ~/ 2 < widget.interestSelections.length &&
                        index % 2 == 0 &&
                        index != 0)
                    ? widget.interestSelections[(index - 1) ~/ 2]
                    : null,
            onInterestSelected:
                ((index - 1) ~/ 2 < widget.interestSelections.length &&
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
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32.0, vertical: 16.0),
                    child: SizedBox(
                      width: 300,
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
      ),
    );
  }
}

class InterestSummaryPage extends StatelessWidget {
  final List<bool?> interestSelections;
  final Duration elapsedTime;

  final List<String> interestPageNames = [
    "Bengal Bots",
    "Panera Bread",
    "Chevron Center",
    "PFT Sponsors",
    "Traffic Research Lab",
    "LSU Career Center Office",
  ];

  InterestSummaryPage(
      {super.key, required this.interestSelections, required this.elapsedTime});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
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
                Text(
                  "Total Tour Time: ${elapsedTime.inMinutes} min ${elapsedTime.inSeconds % 60} sec",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
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
