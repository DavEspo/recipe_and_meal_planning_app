import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe & Meal Planning App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("By: David Espinosa and John Pham"),
        centerTitle: true,
        backgroundColor: Colors.grey,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Welcome to Recipe & Meal Planning Application",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SignupPage()),
                );
              },
              child: const Text("Sign Up"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(title: 'Login Screen'),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: const TextStyle(fontSize: 20),
                backgroundColor: Colors.grey,
              ),
              child: const Text("Go to Login"),
            ),
          ],
        ),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: email,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                  ),
                  validator: _validateInput,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: password,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                  ),
                  obscureText: true,
                  validator: _validateInput,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final userList = await dbHelper.fetchUser(email.text, password.text);
                        if (userList.isNotEmpty) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Wrong email or password')),
                          );
                        }
                      }
                    },
                    child: const Text("Submit"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return "This field cannot be empty";
    }
    return null;
  }
}

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final dbHelper = DatabaseHelper();

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      Map<String, dynamic> user = {
        DatabaseHelper.columnFirstName: _firstNameController.text,
        DatabaseHelper.columnLastName: _lastNameController.text,
        DatabaseHelper.columnEmail: _emailController.text,
        DatabaseHelper.columnPassword: _passwordController.text,
      };

      try {
        final id = await dbHelper.insertUser(user);
        if (id > 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Signup successful!')),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login Screen')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Error during signup.')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error: Could not sign up.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
                validator: _validateInput,
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
                validator: _validateInput,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: _validateInput,
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: _validateInput,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _signup,
                child: const Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
        backgroundColor: Colors.red,
        // Removed logout button from the AppBar
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Recipe()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(175, 150),
                    backgroundColor: Colors.blue, // Color for Recipe Screen
                  ),
                  child: const Text(
                    "Recipe Screen",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MealPlanScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(175, 150),
                    backgroundColor: Colors.green, // Color for Meal Planning Screen
                  ),
                  child: const Text(
                    "Meal Planning Screen",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
          // Add Favorite and Settings buttons in the same row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoriteScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(175, 150),
                    backgroundColor: Colors.orange, // Color for Favorite Screen
                  ),
                  child: const Text(
                    "Favorite Screen",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SettingsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(175, 150),
                    backgroundColor: Colors.purple, // Color for Settings Screen
                  ),
                  child: const Text(
                    "Settings Screen",
                    style: TextStyle(color: Colors.white, fontSize: 25),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Logout button
          ElevatedButton(
            onPressed: () {
              _logout(context);  // Call logout function
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red, // Logout button color
            ),
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }

  // Logout function to navigate back to the LoginPage
  void _logout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login Screen')),
    );
  }
}


const allMeals = [
  'Salad',
  'Sandwich',
  'Hamburger',
  'Hot Dog',
  'Fish',
  'Shrimp',
  'Tacos',
  'Chicken Wings',
  'Rice',
  'Spaghetti',
  'Chocolate Chip Cookies',
  'Broccoli',
  'Beef Stew',
  'Chicken Noodle Soup',
  'Beef Noodle Soup',
  'Pork Chops',
  'Scrambled Eggs',
  'Lasagna',
  'Mashed Potatoes',
  'Oatmeal'
];


class Recipe extends StatefulWidget {
  const Recipe({super.key});

  @override
  State<Recipe> createState() => RecipeScreen();
}

class RecipeScreen extends State<Recipe> {
  // RecipeScreen({super.key});
  List<String> Meals = allMeals;
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Screen'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body:Column(
        // mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 16, 16, 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Book Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.blue)
                )
              ),
              onChanged: searchBook,
            )
          ),
          Expanded(
            child: ListView.builder(
              itemCount: Meals.length,
              itemBuilder: (context, index) {
                final Meal = Meals[index];
                return ListTile(
                  title: _buildRecipeTile(context, Meal),
                  onTap: () {}
                );
              }
            ),
          ),
        ]
      )
    );
  }

  void searchBook(String query) {
    final suggestions = allMeals.where((Meal) {
      final MealShown = Meal.toLowerCase();
      final input = query.toLowerCase();

      return MealShown.contains(input);
    }).toList();

    setState(() => Meals = suggestions);
  }

  // Helper method to create a recipe tile
  Widget _buildRecipeTile(BuildContext context, String recipeName) {
    return ListTile(
      title: Text(recipeName),
      trailing: IconButton(
        icon: const Icon(Icons.add),
        onPressed: () {
          FavoritesManager.addFavorite(recipeName);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('$recipeName added to favorites!')),
          );
        },
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  List<String> searchResults= [
    'Brazil',
    'China',
    'Mexico',
    'Venezuela'
  ];
  
  @override
  Widget? buildLeading(BuildContext context) => IconButton(
    icon: const Icon(Icons.arrow_back),
    onPressed: () => close(context, null)
  );

  @override
  List<Widget>? buildActions(BuildContext context) => [
    IconButton(
      icon: Icon(Icons.clear),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = '';
        }
      },
    )
  ];

  @override
  Widget buildResults(BuildContext context) => Center(
    child: Text(
      query,
      style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold)
    ),
  );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = searchResults.where((searchResult) {
      final result = searchResult.toLowerCase();
      final input = query.toLowerCase();
      return result.contains(input);
    }).toList();
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        return ListTile(
          title: Text(suggestion),
          onTap: () {
            query = suggestion;
            showResults(context);
          },
        );
      }
    );
  }
}


