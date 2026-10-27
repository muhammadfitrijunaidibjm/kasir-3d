import 'package:flutter/material.dart';

void main() {
  runApp(const Kasir3DApp());
}

class Kasir3DApp extends StatelessWidget {
  const Kasir3DApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kasir 3D Serba Ada',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const MainCashierScreen(),
    );
  }
}

// ================= MODEL DATA =================
class MenuItem {
  String id;
  String category;
  String name;
  double price;

  MenuItem({
    required this.id,
    required this.category,
    required this.name,
    required this.price,
  });
}

class Customer {
  String id;
  String name;
  String phone;

  Customer({required this.id, required this.name, required this.phone});
}

class CartItem {
  final MenuItem item;
  int quantity;

  CartItem({required this.item, this.quantity = 1});
}

// ================= WIDGET TOMBOL 3D (TACTILE PUSH) =================
class Button3D extends StatefulWidget {
  final String label;
  final String? subLabel;
  final IconData? icon;
  final Color baseColor;
  final Color shadowColor;
  final VoidCallback onTap;
  final double height;

  const Button3D({
    Key? key,
    required this.label,
    this.subLabel,
    this.icon,
    required this.baseColor,
    required this.shadowColor,
    required this.onTap,
    this.height = 100,
  }) : super(key: key);

  @override
  State<Button3D> createState() => _Button3DState();
}

class _Button3DState extends State<Button3D> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double depth = 5.0;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 70),
        margin: EdgeInsets.only(
          top: _isPressed ? depth : 0,
          bottom: _isPressed ? 0 : depth,
        ),
        decoration: BoxDecoration(
          color: widget.baseColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.shadowColor,
                    offset: const Offset(0, depth),
                    blurRadius: 0,
                  ),
                ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.icon != null) ...[
              Icon(widget.icon, size: 32, color: Colors.white),
              const SizedBox(height: 6),
            ],
            Text(
              widget.label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (widget.subLabel != null)
              Text(
                widget.subLabel!,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }
}

// ================= LAYAR UTAMA KASIR =================
class MainCashierScreen extends StatefulWidget {
  const MainCashierScreen({Key? key}) : super(key: key);

  @override
  State<MainCashierScreen> createState() => _MainCashierScreenState();
}

class _MainCashierScreenState extends State<MainCashierScreen> {
  // DATA MASTER MENU AWAL (BISA DIEDIT/DITAMBAH)
  List<MenuItem> menuDatabase = [
    // 1. Galon
    MenuItem(id: '1', category: 'Galon', name: 'Refill 2 Liter', price: 2000),
    MenuItem(id: '2', category: 'Galon', name: 'Refill 5 Liter', price: 4000),
    MenuItem(id: '3', category: 'Galon', name: 'Refill 12 Liter', price: 8000),
    MenuItem(id: '4', category: 'Galon', name: 'Refill 15 Liter', price: 12000),
    MenuItem(id: '5', category: 'Galon', name: 'Refill 19 Liter', price: 16000),

    // 2. Jasa Galon
    MenuItem(id: '6', category: 'Jasa', name: 'Ambil Galon Kosong', price: 2000),
    MenuItem(id: '7', category: 'Jasa', name: 'Antar Galon Isi', price: 3000),
    MenuItem(id: '8', category: 'Jasa', name: 'Sewa Galon', price: 10000),

    // 3. Pulsa
    MenuItem(id: '9', category: 'Pulsa', name: 'Pulsa 5k', price: 7000),
    MenuItem(id: '10', category: 'Pulsa', name: 'Pulsa 10k', price: 12000),
    MenuItem(id: '11', category: 'Pulsa', name: 'Pulsa 15k', price: 17000),
    MenuItem(id: '12', category: 'Pulsa', name: 'Pulsa 20k', price: 22000),
    MenuItem(id: '13', category: 'Pulsa', name: 'Pulsa 25k', price: 27000),

    // 4. Token PLN
    MenuItem(id: '14', category: 'Token', name: 'Token 20k', price: 22500),
    MenuItem(id: '15', category: 'Token', name: 'Token 50k', price: 52500),
    MenuItem(id: '16', category: 'Token', name: 'Token 100k', price: 102500),

    // 5. Kuota
    MenuItem(id: '17', category: 'Kuota', name: 'Kuota 3 GB', price: 15000),
    MenuItem(id: '18', category: 'Kuota', name: 'Kuota 5 GB', price: 25000),
    MenuItem(id: '19', category: 'Kuota', name: 'Kuota 20 GB', price: 60000),

    // 6. Print
    MenuItem(id: '20', category: 'Print', name: 'Print 500', price: 500),
    MenuItem(id: '21', category: 'Print', name: 'Print 1k', price: 1000),
    MenuItem(id: '22', category: 'Print', name: 'Print 2k', price: 2000),
    MenuItem(id: '23', category: 'Print', name: 'Print 3k', price: 3000),
    MenuItem(id: '24', category: 'Print', name: 'Print 4k', price: 4000),
    MenuItem(id: '25', category: 'Print', name: 'Print 5k', price: 5000),

    // 7. Scan
    MenuItem(id: '26', category: 'Scan', name: 'Scan 2k', price: 2000),
    MenuItem(id: '27', category: 'Scan', name: 'Scan 3k', price: 3000),
    MenuItem(id: '28', category: 'Scan', name: 'Scan 4k', price: 4000),

    // 8. Edit
    MenuItem(id: '29', category: 'Edit', name: 'Edit Jasa 5k', price: 5000),
    MenuItem(id: '30', category: 'Edit', name: 'Edit Jasa 10k', price: 10000),
    MenuItem(id: '31', category: 'Edit', name: 'Edit Jasa 15k', price: 15000),
    MenuItem(id: '32', category: 'Edit', name: 'Edit Jasa 20k', price: 20000),
    MenuItem(id: '33', category: 'Edit', name: 'Edit Jasa 30k', price: 30000),
  ];

