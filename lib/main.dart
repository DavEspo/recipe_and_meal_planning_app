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
      home: const WelcomePage(),
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
        children: [
          SizedBox(
            height: 5
          ),
          SizedBox(
            width: 400,
            child: Text(
              '  Click on Meal to view Recipe',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.left,
            )
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 5, 16, 16),
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    searchBook('');
                  }
                ),
                hintText: 'Find Meal',
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
                return Container(
                  child: _buildRecipeTile(context, Meal),
                  decoration: BoxDecoration(
                    border: Border.all(width: .05)
                  )
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
      onTap: () {
        if (recipeName == 'Salad') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Salad()),
          );
        } else if (recipeName == 'Sandwich') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Sandwich()),
          );
        } else if (recipeName == 'Hamburger') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Hamburger()),
          );
        } else if (recipeName == 'Hot Dog') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HotDog()),
          );
        } else if (recipeName == 'Fish') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Fish()),
          );
        } else if (recipeName == 'Shrimp') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Shrimp()),
          );
        } else if (recipeName == 'Tacos') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Tacos()),
          );
        } else if (recipeName == 'Chicken Wings') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChickenWings()),
          );
        } else if (recipeName == 'Rice') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Rice()),
          );
        } else if (recipeName == 'Spaghetti') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Spaghetti()),
          );
        } else if (recipeName == 'Chocolate Chip Cookies') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChocolateChipCookies()),
          );
        } else if (recipeName == 'Broccoli') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Broccoli()),
          );
        } else if (recipeName == 'Beef Stew') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BeefStew()),
          );
        } else if (recipeName == 'Chicken Noodle Soup') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChickenNoodleSoup()),
          );
        } else if (recipeName == 'Beef Noodle Soup') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BeefNoodleSoup()),
          );
        } else if (recipeName == 'Pork Chops') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PorkChops()),
          );
        } else if (recipeName == 'Scrambled Eggs') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScrambledEggs()),
          );
        } else if (recipeName == 'Lasagna') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Lasagna()),
          );
        } else if (recipeName == 'Mashed Potatoes') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MashedPotatoes()),
          );
        } else if (recipeName == 'Oatmeal') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Oatmeal()),
          );
        }
      },
    );
  }
}


class Salad extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Salad'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Salad.jpeg'),
          Text('-Add lots of Lettuce.', style: TextStyle(fontSize: 25)),
          Text('-Add some Spinach.', style: TextStyle(fontSize: 25)),
          Text('-Add some Onions.', style: TextStyle(fontSize: 25)),
          Text('-Add some Tomatoes.', style: TextStyle(fontSize: 25)),
          Text('-Add some Grilled Chicken.', style: TextStyle(fontSize: 25)),
          Text('-Add some Croutons.', style: TextStyle(fontSize: 25)),
          Text('-Add some Dressing.', style: TextStyle(fontSize: 25)),
          Text('-Mix it all.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}


class Sandwich extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Sandwich'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Sandwich.jpg'),
          Text('-Grab 2 slices of sandwich breads.', style: TextStyle(fontSize: 25)),
          Text('-Add a little bit of mayonese on both \n breads', style: TextStyle(fontSize: 25)),
          Text('-Put a slice of cheese on one of the \n breads.', style: TextStyle(fontSize: 25)),
          Text('-Put a slice of ham on top of the \n cheese.', style: TextStyle(fontSize: 25)),
          Text('-Add some lettuce on top of the \n ham.', style: TextStyle(fontSize: 25)),
          Text('-Cook a medium piece of chicken \n (either fried or grilled).', style: TextStyle(fontSize: 25)),
          Text('-Add the chicken to the sandwich \n and put the other bread on it as \n well.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Hamburger extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Hamburger'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Hamburger.jpeg', width: 400, height: 200, alignment: Alignment.center,),
          Text('-Grab 2 pieces of Hamburger Bread.', style: TextStyle(fontSize: 25)),
          Text('-Add some mayonese on both \n pieces of bread.', style: TextStyle(fontSize: 25)),
          Text('-Put both pieces of bread on the \n grill.', style: TextStyle(fontSize: 25)),
          Text('-Put a big piece of meat on the grill \n and let it cook for a while.', style: TextStyle(fontSize: 25)),
          Text('-Take everything out of the grill.', style: TextStyle(fontSize: 25)),
          Text('-Add the meat between the 2 pieces \n of bread.', style: TextStyle(fontSize: 25)),
          Text('-Add lettuce, onions, tomato, \n mustard, and ketchup on the meat.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class HotDog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Hot Dog'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/HotDog.jpg'),
          Text('-Grab a piece of Hot Dog bread and \n put it on the grill.', style: TextStyle(fontSize: 25)),
          Text('-Put a sausage on the grill and let it \n cook for a good minute.', style: TextStyle(fontSize: 25)),
          Text('-Grab the bread and put some \n mayonese on it.', style: TextStyle(fontSize: 25)),
          Text('-Put the sausage in the bread.', style: TextStyle(fontSize: 25)),
          Text('-Put ketchup, mustard, little pieces \n of onions, and little pieces of \n tomatoes on the Hot Dog.', style: TextStyle(fontSize: 25)),
        ],
      )
    );
  }
}

