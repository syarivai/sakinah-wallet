---
title: 'Flutter — states & widget lifecycle'
description: Reference notes on widget state, rebuilds, and lifecycle methods in Flutter.
category: reference
---

# Flutter — states & widget lifecycle

> **Vendored reference.** Copied from the owner's personal notes
> (`software-engineering/mobile/flutter/`), links rewritten for this repo.
> General Flutter guidance the project follows; kept in sync manually. See the
> [Flutter reference index](./README.md).

## 📋 Overview

Understanding state and widget lifecycle is fundamental to building Flutter applications. This guide covers how widgets manage their state, when and how they rebuild, and the lifecycle methods available for different scenarios.

> [!info] Key Concept
> In Flutter, **state** is information that can change over the lifetime of a widget. When state changes, the UI automatically rebuilds to reflect those changes.

## 🎯 Widget Types

Flutter has two fundamental widget types based on how they handle state:

### StatelessWidget vs StatefulWidget

| Aspect | StatelessWidget | StatefulWidget |
|--------|-----------------|----------------|
| **State** | Immutable, no internal state | Mutable, manages internal state |
| **Rebuilds** | Only when parent rebuilds | Rebuilds when `setState()` is called |
| **Use Case** | Static content, pure UI | Dynamic content, user interaction |
| **Performance** | Slightly faster | Small overhead for state management |
| **Example** | Text, Icon, Image | Checkbox, TextField, AnimatedContainer |

## 🔷 StatelessWidget

Widgets that don't require mutable state. Once built, they don't change unless their parent rebuilds them with different parameters.

### Basic Structure

```dart
class MyStatelessWidget extends StatelessWidget {
  // Constructor parameters are the widget's configuration
  final String title;
  final int count;

  const MyStatelessWidget({
    Key? key,
    required this.title,
    this.count = 0,
  }) : super(key: key);

  // build() is called whenever the widget needs to be rendered
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(title),
          Text('Count: $count'),
        ],
      ),
    );
  }
}
```

### When to Use StatelessWidget

✅ **Use StatelessWidget when:**
- Widget displays static content
- Widget receives data only from parent (via constructor)
- Widget doesn't need to track changing data
- Widget is purely presentational

```dart
// Good examples of StatelessWidget
class WelcomeMessage extends StatelessWidget {
  final String userName;

  const WelcomeMessage({Key? key, required this.userName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text('Welcome, $userName!');
  }
}

class ProfileCard extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const ProfileCard({
    Key? key,
    required this.name,
    required this.email,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(avatarUrl)),
          Text(name),
          Text(email),
        ],
      ),
    );
  }
}
```

## 🔶 StatefulWidget

Widgets that maintain mutable state. They can rebuild themselves when internal data changes.

### Basic Structure

```dart
// 1. StatefulWidget class (immutable)
class MyStatefulWidget extends StatefulWidget {
  final String title;

  const MyStatefulWidget({Key? key, required this.title}) : super(key: key);

  // Creates the mutable state
  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

// 2. State class (mutable)
class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  // Mutable state variables
  int _counter = 0;

  // Methods to modify state
  void _incrementCounter() {
    setState(() {
      _counter++; // Modify state inside setState()
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.title), // Access widget properties via 'widget.'
        Text('Count: $_counter'),
        ElevatedButton(
          onPressed: _incrementCounter,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

### When to Use StatefulWidget

✅ **Use StatefulWidget when:**
- Widget needs to track changing data
- Widget responds to user interactions
- Widget manages animations
- Widget needs lifecycle callbacks

```dart
// Good examples of StatefulWidget
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      // Perform login
      await performLogin(_email, _password);

      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            onChanged: (value) => _email = value,
            validator: (value) => value!.isEmpty ? 'Required' : null,
          ),
          TextFormField(
            onChanged: (value) => _password = value,
            obscureText: true,
          ),
          if (_isLoading)
            CircularProgressIndicator()
          else
            ElevatedButton(
              onPressed: _submitForm,
              child: Text('Login'),
            ),
        ],
      ),
    );
  }
}
```

## 🔄 StatefulWidget Lifecycle

The State class provides lifecycle methods that are called at different stages of a widget's life.

### Complete Lifecycle Diagram

```
Widget Creation
     ↓
