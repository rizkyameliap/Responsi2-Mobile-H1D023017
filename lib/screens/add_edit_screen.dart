import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:responsi2_mobile_paket1_h1d023017/models/inventaris_model.dart';
import 'package:responsi2_mobile_paket1_h1d023017/services/api_service.dart';
import 'package:responsi2_mobile_paket1_h1d023017/utils/constants.dart';

class AddEditScreen extends StatefulWidget {
  final Inventaris? inventaris;

  AddEditScreen({this.inventaris});

  @override
  _AddEditScreenState createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _jumlahController = TextEditingController();
  final _tanggalController = TextEditingController();
  
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  bool _isEditMode = false;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _isEditMode = widget.inventaris != null;
    
    if (_isEditMode && widget.inventaris != null) {
      final inventaris = widget.inventaris!;
      _namaController.text = inventaris.nama;
      _hargaController.text = inventaris.harga.toString();
      _jumlahController.text = inventaris.jumlah.toString();
      _tanggalController.text = inventaris.tanggalMasuk;
      _selectedDate = DateTime.parse(inventaris.tanggalMasuk);
    } else {
      // Set default date to today
      _selectedDate = DateTime.now();
      _tanggalController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _jumlahController.dispose();
    _tanggalController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.grey[800],
            colorScheme: ColorScheme.light(primary: Colors.grey[800]!),
            buttonTheme: ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _tanggalController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveInventaris() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final request = InventarisRequest(
          nama: _namaController.text.trim(),
          harga: int.parse(_hargaController.text),
          jumlah: int.parse(_jumlahController.text),
          tanggalMasuk: _tanggalController.text,
        );

        if (_isEditMode && widget.inventaris != null) {
          // Update existing
          await _apiService.put(
            '${AppConstants.inventarisEndpoint}/${widget.inventaris!.id}',
            request.toJson(),
          );
          
          Fluttertoast.showToast(
            msg: 'Data berhasil diperbarui',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          // Create new
          await _apiService.post(
            AppConstants.inventarisEndpoint,
            request.toJson(),
          );
          
          Fluttertoast.showToast(
            msg: 'Data berhasil ditambahkan',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }

        Navigator.pop(context, true); // Return success
      } catch (e) {
        Fluttertoast.showToast(
          msg: 'Gagal menyimpan data: $e',
          backgroundColor: Colors.red,
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String? _validateHarga(String? value) {
    if (value == null || value.isEmpty) {
      return 'Harga harus diisi';
    }
    final harga = int.tryParse(value);
    if (harga == null) {
      return 'Harga harus berupa angka';
    }
    if (harga <= 0) {
      return 'Harga harus lebih dari 0';
    }
    return null;
  }

  String? _validateJumlah(String? value) {
    if (value == null || value.isEmpty) {
      return 'Jumlah harus diisi';
    }
    final jumlah = int.tryParse(value);
    if (jumlah == null) {
      return 'Jumlah harus berupa angka';
    }
    if (jumlah <= 0) {
      return 'Jumlah harus lebih dari 0';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditMode 
            ? AppConstants.editAppBarTitle 
            : AppConstants.addAppBarTitle,
        ),
        actions: [
          if (_isEditMode)
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                // Delete functionality would be handled in parent
                Navigator.pop(context);
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Icon
              Icon(
                _isEditMode ? Icons.edit : Icons.add_circle_outline,
                size: 60,
                color: Theme.of(context).primaryColor,
              ),
              SizedBox(height: 16),
              Text(
                _isEditMode ? 'Edit Data Inventaris' : 'Tambah Data Inventaris',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40),

              // Nama Barang
              Text(
                'Nama Barang *',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _namaController,
                decoration: InputDecoration(
                  hintText: 'Contoh: Laptop Asus ROG',
                  prefixIcon: Icon(Icons.computer),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama barang harus diisi';
                  }
                  if (value.length < 3) {
                    return 'Nama barang minimal 3 karakter';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),

              // Harga
              Text(
                'Harga (Rp) *',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _hargaController,
                decoration: InputDecoration(
                  hintText: 'Contoh: 15000000',
                  prefixIcon: Icon(Icons.attach_money),
                  suffixText: 'Rp',
                ),
                keyboardType: TextInputType.number,
                validator: _validateHarga,
              ),
              SizedBox(height: 20),

              // Jumlah
              Text(
                'Jumlah (unit) *',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _jumlahController,
                decoration: InputDecoration(
                  hintText: 'Contoh: 5',
                  prefixIcon: Icon(Icons.inventory_2),
                  suffixText: 'unit',
                ),
                keyboardType: TextInputType.number,
                validator: _validateJumlah,
              ),
              SizedBox(height: 20),

              // Tanggal Masuk
              Text(
                'Tanggal Masuk *',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: _tanggalController,
                decoration: InputDecoration(
                  hintText: 'YYYY-MM-DD',
                  prefixIcon: Icon(Icons.calendar_today),
                  suffixIcon: IconButton(
                    icon: Icon(Icons.date_range),
                    onPressed: _selectDate,
                  ),
                ),
                readOnly: true,
                onTap: _selectDate,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Tanggal masuk harus diisi';
                  }
                  return null;
                },
              ),
              SizedBox(height: 30),

              // Info format tanggal
              Card(
                color: Colors.blueGrey[50],
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      Icon(Icons.info, size: 20, color: Colors.blueGrey),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Format tanggal: YYYY-MM-DD (Contoh: 2024-01-20)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blueGrey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30),

              // Save Button
              ElevatedButton(
                onPressed: _isLoading ? null : _saveInventaris,
                child: _isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isEditMode ? 'UPDATE DATA' : 'SIMPAN DATA',
                        style: TextStyle(fontSize: 16),
                      ),
              ),
              SizedBox(height: 20),

              // Cancel Button
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: Text('BATAL'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}