// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {Vm} from "forge-std/Vm.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";

import {Configuration} from "./Configuration.sol";

library ConfigurationBaseSepolia {
    using DeploymentUtils for Vm;

    function getConfig(Vm _vm) external view returns (Configuration.ConfigValues memory) {
        address mockUSDC = _vm.loadDeploymentAddress("MockUSDC");
        require(mockUSDC != address(0), "MockUSDC not deployed");

        return Configuration.ConfigValues({
            UNDERLYING_TOKEN: mockUSDC, // Mock USDC address from deployment
            AGENT_ADDRESS: 0xd7447e12D4Da4a0aa7ca4B0D270f4687683C3b0C, // AI Agent address
            VAULT_NAME: "Aave Rebalancer",
            VAULT_SYMBOL: "AAVE-RB"
        });
    }
}
