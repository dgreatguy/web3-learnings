import { HardhatUserConfig } from "hardhat/types";
import "@nomicfoundation/hardhat-toolbox";
import "dotenv/config";
require("dotenv").config();

const config: HardhatUserConfig = {
  solidity: "0.8.19",
  networks: {
    base: {
      url: process.env.BASERPC,
      // @ts-ignore
      accounts: [process.env.PRIVATEKEY],
    },
    hardhat: {
      forking: {
        // @ts-ignore
        url: process.env.URL,
      },
    },
  },
  etherscan: {
    apiKey: process.env.BASE_API_KEY,
  },
};

export default config;
