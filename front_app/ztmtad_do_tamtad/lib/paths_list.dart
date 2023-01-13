import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ztmtad_do_tamtad/path.dart';

class PathsList extends StatefulWidget {
  final List<Path> paths;

  const PathsList({super.key, required this.paths});

  @override
  State<PathsList> createState() => _PathsListState();
}

class _PathsListState extends State<PathsList> {
  int? activePathIndex;

  onTap(int index) {
    setState(() {
      activePathIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: 300,
        child: ListView(
          children: widget.paths
              .map((e) => PathListTile(
                    path: e,
                    onTapCallback: onTap,
                    active: activePathIndex == widget.paths.indexOf(e),
                    index: widget.paths.indexOf(e),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class PathListTile extends StatelessWidget {
  final int index;
  final Path path;
  final bool active;
  final void Function(int) onTapCallback;
  const PathListTile({
    super.key,
    required this.path,
    required this.onTapCallback,
    required this.index,
    this.active = false,
  });

  IconData getIconData(RouteTypes rt) {
    switch (rt) {
      case RouteTypes.bus:
        return Icons.bus_alert_sharp;
      case RouteTypes.tram:
        return Icons.tram;
      case RouteTypes.ferry:
        return Icons.directions_ferry;
      case RouteTypes.train:
        return Icons.train;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = path.segments
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              children: [
                Icon(getIconData(e.routeType)),
                Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      color: Colors.grey),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(e.route),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
    List<Widget> childrenVertical = path.segments
        .map(
          (e) => Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
            child: Row(
              children: [
                Column(
                  children: [
                    Icon(getIconData(e.routeType)),
                    Container(
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(4.0)),
                          color: Colors.grey),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(e.route),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(e.stopDesc),
                ),
                const Spacer(),
                Column(
                  children: [
                    Text(DateFormat('kk:mm').format(e.departureTime)),
                    Text("${e.minutesLength} min")
                  ],
                ),
              ],
            ),
          ),
        )
        .toList();
    return active
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: childrenVertical),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "na miejscu: ${DateFormat("kk:mm").format(path.arrivalTime)}",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${path.totalMinutesLenght} min",
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider()
            ],
          )
        : InkWell(
            onTap: () {
              onTapCallback(index);
            },
            highlightColor: Colors.amber,
            child: Column(
              children: [
                Row(
                  children: [
                    Row(
                      children: children,
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "${path.totalMinutesLenght} min",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(),
              ],
            ),
          );
  }
}
