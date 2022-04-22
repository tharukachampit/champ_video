class Caller {
  final String callerName;
  final String? photoUrl;

  Caller({
    required this.callerName,
    this.photoUrl,
  });

  Map<String, String> toJson() {
    return <String, String>{
      "callerName": callerName,
      "photoUrl": "$photoUrl",
    };
  }

  factory Caller.fromJson(Map<String, dynamic> json) {
    return Caller(
      callerName: json['callerName'] ?? 'Unknown',
      photoUrl: json['photoUrl'] ?? '',
    );
  }
}
