//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "./Allowance.sol";

contract SharedWallet is Allowance { 

    event MoneyReceived(address indexed _from, uint _amount);
    event MoneyWithdrawn(address indexed _from, uint _amount);

    function renounceOwnership() public override onlyOwner { 
        revert("Ownership can't be renounced");
    }
 
    function getBalance() public view returns(uint) { 
        return address(this).balance;
    }

    function withdrawMoney (address payable _to, uint _amount) public ownerOrAllowed(_amount) {
        require(_amount <= address(this).balance, "Not enough funds on wallet");
        if(!isOwner()) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneyWithdrawn(_to, _amount);
        _to.transfer(_amount);
    }

    receive () external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }

}
