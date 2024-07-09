import 'package:flutter/material.dart';
import 'package:myapp/add_item_dialog.dart';

import 'menu_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<MenuItem>> menu;
  late Future<MenuEquivalent> menuEquivalent;
  late List<RecipeItem> recipe;
  @override
  void initState() {
    super.initState();
    menu = getMenuData();
    menuEquivalent = getEquivalentMenu(menu);
    recipe = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      floatingActionButton: FutureBuilder(
        future: menuEquivalent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              onPressed: () async {
                RecipeItem item =
                    await addMenuItemDialog(context, snapshot.data!, null);
                recipe.add(item);
                print(item.toJson());
                setState(() {});
              },
              tooltip: "Add item",
              child: const Icon(Icons.add),
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      body: FutureBuilder(
        future: menuEquivalent,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final MenuEquivalent menuData = snapshot.data!;
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: recipe.length + 1,
                    itemBuilder: (context, index) {
                      if (index < recipe.length) {
                        return ListTile(
                          onTap: () async {
                            RecipeItem item = await addMenuItemDialog(
                                context, snapshot.data!, recipe[index]);
                            ;
                            setState(() {
                              recipe[index] = item;
                            });
                          },
                          title: Text(
                              "${recipe[index].menuItemName} (${recipe[index].varientName})"),
                          subtitle: recipe[index].extras.isNotEmpty
                              ? Text(recipe[index].extras.join(", "))
                              : null,
                          trailing: Text(
                            recipe[index].getPrice(menuData).toString() +
                                (recipe[index].notes == null
                                    ? ""
                                    : "\n${recipe[index].notes}"),
                            style: const TextStyle(fontSize: 15),
                          ),
                        );
                      } else if (index == recipe.length) {
                        return ListTile(
                          title: Text("Total"),
                          trailing: Text(
                              style: const TextStyle(fontSize: 15),
                              recipe
                                  .fold(
                                    0.0,
                                    (sum, element) =>
                                        sum + element.getPrice(menuData),
                                  )
                                  .toString()),
                        );
                      } else {
                        showDialog(
                          context: context,
                          builder: (context) => const AlertDialog(
                            content: Text("Unexpected error"),
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