class MealPlanScreen extends StatelessWidget {
  const MealPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meal Plan Screen'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: _buildDaySections(context),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back to Home Screen"),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDaySections(BuildContext context) {
    List<Widget> daySections = [];
    const daysOfWeek = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'];

    for (String day in daysOfWeek) {
      daySections.add(_buildDaySection(day, context));
    }
    return daySections;
  }

  Widget _buildDaySection(String day, BuildContext context) {
    List<String> mealPlanRecipes = MealPlanManager.getMealPlan(day);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        children: [
          ListTile(
            title: Text(day, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            subtitle: Text('Meals for $day'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: mealPlanRecipes.isNotEmpty
                  ? mealPlanRecipes.map((recipe) {
                      return ListTile(
                        title: Text(recipe),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () {
                            MealPlanManager.removeFromMealPlan(day, recipe);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('$recipe removed from $day meal plan!')),
                            );
                          },
                        ),
                      );
                    }).toList()
                  : [const Text('No recipes added for this day.')],
            ),
          ),
        ],
      ),
    );
  }
}



class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  String? selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Recipes'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          DropdownButton<String>(
            hint: const Text('Select a Day'),
            value: selectedDay,
            onChanged: (String? newValue) {
              setState(() {
                selectedDay = newValue;
              });
            },
            items: <String>[
              'Sunday',
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ElevatedButton(
            onPressed: () {
              if (selectedDay != null) {
                for (String recipe in FavoritesManager.favorites) {
                  // Example: adding all favorites to the selected day
                  MealPlanManager.addToMealPlan(selectedDay!, recipe);
                }
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to $selectedDay Meal Plan')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please select a day')),
                );
              }
            },
            child: const Text('Add to Meal Plan'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: FavoritesManager.favorites.length,
              itemBuilder: (context, index) {
                final recipe = FavoritesManager.favorites[index];
                return ListTile(
                  title: Text(recipe),
                  trailing: IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      FavoritesManager.removeFavorite(recipe);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$recipe removed from favorites!')),
                      );
                      setState(() {}); // Refresh the screen after removing the item
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Screen'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: SizedBox.expand(
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back to Home Screen"),
          ),
          SizedBox(height: 20), // Adding some space
          ElevatedButton(
            onPressed: () async {
              // Call the logout functionality
              await DatabaseHelper().logoutUser(); // Implement in DatabaseHelper
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WelcomePage()), // Navigate to login screen
              );
            },
            child: Text("DELETE ACCOUNT"),
          ),
        ],
      ),)
    );
  }
}


class FavoritesManager { //This manages list of saved recipe to favorites(Recipe to Fav)
  static final List<String> _favorites = [];

  static List<String> get favorites => _favorites;

  static void addFavorite(String recipe) {
    if (!_favorites.contains(recipe)) {
      _favorites.add(recipe);
    }
  }

  static void removeFavorite(String recipe) {
    _favorites.remove(recipe);
  }
}

class MealPlanManager {//this manages Fvorite Screen to Meal Plan Screen 
  static final Map<String, List<String>> _mealPlans = {
    'Sunday': [],
    'Monday': [],
    'Tuesday': [],
    'Wednesday': [],
    'Thursday': [],
    'Friday': [],
    'Saturday': [],
  };

  static List<String> getMealPlan(String day) {
    return _mealPlans[day] ?? [];
  }

  static void addToMealPlan(String day, String recipe) {
    if (_mealPlans[day] != null && !_mealPlans[day]!.contains(recipe)) {
      _mealPlans[day]!.add(recipe);
    }
  }

  static void removeFromMealPlan(String day, String recipe) {
    _mealPlans[day]?.remove(recipe);
  }
}
