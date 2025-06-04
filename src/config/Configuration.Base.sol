// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {Configuration} from "./Configuration.sol";

library ConfigurationBaseMainnet {
    function getConfig() external pure returns (Configuration.ConfigValues memory) {
        revert("ConfigurationBaseMainnet: not implemented");
    }
}
