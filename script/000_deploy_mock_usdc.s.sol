// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {console2} from "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";
import {DeployerUtils} from "@utils/DeployerUtils.sol";
import {Constants} from "@constants/Constants.sol";
import {MockUSDC} from "@mocks/MockUSDC.sol";
import {BaseScript} from "./BaseScript.s.sol";

contract DeployMockUSDCScript is BaseScript {
    using DeployerUtils for Vm;
    using DeploymentUtils for Vm;

    MockUSDC public mockUSDC;

    function run() public {
        console2.log("Deploying MockUSDC contract");

        vm.startBroadcast(deployer);

        mockUSDC = new MockUSDC();

        mockUSDC.mint(0xCA78C111CF45FE0B8D4F3918632DDc33917Af882, 100_000_000 ether); // Mint 1 million USDC to 0xCA78C111CF45FE0B8D4F3918632DDc33917Af882

        vm.stopBroadcast();

        vm.saveDeploymentAddress(Constants.MOCK_USDC, address(mockUSDC));
    }
}
