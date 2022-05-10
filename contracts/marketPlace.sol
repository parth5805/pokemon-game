//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
 * @title MarketPlace
 * @dev Marketplace smart contract consist the logic for buying, selling and tradeing of the nfts.
 * @author Shayan Shaikh
 */

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "./pokemon.sol";

contract marketPlace is ERC1155Holder{
    address private pokemonCardAddress = address(0xDA0bab807633f07f013f94DD0E6A4F96F8742B53);
    PokemonNFTs _pokemon = PokemonNFTs(pokemonCardAddress);

    //Struct For Buy
    struct buyCard {
        uint256 buyId;
        uint256 cardId;
        uint256 amount;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalMintedCopies;
        uint256 timeStamp;
    }
    //Struct For Sell
    struct sellCard {
        uint256 sellId;
        uint256 cardId;
        uint256 amount;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalMintedCopies;
        uint256 timeStamp;
    }
    //Struct For Trade History
    struct tradeHistory {
        uint256 tradeId;
        uint256 cardId;
        uint256 buyId;
        uint256 sellId;
        uint256 amount;
        address buyer;
        address seller;
        uint256 quantity;
        uint256 totalMintedCopies;
        uint256 timeStamp;
    }

    //Mapping for Buy
    mapping(uint256 => buyCard) public idToBuyCard;
    //Mapping for Sale
    mapping(uint256 => sellCard) public idToSellCard;
    //Mapping For Trade
    mapping(uint256 => tradeHistory) public idToTradeHistory;

    //Event For Buy
    event buyEmit
    (
        uint256 indexed buyId,
        uint256 indexed cardId,
        uint256 amount,
        address buyer,
        address seller,
        uint256 quantity,
        uint256 totalMintedCopies,
        uint256 indexed timeStamp
    );
    //Event For Sell
     event sellEmit
    (
        uint256 indexed sellId,
        uint256 indexed cardId,
        uint256 amount,
        address buyer,
        address seller,
        uint256 quantity,
        uint256 totalMintedCopies,
        uint256 indexed timeStamp
    );
    //Event For Trade
     event tradeEmit
    (
        uint256 indexed tradeId,
        uint256 indexed cardId,
        uint256 buyId,
        uint256 sellId,
        uint256 amount,
        address buyer,
        address seller,
        uint256 quantity,
        uint256 totalMintedCopies,
        uint256 indexed timeStamp
    );

    //Write Functions
    //Buy Function
    function buy(uint256 _id, uint256 _amount, uint256 _quantity) public {

    }
    //Sell Function
    //Trade Function

    //Read Functions
    //Fetch MarketPlace Cards Function 
    function fetchAllCards() public view returns(PokemonNFTs.energyCard[] memory){
        return _pokemon.fetchEnergyNfts();
    }

    struct fetchAllCard{
        PokemonNFTs.pokemonCard _pokemonCard;
        PokemonNFTs.energyCard _energyCard;
        PokemonNFTs.trainerCard _trainerCard;
    }

    mapping(uint256 => fetchAllCard) public idToAllCard;
    
    function fetchAllCards2() public view returns(fetchAllCard[] memory){
        uint currentIndex = 0;
        uint256 finalIdCount = _pokemon.retTotalId();
        PokemonNFTs.pokemonCard[] memory pokemonCard = _pokemon.fetchPokemonNfts();
        PokemonNFTs.energyCard[] memory energyCard = _pokemon.fetchEnergyNfts();
        PokemonNFTs.trainerCard[] memory trainerCard = _pokemon.fetchTrainerNfts();
        fetchAllCard[] memory ret = new fetchAllCard[](1);
        fetchAllCard memory fc;
        fc = fetchAllCard(pokemonCard,energyCard,trainerCard);

        ret = pokemonCard;
        ret = energyCard;
        ret = trainerCard;
    }   
}
