---
title: 'Flutter — development best practices'
description: Reference notes on Flutter code quality, performance, testing, and security — the conventions this project follows.
category: reference
---

# Flutter — development best practices

> **Vendored reference.** Copied from the owner's personal notes
> (`software-engineering/mobile/flutter/`), links rewritten for this repo.
> General Flutter guidance the project follows; kept in sync manually. See the
> [Flutter reference index](./README.md).

## 📋 Overview

This guide covers essential best practices for Flutter development, from code quality and performance optimization to testing and security. Following these practices will help you build maintainable, performant, and robust Flutter applications.

> [!info] Continuous Improvement
> Best practices evolve with the framework. Always refer to official Flutter documentation and community resources for the latest recommendations.

## 🎨 Code Style & Conventions

### 1. Follow Dart Style Guide

Use `dart format` and `dart analyze` to enforce consistent code style.

```bash
# Format code automatically
dart format .

# Analyze code for issues
dart analyze

# Fix auto-fixable issues
dart fix --apply
```

### 2. Use `const` Constructors Liberally

```dart
// ❌ BAD - Creates new widget instances on every rebuild
Widget build(BuildContext context) {
  return Column(
    children: [
      Text('Hello'),
      SizedBox(height: 16),
      Icon(Icons.star),
    ],
  );
}

// ✅ GOOD - Reuses widget instances
Widget build(BuildContext context) {
  return Column(
    children: [
      const Text('Hello'),
      const SizedBox(height: 16),
      const Icon(Icons.star),
    ],
  );
}
```

**Benefits:**
- Compile-time constants are cached
- Reduces memory allocation
- Improves rebuild performance

> [!tip] Quick Win
> Add `prefer_const_constructors` to your `analysis_options.yaml` to get warnings when you forget `const`.

### 3. Prefer `final` Over `var`

```dart
// ❌ BAD - Mutable when it shouldn't be
var userName = 'John';
var userAge = 25;

// ✅ GOOD - Immutable
final userName = 'John';
final userAge = 25;

// ✅ ALSO GOOD - Explicit type
final String userName = 'John';
final int userAge = 25;
```

### 4. Use Meaningful Names

```dart
// ❌ BAD - Unclear names
Widget build(BuildContext context) {
  final d = fetchData();
  final c = getCount();
  return Text('$c items');
}

// ✅ GOOD - Descriptive names
Widget build(BuildContext context) {
  final userData = fetchUserData();
  final itemCount = getItemCount();
  return Text('$itemCount items');
}
```

### 5. Extract Widgets for Reusability

```dart
// ❌ BAD - Repeated code
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Card 1'),
        ),
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text('Card 2'),
        ),
      ],
    );
  }
}

// ✅ GOOD - Extracted reusable widget
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomCard(title: 'Card 1'),
        CustomCard(title: 'Card 2'),
      ],
    );
  }
}

class CustomCard extends StatelessWidget {
  final String title;

  const CustomCard({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(title),
    );
  }
}
```

### 6. Use Extension Methods

```dart
// Create reusable extensions
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
}

extension ContextExtension on BuildContext {
  // Quick access to common properties
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  Size get screenSize => MediaQuery.of(this).size;
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;

  // Navigation helpers
  void push(Widget page) {
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }

  void pop() => Navigator.of(this).pop();
}

// Usage
final name = 'john'.capitalize(); // 'John'
final isValid = 'test@email.com'.isValidEmail; // true
final width = context.screenWidth;
context.push(DetailPage());
```

## 🚀 Performance Optimization

### 1. Avoid Rebuilding Widgets Unnecessarily

```dart
// ❌ BAD - Entire widget rebuilds when count changes
class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ExpensiveWidget(), // Rebuilds unnecessarily!
        Text('Count: $_count'),
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: Text('Increment'),
        ),
      ],
    );
  }
}

// ✅ GOOD - Extract widgets that don't need to rebuild
class CounterPage extends StatefulWidget {
  @override
  State<CounterPage> createState() => _CounterPageState();
}

class _CounterPageState extends State<CounterPage> {
  int _count = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ExpensiveWidget(), // Doesn't rebuild!
        Text('Count: $_count'),
        ElevatedButton(
          onPressed: () => setState(() => _count++),
          child: const Text('Increment'),
        ),
      ],
    );
  }
}
```