┌────────────────────────────────────────┐
│ createState()                          │ ← Called once when widget is inserted
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ initState()                            │ ← Initialize state, subscriptions
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ didChangeDependencies()                │ ← Called after initState, when dependencies change
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ build()                                │ ← Build the widget tree
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ Widget is rendered on screen           │
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ setState() called?                     │ ← User interaction or data change
└────────────────────────────────────────┘
     ↓ (yes)
┌────────────────────────────────────────┐
│ build()                                │ ← Rebuild widget
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ didUpdateWidget()                      │ ← Parent widget rebuilt with new config
└────────────────────────────────────────┘
     ↓ (if widget updated)
┌────────────────────────────────────────┐
│ build()                                │ ← Rebuild with new configuration
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ deactivate()                           │ ← Widget removed from tree (temporarily)
└────────────────────────────────────────┘
     ↓
┌────────────────────────────────────────┐
│ dispose()                              │ ← Widget removed permanently
└────────────────────────────────────────┘
```

### Lifecycle Methods in Detail

#### 1. `createState()`

```dart
@override
State<MyWidget> createState() => _MyWidgetState();
```

- **Called**: Once, when Flutter inserts widget into the tree
- **Purpose**: Create the State object
- **Use Case**: Rarely overridden, usually just returns state instance

#### 2. `initState()`

```dart
@override
void initState() {
  super.initState(); // MUST call super.initState() first

  // Initialize state variables
  _counter = 0;

  // Set up controllers
  _controller = AnimationController(
    duration: Duration(seconds: 2),
    vsync: this,
  );

  // Subscribe to streams
  _subscription = myStream.listen((data) {
    setState(() => _data = data);
  });

  // Start timers
  _timer = Timer.periodic(Duration(seconds: 1), (timer) {
    setState(() => _seconds++);
  });
}
```

- **Called**: Once, right after `createState()`
- **Purpose**: One-time initialization
- **Use Case**: Initialize variables, controllers, subscriptions
- **Limitations**: Cannot use `BuildContext` to access inherited widgets (use `didChangeDependencies()` instead)

> [!warning] Common Mistake
> Don't call `setState()` inside `initState()`. The widget hasn't been built yet, so there's nothing to rebuild.

#### 3. `didChangeDependencies()`

```dart
@override
void didChangeDependencies() {
  super.didChangeDependencies();

  // Access inherited widgets safely
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);

  // React to dependency changes
  _updateBasedOnTheme(theme);
}
```

- **Called**: After `initState()` and whenever dependencies change
- **Purpose**: Respond to changes in inherited widgets
- **Use Case**: Access `BuildContext`, react to theme/locale changes
- **Caution**: Can be called multiple times

> [!tip] When to Use
> Use `didChangeDependencies()` when you need to access inherited widgets like `Theme.of(context)` or `MediaQuery.of(context)` during initialization.

#### 4. `build()`

```dart
@override
Widget build(BuildContext context) {
  // Build the widget tree
  return Container(
    child: Text('Counter: $_counter'),
  );
}
```

- **Called**: After `didChangeDependencies()` and after every `setState()`
- **Purpose**: Describe the widget UI
- **Use Case**: Construct and return the widget tree
- **Important**: Should be pure (no side effects)

> [!warning] Performance Warning
> `build()` can be called frequently (60+ times per second during animations). Keep it fast and pure - no expensive operations or side effects!

#### 5. `didUpdateWidget()`

```dart
@override
void didUpdateWidget(MyWidget oldWidget) {
  super.didUpdateWidget(oldWidget);

  // Compare old and new widget properties
  if (widget.url != oldWidget.url) {
    _fetchData(widget.url);
  }

  if (widget.color != oldWidget.color) {
    _controller.animateTo(widget.color);
  }
}
```

- **Called**: When parent rebuilds and provides new configuration
- **Purpose**: Respond to configuration changes
- **Use Case**: Update state based on new widget properties
- **Access**: Compare `widget` (new) with `oldWidget` (previous)

#### 6. `setState()`

```dart
void _updateCounter() {
  setState(() {
    _counter++; // Modify state here
  });
}
```

- **Called**: By you, when state changes
- **Purpose**: Notify Flutter that state changed and widget needs rebuilding
- **Use Case**: Trigger UI updates after state modifications
- **Important**: Only call on mounted widgets

> [!danger] Critical Rule
> Always modify state inside the `setState()` callback. Modifying state outside won't trigger a rebuild!

```dart
// ❌ WRONG - Won't rebuild UI
_counter++;
setState(() {});

