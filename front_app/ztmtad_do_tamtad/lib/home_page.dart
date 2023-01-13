import 'package:carousel_slider/carousel_slider.dart';
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
  String? stop1field;
  String? stop2field;

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
              const StopsLoadingIndicator(),
              collectingInput
                  ? Column(
                      children: [
                        const Text(
                          "OnlyTrams",
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.pinkAccent,
                              shadows: [
                                Shadow(
                                    offset: Offset(2.0, 2.0),
                                    color: Colors.pink)
                              ]),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                              height: 300.0,
                              padEnds: true,
                              autoPlay: true,
                              autoPlayInterval: const Duration(seconds: 2)),
                          items: [1, 2, 3, 4, 5].map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                    width: 250,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    child: Image.asset(
                                      'assets/images/tram$i.png',
                                      width: 150,
                                      height: 250,
                                    ));
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const Spacer(),
              Padding(
                padding: collectingInput
                    ? const EdgeInsets.all(10.0)
                    : const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, right: 10.0, top: 0.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "starting location",
                  enabled: collectingInput,
                  onChanged: (value) {
                    setState(() {
                      stop1field = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "target location",
                  enabled: collectingInput,
                  onChanged: (value) {
                    setState(() {
                      stop2field = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: collectingInput
                    ? const EdgeInsets.all(10.0)
                    : const EdgeInsets.all(5.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    collectingInput
                        ? ElevatedButton(
                            onPressed: () {
                              setState(() {
                                repository.collectPaths(
                                    stop1field ?? '', stop2field ?? '');
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