### 2. Use `ListView.builder` for Long Lists

```dart
// ❌ BAD - Creates all items upfront (memory intensive)
ListView(
  children: List.generate(
    1000,
    (index) => ListTile(title: Text('Item $index')),
  ),
);

// ✅ GOOD - Lazily builds items as needed
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'));
  },
);

// ✅ EVEN BETTER - For large lists with different heights
ListView.separated(
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
  separatorBuilder: (context, index) => const Divider(),
);
```

### 3. Optimize Images

```dart
// ❌ BAD - Loads full-size image
Image.network('https://example.com/large-image.jpg');

// ✅ GOOD - Cache and resize
Image.network(
  'https://example.com/large-image.jpg',
  cacheWidth: 500, // Resize to 500px width
  cacheHeight: 300,
  loadingBuilder: (context, child, loadingProgress) {
    if (loadingProgress == null) return child;
    return CircularProgressIndicator(
      value: loadingProgress.expectedTotalBytes != null
          ? loadingProgress.cumulativeBytesLoaded /
              loadingProgress.expectedTotalBytes!
          : null,
    );
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
  },
);

// ✅ BEST - Use cached_network_image package
CachedNetworkImage(
  imageUrl: 'https://example.com/large-image.jpg',
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.error),
  memCacheWidth: 500,
  memCacheHeight: 300,
);
```

### 4. Use `RepaintBoundary` for Complex Widgets

```dart
// Isolate expensive widgets to prevent unnecessary repaints
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RepaintBoundary(
          child: ComplexChart(), // Won't repaint when siblings change
        ),
        SimpleCounter(), // Can rebuild independently
      ],
    );
  }
}
```

### 5. Avoid Building Widgets in `build()` Methods

```dart
// ❌ BAD - Creates new objects on every build
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(fontSize: 16, color: Colors.blue);
    return Text('Hello', style: textStyle);
  }
}

// ✅ GOOD - Define constants outside build
class MyWidget extends StatelessWidget {
  static const textStyle = TextStyle(fontSize: 16, color: Colors.blue);

  @override
  Widget build(BuildContext context) {
    return const Text('Hello', style: textStyle);
  }
}
```

### 6. Use `key` Property Wisely

```dart
// Use keys when widget order changes
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    final item = items[index];
    return ListTile(
      key: ValueKey(item.id), // Preserves state when list reorders
      title: Text(item.title),
    );
  },
);
```

**Key Types:**
- `ValueKey`: For primitive values (int, String)
- `ObjectKey`: For objects with `==` and `hashCode`
- `UniqueKey`: For unique identification
- `GlobalKey`: For accessing widget state from outside (use sparingly)

## 🧪 Testing Best Practices

### Testing Pyramid

Follow the testing pyramid for optimal test coverage:

```
         /\
        /  \          Integration Tests (Few)
       /    \         - Full user flows
      /------\        - E2E scenarios
     /        \
    /          \      Widget Tests (Some)
   /            \     - UI components
  /--------------\    - User interactions
 /                \
/                  \  Unit Tests (Many)
--------------------  - Business logic
                      - Utilities
                      - Data layer
```

**Recommended ratio**: 70% Unit | 20% Widget | 10% Integration

### AAA Pattern (Arrange-Act-Assert)

Structure all tests using the AAA pattern:

```dart
test('description', () {
  // Arrange: Set up test data and dependencies
  final calculator = Calculator();

  // Act: Execute the action being tested
  final result = calculator.add(2, 3);

  // Assert: Verify the expected outcome
  expect(result, 5);
});
```

### Testing by Layer

#### 1. Domain Layer Testing (Pure Business Logic)

**What to test:**
- Use cases / interactors
- Business rules and validations
- Domain models and entities

