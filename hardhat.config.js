require("@nomiclabs/hardhat-waffle");

// This is a sample Hardhat task. To learn how to create your own go to
// https://hardhat.org/guides/create-task.html
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});


const MATICVGIL_API_KEY="6bb7f377537cc2af48fb68b86d67ca9f5a612500";

const ALCHEMY_API_KEY="d8ad98b476b7464b9537a95b15f58cbd";
const GOERLI_PRIVATE_KEY="1192b468aa27ddecfc965bd43a97999ef1a3a43f7aeebdc35659ea7d9d76bebe";
module.exports = {
  solidity: "0.8.4",

  networks:{
    goerli:{
      url:`https://goerli.infura.io/v3/${ALCHEMY_API_KEY}`,
      accounts:[`${GOERLI_PRIVATE_KEY}`]
    },

    matic:{
      url:`https://rpc-mumbai.maticvigil.com/v1/${MATICVGIL_API_KEY}`,
      accounts:[`${GOERLI_PRIVATE_KEY}`]

    },

    binance: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      accounts:[`${GOERLI_PRIVATE_KEY}`]
    },
  }
};
