class SupportTicketBody {
  String? _type;
  String? _subject;
  String? _description;

  SupportTicketBody(String type, String subject, String description) {
    _type = type;
    _subject = subject;
    _description = description;
  }

  String? get type => _type;
  String? get subject => _subject;
  String? get description => _description;

  SupportTicketBody.fromJson(Map<String, dynamic> json) {
    _type = json['type'];
    _subject = json['subject'];
    _description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = _type;
    data['subject'] = _subject;
    data['description'] = _description;
    return data;
  }
}
