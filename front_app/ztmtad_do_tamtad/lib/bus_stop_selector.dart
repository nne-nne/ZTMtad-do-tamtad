import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:ztmtad_do_tamtad/stop.dart';

class BusStopSelector extends StatelessWidget {
  final List<Stop> stops;
  final String title;
  final bool enabled;
  final void Function(String?)? onChanged;
  const BusStopSelector({
    super.key,
    required this.stops,
    required this.title,
    required this.onChanged,
    this.enabled = true,
  });

  List<String> prepareStopsItems(List<Stop> stops) {
    List<Stop> stopsForItems = [];
    for (Stop stop in stops) {
      if (stop.stopDesc != null && stop.nonpassenger == 0) {
        if (stopsForItems.where((e) => e.stopDesc == stop.stopDesc).isEmpty) {
          stopsForItems.add(stop);
        }
      }
    }
    stopsForItems.sort((a, b) => a.stopDesc!.compareTo(b.stopDesc!));
    return stopsForItems.map((e) => e.stopDesc!).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<String>(
      enabled: enabled,
      popupProps: const PopupProps.dialog(
        showSearchBox: true,
        showSelectedItems: true,
      ),
      items: prepareStopsItems(stops),
      dropdownDecoratorProps: DropDownDecoratorProps(
        dropdownSearchDecoration: InputDecoration(
          labelText: title,
        ),
      ),
      onChanged: onChanged,
      selectedItem: null,
    );
  }
}
