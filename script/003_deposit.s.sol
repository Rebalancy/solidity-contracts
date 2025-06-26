// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {console2} from "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";

import {IERC20Metadata} from "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";
import {DeployerUtils} from "@utils/DeployerUtils.sol";
import {Constants} from "@constants/Constants.sol";

import {BaseScript} from "./BaseScript.s.sol";
import {AaveVault} from "../src/AaveVault.sol";

contract DepositScript is BaseScript {
    using DeployerUtils for Vm;
    using DeploymentUtils for Vm;

    constructor() BaseScript() {
        _loadConfiguration();
    }

    function run() public {
        console2.log("Deposit and Withdraw Script");

        vm.startBroadcast(deployer);

        address mockUSDCAddress = vm.loadDeploymentAddress(Constants.MOCK_USDC);
        address aaveVaultAddress = vm.loadDeploymentAddress(Constants.AAVE_VAULT);

        require(mockUSDCAddress != address(0), "MockUSDC not deployed");
        require(aaveVaultAddress != address(0), "AaveVault not deployed");

        IERC20Metadata mockUSDC = IERC20Metadata(mockUSDCAddress);
        AaveVault aaveVault = AaveVault(aaveVaultAddress);

        console2.log("MockUSDC Address: %s", address(mockUSDC));
        console2.log("AaveVault Address: %s", address(aaveVault));

        // Approve the AaveVault to spend MockUSDC
        mockUSDC.approve(address(aaveVault), type(uint256).max);

        console2.log("Approved AaveVault to spend MockUSDC");

        // Deposit 1000 MockUSDC into AaveVault
        uint256 depositAmount = 100_000 * 10 ** mockUSDC.decimals();
        console2.log("Depositing %s MockUSDC into AaveVault", depositAmount);
        aaveVault.deposit(depositAmount, deployer);

        console2.log("Deposit successful");
        vm.stopBroadcast();
    }
}
