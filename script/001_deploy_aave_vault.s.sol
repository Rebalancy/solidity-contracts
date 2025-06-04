// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {console2} from "forge-std/console2.sol";
import {Vm} from "forge-std/Vm.sol";

import {IERC20Metadata} from "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";

import {DeploymentUtils} from "@utils/DeploymentUtils.sol";
import {DeployerUtils} from "@utils/DeployerUtils.sol";
import {Constants} from "@constants/Constants.sol";

import {AaveVault} from "../src/AaveVault.sol";
import {BaseScript} from "./BaseScript.s.sol";

contract DeployAaveVaultScript is BaseScript {
    using DeployerUtils for Vm;
    using DeploymentUtils for Vm;

    AaveVault public aaveVault;

    constructor() BaseScript() {
        _loadConfiguration();
    }

    function run() public {
        console2.log("Deploying AaveVault contract");

        vm.startBroadcast(deployer);

        IERC20Metadata underlyingToken = IERC20Metadata(config.UNDERLYING_TOKEN);
        console2.log("Underlying Token Address %s", address(underlyingToken));
        console2.log("Underlying Token Name %s", underlyingToken.name());
        console2.log("Underlying Token Symbol %s", underlyingToken.symbol());

        aaveVault = new AaveVault(underlyingToken, config.AGENT_ADDRESS, config.VAULT_NAME, config.VAULT_SYMBOL);

        vm.stopBroadcast();

        vm.saveDeploymentAddress(Constants.AAVE_VAULT, address(aaveVault));
    }
}
