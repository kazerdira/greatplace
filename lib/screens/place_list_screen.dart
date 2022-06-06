// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:greateplace/providers/great_places.dart';
import 'package:greateplace/screens/place_detail_screen.dart';
import 'package:provider/provider.dart';

import 'package:greateplace/screens/place_add_screen.dart';
import '../providers/great_places.dart';

class PlaceListScreen extends StatefulWidget {
  const PlaceListScreen({Key? key}) : super(key: key);

  @override
  State<PlaceListScreen> createState() => _PlaceListScreenState();
}

class _PlaceListScreenState extends State<PlaceListScreen> {
  final key = GlobalKey();
  void deletePlace(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Warning'),
        content: const Text('Are you sure you want delete the place '),
        elevation: 15,
        actions: [
          FlatButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text("no "),
          ),
          FlatButton(
            onPressed: () async {
              await Provider.of<greatPlaces>(context, listen: false)
                  .deletePlace(id)
                  .then((_) {
                //     setState(() {});
                Navigator.of(ctx).pop();
              });
            },
            child: const Text("yes"),
          ),
        ],
      ),
    );
  }

  Future<void> _refreshData(BuildContext context) async {
    await Provider.of<greatPlaces>(context, listen: false).setAndFetchPlaces();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('good places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(PlaceAddScreen.routeName);
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: FutureBuilder(
        future: _refreshData(context),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshData(context),
                child: Consumer<greatPlaces>(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey[200],
                          ),
                          child: const Center(
                            child: Text(
                              'no places yet , you should enter some !',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                              ),
                            ),
                          ),
                        ),
                        FlatButton.icon(
                          icon: const Icon(Icons.add),
                          color: Colors.grey[200],
                          splashColor: Colors.grey,
                          hoverColor: Colors.grey,
                          onPressed: () => Navigator.of(context)
                              .pushNamed(PlaceAddScreen.routeName),
                          label: const Text('Start adding now !'),
                        ),
                      ],
                    ),
                  ),
                  // ignore: avoid_types_as_parameter_names
                  builder: (ctx, GreatPlaces, ch) => GreatPlaces.item.isEmpty
                      ? ch!
                      : ListView.builder(
                          key: key,
                          itemCount: GreatPlaces.item.length,
                          itemBuilder: (ctx, i) => ListTile(
                            leading: CircleAvatar(
                              backgroundImage: FileImage(
                                GreatPlaces.item[i].image,
                              ),
                            ),
                            title: Text(
                              GreatPlaces.item[i].title,
                            ),
                            subtitle:
                                Text(GreatPlaces.item[i].location.adress!),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () =>
                                  deletePlace(GreatPlaces.item[i].id),
                            ),
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routeName,
                                  arguments: GreatPlaces.item[i].id);
                            },
                          ),
                        ),
                ),
              ),
      ),
    );
  }
}
