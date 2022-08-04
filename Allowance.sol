//SPDX-License-Identifier: MIT

pragma solidity ^0.8.1;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/contracts/utils/math/SafeMath.sol";

contract Allowance is Ownable {

    using SafeMath for uint; 

    event AllowanceUpdate(address indexed _from, address indexed to_, uint _oldAllowance, uint _newAllowance);

    mapping(address => uint) public allowance;
    
    modifier ownerOrAllowed(uint _amount) {
        require(isOwner() || allowance[msg.sender] >= _amount, "You are not allowed to withdraw or you are exceeding your allowance"); 
        _;
    }
 
    function isOwner() internal view returns(bool) {
        return owner() == msg.sender;
    }

    function addAllowance(address _who, uint _amount) public onlyOwner {
        emit AllowanceUpdate(msg.sender, _who, allowance[_who], allowance[_who].add(_amount)); 
        allowance[_who] = allowance[_who].add(_amount);  
    }

    function reduceAllowance(address _who, uint _amount) public ownerOrAllowed(_amount) {
        emit AllowanceUpdate(msg.sender, _who, allowance[_who], allowance[_who].sub(_amount));  
        allowance[_who] -= allowance[_who].sub(_amount);  
    }

}
