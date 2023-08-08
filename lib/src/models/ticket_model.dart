import 'dart:convert';

TicketModel ticketModelFromJson(String str) =>
    TicketModel.fromJson(json.decode(str));

String ticketModelToJson(TicketModel data) => json.encode(data.toJson());

class TicketModel {
  TicketModel({
    required this.ticketId,
    required this.tripId,
    required this.userId,
    required this.qrUrl,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  String ticketId;
  String tripId;
  String userId;
  String qrUrl;
  bool status;
  DateTime createdAt;
  DateTime updatedAt;

  factory TicketModel.fromJson(Map<String, dynamic> json) => TicketModel(
        ticketId: json["ticket_id"],
        tripId: json["trip_id"],
        userId: json["user_id"],
        qrUrl: json["qrUrl"],
        status: json["status"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "ticket_id": ticketId,
        "trip_id": tripId,
        "user_id": userId,
        "qrUrl": qrUrl,
        "status": status,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
