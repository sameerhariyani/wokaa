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
  final String rpcUrl = 'https://mainnet.infura.io/v3/YOUR_INFURA_PROJECT_ID'; // Replace with your Infura project ID

  WalletService() {
    initializeWalletConnect();
    web3client = Web3Client(rpcUrl, Client());
  }

  // Initialize WalletConnect
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

  // Fetch Wallets (simulate API or remote config)
  Future<List<Wallet>> fetchWallets() async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Wallet(
          name: "MetaMask",
          icon:
          "https://cdn.iconscout.com/icon/free/png-512/free-metamask-logo-icon-download-in-svg-png-gif-file-formats--browser-extension-chrome-logos-icons-2261817.png?f=webp&w=256"),
      Wallet(
          name: "Trust Wallet",
          icon: "https://cdn.iconscout.com/icon/premium/png-512-thumb/trust-wallet-token-twt-7152436-5795267.png?f=webp&w=256"),
      Wallet(
          name: "Rainbow",
          icon: "https://cdn.iconscout.com/icon/premium/png-512-thumb/rainbow-155-519991.png?f=webp&w=256"),
      Wallet(
          name: "Coinbase Wallet",
          icon: "https://cdn.iconscout.com/icon/free/png-512/free-coinbase-logo-icon-download-in-svg-png-gif-file-formats--bitcoin-cryptocurrency-blockchain-currency-social-media-company-logos-pack-icons-6297189.png?f=webp&w=256"),
    ];
  }

  // Create WalletConnect Session
  Future<SessionStatus> connectWallet(Function(String) onDisplayUri) async {
    try {
      final session = await walletConnect.createSession(onDisplayUri: onDisplayUri);
      return session;
    } catch (e) {
      throw Exception("Failed to create session: $e");
    }
  }

  // Disconnect Wallet
  Future<void> disconnectWallet() async {
    if (walletConnect.session != null) {
      await walletConnect.killSession();
    }
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
  Future<String> sendTransaction(
      String privateKey, String toAddress, double amount) async {
    try {
      // Convert private key to credentials
      final credentials = EthPrivateKey.fromHex(privateKey);
      final ethAddress = EthereumAddress.fromHex(toAddress);

      // Create and send the transaction
      final txHash = await web3client.sendTransaction(
        credentials,
        Transaction(
          to: ethAddress,
          value: EtherAmount.fromUnitAndValue(EtherUnit.ether, amount),
        ),
        chainId: 1, // Mainnet
      );

      return txHash; // Return the transaction hash
    } catch (e) {
      throw Exception("Failed to send transaction: $e");
    }
  }
}
