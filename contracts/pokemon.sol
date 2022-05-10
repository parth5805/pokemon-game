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
           uint hp;  // number of Health Points (HP)
           string name; // name of pokemon
           string cardType; //type of card
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
        string name; //energy name
        string color; //name of color
    }

/**
This structure represents the trainer card features
*/
    struct trainerCard{
        uint id;
        string name; //name of trainer
        string taskDetails; //information about task

    }

    uint nextEnergyId;
    uint nextTrainerId;
    uint nextPokemonId;

    mapping(uint=>pokemonCard) private Pokemon_card_details;
    mapping(uint=>energyCard)  private Energy_card_details;
    mapping(uint=>trainerCard) private Trainer_card_details;

    event pokemonNFT(address indexed _to,uint amount,uint indexed _tokenId,uint _hp,string _name,string _cardType,string _stage,string _info,string _attack,uint _damage,string _weak);
    event energyNFT(address indexed _to,uint amount,uint indexed _tokenId,string _name,string _color);
    event trainerNFT(address indexed _to,uint amount,uint indexed _tokenId,string _name,string _taskDetails);


    constructor() ERC1155("") {}
    
    function addPokemonCard(address _marketplaceAddress,uint _hp,string memory _name,string memory _cardtype,string memory _stage,string memory _info,string memory _attack,uint _damage,string memory _weak,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextPokemonId,_amount,_data);
    Pokemon_card_details[nextPokemonId]=pokemonCard(nextPokemonId,_hp,_name,_cardtype,_stage,_info,_attack,_damage,_weak);
    emit pokemonNFT(msg.sender,_amount,nextPokemonId,_hp,_name,_cardtype,_stage,_info,_attack,_damage,_weak);
    nextPokemonId++;
    return true;
    }
    
    function addEnergyCard(address _marketplaceAddress,string memory _name,string memory _color,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextEnergyId,_amount,_data);
    Energy_card_details[nextEnergyId]=energyCard(nextEnergyId,_name,_color);
    emit energyNFT(msg.sender,_amount,nextEnergyId,_name,_color);
    nextEnergyId++;
    return true;
    }

    
    function addTrainerCard(address _marketplaceAddress,string memory _name,string memory _taskdetails,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextTrainerId,_amount,_data);
    Trainer_card_details[nextTrainerId]=trainerCard(nextTrainerId,_name,_taskdetails);
    emit trainerNFT(msg.sender,_amount,nextTrainerId,_name,_taskdetails);
    nextTrainerId++;
    return true;
    }

    function fetchPokemonNfts() public view returns(uint[] memory)
    {
        uint[] memory pokemonArray=new uint[](nextPokemonId);
        for(uint i=0;i<nextPokemonId;i++){
            pokemonArray[i]=Pokemon_card_details[i].id;
        }
        return pokemonArray;
    }

    function fetchEnergyNfts() public view returns(uint[] memory)
    {
        uint[] memory enerygyArray=new uint[](nextEnergyId);
        for(uint i=0;i<nextEnergyId;i++){
            enerygyArray[i]=Energy_card_details[i].id;
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