  // DATA MASTER PELANGGAN AWAL
  List<Customer> customerDatabase = [
    Customer(id: 'c1', name: 'Pelanggan Umum (Cash)', phone: '-'),
    Customer(id: 'c2', name: 'Pak Budi (RT 03)', phone: '081234567890'),
  ];

  Customer? selectedCustomer;
  List<CartItem> cart = [];

  @override
  void initState() {
    super.initState();
    selectedCustomer = customerDatabase.first;
  }

  double get totalPrice =>
      cart.fold(0, (sum, item) => sum + (item.item.price * item.quantity));

  void addToCart(MenuItem item) {
    setState(() {
      final index = cart.indexWhere((c) => c.item.id == item.id);
      if (index >= 0) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(item: item));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${item.name} dimasukkan ke keranjang!"),
        duration: const Duration(milliseconds: 600),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // DIALOG PEMILIHAN SUB-ITEM / VARIAN DENGAN TOMBOL 3D
  void showCategoryVariants(String categoryName, Color baseColor, Color shadowColor) {
    final items = menuDatabase.where((e) => e.category == categoryName).toList();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Pilih Varian: $categoryName",
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.indigo),
                    tooltip: "Tambah Menu Baru ke Kategori ini",
                    onPressed: () {
                      Navigator.pop(ctx);
                      showAddEditMenuDialog(category: categoryName);
                    },
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              if (items.isEmpty)
                const Center(child: Text("Belum ada menu di kategori ini."))
              else
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, idx) {
                    final itm = items[idx];
                    return Button3D(
                      label: itm.name,
                      subLabel: "Rp ${itm.price.toInt()}",
                      baseColor: baseColor,
                      shadowColor: shadowColor,
                      onTap: () {
                        Navigator.pop(ctx);
                        addToCart(itm);
                      },
                    );
                  },
                ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  // ================= CRUD: TAMBAH / EDIT MENU =================
  void showAddEditMenuDialog({MenuItem? existingItem, String? category}) {
    final nameCtrl = TextEditingController(text: existingItem?.name ?? '');
    final priceCtrl = TextEditingController(
        text: existingItem != null ? existingItem.price.toInt().toString() : '');
    String selectedCat = existingItem?.category ?? category ?? 'Galon';

    final categories = [
      'Galon', 'Jasa', 'Pulsa', 'Token', 'Kuota', 'Print', 'Scan', 'Edit'
    ];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingItem == null ? "Tambah Menu" : "Edit Menu"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: selectedCat,
                items: categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => selectedCat = v!,
                decoration: const InputDecoration(labelText: "Kategori"),
              ),
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Nama Menu / Varian"),
              ),
              TextField(
                controller: priceCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga (Rp)"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || priceCtrl.text.isEmpty) return;
              final price = double.tryParse(priceCtrl.text) ?? 0.0;
              setState(() {
                if (existingItem == null) {
                  menuDatabase.add(MenuItem(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    category: selectedCat,
                    name: nameCtrl.text,
                    price: price,
                  ));
                } else {
                  existingItem.category = selectedCat;
                  existingItem.name = nameCtrl.text;
                  existingItem.price = price;
                }
              });
              Navigator.pop(ctx);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ================= CRUD: KELOLA PELANGGAN =================
  void openCustomerManagement() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.7,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Daftar Pelanggan",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.person_add, color: Colors.indigo),
                      onPressed: () => showAddEditCustomerDialog(setModalState),
                    )
                  ],
                ),
                const Divider(),
                Expanded(
                  child: ListView.builder(
                    itemCount: customerDatabase.length,
                    itemBuilder: (context, idx) {
                      final c = customerDatabase[idx];
                      final isSelected = selectedCustomer?.id == c.id;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor:
                              isSelected ? Colors.indigo : Colors.grey[300],
                          child: Icon(Icons.person,
                              color: isSelected ? Colors.white : Colors.black54),
                        ),
                        title: Text(c.name,
                            style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text("HP: ${c.phone}"),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blueGrey),
                              onPressed: () => showAddEditCustomerDialog(
                                  setModalState,
                                  existingCust: c),
                            ),
                            if (customerDatabase.length > 1)
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setModalState(() {
                                    customerDatabase.removeWhere((el) => el.id == c.id);
                                    if (selectedCustomer?.id == c.id) {
                                      selectedCustomer = customerDatabase.first;
                                    }
                                  });
                                  setState(() {});
                                },
                              ),
                          ],
                        ),
                        onTap: () {
                          setState(() => selectedCustomer = c);
                          Navigator.pop(ctx);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void showAddEditCustomerDialog(void Function(void Function()) setModalState,
      {Customer? existingCust}) {
    final nameCtrl = TextEditingController(text: existingCust?.name ?? '');
    final phoneCtrl = TextEditingController(text: existingCust?.phone ?? '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(existingCust == null ? "Tambah Pelanggan" : "Edit Pelanggan"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Nama Lengkap"),
            ),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: "Nomor WhatsApp / HP"),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty) return;
              setState(() {
                if (existingCust == null) {
                  customerDatabase.add(Customer(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameCtrl.text,
                    phone: phoneCtrl.text.isEmpty ? '-' : phoneCtrl.text,
                  ));
                } else {
                  existingCust.name = nameCtrl.text;
                  existingCust.phone = phoneCtrl.text;
                }
              });
              setModalState(() {});
              Navigator.pop(ctx);
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  // ================= TAMPILAN KERANJANG KASIR =================
  void openCartSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setCartState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                "Pesanan: ${selectedCustomer?.name}",
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              Expanded(
                child: cart.isEmpty
                    ? const Center(child: Text("Keranjang kosong"))
                    : ListView.builder(
                        itemCount: cart.length,
                        itemBuilder: (context, idx) {
                          final item = cart[idx];
                          return ListTile(
                            title: Text(item.item.name),
                            subtitle: Text(
                                "Rp ${item.item.price.toInt()} x ${item.quantity}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setCartState(() {
                                      if (item.quantity > 1) {
                                        item.quantity--;
                                      } else {
                                        cart.removeAt(idx);
                                      }
                                    });
                                    setState(() {});
                                  },
                                ),
                                Text("${item.quantity}",
                                    style: const TextStyle(fontWeight: FontWeight.bold)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setCartState(() => item.quantity++);
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Total Bayar:",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text("Rp ${totalPrice.toInt()}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  icon: const Icon(Icons.check_circle),
                  label: const Text("SELESAIKAN TRANSAKSI",
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                  onPressed: cart.isEmpty
                      ? null
                      : () {
                          Navigator.pop(ctx);
                          showDialog(
                            context: context,
                            builder: (c) => AlertDialog(
                              title: const Text("Transaksi Berhasil!"),
                              content: Text(
                                  "Total: Rp ${totalPrice.toInt()}\nPelanggan: ${selectedCustomer?.name}"),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() => cart.clear());
                                    Navigator.pop(c);
                                  },
                                  child: const Text("Tutup & Baru"),
                                )
                              ],
                            ),
                          );
                        },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text("Kasir 3D Serba Ada",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.indigo[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.person_pin, color: Colors.white),
            tooltip: "Pilih / Kelola Pelanggan",
            onPressed: openCustomerManagement,
          ),
          IconButton(
            icon: const Icon(Icons.edit_note, color: Colors.white),
            tooltip: "Kelola / Tambah Menu",
            onPressed: () => showAddEditMenuDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // BAR INFORMASI PELANGGAN TERPILIH
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: Colors.indigo[50],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.person, color: Colors.indigo, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      "Pelanggan: ${selectedCustomer?.name}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: openCustomerManagement,
                  child: const Text("GANTI"),
                ),
              ],
            ),
          ),

          // GRID 8 TOMBOL KATEGORI 3D
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  Button3D(
                    label: "1. Galon Air",
                    subLabel: "Refill 2L - 19L",
                    icon: Icons.water_drop_rounded,
                    baseColor: const Color(0xFF0288D1),
                    shadowColor: const Color(0xFF01579B),
                    onTap: () => showCategoryVariants(
                        "Galon", const Color(0xFF0288D1), const Color(0xFF01579B)),
                  ),
                  Button3D(
                    label: "2. Jasa Galon",
                    subLabel: "Ambil, Antar, Sewa",
                    icon: Icons.delivery_dining_rounded,
                    baseColor: const Color(0xFF00897B),
                    shadowColor: const Color(0xFF004D40),
                    onTap: () => showCategoryVariants(
                        "Jasa", const Color(0xFF00897B), const Color(0xFF004D40)),
                  ),
                  Button3D(
                    label: "3. Pulsa HP",
                    subLabel: "5k s/d 25k+",
                    icon: Icons.phone_android_rounded,
                    baseColor: const Color(0xFFFB8C00),
                    shadowColor: const Color(0xFFE65100),
                    onTap: () => showCategoryVariants(
                        "Pulsa", const Color(0xFFFB8C00), const Color(0xFFE65100)),
                  ),
                  Button3D(
                    label: "4. Token PLN",
                    subLabel: "20k, 50k, 100k+",
                    icon: Icons.bolt_rounded,
                    baseColor: const Color(0xFFF9A825),
                    shadowColor: const Color(0xFFC43E00),
                    onTap: () => showCategoryVariants(
                        "Token", const Color(0xFFF9A825), const Color(0xFFC43E00)),
                  ),
                  Button3D(
                    label: "5. Paket Kuota",
                    subLabel: "3GB, 5GB, 20GB+",
                    icon: Icons.wifi_rounded,
                    baseColor: const Color(0xFF7E57C2),
                    shadowColor: const Color(0xFF4527A0),
                    onTap: () => showCategoryVariants(
                        "Kuota", const Color(0xFF7E57C2), const Color(0xFF4527A0)),
                  ),
                  Button3D(
                    label: "6. Print Dokumen",
                    subLabel: "500 s/d 5k",
                    icon: Icons.print_rounded,
                    baseColor: const Color(0xFF43A047),
                    shadowColor: const Color(0xFF1B5E20),
                    onTap: () => showCategoryVariants(
                        "Print", const Color(0xFF43A047), const Color(0xFF1B5E20)),
                  ),
                  Button3D(
                    label: "7. Scan Berkas",
                    subLabel: "2k, 3k, 4k",
                    icon: Icons.document_scanner_rounded,
                    baseColor: const Color(0xFFD81B60),
                    shadowColor: const Color(0xFF880E4F),
                    onTap: () => showCategoryVariants(
                        "Scan", const Color(0xFFD81B60), const Color(0xFF880E4F)),
                  ),
                  Button3D(
                    label: "8. Jasa Edit",
                    subLabel: "5k s/d 30k",
                    icon: Icons.edit_note_rounded,
                    baseColor: const Color(0xFF5E35B1),
                    shadowColor: const Color(0xFF311B92),
                    onTap: () => showCategoryVariants(
                        "Edit", const Color(0xFF5E35B1), const Color(0xFF311B92)),
                  ),
                ],
              ),
            ),
          ),

          // BAR TOTAL BAWAH DENGAN TOMBOL 3D KERANJANG
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                )
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total (${cart.length} item)",
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    Text(
                      "Rp ${totalPrice.toInt()}",
                      style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo),
                    ),
                  ],
                ),
                SizedBox(
                  width: 140,
                  child: Button3D(
                    label: "KERANJANG",
                    icon: Icons.shopping_cart,
                    baseColor: Colors.green[600]!,
                    shadowColor: Colors.green[900]!,
                    onTap: openCartSheet,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
