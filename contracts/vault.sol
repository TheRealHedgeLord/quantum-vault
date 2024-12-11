// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract Vault {
    bytes32 private _oneTimeHash;

    error Unauthorized();

    constructor(bytes32 initialHash) {
        _oneTimeHash = initialHash;
    }

    function oneTimeHash() public view returns (bytes32) {
        return _oneTimeHash;
    }

    function withdraw(
        address token,
        address to,
        uint256 amount,
        bytes memory oneTimeKey,
        bytes32 newHash
    ) public {
        _verifyAndUpdate(oneTimeKey, newHash);
        if (token == address(0)) {
            _withdrawETH(to, amount);
        } else {
            _withdrawTokens(token, to, amount);
        }
    }

    function _verifyAndUpdate(
        bytes memory oneTimeKey,
        bytes32 newHash
    ) private {
        if (keccak256(oneTimeKey) != _oneTimeHash) {
            revert Unauthorized();
        }
        _oneTimeHash = newHash;
    }

    function _withdrawETH(address to, uint256 amount) private {
        payable(to).transfer(amount);
    }

    function _withdrawTokens(
        address token,
        address to,
        uint256 amount
    ) private {
        IERC20(token).transfer(to, amount);
    }
}
