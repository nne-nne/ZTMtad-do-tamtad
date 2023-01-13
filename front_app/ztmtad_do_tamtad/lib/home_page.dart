import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ztmtad_do_tamtad/bus_stop_selector.dart';
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
            leading: const Icon(Icons.tram),
            title: const Text("ZTMtąd tam"),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const StopsList(),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "starting location",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "target location",
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
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
                      )),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
