import 'package:flutter/material.dart';
import 'package:greateplace/widgets/mapscreen.dart';
import 'package:provider/provider.dart';
import '../providers/great_places.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({Key? key}) : super(key: key);
  static const routeName = 'place-detail';

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments;
    final selctedPlace =
        Provider.of<greatPlaces>(context).findById(id.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text(selctedPlace.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 250,
              padding: const EdgeInsets.all(5),
              child: Image.file(
                selctedPlace.image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              selctedPlace.location.adress!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(
              height: 10,
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    fullscreenDialog: true,
                    builder: (ctx) => MapScreen(
                          initialLocalisation: selctedPlace.location,
                          isSelecting: false,
                        )));
              },
              child: const Text(
                'View on the map ',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
