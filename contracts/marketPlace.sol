//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

/**
 * @title MarketPlace
 * @dev Marketplace smart contract consist the logic for buying, selling and tradeing of the nfts.
 * @author Shayan Shaikh
 */

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "./pokemon.sol";

contract marketPlace is ERC1155Holder, ReentrancyGuard{
    address pokemonAddress = 0x9240dDc345D7084cC775EB65F91f7194DbBb48d8;
    address private pokemonCardAddress = address(pokemonAddress);
    PokemonNFTs _pokemon = PokemonNFTs(pokemonCardAddress);

    uint256 buyId;
    uint256 sellId;
    uint256 tradeId;
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

    function ce() public 
    {
        idToBuyCard[1] = buyCard(
        1,1,5,address(0),address(0),10,50,block.timestamp
        );
    }

    //Write Functions
    //Buy Function
    function buy(uint256 _sellId) public payable nonReentrant {
      //Generate Unique Buy Id
      buyId++;
      uint _amount = idToSellCard[_sellId].amount;
      address _seller = idToSellCard[_sellId].seller;
      uint _cardId = idToSellCard[_sellId].cardId;
      uint _quantity = idToSellCard[_sellId].quantity;
      uint _totalMintedCopies = idToSellCard[_sellId].totalMintedCopies;
      require(msg.value == _amount, "Please submit the asking price in order to complete the purchase");
      //Transfer the amout to seller 
      payable(_seller).transfer(msg.value);
      //Transfer the nft to the buyer
      IERC1155(pokemonAddress).safeTransferFrom(
       address(this),
       msg.sender,
       _cardId,
       _quantity,
       '0xaa'
      );
      //Set Buy Struct
      idToBuyCard[buyId] = buyCard(
        buyId,
        _cardId,
        _amount,
        msg.sender,
        _seller,
        _quantity,
        _totalMintedCopies,
        block.timestamp
      );
      idToSellCard[_sellId].quantity = idToSellCard[_sellId].quantity - _quantity;
    }
    //Sell Function
    function sell(uint256 _cardId, uint256 _amount, uint256 _quantity) public payable nonReentrant
    {
        require(_amount > 0, 'Price is too low');
        //Set Approved True
        require(_pokemon.isApprovedForAll(msg.sender, address(this)), "Please Approved Your Self");
        //Generate a new sell Id 
        sellId++;

         //Transfering nft from owner wallet address to the marketPlace address
         IERC1155(pokemonAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _cardId,
            _quantity,
            '0xaa'
         );

         //Create Entry In Sell Struct
         idToSellCard[sellId] = sellCard(
            sellId,
            _cardId,
            _amount,
            address(0),
            msg.sender,
            _quantity,
            _quantity,
            //_totalMintedCopies,
            block.timestamp
         );
    }
    //Trade Function

    //Read Functions
    //Fetch MarketPlace Cards Function 
    function fetchAllCards() public view returns(PokemonNFTs.pokemonCard[] memory){
        return _pokemon.fetchPokemonNfts();
    }
    //Fetch MarketPlace Cards Function 
    function fetchAllCards4() public view returns(PokemonNFTs.energyCard[] memory){
        return _pokemon.fetchEnergyNfts();
    }
    //Fetch MarketPlace Cards Function 
    function fetchAllCards3() public view returns(PokemonNFTs.trainerCard[] memory){
        return _pokemon.fetchTrainerNfts();
    }

    struct fetchAllCard{
        PokemonNFTs.pokemonCard _pokemonCard;
        PokemonNFTs.energyCard _energyCard;
        PokemonNFTs.trainerCard _trainerCard;
    }

    mapping(uint256 => fetchAllCard) public idToAllCard;
    
    // function fetchAllCards2() public view returns(fetchAllCard[] memory){
    //     uint currentIndex = 0;
    //     uint256 finalIdCount = _pokemon.retTotalId();
    //     PokemonNFTs.pokemonCard[] memory pokemonCard = _pokemon.fetchPokemonNfts();
    //     PokemonNFTs.energyCard[] memory energyCard = _pokemon.fetchEnergyNfts();
    //     PokemonNFTs.trainerCard[] memory trainerCard = _pokemon.fetchTrainerNfts();
    //     fetchAllCard[] memory ret = new fetchAllCard[](1);
    //     fetchAllCard memory fc;
    //     fc = fetchAllCard(pokemonCard,energyCard,trainerCard);

    //     ret = pokemonCard;
    //     ret = energyCard;
    //     ret = trainerCard;
    // }   
}
