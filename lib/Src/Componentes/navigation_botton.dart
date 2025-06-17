import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeBottomNav extends StatefulWidget {
  const HomeBottomNav({super.key});

  @override
  State<HomeBottomNav> createState() => _HomeBottomNavState();
}

class _HomeBottomNavState extends State<HomeBottomNav> {
  int currentIndex = 0;

  final List<String> routes = ['/home', '/clientes', '/boletos', '/servicos'];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black, offset: const Offset(4, 4)),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              setState(() => currentIndex = index);
              context.go(routes[index]);
            },
            selectedItemColor: const Color.fromARGB(255, 206, 169, 255),
            unselectedItemColor: Colors.white,
            backgroundColor: Color.fromARGB(255, 44, 44, 44),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Clientes',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Orçamentos',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.messenger_sharp),
                label: 'Materiais',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