// ✅ CORRECT - Will rebuild UI
setState(() {
  _counter++;
});
```

#### 7. `deactivate()`

```dart
@override
void deactivate() {
  // Widget is being removed from tree
  super.deactivate();
}
```

- **Called**: When widget is removed from the tree (but might be reinserted)
- **Purpose**: Cleanup before potential removal
- **Use Case**: Rarely used, mostly for framework internals

#### 8. `dispose()`

```dart
@override
void dispose() {
  // Clean up resources
  _controller.dispose();
  _subscription.cancel();
  _timer.cancel();
  _focusNode.dispose();

  super.dispose(); // MUST call super.dispose() last
}
```

- **Called**: When widget is removed permanently
- **Purpose**: Release resources to prevent memory leaks
- **Use Case**: Dispose controllers, cancel subscriptions, close streams
- **Important**: Always call `super.dispose()` at the end

> [!warning] Memory Leaks
> Failing to dispose of controllers, subscriptions, and listeners causes memory leaks. Always clean up in `dispose()`!

### Complete Lifecycle Example

```dart
class LifecycleDemo extends StatefulWidget {
  final String title;

  const LifecycleDemo({Key? key, required this.title}) : super(key: key);

  @override
  State<LifecycleDemo> createState() {
    print('1. createState()');
    return _LifecycleDemoState();
  }
}

class _LifecycleDemoState extends State<LifecycleDemo> {
  int _counter = 0;
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    print('2. initState()');

    // Initialize state
    _counter = 0;

    // Subscribe to events
    _subscription = eventStream.listen((event) {
      setState(() => _counter++);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('3. didChangeDependencies()');

    // Access inherited widgets
    final theme = Theme.of(context);
  }

  @override
  void didUpdateWidget(LifecycleDemo oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('5. didUpdateWidget()');

    // React to property changes
    if (widget.title != oldWidget.title) {
      print('Title changed from ${oldWidget.title} to ${widget.title}');
    }
  }

  @override
  Widget build(BuildContext context) {
    print('4. build()');

    return Column(
      children: [
        Text(widget.title),
        Text('Counter: $_counter'),
        ElevatedButton(
          onPressed: () => setState(() => _counter++),
          child: Text('Increment'),
        ),
      ],
    );
  }

  @override
  void deactivate() {
    print('6. deactivate()');
    super.deactivate();
  }

  @override
  void dispose() {
    print('7. dispose()');

    // Clean up
    _subscription.cancel();

    super.dispose();
  }
}
```

## 🧠 Understanding BuildContext

`BuildContext` is a handle to the location of a widget in the widget tree.

### What is BuildContext?

```dart
@override
Widget build(BuildContext context) {
  // 'context' represents this widget's location in the tree

  // Access inherited widgets
  final theme = Theme.of(context);
  final mediaQuery = MediaQuery.of(context);
  final navigator = Navigator.of(context);

  // Access ancestor widgets
  final scaffold = Scaffold.of(context);

  return Container();
}
```

### Common BuildContext Uses

#### 1. Accessing Inherited Widgets

```dart
// Theme
final theme = Theme.of(context);
final primaryColor = theme.primaryColor;

// Media Query (screen size, orientation)
final size = MediaQuery.of(context).size;
final orientation = MediaQuery.of(context).orientation;

// Localization
final localizations = MaterialLocalizations.of(context);
```

#### 2. Navigation

```dart
// Push new route
Navigator.of(context).push(
  MaterialPageRoute(builder: (context) => DetailPage()),
);

// Pop route
Navigator.of(context).pop();

// Named routes
Navigator.of(context).pushNamed('/details');
```

#### 3. Showing Dialogs and Snackbars

```dart
// Show dialog
showDialog(
  context: context,
  builder: (context) => AlertDialog(
    title: Text('Alert'),
    content: Text('This is an alert'),
  ),
);

// Show snackbar
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(content: Text('Action completed')),
);
```

> [!warning] Context Gotcha
> The `context` used must be from a widget **below** the widget you're trying to access. For example, to show a `SnackBar`, the context must be from a widget below `Scaffold`.

```dart
// ❌ WRONG - context is above Scaffold
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () {
          // This context is from MyApp, above Scaffold!
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error!')),
          );
        },
        child: Text('Show Snackbar'),
      ),
    );
  }
}

