> Please note that this repository is still under development and needs testing and auditing. It is not production ready yet!

<div align="center">  <img  width="446.5px" height="146.5px"  src="./assets/logo.png" /></div>

<h3 align="center"><em>Production ready modules for Sui Move developers</em></h3>

## Installation

Add the following snippet in your `Move.toml`

```toml
[dependencies.SuiTears]
git = "https://github.com/interest-protocol/suitears.git"
subdir = "contracts"
rev = "testnet"
```

## Contracts

The Sui Move contracts are located in the `contracts` directory.

```ml
airdrop
├─ airdrop_utils — "Verify function for the airdrop modules"
├─ airdrop — "A pull design airdrop that distributes the tokens after a specific date"
├─ linear_vesting_airdrop — "A pull design that distributes the tokens according to a linear vesting"
├─ multi_sender — "A push style airdrop"
├─ quadratic_vesting_airdrop — "A pull design that distributes the tokens according to a quadratic vesting"
capabilities
├─ owner — "Owner capability to give access to multiple objects"
├─ quest — "A wrapper that can only be unwrapped once a set of actions are completed"
├─ request_lock — "A hot potato to ensure that a set of requests are completed before destroying it"
├─ timelock — "Timelock capability to add a delay between actions"
collections
├─ ac_collection — "Capability access wrapper for collections"
├─ bitmap — "Bitmap implementation for sequential keys"
├─ coin_decimals — "A collection that stores Coin decimals"
├─ wit_collection - "Witness access wrapper for collections"
defi
├─ farm — "Farm module to reward coin holders over time"
├─ fund — "Struct to track shares associated with underlying deposits/withdrawals"
├─ linear_vesting_wallet — "Wallet that allows withdrawals according to a linear vesting"
├─ linear_vesting_wallet_with_clawback — "Wallet that distributes the tokens according to a linear vesting and allows the clawback owner to claim all unreleased coins back"
├─ quadratic_vesting_wallet — "Wallet that allows withdrawals according to a quadratic"
├─ quadratic_vesting_wallet_with_clawback — "Wallet that allows withdrawals according to a quadratic and allows the clawback owner to claim all unreleased coins back"
├─ vesting — "Virtual implementation of vesting schedules"
governance
├─ dao — "Decentralized autonomous organization"
├─ dao_request_lock — "DAO module to create a request locks"
├─ dao_treasury — "A treasury plugin for the DAO module"
math
├─ fixed_point64 — "Fixed point math module for x << 64 numbers"
├─ fixed_point_roll — "Fixed point math module for numbers with 1e9 decimals"
├─ fixed_point_wad — "Fixed point math module for numbers with 1e18 decimals"
├─ math128 — "Utility math functions for u128 numbers"
├─ math256 — "Utility math functions for u256 numbers"
├─ math64 — "Utility math functions for u64 numbers"
├─ int — "Module to handle unsigned integer operations"
utils
├─ comparator — "Module to compare u8 vectors (bits)"
├─ merkle_proof — "Module to verify Merkle proofs"
├─ ascii_utils — "A set of functions to operate on ASCII strings"
├─ vectors — "Utility functions for vectors"
```

## Directories

```ml
contracts — "Move modules"
utils - "Typescript utilities to support Move modules"
audits - "Audit reports"
examples - "Unaudited implementations of SuiTears and other Move scraps"
```

## Contributing

This repository is meant to provide Sui Move developers with production ready plug and play modules.

Feel free to make a pull request.

Do refer to the [contribution guidelines](https://github.com/interest-protocol/suitears/blob/main/CONTRIBUTING.md) for more details.

## Credits

Suitears💧 modules are inspired/based on many open-source projects. The list below is not extensive by any means.

- Aptos
- Movemate
- PancakeSwap
- Scallop
- Starcoin

## Safety

This is provided on an "as is" and "as available" basis.

We **do not give any warranties** and **will not be liable for any loss** incurred through any use of this codebase.

While Suitears💧 has been heavily tested, there may be parts that may exhibit unexpected emergent behavior when used with other code, or may break in future Move versions.

Please always include your own thorough tests when using Suitears💧 to make sure it works correctly with your code.
