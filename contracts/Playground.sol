// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
import "./pokemon.sol";

contract PlayGround {

    address pokemonAddress = 0xd9145CCE52D386f254917e481eB44e9943F39138;
    address private pokemonCardAddress = address(pokemonAddress);
    PokemonNFTs _pokemon = PokemonNFTs(pokemonCardAddress);

     struct Player{
         address player_address;
         uint[6] card_list;
     }

     mapping(address=>Player) public players;
     address[] public player_no;

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

    modifier onlyPlayer {
        require(msg.sender==players[msg.sender].player_address,"Only Player can call this function");
        _;
    }
    
    function checkOwnerShip(uint[6] memory _pokemonNftId,address _caller) private view returns(bool){
        
        uint flag=0;
        for(uint i=0;i<6;i++)
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
       
    function checkCardTypePokemon(uint[6] memory _pokemonNftId) private view returns(bool){
        
        uint flag=0;
        for(uint i=0;i<6;i++)
        {
            (uint _id , , , , , , , , , ) =  _pokemon.Pokemon_card_details(_pokemonNftId[i]);
            if(_id >0)
            {
                flag++;
            }
            else
            {
                 revert("Your NFTs is not a pokemon type");
               flag--;
            }
        }
        return flag==6?true:false;
    }


    function enterIntoGame(uint[6] memory _pokemonNftId) public  {
        require(checkOwnerShip(_pokemonNftId,msg.sender),"You are not owner of all NFTs");
        require(msg.sender != players[msg.sender].player_address ,"You already Joined the game");
        require(player_no.length < 2 ,"only two players are allowed");
        require(checkCardTypePokemon(_pokemonNftId),"Your NFTs is not the pokemon type");

        players[msg.sender]=Player(msg.sender,_pokemonNftId);
        player_no.push(msg.sender);

    }

    function startGame() public onlyManager returns(bool)
    {
        require(player_no.length==2,"at least two player is required to start this game");
        require(playerGameSettings[player_no[0]].active_pokemon > 0 && playerGameSettings[player_no[1]].active_pokemon > 0,"each player have must set their active pokemon");
        require(playerGameSettings[player_no[0]].pokemon_bench[0] > 0 && playerGameSettings[player_no[1]].pokemon_bench[0] > 0,"each Player have must add their pokemon on bench");
  
        require(setOpponent(),"ERROR: setOpponent function");
        require(flipacoin(),"ERROR: flipacoin function");
        require(mintPrizeCard(),"ERROR: mintPrizeCard function");
        return true;
   }

    function flipacoin() public onlyManager returns(bool)
    {

    }


    function checkPokemonStage(uint _pokemonNftId) private view returns(bool){
        
        (,,,,,string memory _stage,,,,)=_pokemon.Pokemon_card_details(_pokemonNftId);
        if(keccak256(abi.encodePacked(_stage))==keccak256(abi.encodePacked("basic")))
        {
            return true;
        }
        else
        {
            revert("This is not a basic pokemon type card");
        }
    }


    function addActivePokemon(uint _activePokemonId) public onlyPlayer {
        require(playerGameSettings[msg.sender].active_pokemon == 0,"Active Pokemon is already added");
        require(checkPokemonStage(_activePokemonId),"Pokemon Stage must be Basic");
        for(uint i=0;i<players[msg.sender].card_list.length;i++)
        {
            if(players[msg.sender].card_list[i]==_activePokemonId)
            {
                playerGameSettings[msg.sender].active_pokemon=_activePokemonId;
                break;
            }
        }
        if(playerGameSettings[msg.sender].active_pokemon == 0)
        {
        revert("your active pokemon id is different from your intital pokemon list");
        }

    }

    function addPokemonInBench(uint[5] memory _benchPokemonId) public onlyPlayer {
        require(playerGameSettings[msg.sender].pokemon_bench.length == 0,"You already Added Five Pokemon onto bench");
        uint flag=0;
        for(uint i=0;i<5;i++)
        {
            for(uint j=0;j<6;j++)
            {
                if(_benchPokemonId[i]==players[msg.sender].card_list[i]){
                    if(_benchPokemonId[i] != playerGameSettings[msg.sender].active_pokemon)
                    {
                        flag++;
                    }
                    else
                    {
                        revert("Your bench pokemon list consits active pokemon id");
                    }
                }
            }
        }

        if(flag==5)
        {
            playerGameSettings[msg.sender].pokemon_bench=_benchPokemonId;
        }
        else
        {
            revert("your bench pokemon ids are  different from your intital pokemon list");
        }

    }

    function attack() public returns(bool)
    {

    }

    function mintPrizeCard() public onlyManager returns(bool)
    {

    }

    function setOpponent() private  onlyManager returns(bool)
    {

    }





}