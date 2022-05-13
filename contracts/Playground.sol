// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/IERC1155.sol";
import "./pokemon.sol";

contract PlayGround {

    address pokemonAddress = 0x9bF88fAe8CF8BaB76041c1db6467E7b37b977dD7;
    address private pokemonCardAddress = address(pokemonAddress);
    PokemonNFTs _pokemon = PokemonNFTs(pokemonCardAddress);

     struct Player{
         address player_address;
         uint[6] card_list;
     }

     mapping(address=>Player) public players;
     address[2] player_no;

     address manager;
     
     struct PlayerGameSetting{
         address player_address;
         uint active_pokemon;
         uint[5] pokemon_bench;
         uint current_hp;
         bool is_knocked;
         address opponent;
     }

     mapping(address=>PlayerGameSetting) playerGameSettings;
     

     address current_turn;
     address winner;
     

    constructor(){
        manager=msg.sender;
    }

    modifier onlyManager {
        require(msg.sender==manager,"Only manager can call this function");
        _;
    }
    
    function checkOwnerShip(uint[6] memory _pokemonNftId,address _caller) private view returns(bool){
        
        uint flag=0;
        for(uint i=0;i<_pokemonNftId.length;i++)
        {
            if(_pokemon.balanceOf(_caller,_pokemonNftId[i]) >0)
            {
                flag++;
            }
            else
            {
               flag--;
            }
        }
        return flag==6?true:false;
    }

    function enterIntoGame(uint[6] memory _pokemonNftId) public {
        require(checkOwnerShip(_pokemonNftId,msg.sender),"You are not owner of all NFTs");
        players[msg.sender]=Player(msg.sender,_pokemonNftId);


    }

    function startGame() public returns(bool)
    {

    }

    function flipacoin() public returns(bool)
    {

    }

    function addActivePokemon() public{

    }

    function addPokemonInBench() public {

    }

    function attack() public returns(bool)
    {

    }

    function mintPrizeCard() public returns(bool)
    {

    }

    function setOpponent() private returns(bool)
    {

    }





}