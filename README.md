# Quantum Vault

## Overview

This repository propose a simple schema to secure your asset on Ethereum against quantum computers.

## Quantum attacks

The two quantum computer algorithms that poses threat to modern cryptography are Grover's algorithm and Shor's algorithm.

### Grover's Algorithm

Grover's algorithm is able to perform brute force attacks more efficiently, in the context of preimage attacks on hash algorithms, it can reduce the security of a 256 bits hash to the level of a 128 bits hash. Because a 128 bits hash is still considered as secure, algorithms such as `keccak256` can be considered as quantum secure.

### Shor's Algorithm

Shor's algorithm is capable of finding the private key of a given public key for eliptic curve key pairs.

For EOA accounts, the address is a hash of the public key, thus Shor's algorithm cannot find the private key given the address, however, if an EOA account has made a transaction before, the public key can be derived from past transaction. So although newly created EOA accounts are quantum secure, EOA accounts that have already made transactions are not quantum secure.

For smart contracts, the address is not derived from a public key, thus smart contracts can be considered quantum secure.

## Quantum Resistant Schema

### Vault Authentication

The schema use a smart contract vault to secure funds against quantum computers, the vault contract use a one time hash of `keccak256` as authentication method. Each time a transaction is verified, the next one time hash is updated. Each time a transaction is made, it will also fund the next signer with a small amount of ETH, because the previous signer has already made a transaction thus no longer quantum secure.

### Wallet Side Implementation

The wallet will always store an EOA account and a one time key. Everytime before the wallet make a transaction, it needs to generate a new random one time key, and a new EOA wallet. When submitting a transaction, it needs to create the one time hash by performing `keccak256` on the new one time key, sign the transaction with the old EOA account, use the old one time key to authenticate the vault contract, update the one time hash with the `keccak256` of the new one time key, and fund the new EOA account with a small amount of ETH. After the transaction, replace the old one time key and EOA account with the new ones.

## Quantum Schema For Bitcoin

For Bitcoin, the existing wallet intfrastruction would work, simply always use `P2PKH` addresses and always send all the remaining UTXO to a new address every time making a transaction.
