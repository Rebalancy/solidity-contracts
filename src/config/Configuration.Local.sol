// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {Vm} from "forge-std/Vm.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";

import {Configuration} from "./Configuration.sol";

library ConfigurationLocal {
    using DeploymentUtils for Vm;

    function getConfig(Vm _vm) external view returns (Configuration.ConfigValues memory) {
        address mockUSDC = _vm.loadDeploymentAddress("MockUSDC");
        require(mockUSDC != address(0), "MockUSDC not deployed");

        return Configuration.ConfigValues({
            UNDERLYING_TOKEN: mockUSDC, // Mock USDC address from deployment
            AGENT_ADDRESS: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            VAULT_NAME: "Aave Rebalancer",
            VAULT_SYMBOL: "AAVE-RB",
            POOL_ADDRESS: address(0),
            A_TOKEN_ADDRESS: address(0)
        });
    }
}
