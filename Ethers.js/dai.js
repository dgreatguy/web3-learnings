const {ethers} = require('ethers');

const daiContractAddress = '0x6b175474e89094c44da98b954eedeac495271d0f';
const provider = new ethers.providers.JsonRpcProvider('_ALCHEMY MAINNET API KEY_');

const daiAbi = [
  'function name() view returns (string)',
  'function symbol() view returns (string)',
  'function decimals() view returns (uint8)',
  'function totalSupply() view returns (uint256)',
  'function balanceOf(address) view returns (uint256)',
];

async function getTokenInfo() {
  const daiContract = new ethers.Contract(daiContractAddress, daiAbi, provider);

  const name = await daiContract.name();
  const symbol = await daiContract.symbol();
  const decimals = await daiContract.decimals();
  const totalSupply = await daiContract.totalSupply();

  return { name, symbol, decimals, totalSupply };
}

async function main() {
  try {
    const tokenInfo = await getTokenInfo();
    console.log('Token Name:', tokenInfo.name);
    console.log('Token Symbol:', tokenInfo.symbol);
    console.log('Token Decimals:', tokenInfo.decimals);
    console.log('Total Supply:', tokenInfo.totalSupply.toString());

    const address = '0x0489DB67c9B49C1C813da3C538103926f31BE572';
    const daiContract = new ethers.Contract(daiContractAddress, daiAbi, provider);
    const balance = await daiContract.balanceOf(address);
    const formattedBalance = ethers.utils.formatUnits(balance, tokenInfo.decimals);
    console.log(`Balance of ${address}:`, formattedBalance, tokenInfo.symbol);
  } catch (error) {
    console.error('Error:', error.message);
  }
}

main();
