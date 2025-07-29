import 'package:flutter/material.dart';
import 'package:islamibilgiler/screens/zikirmatik_sayac_screen.dart';

class ZikirmatikSecimScreen extends StatelessWidget {
  const ZikirmatikSecimScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tesbihat / Zikirmatik'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildSelectionCard(
              context,
              icon: Icons.mosque_outlined,
              title: 'Namaz Sonrası Tesbihatı',
              subtitle: 'Sübhanallah, Elhamdülillah, Allahu Ekber',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ZikirmatikSayacScreen(isSerbestZikir: false),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            _buildSelectionCard(
              context,
              icon: Icons.all_inclusive,
              title: 'Serbest Zikir',
              subtitle: 'Hedef olmadan, dilediğiniz kadar',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ZikirmatikSayacScreen(isSerbestZikir: true),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Tekrarlanan kart yapısı için yardımcı metot
  Widget _buildSelectionCard(BuildContext context, {required IconData icon, required String title, required String subtitle, required VoidCallback onTap}) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              Icon(icon, size: 60, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}