import 'package:flutter/material.dart';

void main() {
  runApp(const CounterImageToggleApp());
}

class CounterImageToggleApp extends StatelessWidget {
  const CounterImageToggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CW1 Counter & Toggle',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  int _counter = 0;
  bool _isDark = false;
  bool _isFirstImage = true;

  late final AnimationController _controller;
  late final Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500), // Length of the animation between images
      vsync: this,
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Updated increment counter to accept optional step
  void _incrementCounter([int step = 1]) {
    setState(() => _counter += step);
  }

  // Logic for decrement button
  void _decrementCounter() {
    if (_counter > 0) {
      setState(() => _counter--);
    }
  }

  void _resetCounter() {
    if (_counter > 0) {
      setState(() => _counter = 0);
    }
  }

  // Flips _isDark from True to False or vice versa to change the theme
  void _toggleTheme() {
    setState(() {
    _isDark = !_isDark;
  });
}

  void _toggleImage() {
  // Fade out the current image
  _controller.reverse(from: 1).then((_) {
    // Swap the image after fade-out completes
    setState(() => _isFirstImage = !_isFirstImage);
    _controller.forward(from: 0); // Fade in new image
  });
}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('CW1 Counter & Toggle'),
          actions: [
             IconButton(
              onPressed: _toggleTheme,
              icon: Icon(_isDark ? Icons.light_mode : Icons.dark_mode),
              tooltip: 'Toggle Theme',
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Counter: $_counter',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),

              // Multi-step increment buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _incrementCounter(1),
                    child: const Text('+1'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _incrementCounter(5),
                    child: const Text('+5'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () => _incrementCounter(10),
                    child: const Text('+10'),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Decrement and Reset buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _counter > 0 ? _decrementCounter : null,
                    child: const Text('-1'),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _counter > 0 ? _resetCounter : null,
                    child: const Text('Reset'),
                  ),
                ],
              ),

              const SizedBox(height: 24),


              // Image display
              FadeTransition(
                opacity: _fade,
                child: Image.asset(
                  _isFirstImage ? 'assets/image1.jpg' : 'assets/image2.jpg',
                  width: 200,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _toggleImage,
                child: const Text('Toggle Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
