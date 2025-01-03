// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract FeeCollector{
    address public  owner;
    uint256 public balance;
    constructor(){

        owner=msg.sender;

    }
     receive() external payable {

        balance += msg.value;

     }

}
