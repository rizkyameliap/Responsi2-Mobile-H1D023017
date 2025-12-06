import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsi2_mobile_paket1_h1d023017/models/inventaris_model.dart';
import 'package:responsi2_mobile_paket1_h1d023017/services/api_service.dart';
import 'package:responsi2_mobile_paket1_h1d023017/services/auth_service.dart';
import 'package:responsi2_mobile_paket1_h1d023017/screens/add_edit_screen.dart';
import 'package:responsi2_mobile_paket1_h1d023017/utils/constants.dart';
import 'package:responsi2_mobile_paket1_h1d023017/widgets/inventory_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Inventaris> _inventarisList = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadTokenAndData();
  }

  Future<void> _loadTokenAndData() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final token = await authService.getToken();
    if (token != null) {
      _apiService.setToken(token);
    }
    await _fetchInventaris();
  }

  Future<void> _fetchInventaris() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final response = await _apiService.get(AppConstants.inventarisEndpoint);
      final apiResponse = ApiResponse.fromJson(response);
      
      if (apiResponse.isSuccess) {
        if (apiResponse.data is List) {
          setState(() {
            _inventarisList = (apiResponse.data as List)
                .map((item) => Inventaris.fromJson(item))
                .toList();
          });
        } else {
          // For demo, show dummy data if API returns different structure
          _showDemoData();
        }
      } else {
        setState(() {
          _errorMessage = apiResponse.message;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Gagal memuat data: $e';
      });
      // Show demo data for testing
      _showDemoData();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDemoData() {
    // Demo data for testing
    setState(() {
      _inventarisList = [
        Inventaris(
          id: 1,
          userId: 1,
          nama: 'Laptop Asus ROG Zephyrus',
          harga: 25000000,
          jumlah: 3,
          tanggalMasuk: '2024-01-15',
        ),
        Inventaris(
          id: 2,
          userId: 1,
          nama: 'Mouse Wireless Logitech',
          harga: 350000,
          jumlah: 10,
          tanggalMasuk: '2024-01-16',
        ),
        Inventaris(
          id: 3,
          userId: 1,
          nama: 'Keyboard Mechanical',
          harga: 850000,
          jumlah: 5,
          tanggalMasuk: '2024-01-17',
        ),
        Inventaris(
          id: 4,
          userId: 1,
          nama: 'Monitor 24 inch',
          harga: 1800000,
          jumlah: 4,
          tanggalMasuk: '2024-01-18',
        ),
      ];
    });
  }

  Future<void> _deleteInventaris(int id) async {
    try {
      await _apiService.delete('${AppConstants.inventarisEndpoint}/$id');
      
      setState(() {
        _inventarisList.removeWhere((item) => item.id == id);
      });
      
      Fluttertoast.showToast(
        msg: 'Data berhasil dihapus',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Gagal menghapus data: $e',
        backgroundColor: Colors.red,
      );
    }
  }

  void _confirmDelete(int id, String nama) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Data'),
        content: Text('Yakin ingin menghapus "$nama"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteInventaris(id);
            },
            child: Text(
              'Hapus',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToAdd() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreen(),
      ),
    ).then((value) {
      if (value == true) {
        _fetchInventaris();
      }
    });
  }

  void _navigateToEdit(Inventaris inventaris) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddEditScreen(inventaris: inventaris),
      ),
    ).then((value) {
      if (value == true) {
        _fetchInventaris();
      }
    });
  }

  void _logout() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    await authService.logout();
    
    Navigator.pushReplacementNamed(context, '/login');
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Memuat data inventaris...'),
          ],
        ),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _fetchInventaris,
              child: Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (_inventarisList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
            SizedBox(height: 16),
            Text(
              'Belum ada data inventaris',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tekan tombol + untuk menambahkan data',
              style: TextStyle(color: Colors.grey[500]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchInventaris,
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: _inventarisList.length,
        itemBuilder: (context, index) {
          final inventaris = _inventarisList[index];
          return InventoryCard(
            inventaris: inventaris,
            onEdit: () => _navigateToEdit(inventaris),
            onDelete: () => _confirmDelete(inventaris.id, inventaris.nama),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Hitung total nilai inventaris
    final totalNilai = _inventarisList.fold<int>(
      0,
      (previousValue, element) => previousValue + element.totalNilai,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(AppConstants.homeAppBarTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchInventaris,
            tooltip: 'Refresh',
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _showLogoutDialog,
            tooltip: 'Logout',
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAdd,
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      bottomNavigationBar: _inventarisList.isNotEmpty
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Barang',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        '${_inventarisList.length} item',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Total Nilai',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      Text(
                        'Rp ${totalNilai.toString().replaceAllMapped(
                              RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                              (Match m) => '${m[1]}.',
                            )}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          : null,
    );
  }
}