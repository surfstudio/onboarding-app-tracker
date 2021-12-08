/// Note model.
class Note {
  final String id;
  final String title;
  final DateTime? startDateTime;
  final DateTime? endDateTime;

  Duration? get noteDuration =>
      startDateTime == null ? null : endDateTime?.difference(startDateTime!);

  Note({
    required this.id,
    required this.title,
    required this.startDateTime,
    this.endDateTime,
  });

  Note.fromJson(Map<String, dynamic> json)
      : id = json['id'].toString(),
        title = json['title'].toString(),
        startDateTime = json['startTimestamp'] == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(
                (json['startTimestamp'] as int) * 1000,
              ),
        endDateTime = json['endTimestamp'] == null
            ? null
            : DateTime.fromMicrosecondsSinceEpoch(
                (json['endTimestamp'] as int) * 1000,
              );

  Note copyWith({
    String? id,
    String? title,
    DateTime? startDateTime,
    DateTime? endDateTime,
  }) =>
      Note(
        id: id ?? this.id,
        title: title ?? this.title,
        startDateTime: startDateTime ?? this.startDateTime,
        endDateTime: endDateTime ?? this.endDateTime,
      );

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'startTimestamp': startDateTime?.millisecondsSinceEpoch,
      'endTimestamp': endDateTime?.millisecondsSinceEpoch,
    };
  }
}
