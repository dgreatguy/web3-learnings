const ethers = require("ethers");
let mnemonic = "_SEED PHRASE_";
let walletMnemonic = ethers.Wallet.fromMnemonic(mnemonic);

console.log(walletMnemonic.privateKey);
console.log(walletMnemonic.publicKey);
console.log(walletMnemonic.address);
console.log(walletMnemonic.mnemonic);
console.log(walletMnemonic);

walletPrivateKey = new ethers.Wallet(walletMnemonic.privateKey);
console.log(walletPrivateKey.address);

console.log(walletMnemonic.address === walletPrivateKey.address);

const value = ethers.utils.parseEther("2.0");
console.log(value);

// console.log(sign)

const provider = new ethers.providers.JsonRpcProvider(
  "_ALCHEMY GOERLI API KEY_"
);
// const wallet = ethers.Wallet.createRandom({ provider });
// console.log(wallet)

async function talk() {
  try {
    console.log("hey");
    const sign = await walletMnemonic.signMessage("Hello World");
    const sigh = await walletMnemonic.getAddress();
    console.log(sign, sigh);
    const ethAddress = "0x0489DB67c9B49C1C813da3C538103926f31BE572";
    const balanceWei = await provider.getBalance(ethAddress);
    console.log(balanceWei);
    const balanceEth = ethers.utils.formatEther(balanceWei);
    console.log(balanceEth);
    console.log("testy");
    const tx = {
      to: "0x8ba1f109551bD432803012645Ac136ddd64DBA72",
      value: ethers.utils.parseEther("0.1"),
    };
    const long = await walletMnemonic.signTransaction(tx);
    console.log(long, "long");
    console.log("Balance:", balanceEth);
    const wallet = await walletMnemonic.connect(provider);
    const extra = await wallet.getTransactionCount();
    const extra2 = await wallet.getBalance();
    console.log("Wallet:", extra2);
    const send = await wallet.sendTransaction(tx);
    console.log(send);
  } catch (error) {
    console.error("Error:", error.message);
  }

  console.log("test");
}

talk();

const { v, r, s } = ethers.utils.parseTransaction(word);
console.log({ v, r, s });
