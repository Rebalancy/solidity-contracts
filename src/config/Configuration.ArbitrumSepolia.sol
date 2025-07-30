// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {Vm} from "forge-std/Vm.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";

import {Configuration} from "./Configuration.sol";

library ConfigurationArbitrumSepolia {
    using DeploymentUtils for Vm;

    function getConfig(Vm) external pure returns (Configuration.ConfigValues memory) {
        return Configuration.ConfigValues({
            UNDERLYING_TOKEN: 0x75faf114eafb1BDbe2F0316DF893fd58CE46AA4d, // USDC address from deployment https://developers.circle.com/stablecoins/usdc-contract-addresses#testnet
            AGENT_ADDRESS: 0xD5aC5A88dd3F1FE5dcC3ac97B512Faeb48d06AF0, // AI Agent address
            VAULT_NAME: "Aave Rebalancer",
            VAULT_SYMBOL: "AAVE-RB"
        });
    }
}
