import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

class Wallet {
  final String name;
  final String icon;

  Wallet({required this.name, required this.icon});
}

class WalletService {
  late WalletConnect walletConnect;
  late Web3Client web3client;
  final String rpcUrl = 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID';

  WalletService() {
    initializeWalletConnect();
    web3client = Web3Client(rpcUrl, Client());
  }

  void initializeWalletConnect() {
    walletConnect = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: "Web3 Wallet Connect",
        description: "A demo app to connect to wallets",
        url: "https://walletconnect.org",
        icons: [
          "https://walletconnect.org/walletconnect-logo.png",
        ],
      ),
    );
  }

  // Fetch Ethereum Account Balance
  Future<EtherAmount> getBalance(String address) async {
    try {
      final ethAddress = EthereumAddress.fromHex(address);
      return await web3client.getBalance(ethAddress);
    } catch (e) {
      throw Exception("Failed to fetch balance: $e");
    }
  }

  // Send Transaction
  Future<String> sendTransaction(String privateKey, String toAddress, double amount) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final ethAddress = EthereumAddress.fromHex(toAddress);

      final transactionHash = await web3client.sendTransaction(
        credentials,
        Transaction(
          to: ethAddress,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
        ),
        chainId: 1, // Mainnet
      );

      return transactionHash;
    } catch (e) {
      throw Exception("Failed to send transaction: $e");
    }
  }
}
