// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Pokemon is ERC1155, Ownable {
    struct Pokemon_Card {
        uint256 hp; // number of Health Points (HP)
        string name; // name of pokemon
        string card_type; //type of card
        string stage; //stage of pokemon card
        string info; //information about pokenmon card
        string attack; //number of attack
        uint256 damage; //amount of damage
        string weak; //weak energy point
    }

    struct Energy_Card {
        string name; //energy name
        string color; //name of color
    }

    struct Trainer_Card {
        string name; //name of trainer
        string task_details; //information about task
    }

    uint256 nextId;

    mapping(uint256 => Pokemon_Card) private Pokemon_card_details;
    mapping(uint256 => Energy_Card) private Energy_card_details;
    mapping(uint256 => Trainer_Card) private Trainer_card_details;

    constructor() ERC1155("") {}

    function add_pokemon_card(
        uint256 _hp,
        string memory _name,
        string memory _cardtype,
        string memory _stage,
        string memory _info,
        string memory _attack,
        uint256 _damage,
        string memory _weak,
        uint256 _amount,
        bytes memory _data
    ) public onlyOwner returns (bool) {
        _mint(msg.sender, nextId, _amount, _data);
        Pokemon_card_details[nextId] = Pokemon_Card(
            _hp,
            _name,
            _cardtype,
            _stage,
            _info,
            _attack,
            _damage,
            _weak
        );
        nextId++;
        return true;
    }

    function add_energy_card(
        string memory _name,
        string memory _color,
        uint256 _amount,
        bytes memory _data
    ) public onlyOwner returns (bool) {
        _mint(msg.sender, nextId, _amount, _data);
        Energy_card_details[nextId] = Energy_Card(_name, _color);
        nextId++;
        return true;
    }

    function add_trainer_card(
        string memory _name,
        string memory _taskdetails,
        uint256 _amount,
        bytes memory _data
    ) public onlyOwner returns (bool) {
        _mint(msg.sender, nextId, _amount, _data);
        Trainer_card_details[nextId] = Trainer_Card(_name, _taskdetails);
        nextId++;
        return true;
    }
}
