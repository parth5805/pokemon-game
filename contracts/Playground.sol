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

     bool public isGameStart;

     address manager;
     
     struct PlayerGameSetting{
         address player_address;
         uint active_pokemon;
         uint[5] pokemon_bench;
         uint current_hp;
         mapping(uint=>bool) is_knocked;
         address opponent;
     }

     mapping(address=>PlayerGameSetting) public playerGameSettings;
     

     address public current_turn;
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
        // require(mintPrizeCard(),"ERROR: mintPrizeCard function");
        isGameStart=true;
        return true;
   }
    

    function random() private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, player_no)));
      }


    function flipacoin() public onlyManager returns(bool)
    {
        require(current_turn == address(0),"You have already flip the coin");
        uint index = random() % player_no.length;
        current_turn=player_no[index];
        return true;

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
                playerGameSettings[msg.sender].player_address=msg.sender;
                playerGameSettings[msg.sender].active_pokemon=_activePokemonId;
                ( , ,uint _currentHp , , , , , , ,  ) =  _pokemon.Pokemon_card_details(playerGameSettings[msg.sender].active_pokemon);
                playerGameSettings[msg.sender].current_hp=_currentHp;
                break;
            }
        }
        if(playerGameSettings[msg.sender].active_pokemon == 0)
        {
        revert("your active pokemon id is different from your intital pokemon list");
        }

    }

    function addPokemonInBench(uint[5] memory _benchPokemonId) public onlyPlayer{
        require(playerGameSettings[msg.sender].pokemon_bench[0] == 0,"You already Added Five Pokemon onto bench");
        uint flag;
        for(uint i=0;i<5;i++)
        {
            for(uint j=0;j<6;j++)
            {
                if(_benchPokemonId[i]==players[msg.sender].card_list[j])
                {
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


    function checkEnergyCardOwnerShip(uint _energyCardId,address _caller) private view returns(bool){
        
        if(_pokemon.balanceOf(_caller,_energyCardId) >0){
            return true;
        }
        else
        {
            return false;
        }  
    }

    function checkEnergyCardQty(uint _energyCardId,uint _quantity,address _caller) private view returns(bool){
        
        if(_pokemon.balanceOf(_caller,_energyCardId) >= _quantity){
            return true;
        }
        else
        {
            return false;
        }  
    }


    function checkCardTypeEnergy(uint _energyCardId) private view returns(bool){  
        (uint _id , , , ) =  _pokemon.Energy_card_details(_energyCardId);
         if(_id >0)
            {
                return true;
            }
            else
            {
                 return false;
            }
           
    
    }


    function attack(uint _energyCardId,uint _quantity) public onlyPlayer returns(bool)
    {
        require(checkCardTypeEnergy(_energyCardId),"Your NFTs is not the energy type");
        require(checkEnergyCardOwnerShip(_energyCardId,msg.sender),"You are not a owner of this energy card");
        require(checkEnergyCardQty(_energyCardId,_quantity,msg.sender),"You must own the require quantity of energy card");
        require(isGameStart==true,"This game is not started yet");
        require(msg.sender==current_turn,"This is not your turn.Please wait for your turn");
        
        ( , , , ,string memory _activePokemonType , , , , ,  ) =  _pokemon.Pokemon_card_details(playerGameSettings[msg.sender].active_pokemon);
        ( , ,string memory _energyCardName , ) =  _pokemon.Energy_card_details(_energyCardId);
        require(keccak256(abi.encodePacked(_activePokemonType))==keccak256(abi.encodePacked(_energyCardName)),"You are using different energy for your active pokemon card.Please Use Same energy as per your Active Pokemon");
        ( , , , , , , ,uint _activePokemonQty, ,  ) =  _pokemon.Pokemon_card_details(playerGameSettings[msg.sender].active_pokemon);
        require(_activePokemonQty==_quantity,"Your energy card quantity is not equal to  required Active Pokemon Quantity");

        uint result;
        uint opponentCurrentHp=playerGameSettings[playerGameSettings[msg.sender].opponent].current_hp;
        ( , , , , , , , ,uint activePokemonDamage ,  ) =  _pokemon.Pokemon_card_details(playerGameSettings[msg.sender].active_pokemon);
        result=opponentCurrentHp-activePokemonDamage;
        if(result <=0)
        {

        playerGameSettings[playerGameSettings[msg.sender].opponent].is_knocked[playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon]=true;
        
        
        for(uint i=0;i<playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench.length;i++)
        {

        if(playerGameSettings[playerGameSettings[msg.sender].opponent].is_knocked[playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench[i]]==false)
        {
        playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon=playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench[i];
        }

        }
        
        if(playerGameSettings[playerGameSettings[msg.sender].opponent].is_knocked[playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon]==true)
        {
            winner=msg.sender;
            isGameStart=false;
        }
        
        // playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon=playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench[0];
        
        // uint _index;
        // require(_index < playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench.length, "index out of bound");
        // for (uint i = _index; i < playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench.length - 1; i++) {
        //     playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench[i] = playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench[i + 1];
        // }
        // playerGameSettings[playerGameSettings[msg.sender].opponent].pokemon_bench.pop();


        
        ( , ,uint _opponentActivePokemonHp , , , , , , ,  ) =  _pokemon.Pokemon_card_details(playerGameSettings[playerGameSettings[msg.sender].opponent].active_pokemon);
        playerGameSettings[playerGameSettings[msg.sender].opponent].current_hp=_opponentActivePokemonHp;
        current_turn=playerGameSettings[msg.sender].opponent;
        return true;
        }
        else
        {
            playerGameSettings[playerGameSettings[msg.sender].opponent].current_hp=result;
            current_turn=playerGameSettings[msg.sender].opponent;
            return true;
        }

    }

    function mintPrizeCard() public onlyManager returns(bool)
    {
      
    }

    function setOpponent() public  onlyManager  returns(bool)
    {
        require(playerGameSettings[player_no[0]].opponent==address(0) && playerGameSettings[player_no[1]].opponent==address(0),"You have already set the opponent of each player");
        playerGameSettings[player_no[0]].opponent=player_no[1];
        playerGameSettings[player_no[1]].opponent=player_no[0];
        return true;
    }





}