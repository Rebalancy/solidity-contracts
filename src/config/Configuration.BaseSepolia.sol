// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {Configuration} from "./Configuration.sol";

library ConfigurationBaseSepolia {
    function getConfig() external pure returns (Configuration.ConfigValues memory) {
        revert("ConfigurationBaseSepolia: not implemented");
    }
}
