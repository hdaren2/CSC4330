import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for iOS
  if (Platform.isIOS) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

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
        // Add iOS-specific styling
        platform: TargetPlatform.iOS,
        cupertinoOverrideTheme: const CupertinoThemeData(
          primaryColor: Color(0xFF461D7C),
        ),
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
      List.generate(10, (index) => TextEditingController());
  final List<bool> _isCodeCorrect = List.generate(10, (index) => false);
  final List<bool?> _interestSelections = List.generate(10, (index) => null);
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
    final List<Widget> pages = [
      PageNavigator(
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
      const MapPage(),
      DiscoveredPlacesPage(
        isCodeCorrect: _isCodeCorrect,
        onPageSelected: (pageIndex) {
          setState(() {
            _selectedIndex = 0; // Switch to Hunt tab
            _currentHuntPage = pageIndex; // Set the page index
          });
        },
      ),
    ];

    return Scaffold(
      body: pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Hunt',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Discovered',
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
      leadingWidth: 120,
      leading: Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: SizedBox(
          width: 120,
          height: 60,
          child: Image.asset(
            'assets/LSUlogo.png',
            fit: BoxFit.contain,
          ),
        ),
      ),
      title: const Text(
        'Patrick F. Taylor Hall Scavenger Hunt',
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      actions: action != null ? [action!] : null,
      elevation: Platform.isIOS ? 0.0 : 4.0,
    );
  }
}

class MapMarker {
  final Offset position;
  final String label;
  final DateTime timestamp;

