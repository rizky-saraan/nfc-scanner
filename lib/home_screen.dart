import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';

import 'widgets/ndef_record_info.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ndefWidgets = <Widget>[];
  String? valueNfc = "";

  @override
  void initState() {
    super.initState();

    _startNfc();
  }

  void _startNfc() async {
    // Check availability
    bool isAvailable = await NfcManager.instance.isAvailable();

    if (isAvailable) {
      // Start Session
      NfcManager.instance.startSession(
        onDiscovered: (NfcTag tag) async {
          var ndef = Ndef.from(tag);
          if (ndef == null) {
            if (kDebugMode) {
              print('Tag is not compatible with NDEF');
            }
            return;
          }

          final cachedMessage = ndef.cachedMessage;
          if (cachedMessage != null) {
            for (var i in Iterable.generate(cachedMessage.records.length)) {
              final record = cachedMessage.records[i];
              final info = NdefRecordInfo.fromNdef(record);
              setState(() {
                valueNfc = info.subtitle;
              });
            }
          }
          //var record = ndef.cachedMessage?.records.first;

          NfcManager.instance.stopSession();
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NFC Scanner"),
      ),
      body: SafeArea(
        child: Center(
          child: Text(
            "ISI NFC $valueNfc",
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
