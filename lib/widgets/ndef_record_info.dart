import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_scanner/extension/ui8_ext.dart';

import '../model/record.dart';

class NdefRecordInfo {
  const NdefRecordInfo(
      {required this.record, required this.title, required this.subtitle});

  final Record record;

  final String title;

  final String subtitle;

  static NdefRecordInfo fromNdef(NdefRecord records) {
    final record = Record.fromNdef(records);
    if (record is WellknownTextRecord) {
      return NdefRecordInfo(
        record: record,
        title: 'Wellknown Text',
        subtitle: record.text,
      );
    }
    if (record is WellknownUriRecord) {
      return NdefRecordInfo(
        record: record,
        title: 'Wellknown Uri',
        subtitle: '${record.uri}',
      );
    }
    if (record is MimeRecord) {
      return NdefRecordInfo(
        record: record,
        title: 'Mime',
        subtitle: '(${record.type}) ${record.dataString}',
      );
    }
    if (record is AbsoluteUriRecord) {
      return NdefRecordInfo(
        record: record,
        title: 'Absolute Uri',
        subtitle: '(${record.uriType}) ${record.payloadString}',
      );
    }
    if (record is ExternalRecord) {
      return NdefRecordInfo(
        record: record,
        title: 'External',
        subtitle: '(${record.domainType}) ${record.dataString}',
      );
    }
    if (record is UnsupportedRecord) {
      // more custom info from NdefRecord.
      if (records.typeNameFormat == NdefTypeNameFormat.empty) {
        return NdefRecordInfo(
          record: record,
          title: _typeNameFormatToString(record.record.typeNameFormat),
          subtitle: '-',
        );
      }
      return NdefRecordInfo(
        record: record,
        title: _typeNameFormatToString(record.record.typeNameFormat),
        subtitle:
            '(${record.record.type.toHexString()}) ${record.record.payload.toHexString()}',
      );
    }
    throw UnimplementedError();
  }
}

String _typeNameFormatToString(NdefTypeNameFormat format) {
  switch (format) {
    case NdefTypeNameFormat.empty:
      return 'Empty';
    case NdefTypeNameFormat.nfcWellknown:
      return 'NFC Wellknown';
    case NdefTypeNameFormat.media:
      return 'Media';
    case NdefTypeNameFormat.absoluteUri:
      return 'Absolute Uri';
    case NdefTypeNameFormat.nfcExternal:
      return 'NFC External';
    case NdefTypeNameFormat.unknown:
      return 'Unknown';
    case NdefTypeNameFormat.unchanged:
      return 'Unchanged';
  }
}
