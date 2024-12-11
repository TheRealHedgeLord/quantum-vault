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

    function transfer(
        address token,
        address to,
        uint256 amount,
        bytes memory oneTimeKey,
        bytes32 newHash,
        address nextSigner,
        uint256 nextSignerFunding
    ) public {
        _verifyAndUpdate(oneTimeKey, newHash);
        if (token == address(0)) {
            _transferETH(to, amount);
        } else {
            _transferTokens(token, to, amount);
        }
        if (nextSigner != address(0) && nextSignerFunding > 0) {
            _transferETH(nextSigner, nextSignerFunding);
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

    function _transferETH(address to, uint256 amount) private {
        payable(to).transfer(amount);
    }

    function _transferTokens(
        address token,
        address to,
        uint256 amount
    ) private {
        IERC20(token).transfer(to, amount);
    }
}
