// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.3.2 (utils/Context.sol)

pragma solidity ^0.8.0;

import './Ownable.sol';
import './SafeMath.sol';

contract Allowance is Ownable {
    event AllowanceChanged(
        address indexed _forWho,
        address indexed _fromWhom,
        uint256 _oldAmount,
        uint256 _newAmount
    );
    using SafeMath for uint256;

    mapping(address => uint256) public allowance;
    bool public isOwner = msg.sender == owner();

    modifier ownerOrAllowed(uint256 _amount) {
        require(
            isOwner || allowance[msg.sender] >= _amount,
            "You are not allowed"
        );
        _;
    }

    function addAllowance(address _who, uint256 _amount) public onlyOwner {
        emit AllowanceChanged(_who, msg.sender, allowance[_who], _amount);
        allowance[_who] = _amount;
    }

    function reduceAllowance(address _who, uint256 _amount) internal {
        emit AllowanceChanged(
            _who,
            msg.sender,
            allowance[_who],
            allowance[_who].sub(_amount)
        );
        allowance[_who] = allowance[_who].sub(_amount);
    }
}