// ✅ CORRECT - use Builder to get context below Scaffold
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext scaffoldContext) {
          return ElevatedButton(
            onPressed: () {
              // scaffoldContext is below Scaffold
              ScaffoldMessenger.of(scaffoldContext).showSnackBar(
                SnackBar(content: Text('Success!')),
              );
            },
            child: Text('Show Snackbar'),
          );
        },
      ),
    );
  }
}
```

## 🎨 State Management Patterns

### 1. Local State (setState)

Best for simple, widget-local state.

```dart
class Counter extends StatefulWidget {
  @override
  State<Counter> createState() => _CounterState();
}

class _CounterState extends State<Counter> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_count'),
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**When to use**: Simple UI state (toggle, counter, form input)

### 2. InheritedWidget

**InheritedWidget** is Flutter's built-in mechanism for efficiently propagating data down the widget tree without passing it through every widget's constructor (avoiding "prop drilling").

#### What Problem Does It Solve?

Without InheritedWidget, you'd need to pass data through every widget in the tree:

```dart
// ❌ PROP DRILLING - Data passed through every level
class GrandParent extends StatelessWidget {
  final String userName = "John";

  @override
  Widget build(BuildContext context) {
    return Parent(userName: userName); // Pass to child
  }
}

class Parent extends StatelessWidget {
  final String userName;

  Parent({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Child(userName: userName); // Pass to grandchild
  }
}

class Child extends StatelessWidget {
  final String userName;

  Child({required this.userName});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $userName'); // Finally use it!
  }
}
```

**Problem**: If `Parent` doesn't need `userName` but `Child` does, we still have to pass it through `Parent`. This becomes messy in large apps!

#### How InheritedWidget Solves This

InheritedWidget allows widgets deep in the tree to access data from ancestors **without explicit passing**:

```
        UserData (InheritedWidget)
             |
             | (Data available to ALL descendants)
             |
        ┌────┴────┐
        │         │
     Parent    Other
        │         │
     Child    GrandChild
        │
   GreatGrandChild ← Can access UserData directly!
```

#### Basic InheritedWidget Implementation

```dart
// 1. Create the InheritedWidget
class UserData extends InheritedWidget {
  final String userName;
  final String email;

  const UserData({
    Key? key,
    required this.userName,
    required this.email,
    required Widget child,
  }) : super(key: key, child: child);

  // Static method to access data from any descendant
  static UserData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<UserData>();
  }

  // Determines if widgets should rebuild when data changes
  @override
  bool updateShouldNotify(UserData oldWidget) {
    // Rebuild descendants if userName or email changed
    return oldWidget.userName != userName || oldWidget.email != email;
  }
}

// 2. Wrap your widget tree with it
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UserData(
      userName: "John Doe",
      email: "john@example.com",
      child: MaterialApp(
        home: HomePage(),
      ),
    );
  }
}

// 3. Access data from ANY descendant widget
class ProfileWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get data without passing through constructors!
    final userData = UserData.of(context);

    return Column(
      children: [
        Text('Name: ${userData?.userName}'),
        Text('Email: ${userData?.email}'),
      ],
    );
  }
}

class DeepNestedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Can access data even if deeply nested!
    final userData = UserData.of(context);
    return Text('Welcome, ${userData?.userName}!');
  }
}
```

#### How It Works Internally

Visual flow of how InheritedWidget works:

```
Step 1: Widget tree is built with InheritedWidget at top
┌─────────────────────────────────────┐
│ UserData (userName: "John")         │ ← InheritedWidget
│   └─ MaterialApp                    │
│       └─ HomePage                   │
│           └─ ProfileWidget          │
│               └─ Text               │
└─────────────────────────────────────┘

Step 2: Child widget calls UserData.of(context)
┌─────────────────────────────────────┐
│ ProfileWidget:                      │
│   UserData.of(context) ──────────┐  │
└──────────────────────────────────│──┘
                                   │
Step 3: Flutter walks UP the tree  │
                                   │
┌──────────────────────────────────▼──┐
│ UserData (userName: "John")   ◄──── Found!
│   └─ MaterialApp                    │
│       └─ HomePage                   │
│           └─ ProfileWidget          │
└─────────────────────────────────────┘

Step 4: Flutter returns the UserData instance
ProfileWidget receives userName: "John"

Step 5: If userName changes, updateShouldNotify() is called
┌─────────────────────────────────────┐
│ updateShouldNotify(oldWidget) {     │
│   return oldWidget.userName !=      │
│          userName;  ← Returns true  │
│ }                                   │
└─────────────────────────────────────┘

Step 6: If true, ALL widgets that called .of() rebuild
ProfileWidget rebuilds with new userName
```

