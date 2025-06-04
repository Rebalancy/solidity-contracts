// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {console2} from "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";
import {DeployerUtils} from "@utils/DeployerUtils.sol";

import {BaseScript} from "./BaseScript.s.sol";

contract DepositAndWithdrawScript is BaseScript {
    using DeployerUtils for Vm;
    using DeploymentUtils for Vm;

    constructor() BaseScript() {
        _loadConfiguration();
    }

    function run() public {
        console2.log("Deposit and Withdraw Script");

        vm.startBroadcast(deployer);

        // TODO: Implement deposit and withdraw logic
        // Assuming MockUSDC is already deployed and its address is saved
        address mockUSDCAddress = vm.loadDeploymentAddress("MockUSDC");
        require(mockUSDCAddress != address(0), "MockUSDC not deployed");

        vm.stopBroadcast();
    }
}
