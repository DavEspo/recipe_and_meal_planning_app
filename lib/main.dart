import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Login Screen'),
      // home: const RPage(title: 'L',)
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
  final FormKey = GlobalKey<FormState>();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Form(
        key: FormKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email"
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your email";
                    }
                    return null;
                  },
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: TextFormField(
                  controller: password,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password"
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter your password";
                    }
                    return null;
                  },
                )
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                child: Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (FormKey.currentState!.validate()) {
                        if (email.text == "1" && password.text == "1") {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomePage()
                            )
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Wrong username or password'
                            )
                          )
                        );
                      }
                    },
                    child: Text("Submit")
                  )
                )
              ),
            ],
          ),
        )
      )
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Screen"),
        centerTitle: true,
        backgroundColor: Colors.red
      ),
      body: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) {
                          return RecipeScreen();
                        }
                      )
                    );
                  },
                  child: Text(
                    "Recipe Screen",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25
                    ),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    fixedSize: Size(175,150),
                    backgroundColor: Colors.blue
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) {
                          return MealPlanScreen();
                        }
                      )
                    );
                  },
                  child: Text(
                    "Meal Plan Screen",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25
                    ),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    fixedSize: Size(175,150),
                    backgroundColor: Colors.purple
                  )
                ),
              ),
            ]
          ),
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) {
                          return FavoriteScreen();
                        }
                      )
                    );
                  },
                  child: Text(
                    "Favorite Screen",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25
                    ),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    fixedSize: Size(175,150),
                    backgroundColor: Colors.green
                  )
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context, MaterialPageRoute(
                        builder: (context) {
                          return SettingsScreen();
                        }
                      )
                    );
                  },
                  child: Text(
                    "Settings Screen",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25
                    ),
                    textAlign: TextAlign.center,
                  ),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                    ),
                    fixedSize: Size(175,150),
                    backgroundColor: Colors.orange
                  )
                ),
              ),
            ]
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Logout")
          ),
        ],
      )
    );
  }
}

class RecipeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipe Screen'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: ListView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          const ListTile(
            // leading: Icon(Icons.map),
            // trailing: IconButton(
            //   icon: Icon(Icons.add),
            //   onPressed: () {
                
            //   }
            // ),
            title: Text("Salad")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Sandwich")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Hamburger")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("HotDog")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Fish")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Shrimp")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Tacos")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Chicken Wings")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Rice")
          ),
          const ListTile(
            trailing: Icon(Icons.add),
            title: Text("Spaghetti")
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Back to Home Screen")
          )
        ],
      ),
          
      //   ],
      // ),
    );
  }
}

class MealPlanScreen extends StatelessWidget {
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
          // ListView.builder(
          //   itemBuilder: itemBuilder),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back to Home Screen")
          )
        ],
      ),
    );
  }
}

class FavoriteScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Screen'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back to Home Screen")
          )
        ],
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Screen'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Back to Home Screen")
          )
        ],
      ),
    );
  }
}