**Key practices:**
```dart
// No mocking needed for pure logic
test('email validation returns false for invalid format', () {
  final validator = EmailValidator();

  expect(validator.isValid('invalid-email'), false);
  expect(validator.isValid('test@example.com'), true);
});

// Test use case with mocked repository
test('GetUserUseCase returns user when repository succeeds', () async {
  final mockRepo = MockUserRepository();
  final useCase = GetUserUseCase(mockRepo);

  when(mockRepo.getUser('123'))
      .thenAnswer((_) async => User(id: '123', name: 'John'));

  final result = await useCase.execute('123');

  expect(result.name, 'John');
});
```

#### 2. Data Layer Testing

**What to test:**
- API clients and data sources
- Data models (toJson/fromJson)
- Repository implementations

**Key practices:**
```dart
// Use mockito for external dependencies
@GenerateMocks([ApiClient, Database])
test('UserRepository fetches user from API', () async {
  final mockApi = MockApiClient();
  final repo = UserRepositoryImpl(mockApi);

  when(mockApi.fetchUser('123'))
      .thenAnswer((_) async => {'id': '123', 'name': 'John'});

  final user = await repo.getUser('123');

  expect(user.id, '123');
  verify(mockApi.fetchUser('123')).called(1);
});
```

#### 3. Presentation Layer Testing

**Widget Tests:**
```dart
testWidgets('LoginButton calls onPressed when tapped', (tester) async {
  bool pressed = false;

  await tester.pumpWidget(
    MaterialApp(
      home: LoginButton(onPressed: () => pressed = true),
    ),
  );

  await tester.tap(find.text('Login'));
  await tester.pump();

  expect(pressed, true);
});
```

**BLoC/Cubit Tests:**
```dart
// Use bloc_test package
blocTest<CounterCubit, int>(
  'emits [1] when increment is called',
  build: () => CounterCubit(),
  act: (cubit) => cubit.increment(),
  expect: () => [1],
);
```

### Essential Testing Tools

**Core packages:**
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mockito: ^5.6.5              # Mocking (or mocktail ^1.0.5 for codegen-free mocks)
  build_runner: ^2.15.0        # Code generation
  bloc_test: ^10.0.0           # BLoC testing
  integration_test:            # E2E testing
    sdk: flutter
```

### Integration Testing

Test complete user flows end-to-end:

```dart
IntegrationTestWidgetsFlutterBinding.ensureInitialized();

testWidgets('complete login flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Enter credentials
  await tester.enterText(find.byKey(Key('email')), 'test@example.com');
  await tester.enterText(find.byKey(Key('password')), 'password123');

  // Submit and verify
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();

  expect(find.text('Dashboard'), findsOneWidget);
});
```

### Golden Tests (Visual Regression)

Golden tests capture a widget's rendered output as a `.png` baseline and fail the build if it changes unexpectedly. They're the cheapest way to catch unintended UI shifts.

> [!warning] `golden_toolkit` is dead — use `alchemist` instead
> `golden_toolkit` last shipped 2023-02-21 with SDK `<3.0.0`. The maintained replacement is **`alchemist`** (^0.14.0, by Betterment).

```yaml
dev_dependencies:
  alchemist: ^0.14.0
