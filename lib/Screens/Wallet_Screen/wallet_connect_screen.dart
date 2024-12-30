import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wokaa/Controller/wallet_connect_controller.dart';

class WalletConnectScreen extends StatelessWidget {
  final WalletConnectController walletController = Get.put(WalletConnectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Connect"),
        centerTitle: true,
      ),
      body: Obx(
            () => walletController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            const SizedBox(height: 20),
            if (walletController.connectedAccount.isNotEmpty)
              Column(
                children: [
                  Text(
                    "Connected Account: ${walletController.connectedAccount}",
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Balance: ${walletController.balance}",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            const SizedBox(height: 20),
            const Text(
              "Select a Wallet to Connect",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: walletController.wallets.length,
                itemBuilder: (context, index) {
                  final wallet = walletController.wallets[index];
                  return ListTile(
                    leading: Image.network(
                      wallet.icon,
                      width: 40,
                      height: 40,
                    ),
                    title: Text(wallet.name),
                    onTap: () => walletController.connectWallet(wallet),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (walletController.connectedAccount.isNotEmpty)
              ElevatedButton(
                onPressed: () {
                  walletController.disconnectWallet();
                },
                child: const Text("Disconnect Wallet"),
              ),
          ],
        ),
      ),
    );
  }
}
