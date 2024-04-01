import { ethers, network } from "hardhat";

async function main() {
  const uniswapAddr = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";

  //   const ETH = "0xD76b5c2A23ef78368d8E34288B5b65D616B746aE";
  const WETH = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
  const USDT = "0xdAC17F958D2ee523a2206206994597C13D831ec7";

  const path = [WETH, USDT];
  const to = "0xd8500DA651A2e472AD870cDf76B5756F9c113257";
  const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  const deadline = currentTimestampInSeconds + 86400;
  const WETHHOLDER = "0xF04a5cC80B1E94C69B48f5ee68a08CD2F09A7c3E";

  const uniswap = await ethers.getContractAt("IUniswap", uniswapAddr);

  const usdtContract = await ethers.getContractAt("IERC20", USDT);

  const AmountOutMin = ethers.parseEther("0");

  await network.provider.send("hardhat_setBalance", [
    WETHHOLDER,
    "0x302F26AD93C439900",
  ]);

  const WETHSigner = await ethers.getImpersonatedSigner(WETHHOLDER);
  console.log(await usdtContract.balanceOf(to));

  //@ts-ignore
  await uniswap
    .connect(WETHSigner)
    .swapExactETHForTokens(AmountOutMin, path, to, deadline, {
      value: ethers.parseEther("10"),
    });
  console.log(await usdtContract.balanceOf(to));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

//   const UNI = "0x1f9840a85d5aF5bf1D1762F925BDADdC4201F984";
//   const DAI = "0x6B175474E89094C44Da98b954EedeAC495271d0F";
//   const UNIHOLDER = "0x47173B170C64d16393a52e6C480b3Ad8c302ba1e";
//   const uniContract = await ethers.getContractAt("IERC20", UNI);
//   const DAIContract = await ethers.getContractAt("IERC20", DAI);
//   const AmountOut = ethers.parseEther("1");
//   const AmountinMax = ethers.parseEther("5");

// const UNISigner = await ethers.getImpersonatedSigner(UNIHOLDER);
//   await uniContract.connect(UNISigner).approve(uniswapAddr, AmountinMax);
//   console.log(await DAIContract.balanceOf(to));

//   await uniswap
//     .connect(UNISigner)
//     .swapTokensForExactTokens(AmountOut, AmountinMax, path, to, deadline);
//   console.log(await DAIContract.balanceOf(to));
