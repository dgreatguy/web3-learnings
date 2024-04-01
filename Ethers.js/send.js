const ethers = require("ethers");
const provider = new ethers.providers.JsonRpcProvider(
  "_ALCHEMY MAINNET API KEY_"
);
const mnemonic = "_ENTER SEED PHRASE HERE_";
const walletMnemonic = ethers.Wallet.fromMnemonic(mnemonic);
console.log("wm", walletMnemonic);

async function send() {
  try {
    const ethAddress = "0x0489DB67c9B49C1C813da3C538103926f31BE572";
    const balanceWei = await provider.getBalance(ethAddress);
    const balanceEth = ethers.utils.formatEther(balanceWei);
    const wallet = await walletMnemonic.connect(provider);
    const extra = await wallet.getBalance();
    const extraBal = ethers.utils.formatEther(extra._hex);

    console.log("balanceEth:", balanceEth);
    console.log("extraBal:", extraBal);

    const tx = {
      to: "0x77aC3a62c12333DD9604f8D5cD6E350Cd33D04b4",
      value: ethers.utils.parseEther("0.1"),
    };
    const send = await wallet.sendTransaction(tx);
    console.log(send);

    // provider.send("eth_requestAccounts", [])
    // const signer = await provider.getSigner()
  } catch (err) {
    console.error("Error:", err.message);
  }
}

send();

async function check() {
  try {
    const trans = await provider.getTransaction(
      "0x98b04637910c67154c6acbdcdeead5c7870f232708b5d585e7349d3860c7a47b"
    );
    console.log(trans);
  } catch (err) {
    console.error("Error:", err.message);
  }
}

check();
// const bin = ethers.utils.parseEther("21000")
// console.log(bin._hex)