```

```dart
// test/presentation/screens/transactions_screen_golden_test.dart
import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  goldenTest(
    'TransactionsScreen renders empty / loading / loaded states',
    fileName: 'transactions_screen',
    builder: () => GoldenTestGroup(
      children: [
        GoldenTestScenario(name: 'empty',   child: TransactionsScreen.preview(state: empty)),
        GoldenTestScenario(name: 'loading', child: TransactionsScreen.preview(state: loading)),
        GoldenTestScenario(name: 'loaded',  child: TransactionsScreen.preview(state: loaded)),
      ],
    ),
  );
}
```

**Workflow:**
- Generate / update baselines: `flutter test --update-goldens`
- Validate on CI: `flutter test` (fails if rendered output diverges from baseline)
- Store baselines under `test/goldens/` and check them into git

> [!tip] Why goldens are a portfolio signal
> A repo with golden tests on CI tells reviewers you care about visual regression — most learning projects don't bother. It's also a strong defense against accidental theme/font changes when bumping Flutter versions.

### Key Best Practices

1. **Test Naming**: Use descriptive names that explain what is being tested
   - ✅ `test('returns user when API call succeeds')`
   - ❌ `test('test1')`

2. **One Assertion Focus**: Each test should verify one behavior
   - Group related tests using `group()`

3. **Mock External Dependencies**: Never hit real APIs/databases in tests
   - Use `mockito` for repositories, APIs, services
   - Use `fake` implementations for simple cases

4. **Isolate Tests**: Tests should not depend on each other
   - Use `setUp()` and `tearDown()` for initialization/cleanup

5. **Fast Feedback**: Keep unit tests fast (<100ms)
   - Move slow tests to integration tests
   - Mock time-consuming operations

6. **Test Coverage**: Aim for 80%+ on business logic
   - Don't obsess over 100% coverage
   - Focus on critical paths and edge cases

7. **Widget Testing Tips**:
   - Use `pumpAndSettle()` for animations
   - Use `Key` for finding specific widgets
   - Test user interactions, not implementation details

8. **Continuous Testing**: Run tests automatically
   - Pre-commit hooks
   - CI/CD pipeline integration

### Common Testing Patterns

**Testing Async Code:**
```dart
test('async operation completes', () async {
  final result = await fetchData();
  expect(result, isNotNull);
});
```

**Testing Exceptions:**
```dart
test('throws exception on invalid input', () {
  expect(() => divide(10, 0), throwsException);
});
```

**Testing Streams:**
```dart
test('stream emits expected values', () {
  final stream = countStream();
  expect(stream, emitsInOrder([1, 2, 3, emitsDone]));
});
```

## 🔒 Security Best Practices

### 1. Never Store Sensitive Data in Plain Text

```dart
// ❌ BAD - Plain storage
SharedPreferences prefs = await SharedPreferences.getInstance();
await prefs.setString('api_token', 'secret_token');

// ✅ GOOD - Use flutter_secure_storage
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = FlutterSecureStorage();
await storage.write(key: 'api_token', value: 'secret_token');
final token = await storage.read(key: 'api_token');
```

### 2. Validate User Input

```dart
class LoginForm extends StatefulWidget {
  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!value.contains('@')) {
                return 'Invalid email format';
              }
              return null;
            },
            onSaved: (value) => _email = value!,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required';
              }
              if (value.length < 8) {
                return 'Password must be at least 8 characters';
              }
              return null;
            },
            onSaved: (value) => _password = value!,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                // Proceed with login
              }
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}
```

### 3. Use HTTPS for Network Requests

```dart
// ✅ GOOD - Always use HTTPS
class ApiConfig {
  static const String baseUrl = 'https://api.example.com';
  // NOT http://api.example.com
}

// Configure Dio to reject non-HTTPS in debug mode
final dio = Dio(BaseOptions(
  baseUrl: ApiConfig.baseUrl,
  validateStatus: (status) => status! < 500,
));

// Add interceptor to log insecure requests
dio.interceptors.add(InterceptorsWrapper(
  onRequest: (options, handler) {
    if (!options.uri.scheme.contains('https')) {
      throw Exception('Insecure HTTP request detected: ${options.uri}');
    }
    return handler.next(options);
  },
));
```

### 4. Don't Expose API Keys in Code

```dart
// ❌ BAD - API key in code
const apiKey = 'sk_live_51234567890abcdef';

// ✅ GOOD - Use environment variables
// Run: flutter run --dart-define=API_KEY=your_key_here

class AppConfig {
  static const String apiKey = String.fromEnvironment('API_KEY');
}

// Or use flutter_dotenv package
// .env file (add to .gitignore)
// API_KEY=sk_live_51234567890abcdef

import 'package:flutter_dotenv/flutter_dotenv.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

// Access
final apiKey = dotenv.env['API_KEY'];
```

### 5. Banking / Fintech-Grade Security Extras

For finance apps, the four basics above aren't enough. Add:

#### a) Biometric Authentication

```yaml
dependencies:
  local_auth: ^3.0.1
```

```dart
import 'package:local_auth/local_auth.dart';

class BiometricService {
  final LocalAuthentication _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    if (!canCheck) return _fallbackToPin();

