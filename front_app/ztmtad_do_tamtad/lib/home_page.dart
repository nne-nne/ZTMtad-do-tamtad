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
          backgroundColor: Color.fromARGB(255, 250, 250, 228),
          appBar: AppBar(
            leading: const Icon(Icons.tram),
            title: const Text("ZTMtąd tam"),
            backgroundColor: Color.fromRGBO(46, 80, 144, 1.0),
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              const StopsLoadingIndicator(),
              collectingInput
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              "Only",
                              style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 18, 29, 29),
                              ),
                            ),
                            Text(
                              "Trams",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Marguerite',
                                color: Color.fromRGBO(0, 209, 209, 1),
                              ),
                            ),
                          ],
                        ),
                        repository.stops.isNotEmpty
                            ? CarouselSlider(
                                options: CarouselOptions(
                                    height: 290.0,
                                    padEnds: true,
                                    autoPlay: true,
                                    autoPlayInterval:
                                        const Duration(seconds: 2)),
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
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  : const SizedBox.shrink(),
              const Spacer(),
              Padding(
                padding: collectingInput
                    ? const EdgeInsets.all(8.0)
                    : const EdgeInsets.only(
                        left: 10.0, bottom: 10.0, right: 10.0, top: 0.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "starting location",
                  enabled: collectingInput,
                  selectedItem: stop1field,
                  onChanged: (value) {
                    setState(() {
                      stop1field = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: BusStopSelector(
                  stops: repository.stops,
                  title: "target location",
                  enabled: collectingInput,
                  selectedItem: stop2field,
                  onChanged: (value) {
                    setState(() {
                      stop2field = value;
                    });
                  },
                ),
              ),
              repository.stops.isNotEmpty
                  ? Padding(
                      padding: collectingInput
                          ? const EdgeInsets.all(8.0)
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
                                    backgroundColor: MaterialStatePropertyAll(
                                        Color.fromRGBO(46, 80, 144, 1.0)),
                                    elevation:
                                        const MaterialStatePropertyAll(8.0),
                                    fixedSize: const MaterialStatePropertyAll(
                                        Size(150, 50)),
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(25.0),
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
                    )
                  : const SizedBox.shrink(),
              const Divider(),
              collectingInput
                  ? const SizedBox.shrink()
                  : repository.loading
                      ? const CircularProgressIndicator()
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
                                      backgroundColor: MaterialStatePropertyAll(
                                          Color.fromRGBO(46, 80, 144, 1.0)),
                                      elevation:
                                          const MaterialStatePropertyAll(8.0),
                                      fixedSize: const MaterialStatePropertyAll(
                                          Size(150, 50)),
                                      shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25.0),
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
