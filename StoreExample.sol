// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract StorageExample{
    uint256 private dataToStore;

    constructor (uint256 _dataToStore){
        dataToStore = _dataToStore;
    }

    function setDataToStore(uint256 _data) public{
        dataToStore = _data;
    }
    
    function getDataToStore() public view returns(uint256){
        return dataToStore;
    }
}
