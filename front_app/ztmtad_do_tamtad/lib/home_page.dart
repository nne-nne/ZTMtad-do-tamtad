import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ztmtad_do_tamtad/bus_stop_selector.dart';
import 'package:ztmtad_do_tamtad/paths_list.dart';
import 'package:ztmtad_do_tamtad/stops_presentation.dart';
import 'package:ztmtad_do_tamtad/webservice.dart';
import 'package:ztmtad_do_tamtad/ztm_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool collectingInput = true;

  @override
  Widget build(BuildContext context) {
    return Consumer<ZTMRepository>(
      builder: (context, repository, child) {
        return Scaffold(
          appBar: AppBar(
            leading: const Icon(Icons.tram),
            title: const Text("ZTMtąd tam"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const StopsList(),
              Padding(
                padding: collectingInput
                    ? const EdgeInsets.all(10.0)
                    : const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, right: 10.0, top: 0.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "starting location",
                  enabled: collectingInput,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "target location",
                  enabled: collectingInput,
                ),
              ),
              Padding(
                padding: collectingInput
                    ? const EdgeInsets.all(50.0)
                    : const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    collectingInput
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                repository.getPaths();
                                collectingInput = false;
                              });
                            },
                            style: ButtonStyle(
                              elevation: const MaterialStatePropertyAll(8.0),
                              fixedSize:
                                  const MaterialStatePropertyAll(Size(150, 50)),
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0),
                                ),
                              ),
                            ),
                            child: const Center(
                              child: Text(
                                "szukaj",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              const Divider(),
              collectingInput
                  ? const SizedBox.shrink()
                  : Column(
                      children: [
                        SizedBox(
                          height: 280,
                          child: PathsList(paths: repository.paths),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(30.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    repository.clearPaths();
                                    collectingInput = true;
                                  });
                                },
                                style: ButtonStyle(
                                  elevation:
                                      const MaterialStatePropertyAll(8.0),
                                  fixedSize: const MaterialStatePropertyAll(
                                      Size(150, 50)),
                                  shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                  ),
                                ),
                                child: const Center(
                                  child: FittedBox(
                                    child: Text(
                                      "następna trasa",
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )
            ],
          ),
        );
      },
    );
  }
}
