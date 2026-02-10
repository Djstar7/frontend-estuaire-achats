class Payment {
  final int? id;
  final int? orderId;
  final String? reference;
  final String? method;
  final String? status;
  final double? amount;
  final String? currency;
  final String? transactionId;
  final DateTime? paidAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Payment({
    this.id,
    this.orderId,
    this.reference,
    this.method,
    this.status,
    this.amount,
    this.currency,
    this.transactionId,
    this.paidAt,
    this.createdAt,
    this.updatedAt,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      orderId: json['order_id'],
      reference: json['reference'],
      method: json['method'],
      status: json['status'],
      amount: json['amount']?.toDouble(),
      currency: json['currency'],
      transactionId: json['transaction_id'],
      paidAt: json['paid_at'] != null ? DateTime.parse(json['paid_at']) : null,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'reference': reference,
      'method': method,
      'status': status,
      'amount': amount,
      'currency': currency,
      'transaction_id': transactionId,
      'paid_at': paidAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}