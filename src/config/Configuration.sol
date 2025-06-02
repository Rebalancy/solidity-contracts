// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import "@openzeppelin/utils/Strings.sol";

library Configuration {
    using Strings for uint64;

    struct ConfigValues {
        address UNDERLYING_TOKEN;
        address AAVE_USDC_LENDING_POOL_ADDRESS;
        address AGENT_ADDRESS;
        string VAULT_NAME;
        string VAULT_SYMBOL;
    }

    function load(string memory _networkId) external pure returns (ConfigValues memory) {
        revert(string(abi.encodePacked("Configuration: network not supported ", _networkId)));
    }
}
