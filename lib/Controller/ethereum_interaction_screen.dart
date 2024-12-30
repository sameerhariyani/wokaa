import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'package:wokaa/Controller/wallet_connect_controller.dart';

class EthereumInteractionScreen extends StatelessWidget {
  final WalletConnectController walletController = Get.find();

  EthereumInteractionScreen({Key? key}) : super(key: key);

  final TextEditingController toAddressController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ethereum Interaction'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              final session = walletController.walletService.walletConnect.session;
              if (session == null) {
                return const Text(
                  "No active wallet session",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                );
              }
              return FutureBuilder(
                future: walletController.walletService.getBalance(session.accounts.first),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  }
                  final balance = snapshot.data;
                  return Text(
                    "Balance: ${balance!.getValueInUnit(EtherUnit.ether)} ETH",
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  );
                },
              );
            }),
            const SizedBox(height: 20),
            TextField(
              controller: toAddressController,
              decoration: const InputDecoration(
                labelText: 'Recipient Address',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: amountController,
              decoration: const InputDecoration(
                labelText: 'Amount (ETH)',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                try {
                  final privateKey = walletController.walletService.walletConnect.session?.accounts.first;
                  if (privateKey == null) {
                    Get.snackbar("Error", "Private key not found");
                    return;
                  }
                  final toAddress = toAddressController.text;
                  final amount = double.parse(amountController.text);

                  final txHash = await walletController.walletService
                      .sendTransaction(privateKey, toAddress, amount);

                  Get.snackbar("Transaction Success", "TxHash: $txHash");
                } catch (e) {
                  Get.snackbar("Error", "Failed to send transaction: $e");
                }
              },
              child: const Text('Send ETH'),
            ),
          ],
        ),
      ),
    );
  }
}
