// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {ERC4626} from "@openzeppelin/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {Math} from "@openzeppelin/utils/math/Math.sol";
import {InvalidAmount, MaximumInvestmentExceeded, NotEnoughAssetsToInvest} from "./Errors.sol";

contract AaveVault is ERC4626 {
    using SafeERC20 for IERC20;
    using Math for uint256;

    address public immutable AI_AGENT;
    uint256 public immutable MAX_TOTAL_DEPOSITS = 100_000_000 ether; // 100M

    uint256 public amountInvested;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event AssetsInvested(address indexed agent, uint256 amount, uint256 totalInvested);
    event YieldHarvested(address indexed agent, uint256 yieldAmount, uint256 withdrawnAmount);

    constructor(IERC20 _underlying, address _agentAddress, string memory _name, string memory _symbol)
        ERC4626(_underlying)
        ERC20(_name, _symbol)
    {
        AI_AGENT = _agentAddress;

        // TODO: Creo que debo aprobar USDC para la derived address.
    }

    /*//////////////////////////////////////////////////////////////
                        OVERRIDE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function totalAssets() public view virtual override returns (uint256) {
        uint256 assetsNotInvested = IERC20(asset()).balanceOf(address(this));
        uint256 assetsInvested = getInvestedAssets();
        return assetsNotInvested + assetsInvested;
    }

    /*//////////////////////////////////////////////////////////////
                            AGENT FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function harvest(uint256 _yieldAmount) external onlyAIAgent {
        if (_yieldAmount == 0) {
            revert InvalidAmount();
        }

        amountInvested += _yieldAmount;

        emit YieldHarvested(msg.sender, _yieldAmount, amountInvested);
    }

    function invest(uint256 _amount) external onlyAIAgent {
        if (_amount == 0) {
            revert InvalidAmount();
        }
        if (_amount + amountInvested > MAX_TOTAL_DEPOSITS) {
            revert MaximumInvestmentExceeded();
        }

        // Check if the vault has enough assets available
        if (getAvailableAssets() < _amount) {
            revert NotEnoughAssetsToInvest();
        }

        // Transfer the underlying asset to the agent for investment
        IERC20(asset()).safeTransferFrom(address(this), msg.sender, _amount);

        amountInvested += _amount;

        emit AssetsInvested(msg.sender, _amount, amountInvested);
    }

    /*//////////////////////////////////////////////////////////////
                         INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function getAvailableAssets() internal view returns (uint256) {
        return IERC20(asset()).balanceOf(address(this));
    }

    function getInvestedAssets() internal view returns (uint256) {
        return amountInvested;
    }

    modifier onlyAIAgent() {
        // TODO: Replace with if and revert instead of require
        require(msg.sender == AI_AGENT, "Only AI agent can call this function");
        _;
    }
}