class Fish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Fish'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Fish.jpg'),
          Text('-Put a pan on the stove and scrub \n some button on the pan.', style: TextStyle(fontSize: 25)),
          Text('-Put some oil on the pan.', style: TextStyle(fontSize: 25)),
          Text('-Add the fish on the pan and let it \n cook for a minute.', style: TextStyle(fontSize: 25)),
          Text('-While the fish is cooking, add some \n onion powder, garlic powder, black \n pepper, and salt.', style: TextStyle(fontSize: 25)),
          Text('-Take the fish out of the pan and it\'s \n ready.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Shrimp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Shrimp'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Shrimp.jpg'),
          Text('-Peel the shrimp.', style: TextStyle(fontSize: 25)),
          Text('-Grab a pan and add some butter \n and oil on it.', style: TextStyle(fontSize: 25)),
          Text('-Add the shrimp to the pan and let it \n cook.', style: TextStyle(fontSize: 25)),
          Text('-While the shrimp is cooking, add \n some onion powder, garlic powder, \n black pepper, and salt.', style: TextStyle(fontSize: 25)),
          Text('-Take the shrimp out of the pan and \n it\'s ready.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Tacos extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Tacos'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Tacos.jpg'),
          Text('-Grab a pan and put some oil on it.', style: TextStyle(fontSize: 25)),
          Text('-Grab some tortillas and place them \n on the pan.', style: TextStyle(fontSize: 25)),
          Text('-Let the tortillas heat up.', style: TextStyle(fontSize: 25)),
          Text('-In the meantime, marinate some \n meat.', style: TextStyle(fontSize: 25)),
          Text('-Cook the marinated meat.', style: TextStyle(fontSize: 25)),
          Text('-Take the tortillas out of the pan and \n add the meat to them.', style: TextStyle(fontSize: 25)),
          Text('-Add onions, cilantro, and any sauce \n of your choice to the tacos.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class ChickenWings extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Chicken Wings'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/ChickenWings.jpg'),
          Text('-Get a pot and put it on a fire.', style: TextStyle(fontSize: 25)),
          Text('-Add lots of oil, water, and salt to \n the pot.', style: TextStyle(fontSize: 25)),
          Text('-Put the wings in the pot and let it \n sit there for a good minute.', style: TextStyle(fontSize: 25)),
          Text('-Take the wings out of the pot and \n marinate them whichever flavor of \n your choice.', style: TextStyle(fontSize: 25)),
          Text('-Put the wings back in the pot.', style: TextStyle(fontSize: 25)),
          Text('-Take the wings out and they\'re \n ready.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Rice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Rice'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Rice.jpg'),
          Text('-Add rice to a pot.', style: TextStyle(fontSize: 25)),
          Text('-Add water to the pot until it fills up.', style: TextStyle(fontSize: 25)),
          Text('-Rinse out the pot.', style: TextStyle(fontSize: 25)),
          Text('-Now put roughly the same amount \n of water as rice in the pot.', style: TextStyle(fontSize: 25)),
          Text('-Cover the pot and put it in the stove \n and let it boil.', style: TextStyle(fontSize: 25)),
          Text('-Turn off the stove, open the pot, \n and move the rice around.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Spaghetti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Spaghetti'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Spaghetti.jpg'),
          Text('-Heat up some oil in a large pot.', style: TextStyle(fontSize: 25)),
          Text('-Add the meat and cook it.', style: TextStyle(fontSize: 25)),
          Text('-Add onions and cook them.', style: TextStyle(fontSize: 25)),
          Text('-Add garlic, tomato paste, oregano, \n and red pepper flakes and stir it.', style: TextStyle(fontSize: 25)),
          Text('-Stir some tomatoes with a little bit \n of salt.', style: TextStyle(fontSize: 25)),
          Text('-Toss the pasta into the pot.', style: TextStyle(fontSize: 25)),
          Text('-Take the pasta with the meat and \n sauce out of the pot.', style: TextStyle(fontSize: 25)),
          Text('-Add some parmesan cheese on top \n of the pasta.', style: TextStyle(fontSize: 25)),
        ],
      )
    );
  }
}

