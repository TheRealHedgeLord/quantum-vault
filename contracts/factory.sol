// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.22;

import "./vault.sol";

contract VaultFactory {
    event VaultDeployed(address vaultAddress);

    constructor() {}

    function deployVault(bytes32 initialHash) public {
        Vault vault = new Vault(initialHash);
        emit VaultDeployed(address(vault));
    }
}