#### Understanding `updateShouldNotify()`

This method determines **when** descendant widgets should rebuild:

```dart
@override
bool updateShouldNotify(UserData oldWidget) {
  // Return true: Descendants rebuild
  // Return false: Descendants DON'T rebuild (performance optimization)

  return oldWidget.userName != userName || oldWidget.email != email;
}
```

**Examples:**

```dart
// Always rebuild (expensive!)
bool updateShouldNotify(UserData old) => true;

// Never rebuild (widgets won't update!)
bool updateShouldNotify(UserData old) => false;

// Only rebuild if specific fields change (optimal!)
bool updateShouldNotify(UserData old) {
  return old.userName != userName; // Only if userName changed
}

// Rebuild if any field changes
bool updateShouldNotify(UserData old) {
  return old.userName != userName ||
         old.email != email ||
         old.age != age;
}
```

#### Complete Real-World Example: Theme System

Let's build a simple theme system using InheritedWidget:

```dart
// 1. Define theme data
class AppTheme {
  final Color primaryColor;
  final Color backgroundColor;
  final TextStyle textStyle;

  const AppTheme({
    required this.primaryColor,
    required this.backgroundColor,
    required this.textStyle,
  });

  // Predefined themes
  static const light = AppTheme(
    primaryColor: Colors.blue,
    backgroundColor: Colors.white,
    textStyle: TextStyle(color: Colors.black),
  );

  static const dark = AppTheme(
    primaryColor: Colors.blueGrey,
    backgroundColor: Colors.black,
    textStyle: TextStyle(color: Colors.white),
  );
}

// 2. Create InheritedWidget
class ThemeProvider extends InheritedWidget {
  final AppTheme theme;

  const ThemeProvider({
    Key? key,
    required this.theme,
    required Widget child,
  }) : super(key: key, child: child);

  static ThemeProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ThemeProvider>();
  }

  @override
  bool updateShouldNotify(ThemeProvider oldWidget) {
    // Rebuild if theme changed
    return oldWidget.theme != theme;
  }
}

// 3. Stateful wrapper to change theme
class ThemeController extends StatefulWidget {
  final Widget child;

  const ThemeController({Key? key, required this.child}) : super(key: key);

  @override
  State<ThemeController> createState() => _ThemeControllerState();
}

class _ThemeControllerState extends State<ThemeController> {
  AppTheme _currentTheme = AppTheme.light;

  void toggleTheme() {
    setState(() {
      _currentTheme = _currentTheme == AppTheme.light
          ? AppTheme.dark
          : AppTheme.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      theme: _currentTheme,
      child: widget.child,
    );
  }
}

// 4. Use anywhere in the app
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = ThemeProvider.of(context)!.theme;

    return Scaffold(
      backgroundColor: theme.backgroundColor,
      appBar: AppBar(
        backgroundColor: theme.primaryColor,
        title: Text('My App'),
      ),
      body: ThemedWidget(),
    );
  }
}

class ThemedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Access theme without passing through constructors!
    final theme = ThemeProvider.of(context)!.theme;

    return Container(
      color: theme.backgroundColor,
      child: Text(
        'Themed Text',
        style: theme.textStyle,
      ),
    );
  }
}

// 5. Toggle theme button
class ThemeToggleButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // We can't call toggleTheme() directly from InheritedWidget
    // because InheritedWidget doesn't have methods
    // Solution: Use findAncestorStateOfType
    final controller = context.findAncestorStateOfType<_ThemeControllerState>();

    return ElevatedButton(
      onPressed: () => controller?.toggleTheme(),
      child: Text('Toggle Theme'),
    );
  }
}
```

#### Built-in InheritedWidgets in Flutter

Flutter uses InheritedWidget internally for many features:

```dart
// Theme
final theme = Theme.of(context);
final primaryColor = theme.primaryColor;

// MediaQuery (screen size, orientation)
final size = MediaQuery.of(context).size;
final orientation = MediaQuery.of(context).orientation;

// Navigator
Navigator.of(context).push(...);

// Scaffold
ScaffoldMessenger.of(context).showSnackBar(...);

// Localizations
final localizations = MaterialLocalizations.of(context);
```

All these `.of(context)` methods are using InheritedWidget under the hood!

#### When to Use InheritedWidget