    return _auth.authenticate(
      localizedReason: 'Unlock to view your finances',
      options: const AuthenticationOptions(
        stickyAuth: true,
        biometricOnly: false, // allow PIN/passcode fallback
      ),
    );
  }
}
```

#### b) Certificate Pinning (Dio)

```yaml
dependencies:
  dio_certificate_pinning: ^6.0.0
```

```dart
final dio = Dio()
  ..interceptors.add(CertificatePinningInterceptor(
    allowedSHAFingerprints: [
      'AA:BB:CC:DD:...',  // SHA-256 of your server cert
    ],
  ));
```

Pinning prevents man-in-the-middle attacks even if the device trust store is compromised.

#### c) Root / Jailbreak Detection

```yaml
dependencies:
  flutter_jailbreak_detection: ^1.10.0
```

```dart
final isCompromised = await FlutterJailbreakDetection.jailbroken;
if (isCompromised) {
  // refuse to load sensitive screens, or warn the user
}
```

#### d) PII-Safe Logging

```dart
// Never log full account numbers, JWTs, or full email addresses.
final logger = Logger(
  filter: ProductionFilter(),  // INFO+ in release, DEBUG+ in debug
  printer: PrettyPrinter(noBoxingByDefault: true),
);

// ❌ logger.i('User logged in: ${user.email}');
// ✅ logger.i('User logged in: ${user.email.split('@').first[0]}***');
```

## ♿ Accessibility

Banking apps especially must work for screen-reader users, low-vision users, and users with reduced motion. The cost is small (mostly attribute-level tweaks) and the audience uplift is real.

### 1. Semantic Labels on Every Interactive Widget

```dart
// ❌ BAD — no label, screen reader announces "button"
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: _delete,
);

// ✅ GOOD — screen reader announces "Delete transaction, button"
IconButton(
  icon: const Icon(Icons.delete),
  onPressed: _delete,
  tooltip: 'Delete transaction', // becomes the semantic label too
);

// ✅ For complex composite widgets
Semantics(
  label: 'Halal transaction, 50,000 IDR, food category',
  excludeSemantics: true, // suppress child widgets' own announcements
  child: TransactionTile(...),
);
```

### 2. Respect Dynamic Text Scaling

```dart
// ❌ BAD — clips at 1.5× text scale
Text('Balance: $amount', style: TextStyle(fontSize: 18));

// ✅ GOOD — scales with user preference, capped to prevent overflow
Text(
  'Balance: $amount',
  style: Theme.of(context).textTheme.bodyLarge,
  textScaler: MediaQuery.textScalerOf(context).clamp(maxScaleFactor: 2.0),
);
```

### 3. Sufficient Contrast & Touch Targets

- Minimum tap target: **48×48 dp** (Material) / **44×44 pt** (Cupertino).
- Text contrast: **4.5:1** for body, **3:1** for large text (WCAG AA).
- Don't rely on colour alone — use icons + labels for halal / non-halal indicators.

### 4. Reduced-Motion Support

```dart
final reduceMotion = MediaQuery.disableAnimationsOf(context);
final duration = reduceMotion ? Duration.zero : const Duration(milliseconds: 200);
```

### 5. Test with Real Tools

- **iOS**: VoiceOver (Settings → Accessibility → VoiceOver)
- **Android**: TalkBack (Settings → Accessibility → TalkBack)
- **Programmatic**: `expect(tester.semantics, includesNodeWith(label: 'Delete transaction'));`

> [!tip] Quick wins
> Adding `tooltip` to every `IconButton` is the single highest-leverage change — it satisfies VoiceOver/TalkBack, gives long-press hover labels on desktop, and costs nothing.

## ⚠️ Error Handling

### 1. Use Try-Catch Blocks

```dart
// ❌ BAD - No error handling
Future<User> fetchUser() async {
  final response = await dio.get('/user');
  return User.fromJson(response.data);
}

