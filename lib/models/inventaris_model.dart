class Inventaris {
  final int id;
  final int userId;
  final String nama;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Inventaris({
    required this.id,
    required this.userId,
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
    this.createdAt,
    this.updatedAt,
  });

  factory Inventaris.fromJson(Map<String, dynamic> json) {
    return Inventaris(
      id: json['id'] is String ? int.parse(json['id']) : json['id'],
      userId: json['user_id'] is String ? int.parse(json['user_id']) : json['user_id'],
      nama: json['nama'] ?? '',
      harga: json['harga'] is String ? int.parse(json['harga']) : json['harga'],
      jumlah: json['jumlah'] is String ? int.parse(json['jumlah']) : json['jumlah'],
      tanggalMasuk: json['tanggal_masuk'] ?? '',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
    };
  }

  // Format harga ke Rupiah
  String get formattedHarga {
    return 'Rp ${harga.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  // Total nilai (harga * jumlah)
  int get totalNilai {
    return harga * jumlah;
  }

  String get formattedTotalNilai {
    return 'Rp ${totalNilai.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }
}

class InventarisRequest {
  final String nama;
  final int harga;
  final int jumlah;
  final String tanggalMasuk;

  InventarisRequest({
    required this.nama,
    required this.harga,
    required this.jumlah,
    required this.tanggalMasuk,
  });

  Map<String, dynamic> toJson() {
    return {
      'nama': nama,
      'harga': harga,
      'jumlah': jumlah,
      'tanggal_masuk': tanggalMasuk,
    };
  }
}

class ApiResponse {
  final int status;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      status: json['status'] ?? 200,
      message: json['message'] ?? '',
      data: json['data'],
    );
  }

  bool get isSuccess => status >= 200 && status < 300;
}