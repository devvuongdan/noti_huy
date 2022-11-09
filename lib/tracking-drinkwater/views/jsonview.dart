import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_json_viewer/flutter_json_viewer.dart';
import 'package:settings/tracking-drinkwater/models/app_prefs.dart';
import 'package:intl/intl.dart';

import '../models/app_database_manager.dart';

class WidgetJson extends StatelessWidget {
  const WidgetJson({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            child: JsonViewer({
              'capacityChooserIndex': AppPrefs.instance.capacityChooserIndex,
              'target': AppPrefs.instance.target,
              'logs': AppPrefs.instance.logs
                  .map((e) => {
                        'datetime': DateFormat('dd/MM/yyyy').format(e.date),
                        'records': e.records
                            .map((e) => {
                                  'capacity': e.capacity,
                                  'time': e.time.format(context)
                                })
                            .toList()
                      })
                  .toList(),
            }),
            // child: FutureBuilder<List>(
            //     future: AppDatabaseManager.instance.fetchAll(),
            //     builder: (context, snapshot) {
            //       if (snapshot.data == null) return const SizedBox();
            //       return Column(
            //         mainAxisSize: MainAxisSize.min,
            //         children: snapshot.data!
            //             .map((e) => Padding(
            //                   padding: const EdgeInsets.all(12.0),
            //                   child: Text(
            //                     jsonEncode(e),
            //                     textAlign: TextAlign.center,
            //                   ),
            //                 ))
            //             .toList(),
            //       );
            //     }),
          ),
        ),
      ),
    );
  }
}
