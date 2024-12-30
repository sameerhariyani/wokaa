import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart' as Web3dart;
import 'package:wokaa/wallet_service.dart';

class WalletConnectController extends GetxController {
  final WalletService walletService = WalletService();
  RxBool isLoading = true.obs;
  RxList<Wallet> wallets = <Wallet>[].obs;
  RxString connectedAccount = ''.obs;
  RxString balance = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchWallets();
  }

  // Fetch Wallets
  void fetchWallets() async {
    try {
      isLoading.value = true;
      wallets.value = await walletService.fetchWallets();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch wallets: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Connect to a Wallet
  void connectWallet(Wallet wallet) async {
    try {
      final session = await walletService.connectWallet((uri) {
        Get.snackbar("Wallet URI", uri, duration: const Duration(seconds: 5));
      });

      if (session != null) {
        connectedAccount.value = session.accounts.first;
        Get.snackbar(
          "Wallet Connected",
          "Connected to ${wallet.name}",
          duration: const Duration(seconds: 5),
        );
        fetchBalance();
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to connect to ${wallet.name}: $e");
    }
  }

  // Disconnect Wallet
  void disconnectWallet() async {
    try {
      await walletService.disconnectWallet();
      connectedAccount.value = '';
      balance.value = '';
      Get.snackbar("Wallet Disconnected", "Successfully disconnected",
          duration: const Duration(seconds: 5));
    } catch (e) {
      Get.snackbar("Error", "Failed to disconnect wallet: $e");
    }
  }

  // Fetch Ethereum Balance
  void fetchBalance() async {
    if (connectedAccount.value.isEmpty) return;

    try {
      final accountBalance =
      await walletService.getBalance(connectedAccount.value);
      balance.value =
      "${accountBalance.getValueInUnit(Web3dart.EtherUnit.ether).toString()} ETH";
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch balance: $e");
    }
  }
}
