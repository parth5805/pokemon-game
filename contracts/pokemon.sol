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
        //    string info; //information about pokenmon card //removing this due to this error 'Stack too deep'
           string attack;  //number of attack
           uint quantity; //no of attack card require to attack
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

    uint public nextId=100; //counter starts from 100

    mapping(uint=>pokemonCard) public Pokemon_card_details;
    mapping(uint=>energyCard)  public Energy_card_details;
    mapping(uint=>trainerCard) public Trainer_card_details;

    event pokemonNFT(address indexed _to,uint amount,uint indexed _tokenId,string _cardType,uint _hp,string _name,string _pokemonType,string _stage,string _attack,uint _quantity,uint _damage,string _weak);
    event energyNFT(address indexed _to,uint amount,uint indexed _tokenId,string _cardType,string _name,string _color);
    event trainerNFT(address indexed _to,uint amount,uint indexed _tokenId,string _cardType,string _name,string _taskDetails);


    constructor() ERC1155("") {}
    
    function addPokemonCard(address _marketplaceAddress,uint _hp,string memory _name,string memory _pokemonType,string memory _stage,string memory _attack,uint _quantity,uint _damage,string memory _weak,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextId,_amount,_data);
    Pokemon_card_details[nextId]=pokemonCard(nextId,"pokemon",_hp,_name,_pokemonType,_stage,_attack,_quantity,_damage,_weak);
    emit pokemonNFT(msg.sender,_amount,nextId,"pokemon",_hp,_name,_pokemonType,_stage,_attack,_quantity,_damage,_weak);
    nextId++;
    return true;
    }
    
    function addEnergyCard(address _marketplaceAddress,string memory _name,string memory _color,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextId,_amount,_data);
    Energy_card_details[nextId]=energyCard(nextId,"energy",_name,_color);
    emit energyNFT(msg.sender,_amount,nextId,"energy",_name,_color);
    nextId++;
    return true;
    }

    
    function addTrainerCard(address _marketplaceAddress,string memory _name,string memory _taskdetails,uint _amount,bytes memory _data) public onlyOwner returns(bool)
    {
    _mint(_marketplaceAddress,nextId,_amount,_data);
    Trainer_card_details[nextId]=trainerCard(nextId,"trainer",_name,_taskdetails);
    emit trainerNFT(msg.sender,_amount,nextId,"trainer",_name,_taskdetails);
    nextId++;
    return true;
    }

    function fetchPokemonNfts() public view returns(pokemonCard[] memory)  //function returns all pokenmon NFTs
    {
        
        uint counter;  //counts total pokenmon NFTs
        uint index=0;  
        for(uint i=100;i<nextId;i++) //this for loop help us to get latest count of pokemon NFTs
        {
            if(keccak256(abi.encodePacked(Pokemon_card_details[i].cardType))==keccak256(abi.encodePacked("pokemon")))
                {           
                    counter++; 
                }
        }

        pokemonCard[] memory pokemonArray=new pokemonCard[](counter); //Create local array to store pokemon details

        for(uint i=100;i<nextId;i++) //this for loop help us to store struct values in array
        {
            if(keccak256(abi.encodePacked(Pokemon_card_details[i].cardType))==keccak256(abi.encodePacked("pokemon")))
                {           
                pokemonArray[index]=Pokemon_card_details[i];
                index++;
                }
        }
        
        return pokemonArray;
    }



    function fetchEnergyNfts() public view returns(energyCard[] memory) //function returns all Energy card NFTs
    {
        uint counter;
        uint index=0;
        for(uint i=100;i<nextId;i++)
        {
            if(keccak256(abi.encodePacked(Energy_card_details[i].cardType))==keccak256(abi.encodePacked("energy")))
                {           
                    counter++;
                }
        }

        energyCard[] memory enerygyArray=new energyCard[](counter);

        for(uint i=100;i<nextId;i++)
        {
            if(keccak256(abi.encodePacked(Energy_card_details[i].cardType))==keccak256(abi.encodePacked("energy")))
                {           
                enerygyArray[index]=Energy_card_details[i];
                index++;
                }
        }
        
        return enerygyArray;
    }

    function fetchTrainerNfts() public view returns(trainerCard[] memory) //function returns all Trainer card NFTs
    {
        uint counter;
        uint index=0;
        for(uint i=100;i<nextId;i++)
        {
            if(keccak256(abi.encodePacked(Trainer_card_details[i].cardType))==keccak256(abi.encodePacked("trainer")))
                {           
                    counter++;
                }
        }

        trainerCard[] memory trainerArray=new trainerCard[](counter);

        for(uint i=100;i<nextId;i++)
        {
                if(keccak256(abi.encodePacked(Trainer_card_details[i].cardType))==keccak256(abi.encodePacked("trainer")))
                {           
                trainerArray[index]=Trainer_card_details[i];
                index++;
                }
        }
        
        return trainerArray;
    }
    
    

}