// ✅ GOOD - Proper error handling
//   import 'package:fpdart/fpdart.dart';   // NOT dartz — see "Library Health Notes" below
Future<Either<Failure, User>> fetchUser() async {
  try {
    final response = await dio.get('/user');
    return Right(User.fromJson(response.data));
  } on DioException catch (e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      return Left(NetworkFailure('Connection timeout'));
    } else if (e.response?.statusCode == 404) {
      return Left(NotFoundFailure('User not found'));
    } else {
      return Left(ServerFailure('Server error: ${e.message}'));
    }
  } catch (e) {
    return Left(UnknownFailure('Unknown error: $e'));
  }
}
```

### 2. Show User-Friendly Error Messages

```dart
class ErrorHandler {
  static void showError(BuildContext context, Failure failure) {
    String message;

    if (failure is NetworkFailure) {
      message = 'No internet connection. Please try again.';
    } else if (failure is ServerFailure) {
      message = 'Server error. Please try again later.';
    } else if (failure is NotFoundFailure) {
      message = 'Resource not found.';
    } else {
      message = 'Something went wrong. Please try again.';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'RETRY',
          onPressed: () {
            // Retry logic
          },
        ),
      ),
    );
  }
}
```

### 3. Global Error Handling

```dart
void main() {
  // Catch Flutter framework errors
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    // Log to crash reporting service (e.g., Firebase Crashlytics)
    FirebaseCrashlytics.instance.recordFlutterFatalError(details);
  };

  // Catch async errors
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}
```

## 🐛 Debugging Techniques

### 1. Use Debug Prints Wisely

```dart
import 'package:flutter/foundation.dart';

// ❌ BAD - print() stays in production
print('Debug message');

// ✅ GOOD - Only prints in debug mode
if (kDebugMode) {
  print('Debug message');
}

// ✅ BETTER - Use debugPrint for long messages
debugPrint('Long debug message that might be truncated');

// ✅ BEST - Use logger package
import 'package:logger/logger.dart';

final logger = Logger();

logger.d('Debug message');
logger.i('Info message');
logger.w('Warning message');
logger.e('Error message');
```

### 2. Use Flutter DevTools

```bash
# Run your app
flutter run

# Open DevTools in browser
flutter pub global activate devtools
flutter pub global run devtools
```

**DevTools Features:**
- **Widget Inspector**: Visualize widget tree
- **Performance**: Profile app performance
- **Network**: Monitor network requests
- **Logging**: View app logs
- **Memory**: Detect memory leaks

### 3. Use Assert Statements

```dart
class User {
  final String id;
  final String name;

  User({required this.id, required this.name})
      : assert(id.isNotEmpty, 'User ID cannot be empty'),
        assert(name.isNotEmpty, 'User name cannot be empty');
}

// Assertions only run in debug mode
void processAge(int age) {
  assert(age >= 0, 'Age cannot be negative');
  assert(age <= 150, 'Age seems unrealistic');
  // Process age
}
```

## 📦 Package Management

### 1. Keep Dependencies Updated

```bash
# Check for outdated packages
flutter pub outdated

# Update dependencies
flutter pub upgrade

# Get dependencies
flutter pub get
```

### 2. Use Version Constraints

```yaml
# pubspec.yaml

# ❌ BAD - Any version (dangerous)
dependencies:
  http: any

# ❌ BAD - Exact version (too restrictive)
dependencies:
  http: 1.1.0

# ✅ GOOD - Caret syntax (compatible versions)
dependencies:
  http: ^1.1.0  # Allows 1.1.0 to <2.0.0

# ✅ GOOD - Range (more control)
dependencies:
  http: '>=1.1.0 <2.0.0'
```

### 3. Organize Dependencies

```yaml
dependencies:
  # Core Flutter
  flutter:
    sdk: flutter

  # UI
  cupertino_icons: ^1.0.6

  # State Management
  flutter_bloc: ^9.1.1
  equatable: ^2.0.8

  # Functional types (Either / Option / Task) — replaces unmaintained dartz
  fpdart: ^1.2.0

  # Network
  dio: ^5.9.2
  connectivity_plus: ^7.0.2

  # Storage
  shared_preferences: ^2.5.0
  flutter_secure_storage: ^10.1.0

  # Utilities
  intl: ^0.20.2
  logger: ^2.7.0

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Linting
  flutter_lints: ^6.0.0
  # Stricter alternative: very_good_analysis: ^10.2.0

  # Testing
  mockito: ^5.6.5
  build_runner: ^2.15.0
  bloc_test: ^10.0.0
  alchemist: ^0.14.0          # golden tests (replaces unmaintained golden_toolkit)

  # Code Generation
  json_serializable: ^6.13.2
  freezed: ^3.2.5             # sealed-class states with Dart 3 exhaustive switches
