const { ethers } = require('ethers');

async function sendAndConfirmTransaction() {
  const provider = new ethers.providers.JsonRpcProvider('PROVIDER_URL');
  const wallet = new ethers.Wallet('PRIVATE_KEY', provider);

  const toAddress = '0xRecipientAddress'; // Replace with the recipient's address
  const valueToSend = ethers.utils.parseEther('1.0'); // Send 1 Ether

  const transaction = {
    to: toAddress,
    value: valueToSend,
  };

  const tx = await wallet.sendTransaction(transaction);
  console.log('Transaction sent:', tx.hash);

  const receipt = await tx.wait();
  console.log('Transaction mined in block:', receipt.blockNumber);
  console.log('Gas used:', receipt.gasUsed.toString());
  console.log('Transaction status:', receipt.status === 1 ? 'Success' : 'Failed');
}

sendAndConfirmTransaction();

//for older version of ethers
//for new version, remove '.providers' and '.utils'
