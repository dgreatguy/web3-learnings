import { ethers } from "hardhat";

async function main() {
  let [admin1, admin2] = await ethers.getSigners();
  let amount = ethers.parseEther("1");

  const multisigfactory = await ethers.deployContract("MultiSigFactory", []);

  await multisigfactory.waitForDeployment();

  console.log(`Multisig  deployed to ${multisigfactory.target}`);

  //   let receipt = await multisigfactory.createMultisig(Owners, {
  //     value: ethers.parseEther('200'),
  //   })

  //   let receipt2 = await multisigfactory.createMultisig(Owners, {
  //     value: ethers.parseEther('100'),
  //   })

  //   //@ts-ignore
  //   let newMultisig = (await receipt.wait())?.logs[0].args[0]
  //   //@ts-ignore
  //   let newMultisig2 = (await receipt2.wait())?.logs[0].args[0]
  //   console.log(newMultisig, newMultisig2)
  //   //connect the newMultisig address to the Imultisig interface
  //   let multisigContract = await ethers.getContractAt('IMultisig', newMultisig)

  //   await multisigContract.createTransaction(amount, spender.address)
  //   console.log(await multisigContract.getTransaction(1))
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
