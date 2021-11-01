// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Allowance.sol";

contract SmartWallet is Allowance {
    event MoneySent(address indexed _beneficiary, uint256 _amount);
    event MoneyReceived(address indexed _from, uint256 _amount);

    function renounceOwnership() public view override onlyOwner {
        revert("cant renounce here, pls!");
    }

    function withdrawMoney(address payable _to, uint256 _amount) public ownerOrAllowed(_amount) {
        require(
            address(this).balance >= _amount,
            "There are not enough funds!"
        );

        if (!isOwner) {
            reduceAllowance(msg.sender, _amount);
        }
        emit MoneySent(_to, _amount);
        _to.transfer(_amount);
    }

    receive() external payable {
        emit MoneyReceived(msg.sender, msg.value);
    }
}
