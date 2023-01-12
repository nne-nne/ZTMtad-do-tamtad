import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ztmtad_do_tamtad/stops_presentation.dart';
import 'package:ztmtad_do_tamtad/ztm_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ZTMRepository>(
      builder: (context, repository, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Gąsiorki"),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Robimy zajebistą apkę, tak trzymać',
                ),
                Text(
                  '69',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const Text("API:"),
                Text(repository.homeResponse ?? 'country roads take me home'),
                const StopsList(),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: DropdownSearch<String>(
                    popupProps: PopupProps.menu(
                      showSelectedItems: true,
                      disabledItemFn: (String s) => s.startsWith('I'),
                    ),
                    items: const [
                      "Brazil",
                      "Italia (Disabled)",
                      "Tunisia",
                      'Canada'
                    ],
                    dropdownDecoratorProps: const DropDownDecoratorProps(
                      dropdownSearchDecoration: InputDecoration(
                        labelText: "starting location",
                      ),
                    ),
                    onChanged: print,
                    selectedItem: "Brazil",
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    repository.getHome();
                  },
                  tooltip: 'xDDDD',
                  child: const Icon(Icons.home),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    repository.getStops();
                  },
                  tooltip: 'xD',
                  child: const Icon(Icons.tram),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