✅ **Use InheritedWidget when:**
- You need to share data across multiple widgets without prop drilling
- Data doesn't change frequently (theme, config, auth state)
- You want a lightweight solution without external packages
- You're building a custom Flutter package/library

❌ **Don't use InheritedWidget when:**
- State changes very frequently (use Provider, Riverpod, or BLoC)
- You need complex state management with actions/reducers (use Redux, BLoC)
- State is only used in one widget (use local setState)
- You want easier syntax (use Provider which wraps InheritedWidget)

#### InheritedWidget vs Other Solutions

| Solution | Based On | Ease of Use | Features | When to Use |
|----------|----------|-------------|----------|-------------|
| **InheritedWidget** | Built-in | Medium | Basic sharing | Learning, simple apps |
| **Provider** | InheritedWidget | Easy | ChangeNotifier, lazy | Most apps (recommended) |
| **Riverpod** | InheritedWidget | Easy | Compile-time safety | Type-safe apps |
| **BLoC** | Streams | Medium | Event-driven | Complex business logic |
| **setState** | Local state | Easy | Widget-local | Single-widget state |

**When to use**: Sharing read-only or rarely-changing data (theme, user preferences, configuration) across the widget tree without external dependencies

### 3. ValueNotifier & ChangeNotifier

Lightweight state management with listeners.

```dart
class CounterNotifier extends ValueNotifier<int> {
  CounterNotifier() : super(0);

  void increment() {
    value++;
  }
}

// Usage with ValueListenableBuilder
class CounterWidget extends StatelessWidget {
  final CounterNotifier notifier = CounterNotifier();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: notifier,
      builder: (context, count, child) {
        return Column(
          children: [
            Text('Count: $count'),
            ElevatedButton(
              onPressed: notifier.increment,
              child: Text('Increment'),
            ),
          ],
        );
      },
    );
  }
}
```

**When to use**: Simple reactive state without full state management library

### 4. External State Management

For complex apps, consider dedicated state management solutions:

- **Provider**: Simple, recommended by Flutter team
- **Riverpod**: Improved Provider with compile-time safety
- **BLoC**: Business Logic Component pattern
- **GetX**: All-in-one solution
- **Redux**: Predictable state container
- **MobX**: Reactive state management

> [!tip] Choosing State Management
> Start with `setState()` for local state. As your app grows, gradually adopt Provider or Riverpod for shared state. Don't over-engineer early!

## 💡 Best Practices

### ✅ Do's

1. **Use `const` constructors** when possible for better performance
   ```dart
   const Text('Hello'); // ✅ Reuses widget instance
   Text('Hello');       // ❌ Creates new instance
   ```

2. **Always dispose resources** in `dispose()`
   ```dart
   @override
   void dispose() {
     _controller.dispose();
     _subscription.cancel();
     super.dispose();
   }
   ```

3. **Keep `build()` pure** - no side effects
   ```dart
   // ❌ WRONG
   @override
   Widget build(BuildContext context) {
     _fetchData(); // Side effect!
     return Text(_data);
   }

   // ✅ CORRECT
   @override
   void initState() {
     super.initState();
     _fetchData(); // Initialize once
   }
   ```

4. **Use `mounted` check** before calling `setState()` in async operations
   ```dart
   Future<void> _fetchData() async {
     final data = await api.getData();
     if (mounted) {
       setState(() => _data = data);
     }
   }
   ```

### ❌ Don'ts

1. **Don't call `setState()` in `initState()`**
2. **Don't perform expensive operations in `build()`**
3. **Don't forget to call `super` in lifecycle methods**
4. **Don't create new objects in `build()` unnecessarily**

## 🔗 Related Notes

- [Flutter Architecture and Core Concepts](./flutter-architecture.md)
- [Flutter Folder Best Practices](./flutter-folder-structure.md) (coming next)
- [Flutter Best Practices](./flutter-best-practices.md)

## 📚 Further Reading

- [StatefulWidget lifecycle](https://api.flutter.dev/flutter/widgets/State-class.html)
- [setState() documentation](https://api.flutter.dev/flutter/widgets/State/setState.html)
- [State management approaches](https://flutter.dev/docs/development/data-and-backend/state-mgmt/intro)
- [BuildContext explained](https://api.flutter.dev/flutter/widgets/BuildContext-class.html)

---

**Last Updated**: 2025-12-23
**Learning Project**: `/Users/alami/Documents/Learn/flutter/pin_offline_flutter`
