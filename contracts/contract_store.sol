// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

contract AllowedContracts {

    address public owner;
    
    struct ContractInfo {
        string label;
        address contractAddress;
        uint8 maxSlashableStakePercentage; // Assumes value between 0 to 100
        string command;
        bool exists;
    }

    mapping(address => ContractInfo) public contracts;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function addOrUpdateContract(string memory _label, string memory _command, address _contractAddress, uint8 _maxSlashableStakePercentage) public onlyOwner {
        require(_maxSlashableStakePercentage <= 100, "Percentage value out of range");
        
        ContractInfo storage newContract = contracts[_contractAddress];

        newContract.label = _label;
        newContract.contractAddress = _contractAddress;
        newContract.maxSlashableStakePercentage = _maxSlashableStakePercentage;
        newContract.command = _command;
        newContract.exists = true;
    }

    function removeContract(address _contractAddress) public onlyOwner {
        require(contracts[_contractAddress].exists, "Contract does not exist");
        
        delete contracts[_contractAddress];
    }


    function transferOwnership(address newOwner) public onlyOwner {
        owner = newOwner;
    }
}