  MapMarker({
    required this.position,
    required this.label,
    required this.timestamp,
  });
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        action: Row(
          children: [
            Padding(
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
          ],
        ),
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          InteractiveViewer(
            transformationController: _transformationController,
            minScale: 0.5,
            maxScale: 4.0,
            child: Image.asset(
              'assets/pftmap.png',
              fit: BoxFit.contain,
            ),
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

class SecondFloorMapPage extends StatefulWidget {
  const SecondFloorMapPage({super.key});

  @override
  State<SecondFloorMapPage> createState() => _SecondFloorMapPageState();
}

class _SecondFloorMapPageState extends State<SecondFloorMapPage> {
  final TransformationController _transformationController =
      TransformationController();

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return false;
      },
      child: Scaffold(
        appBar: CustomAppBar(
          action: Row(
            children: [
              Padding(
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
            ],
          ),
        ),
        body: Stack(
          fit: StackFit.expand,
          children: [
            InteractiveViewer(
              transformationController: _transformationController,
              minScale: 0.5,
              maxScale: 4.0,
              child: Image.asset(
                'assets/pftmap2.png',
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    "2108",
    "1300",
    "1278",
    "1354",
    "2348"
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
    "Here you will find vehicles, crawlers, spiders, and robots of all kinds",
    "Welcome to the Robotics Lab, where creativity is crawling",
    "After getting something to eat, you look for a seat.",
    "Welcome to the Commons, where students sit, study, and eat.",
    "Mechanics in motion, and the lab is in sight",
    "Welcome to the Mechanical Engineering Lab, where sparks of innovation fly",
    "Screens galore, they are looking at buildings on the second floor",
    "Welcome to Building Information Modeling Lab, where construction management students can virtually visit building sites.",
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
        itemCount: 22,
        onPageChanged: widget.onPageChanged,
        itemBuilder: (context, index) {
          if (index == 21) {
            Duration elapsedTime = DateTime.now().difference(widget.startTime!);
            return InterestSummaryPage(
              interestSelections: widget.interestSelections,
              elapsedTime: elapsedTime,
              controller: _controller,
            );
          }

          bool showInterestSelection =
              (index - 1) ~/ 2 < widget.interestSelections.length &&
                  index % 2 == 0 &&
                  index != 0;

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
            selectedInterest: showInterestSelection
                ? widget.interestSelections[(index - 1) ~/ 2]
                : null,
            onInterestSelected: showInterestSelection
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
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside the text field
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                            // Dismiss keyboard before navigation
                            FocusScope.of(context).unfocus();
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
                            // Dismiss keyboard before navigation
                            FocusScope.of(context).unfocus();
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
      ),
    );
  }
}

class InterestSummaryPage extends StatelessWidget {
  final List<bool?> interestSelections;
  final Duration elapsedTime;
  final PageController controller;

  final List<String> interestPageNames = [
    "Bengal Bots",
    "Panera Bread",
    "Chevron Center",
    "PFT Sponsors",
    "Traffic Research Lab",
    "LSU Career Center Office",
    "Robotics Lab",
    "The Commons",
    "Mechanical Engineering Lab",
    "Building Information Modeling Lab"
  ];

  InterestSummaryPage({
    super.key,
    required this.interestSelections,
    required this.elapsedTime,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/page_22.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Interest Summary",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                for (int i = 0; i < interestSelections.length; i++)
                  Text(
                    "${interestPageNames[i]}: ${interestSelections[i] == null ? 'No Selection' : interestSelections[i]! ? 'Interested' : 'Not Interested'}",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(height: 14),
                Text(
                  "Total Tour Time: ${elapsedTime.inMinutes} min ${elapsedTime.inSeconds % 60} sec",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  "Thank you for participating in the scavenger hunt!",
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    controller.previousPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: const Text('Previous'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DiscoveredPlacesPage extends StatelessWidget {
  final List<bool> isCodeCorrect;
  final Function(int) onPageSelected;

  const DiscoveredPlacesPage({
    super.key,
    required this.isCodeCorrect,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> places = [
      {
        "title": "Bengal Bots",
        "room": "Room 1344",
        "description": "LSU's Robotics Club",
        "pageIndex": 2,
      },
      {
        "title": "Panera Bread",
        "room": "Room 1375",
        "description": "Food service of choice at PFT",
        "pageIndex": 4,
      },
      {
        "title": "Chevron Center",
        "room": "Room 1269",
        "description": "Where blue and red meet",
        "pageIndex": 6,
      },
      {
        "title": "PFT Sponsors",
        "room": "Room 1200",
        "description": "Proud sponsors of our beloved PFT",
        "pageIndex": 8,
      },
      {
        "title": "Traffic Research Lab",
        "room": "Room 2215",
        "description": "Traffic Research and Visualization Engineering Lab",
        "pageIndex": 10,
      },
      {
        "title": "Career Center",
        "room": "Room 2108",
        "description": "Lisa Hibner's office",
        "pageIndex": 12,
      },
      {
        "title": "Robotics Lab",
        "room": "Room 1300",
        "description": "Where creativity is crawling",
        "pageIndex": 14,
      },
      {
        "title": "The Commons",
        "room": "Room 1278",
        "description": "Where students sit, study, and eat",
        "pageIndex": 16,
      },
      {
        "title": "Mechanical Engineering Lab",
        "room": "Room 1354",
        "description": "Where sparks of innovation fly",
        "pageIndex": 18,
      },
      {
        "title": "Building Information Modeling Lab",
        "room": "Room 2348",
        "description":
            "Where construction management students can virtually visit building sites",
        "pageIndex": 20,
      },
    ];

    return Scaffold(
      appBar: const CustomAppBar(),
      body: ListView.builder(
        itemCount: places.length,
        itemBuilder: (context, index) {
          if (!isCodeCorrect[index]) {
            return const SizedBox.shrink();
          }
          return _buildPlaceTile(
            context,
            places[index]["title"],
            places[index]["room"],
            places[index]["description"],
            places[index]["pageIndex"],
          );
        },
      ),
    );
  }

  Widget _buildPlaceTile(
    BuildContext context,
    String title,
    String roomNumber,
    String description,
    int pageIndex,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              roomNumber,
              style: const TextStyle(
                color: Color(0xFF461D7C),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          onPageSelected(pageIndex);
        },
      ),
    );
  }
}