class ChocolateChipCookies extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Chocolate Chip Cookies'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/ChocolateChipCookies.jpg', width: 400, height: 150, alignment: Alignment.center,),
          Text('-Put flour, baking soda, cornstarch, \n and salt in a large bowl and mix it.', style: TextStyle(fontSize: 25)),
          Text('-Grab a different medium bowl and \n mix some butter, sugar, egg, and \n vanilla.', style: TextStyle(fontSize: 25)),
          Text('-Add chocolate chips to the medium \n bowl and mix a little.', style: TextStyle(fontSize: 25)),
          Text('-Combine both bowls and mix.', style: TextStyle(fontSize: 25)),
          Text('-Put the bowl with everything in the \n fridge for 2 hours.', style: TextStyle(fontSize: 25)),
          Text('-Take the bowl out and grab the \n dough and roll little balls of dough.', style: TextStyle(fontSize: 25)),
          Text('-Press the dough balls to make the \n form of a cookie. Place these in a \n sheet pan.', style: TextStyle(fontSize: 25)),
          Text('-Put the sheet pan in the oven to \n bake the cookies.', style: TextStyle(fontSize: 25)),
          Text('-Take the sheet pan out of the oven.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Broccoli extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Broccoli'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Broccoli.webp'),
          Text('-Cut the broccoli into little pieces.', style: TextStyle(fontSize: 25)),
          Text('-Put the broccoli pieces into a sheet \n pan.', style: TextStyle(fontSize: 25)),
          Text('-Place the sheet pan into the oven \n to bake the broccoli.', style: TextStyle(fontSize: 25)),
          Text('-Take the sheet pan out of the oven.', style: TextStyle(fontSize: 25)),
          Text('-Add a little bit of oil and lemon \n juice on the broccoli.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class BeefStew extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Beef Stew'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/BeefStew.avif'),
          Text('-Mix flour, garlic powder, salt, \n pepper, and beef.', style: TextStyle(fontSize: 25)),
          Text('-Add oil into a pot and cook the beef \n and onions in there.', style: TextStyle(fontSize: 25)),
          Text('-Add carrots, celery, and red wine to \n the pot and mix it.', style: TextStyle(fontSize: 25)),
          Text('-Mix cornstarch with water and \n slowly add it to the boiling stew \n pot.', style: TextStyle(fontSize: 25)),
          Text('-Stir in peas in the pot and add salt \n and pepper.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class ChickenNoodleSoup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Chicken Noodle Soup'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/ChickenNoodleSoup.avif'),
          Text('-Add butter, diced celery and carrots \n to a pot and cook it.', style: TextStyle(fontSize: 25)),
          Text('-Them add garlic to the pot and \n keep cooking.', style: TextStyle(fontSize: 25)),
          Text('-Add chicken stock, red pepper, and \n salt to the pot.', style: TextStyle(fontSize: 25)),
          Text('-Add broth to the pot and let it boil.', style: TextStyle(fontSize: 25)),
          Text('-Add noodles to the pot and remove \n them once they\'re cooked just a \n little.', style: TextStyle(fontSize: 25)),
          Text('-Add chicken meat to the pot and let \n it cook.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class BeefNoodleSoup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Beef Noodle Soup'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/BeefNoodleSoup.webp', width: 400, height: 350, alignment: Alignment.center,),
          Text('-Add oil and mushrooms in a pot.', style: TextStyle(fontSize: 25)),
          Text('-Cut meat into small pieces and add \n it to the pot.', style: TextStyle(fontSize: 25)),
          Text('-Add wine to the pot.', style: TextStyle(fontSize: 25)),
          Text('-Add butter, onions, carrots, and \n celery to the pot and cook it for a \n little bit.', style: TextStyle(fontSize: 25)),
          Text('-Add garlic and soup seasoning.', style: TextStyle(fontSize: 25)),
          Text('-Then add beef broth and let the pot \n boil.', style: TextStyle(fontSize: 25)),
          Text('-Let the pot cool down and then \n serve.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class PorkChops extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Pork Chops'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/PorkChops.webp'),
          Text('-Season Pork Chops with salt.', style: TextStyle(fontSize: 25)),
          Text('-Mix flour, chili powder, garlic \n powder, onion powder, smoked \n paprika, and black pepper in a \n small bowl.', style: TextStyle(fontSize: 25)),
          Text('-Dry the pork chops.', style: TextStyle(fontSize: 25)),
          Text('-Heat oil in a skillet and add the \n pork chops.', style: TextStyle(fontSize: 25)),
          Text('-Take the pork chops out and they\'re \n ready to eat.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class ScrambledEggs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Scrambled Eggs'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/ScrambledEggs.jpg'),
          Text('-Put a skillet on the stove.', style: TextStyle(fontSize: 25)),
          Text('-Crack the eggs into a bowl and add \n milk.', style: TextStyle(fontSize: 25)),
          Text('-Add a little oil and butter to the \n skillet.', style: TextStyle(fontSize: 25)),
          Text('-Put the eggs in the skillet and mix.', style: TextStyle(fontSize: 25)),
          Text('-Take the eggs out of the skilled and \n serve.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Lasagna extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Lasagna'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Lasagna.jpg'),
          Text('-Cook ground beef and sausage.', style: TextStyle(fontSize: 25)),
          Text('-Boil large pot of salted pasta water.', style: TextStyle(fontSize: 25)),
          Text('-Spread some meat sauce on the \n bottom of a casserole dish.', style: TextStyle(fontSize: 25)),
          Text('-Spread ricotta cheese over the \n noodles.', style: TextStyle(fontSize: 25)),
          Text('-Top with more noodles, ricotta \n cheese, and meat sauce.', style: TextStyle(fontSize: 25)),
          Text('-Repeat the previous step again.', style: TextStyle(fontSize: 25)),
          Text('-Top with Mozzarella cheese.', style: TextStyle(fontSize: 25)),
          Text('-Bake in the oven.', style: TextStyle(fontSize: 25)),
          Text('-Take the lasagna out of the oven. \n It\'s ready to eat.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class MashedPotatoes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Mashed Potatoes'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/MashedPotatoes.jpg'),
          Text('-Cut the potatoes.', style: TextStyle(fontSize: 25)),
          Text('-Boil the potatoes.', style: TextStyle(fontSize: 25)),
          Text('-Prepare your melted butter mixture.', style: TextStyle(fontSize: 25)),
          Text('-Pan-dry the potatoes.', style: TextStyle(fontSize: 25)),
          Text('-Mash the potatoes. ', style: TextStyle(fontSize: 25)),
          Text('-Stir everything together.', style: TextStyle(fontSize: 25)),
          Text('-Taste and season.', style: TextStyle(fontSize: 25)),
          Text('-Serve warm.', style: TextStyle(fontSize: 25))
        ],
      )
    );
  }
}

class Oatmeal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe for Oatmeal'),
        backgroundColor: const Color.fromARGB(255, 4, 242, 198),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset('Assets/Oatmeal.jpg', width: 400, height: 350, alignment: Alignment.center,),
          Text('-Put oats, water, and salt in a \n microwave bowl.', style: TextStyle(fontSize: 25)),
          Text('-Heat in the microwave for 90 \n seconds.', style: TextStyle(fontSize: 25)),
          Text('-Add milk to the oatmeal and stir.', style: TextStyle(fontSize: 25))
        ],
      )
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
