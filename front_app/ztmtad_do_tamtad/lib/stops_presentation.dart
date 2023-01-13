import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ztmtad_do_tamtad/ztm_repository.dart';

class StopsList extends StatelessWidget {
  const StopsList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ZTMRepository>(
      builder: (context, repository, child) {
        return repository.stopsResponse == null
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Center(
                        child: Column(
                      children: const [
                        CircularProgressIndicator(),
                        Text(
                          "loading bus stops...",
                        )
                      ],
                    )),
                  ),
                ],
              )
            : const SizedBox.shrink();
      },
    );
  }
}
