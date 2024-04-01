import { ethers, network } from 'hardhat'

async function main() {
  let [admin1] = await ethers.getSigners()
  const amount = ethers.parseEther('1')
  const amount5 = ethers.parseEther('2')

  //   const FACTORY = '0x3c68027368aC1938926f1716AfFAC8A95dDa6267'
  await admin1.sendTransaction({
    to: '0x5832A489EA41Ea03882b1bCD00bdC35958F4e5C8',
    value: amount,
  })
  //   connect to the deployed factory contract using getContractAt
  //   const factory = await ethers.getContractAt('IFactory', FACTORY)
  //   // call the createMultisig function in the factory contract
  //   const receipt = await factory.createMultisig(
  //     [
  //       '0xb12d5059F46a41D82e435fDda8Dc4010d6281fF7',
  //       '0x6B0eA893B1d253bfeeB183eFF6AE6e6D40c7284D',
  //       '0xd8500DA651A2e472AD870cDf76B5756F9c113257',
  //       '0xaaec95f93550c8dB4521ad16Eee49A9b34632fA7',
  //       '0xdE449A556Db775CCBB09477ba81F95FFA4683759',
  //       '0xE03F2A5b69BFD890bf5aF88c8b2a73416fA3F9Af',
  //       '0xe13169f75F3ac186486131862eF89c668Cf57DE9',
  //       '0xC76F962e24F4345301296Bf111529047ec3cA96E',
  //     ],
  //     { value: amount }
  //   )
  //   get into the log database to get the newly created multisig address
  //   //@ts-ignore
  //   let newMultisig = (await receipt.wait())?.logs[0].args[0]
  ///////////////////////////////////////////////////////////////////////////////////////////
  //connect to the newly created multisig using getContractAt().
  const multisig = await ethers.getContractAt(
    'IMultisig',
    '0x5832A489EA41Ea03882b1bCD00bdC35958F4e5C8'
  )
  const impersonatedSigner = await ethers.getImpersonatedSigner(
    '0xb12d5059F46a41D82e435fDda8Dc4010d6281fF7'
  )

  const _spender = '0xdF3e18d64BC6A983f673Ab319CCaE4f1a57C7097'

  let arr = [
    '0xb12d5059F46a41D82e435fDda8Dc4010d6281fF7',
    '0x6B0eA893B1d253bfeeB183eFF6AE6e6D40c7284D',
    '0xd8500DA651A2e472AD870cDf76B5756F9c113257',
    '0xaaec95f93550c8dB4521ad16Eee49A9b34632fA7',
    '0xdE449A556Db775CCBB09477ba81F95FFA4683759',
    '0xE03F2A5b69BFD890bf5aF88c8b2a73416fA3F9Af',
    '0xe13169f75F3ac186486131862eF89c668Cf57DE9',
    '0xC76F962e24F4345301296Bf111529047ec3cA96E',
  ]
  await network.provider.send('hardhat_setBalance', [
    arr[1],
    '0xDE0B6B3A7640000',
  ])
  await network.provider.send('hardhat_setBalance', [
    arr[2],
    '0xDE0B6B3A7640000',
  ])

  await network.provider.send('hardhat_setBalance', [
    arr[3],
    '0xDE0B6B3A7640000',
  ])

  await network.provider.send('hardhat_setBalance', [
    arr[4],
    '0xDE0B6B3A7640000',
  ])
  await network.provider.send('hardhat_setBalance', [
    arr[5],
    '0xDE0B6B3A7640000',
  ])
  await network.provider.send('hardhat_setBalance', [
    arr[6],
    '0xDE0B6B3A7640000',
  ])
  await network.provider.send('hardhat_setBalance', [
    arr[7],
    '0xDE0B6B3A7640000',
  ])

  console.log(ethers.formatEther(1));
  // console.log(ethers.hexlify("1"));

  // console.log(
  //   await ethers.provider.getBalance(arr[1]),
  //   await ethers.provider.getBalance(arr[2]),
  //   await ethers.provider.getBalance(arr[3]),
  //   await ethers.provider.getBalance(arr[4]),
  //   await ethers.provider.getBalance(arr[5]),
  //   await ethers.provider.getBalance(arr[6]),
  //   await ethers.provider.getBalance(arr[7])
  // )

  await network.provider.send('hardhat_setBalance', [
    arr[1],
    '0xDE0B6B3A7640000',
  ])

  await network.provider.send('hardhat_setBalance', [
    arr[4],
    '0xDE0B6B3A7640000',
  ])

  //   await multisig
  //     .connect(impersonatedSigner)
  //     .createTransaction(amount5, _spender)
  //   let [spender1, _amount1, No1, status1] = await multisig.getTransaction(1)
  //   let [spender, _amount, No, status] = await multisig.getTransaction(2)
  //   let [spender3, _amount3, No3, status3] = await multisig.getTransaction(3)
  //   let [spender4, _amount4, No4, status4] = await multisig.getTransaction(4)
  let [spender5, _amount5, No5, status5] = await multisig.getTransaction(5)

  //   console.log(
  //     spender1,
  //     ethers.formatEther(_amount1),
  //     parseInt(String(No1)),
  //     status1
  //   )
  //   console.log(
  //     spender,
  //     ethers.formatEther(_amount),
  //     parseInt(String(No)),
  //     status
  //   )
  //   console.log(
  //     spender3,
  //     ethers.formatEther(_amount3),
  //     parseInt(String(No3)),
  //     status3
  //   )

  //   console.log(
  //     spender4,
  //     ethers.formatEther(_amount4),
  //     parseInt(String(No4)),
  //     status4
  //   )

  // hi
  // console.log(
  //   spender5,
  //   ethers.formatEther(_amount5),
  //   parseInt(String(No5)),
  //   status5
  // )

  //   //////////////////////////////////////////////////////////////////////////////

  const balanceBefore = await ethers.provider.getBalance(_spender)

  //hii
  // console.log(`spender balance before ${balanceBefore}`)

  //   // second approval
  //   const impersonatedSigner2 = await ethers.getImpersonatedSigner(
  //     '0xaaec95f93550c8dB4521ad16Eee49A9b34632fA7'
  //   )

  //   await multisig.connect(impersonatedSigner2).approveTransaction(5)

  //   // third approval
  //   const impersonatedSigner3 = await ethers.getImpersonatedSigner(
  //     '0xd8500DA651A2e472AD870cDf76B5756F9c113257'
  //   )

  //   await multisig.connect(impersonatedSigner3).approveTransaction(5)

  //   // fourth approval
  //   const impersonatedSigner4 = await ethers.getImpersonatedSigner(
  //     '0xe13169f75F3ac186486131862eF89c668Cf57DE9'
  //   )

  //   await multisig.connect(impersonatedSigner4).approveTransaction(5)
  //fifth approval
  const impersonatedSigner5 = await ethers.getImpersonatedSigner(
    '0xC76F962e24F4345301296Bf111529047ec3cA96E'
  )

  await multisig.connect(impersonatedSigner5).approveTransaction(5)

  let [spender5A, _amount5A, No5A, status5A] = await multisig.getTransaction(5)

  const balanceAfter = await ethers.provider.getBalance(_spender)

  // hiii
  // console.log(`spender balance After ${balanceAfter}`)

  //hiiii

  // console.log(
  //   ` The current state of transaction5 after all approval has been made ${spender5A},
  //         ${ethers.formatEther(_amount5A)},
  //         ${parseInt(String(No5A))},
  //         ${status5A}
  //       }`
  // )
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error)
  process.exitCode = 1
})