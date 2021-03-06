pragma solidity ^0.4.18;

import "zeppelin-solidity/contracts/math/SafeMath.sol";

contract DepositsManager {
    using SafeMath for uint;

    mapping(address => uint) public deposits;
    uint public jackpot;
    address public owner;

    event DepositMade(address who, uint amount);
    event DepositWithdrawn(address who, uint amount);

    // @dev – the constructor
    constructor() public {
        owner = msg.sender;
    }
    
    // @dev – fallback to calling makeDeposit when ether is sent directly to contract.
    function() public payable {
        makeDeposit();
    }

    // @dev – returns an account's deposit
    // @param who – the account's address.
    // @return – the account's deposit.
    function getDeposit(address who) view public returns (uint) {
        return deposits[who];
    }

    // @dev – allows a user to deposit eth.
    // @return – the user's updated deposit amount.
    function makeDeposit() public payable returns (uint) {
        deposits[msg.sender] = deposits[msg.sender].add(msg.value);
        emit DepositMade(msg.sender, msg.value);
        return deposits[msg.sender];
    }

    // @dev – allows a user to withdraw eth from their deposit.
    // @param amount – how much eth to withdraw
    // @return – the user's updated deposit amount.
    function withdrawDeposit(uint amount) public returns (uint) {
        require(deposits[msg.sender] > amount);

        deposits[msg.sender] = deposits[msg.sender].sub(amount);
        msg.sender.transfer(amount);

        emit DepositWithdrawn(msg.sender, amount);
        return deposits[msg.sender];
    }

}