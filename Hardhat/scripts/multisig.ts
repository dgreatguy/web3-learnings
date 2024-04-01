import { ethers } from "hardhat";

async function main() {
  const [Admin1, Admin2, Admin3, Admin4, Admin5, spender] =
    await ethers.getSigners();
  const Owners = [
    Admin1.address,
    Admin2.address,
    Admin3.address,
    Admin4.address,
    Admin5.address,
  ];

  const multisig = await ethers.deployContract("MultiSig", [Owners], {
    value: ethers.parseEther("10"),
  });
  await multisig.waitForDeployment();

  console.log(`Multisig  deployed to ${multisig.target}`);

  const amount = ethers.parseEther("5");

  const receipt = await multisig.createTransaction(amount, spender.address);

  const receipt2 = await multisig
    .connect(Admin2)
    .createTransaction(amount, spender.address);

  const receipt3 = await multisig
    .connect(Admin3)
    .createTransaction(amount, spender.address);

  const receipt4 = await multisig.createTransaction(amount, spender.address);

  const receipt5 = await multisig.createTransaction(amount, spender.address);

  //returns the event args
  //@ts-ignore
  console.log(await (await receipt.wait())?.logs[0]?.args[0]);

  await multisig.connect(Admin3).approveTransaction(1);
  let balancebefore = await ethers.provider.getBalance(spender.address);
  console.log(`balance before ${ethers.formatEther(balancebefore)}`);

  await multisig.connect(Admin2).approveTransaction(1);

  console.log(
    `Spender Balance ${ethers.formatEther(
      (await ethers.provider.getBalance(spender.address)) - balancebefore
    )}`
  );

  let [add, _amount, approval, isActive] = await multisig.getTransaction(1);
  console.log(
    add,
    ethers.formatEther(_amount),
    parseInt(String(approval)),
    isActive
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
