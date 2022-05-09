// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/**
 * @title PokemonNFTs
 * @dev Implements creating NFTs for pokenmon cards and also create getter fucntion for all NFTs
 * @author Parth Patel
 */

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PokemonNFTs is ERC1155, Ownable {

/**
This structure represents the pokenmon card features
*/

    struct pokemonCard{
           uint id;
           string cardType;
           uint hp;  // number of Health Points (HP)
           string name; // name of pokemon
           string pokemonType; //type of pokemon card
           string stage;  //stage of pokemon card
           string info; //information about pokenmon card
           string attack;  //number of attack
           uint damage; //amount of damage
           string weak;  //weak energy point
    }

/**
This structure represents the energy card features
*/
    struct energyCard{
        uint id;
        string cardType;
        string name; //energy name
        string color; //name of color
    }

/**
This structure represents the trainer card feature
*/
    struct trainerCard{
        uint id;
        string cardType;
        string name; //name of trainer
        string taskDetails; //information about task

    }

    uint public nextEnergyId;
    uint public nextTrainerId;
    uint public nextPokemonId;

    mapping(uint=>pokemonCard) public Pokemon_card_details;
    mapping(uint=>energyCard)  public Energy_card_details;
    mapping(uint=>trainerCard) public Trainer_card_details;

    event pokemonNFT(address indexed _to,uint amount,uint indexed _tokenId,string _cardType,uint _hp,string _name,string _pokemonType,string _stage,string _info,string _attack,uint _damage,string _weak);
    event energyNFT(address indexed _to,uint amount,uint indexed _tokenId,string _cardType,string _name,string _color);
    event trainerNFT(address indexed _to,uint amount,uint indexed _tokenId,string _cardType,string _name,string _taskDetails);


    constructor() ERC1155("") {}
    
    function addPokemonCard(address _marketplaceAddress,uint _hp,string memory _name,string memory _pokemonType,string memory _stage,string memory _info,string memory _attack,uint _damage,string memory _weak,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextPokemonId,_amount,_data);
    Pokemon_card_details[nextPokemonId]=pokemonCard(nextPokemonId,"pokemon",_hp,_name,_pokemonType,_stage,_info,_attack,_damage,_weak);
    emit pokemonNFT(msg.sender,_amount,nextPokemonId,"pokemon",_hp,_name,_pokemonType,_stage,_info,_attack,_damage,_weak);
    nextPokemonId++;
    return true;
    }
    
    function addEnergyCard(address _marketplaceAddress,string memory _name,string memory _color,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextEnergyId,_amount,_data);
    Energy_card_details[nextEnergyId]=energyCard(nextEnergyId,"energy",_name,_color);
    emit energyNFT(msg.sender,_amount,nextEnergyId,"energy",_name,_color);
    nextEnergyId++;
    return true;
    }

    
    function addTrainerCard(address _marketplaceAddress,string memory _name,string memory _taskdetails,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextTrainerId,_amount,_data);
    Trainer_card_details[nextTrainerId]=trainerCard(nextTrainerId,"trainer",_name,_taskdetails);
    emit trainerNFT(msg.sender,_amount,nextTrainerId,"trainer",_name,_taskdetails);
    nextTrainerId++;
    return true;
    }

    function fetchPokemonNfts() public view returns(pokemonCard[] memory)
    {
        pokemonCard[] memory pokemonArray=new pokemonCard[](nextPokemonId);
        for(uint i=0;i<nextPokemonId;i++){
            pokemonArray[i]=Pokemon_card_details[i];
        }
        return pokemonArray;
    }

    function fetchEnergyNfts() public view returns(energyCard[] memory)
    {
        energyCard[] memory enerygyArray=new energyCard[](nextEnergyId);
        for(uint i=0;i<nextEnergyId;i++){
            enerygyArray[i]=Energy_card_details[i];
        }
        return enerygyArray;
    }

    function fetchTrainerNfts() public view returns(trainerCard[] memory)
    {
        trainerCard[] memory trainerArray=new trainerCard[](nextTrainerId);
        for(uint i=0;i<nextTrainerId;i++){
            trainerArray[i]=Trainer_card_details[i];
        }
        return trainerArray;
    }



}