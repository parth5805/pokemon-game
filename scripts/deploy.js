
const hre = require("hardhat");

async function main() {
 
  const Pokemon = await hre.ethers.getContractFactory("PokemonNFTs");
  const pokemonCard = await Pokemon.deploy();
  await pokemonCard.deployed();

  console.log("Pokenmon Card Address:", pokemonCard.address);
}


main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