```

## 🎯 Common Pitfalls to Avoid

### 1. Don't Use `setState()` After `dispose()`

```dart
// ❌ BAD - Can cause errors
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  Future<void> fetchData() async {
    final data = await api.getData();
    setState(() => _data = data); // Error if widget is disposed!
  }

  @override
  void dispose() {
    super.dispose();
  }
}

// ✅ GOOD - Check if mounted
class _MyWidgetState extends State<MyWidget> {
  Future<void> fetchData() async {
    final data = await api.getData();
    if (mounted) {
      setState(() => _data = data);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
```

### 2. Don't Forget to Dispose Controllers

```dart
// ❌ BAD - Memory leak!
class MyForm extends StatefulWidget {
  @override
  State<MyForm> createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }
  // Missing dispose()!
}

// ✅ GOOD - Proper cleanup
class _MyFormState extends State<MyForm> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(controller: _controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
```

### 3. Don't Perform Heavy Operations in `build()`

```dart
// ❌ BAD - Heavy computation in build
class MyWidget extends StatelessWidget {
  final List<int> numbers;

  @override
  Widget build(BuildContext context) {
    final sum = numbers.reduce((a, b) => a + b); // Computed on every build!
    return Text('Sum: $sum');
  }
}

// ✅ GOOD - Compute once
class MyWidget extends StatelessWidget {
  final List<int> numbers;
  late final int sum = numbers.reduce((a, b) => a + b);

  @override
  Widget build(BuildContext context) {
    return Text('Sum: $sum');
  }
}
```

### 4. Don't Use `context` After Async Gap

```dart
// ❌ BAD - Context might be invalid after await
Future<void> login() async {
  await authService.login();
  Navigator.of(context).pushReplacement(...); // Might crash!
}

// ✅ GOOD - Check if mounted
Future<void> login() async {
  await authService.login();
  if (!mounted) return;
  Navigator.of(context).pushReplacement(...);
}

// ✅ ALSO GOOD - Use BuildContext extension
extension NavigationExtension on BuildContext {
  Future<void> pushAfterAsync(Widget page) async {
    if (!mounted) return;
    Navigator.of(this).push(MaterialPageRoute(builder: (_) => page));
  }
}
```

## 🤖 CI/CD Pipeline

A minimal GitHub Actions workflow that gives you fast, reliable feedback on every push:

```yaml
# .github/workflows/ci.yml
name: ci
on:
  push:
    branches: [main]
  pull_request:

jobs:
  flutter:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - uses: subosito/flutter-action@v2
        with:
          channel: stable
          cache: true

      - run: flutter pub get

      - name: Format check
        run: dart format --set-exit-if-changed .

      - name: Static analysis
        run: flutter analyze --fatal-infos

      - name: Tests with coverage
        run: flutter test --coverage

      - uses: codecov/codecov-action@v4
        with:
          files: coverage/lcov.info
          fail_ci_if_error: false

      - name: Verify Android build
        run: flutter build apk --debug --no-shrink

      - name: Verify iOS build (no signing)
        if: runner.os == 'macOS'
        run: flutter build ios --debug --no-codesign
```

**What this gives you:**
- ✅ Format violations fail the build (consistent style)
- ✅ Lint regressions fail the build
- ✅ Test regressions fail the build
- ✅ Coverage tracked over time via Codecov
- ✅ Catches build-breakers before merge

**Recommended additions when the project grows:**
- Golden test diff artifacts uploaded on failure (so you can inspect visual regressions in the PR UI)
- `melos` workspace orchestration if the repo splits into packages
- Fastlane-driven beta deploys to TestFlight + Play Internal Testing

## 🛠️ Development Tools

### 1. analysis_options.yaml

```yaml
include: package:flutter_lints/flutter.yaml

linter:
  rules:
    # Style
    - prefer_const_constructors
    - prefer_const_declarations
    - prefer_const_literals_to_create_immutables
    - prefer_final_fields
    - prefer_final_locals
    - always_declare_return_types
    - require_trailing_commas

    # Best Practices
    - avoid_print
    - avoid_unnecessary_containers
    - sized_box_for_whitespace
    - use_key_in_widget_constructors
    - prefer_is_empty
    - prefer_is_not_empty

    # Security
    - avoid_web_libraries_in_flutter

analyzer:
  errors:
    missing_required_param: error
    missing_return: error
  exclude:
    - "**/*.g.dart"
    - "**/*.freezed.dart"
```

### 2. VS Code Extensions

Essential extensions for Flutter development:
- **Dart**: Official Dart language support
- **Flutter**: Official Flutter support
- **Bloc**: Snippets for BLoC pattern
- **Pubspec Assist**: Easy dependency management
- **Flutter Intl**: Internationalization support
- **Error Lens**: Inline error messages
- **Better Comments**: Highlight important comments

### 3. Useful Scripts

```json
// package.json or Makefile
{
  "scripts": {
    "analyze": "flutter analyze",
    "format": "dart format .",
    "test": "flutter test",
    "build:android": "flutter build apk --release",
    "build:ios": "flutter build ios --release",
    "clean": "flutter clean && flutter pub get",
    "gen": "flutter pub run build_runner build --delete-conflicting-outputs"
  }
}
```

## 💡 Pro Tips

### 1. Use Code Snippets

Create custom snippets in VS Code for common patterns:

```json
// .vscode/flutter.code-snippets
{
  "Stateless Widget": {
    "prefix": "stl",
    "body": [
      "class ${1:WidgetName} extends StatelessWidget {",
      "  const ${1:WidgetName}({Key? key}) : super(key: key);",
      "",
      "  @override",
      "  Widget build(BuildContext context) {",
      "    return ${2:Container()};",
      "  }",
      "}"
    ]
  }
}
```

### 2. Hot Reload vs Hot Restart

- **Hot Reload (r)**: Fast, preserves state, updates UI changes
- **Hot Restart (R)**: Slower, resets state, rebuilds entire app

Use Hot Reload for UI changes, Hot Restart for:
- Changing `main()`
- Modifying global variables
- Updating enums
- Changing generic types

### 3. Performance Profiling

```dart
import 'dart:developer' as developer;

void expensiveOperation() {
  developer.Timeline.startSync('expensiveOperation');

  // Your expensive code here

  developer.Timeline.finishSync();
}

// View in DevTools Timeline
```

### 4. Build Flavors for Environments

```bash
# Create flavors for dev, staging, production
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor staging -t lib/main_staging.dart
flutter run --flavor production -t lib/main_production.dart
```

## 🔗 Related Notes

- [Flutter Architecture and Core Concepts](./flutter-architecture.md)
- [Flutter States and Lifecycle](./flutter-state-lifecycle.md)
- [Flutter Folder Best Practices](./flutter-folder-structure.md)

## 📚 Essential Resources

### Official Documentation
- [Flutter Best Practices](https://docs.flutter.dev/perf/best-practices)
- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Performance Best Practices](https://docs.flutter.dev/perf/best-practices)

### Community Resources
- [Flutter Community Medium](https://medium.com/flutter-community)
- [Awesome Flutter](https://github.com/Solido/awesome-flutter)
- [Flutter Examples](https://github.com/flutter/samples)

### Tools & Packages
- [Pub.dev](https://pub.dev/) - Package repository
- [Flutter Gems](https://fluttergems.dev/) - Curated packages
- [DevTools](https://docs.flutter.dev/development/tools/devtools/overview)

---

**Last Updated**: 2026-05-09
**Learning Project**: `/Users/alami/Documents/Learn/flutter/pin_offline_flutter`
**Reference Project**: [Sakinah Wallet](../../../plans/in-progress/00-overview.md) — sharia-finance Flutter app applying these conventions
**Focus**: Production-ready Flutter development practices
