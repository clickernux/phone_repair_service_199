class Ussd {
  final String service;
  final String code;

  Ussd({required this.service, required this.code});

  factory Ussd.fromJson(Map<String, dynamic> json) {
    return Ussd(service: json['service'], code: json['code']);
  }
}
