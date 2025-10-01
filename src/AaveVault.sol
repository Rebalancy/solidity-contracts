// SPDX-License-Identifier: Apache-2.0
pragma solidity 0.8.28;

import {ERC4626} from "@openzeppelin/token/ERC20/extensions/ERC4626.sol";
import {IERC20} from "@openzeppelin/token/ERC20/IERC20.sol";
import {ERC20} from "@openzeppelin/token/ERC20/ERC20.sol";
import {SafeERC20} from "@openzeppelin/token/ERC20/utils/SafeERC20.sol";
import {Math} from "@openzeppelin/utils/math/Math.sol";
import {EIP712} from "@openzeppelin/utils/cryptography/EIP712.sol";
import {SignatureChecker} from "@openzeppelin/utils/cryptography/SignatureChecker.sol";
import {IERC20Metadata} from "@openzeppelin/token/ERC20/extensions/IERC20Metadata.sol";
import {InvalidSignature} from "./Errors.sol";

contract AaveVault is ERC4626, EIP712 {
    using SafeERC20 for IERC20;
    using Math for uint256;

    // ------- Snapshot EIP-712 -------
    struct CrossChainBalanceSnapshot {
        uint256 balance; // cross-chain balance in aTokens
        uint256 nonce; // anti-replay
        uint256 deadline; // expiration (unix timestamp)
        uint256 assets; // assets to deposit in the vault
        address receiver; // receiver of the shares
    }

    string private constant SIGNING_DOMAIN = "AaveVault";
    string private constant SIGNING_DOMAIN_VERSION = "1";
    bytes32 public constant SNAPSHOT_TYPEHASH = keccak256(
        "CrossChainBalanceSnapshot(uint256 balance,uint256 nonce,uint256 deadline,uint256 assets,address receiver)"
    );

    uint256 private constant MOCK_TOTAL_ASSETS = 100_000 * 1e6;
    uint256 public crossChainBalanceNonce;
    uint256 public crossChainInvestedAssets;
    address public immutable AI_AGENT;

    /*//////////////////////////////////////////////////////////////
                                EVENTS
    //////////////////////////////////////////////////////////////*/
    event CrossChainBalanceUpdated(uint256 aTokenBalanceBefore, uint256 aTokenBalanceAfter);

    constructor(IERC20 _underlying, string memory _name, string memory _symbol)
        ERC4626(_underlying)
        ERC20(_name, _symbol)
        EIP712(SIGNING_DOMAIN, SIGNING_DOMAIN_VERSION)
    {
        AI_AGENT = msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                        OVERRIDE FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function decimals() public view virtual override(ERC4626) returns (uint8) {
        return IERC20Metadata(asset()).decimals();
    }

    function totalAssets() public view virtual override returns (uint256) {
        return MOCK_TOTAL_ASSETS;
    }

    /// @dev Deposit function that allows deposits only if there are no cross-chain invested assets.
    function deposit(uint256, address) public virtual override returns (uint256) {
        revert("not implemented");
    }

    function depositWithExtraInfoViaSignature(CrossChainBalanceSnapshot calldata _snapshot, bytes calldata signature)
        public
        virtual
        returns (uint256)
    {
        // Hash EIP-712 + verify signature
        bytes32 digest = _hashSnapshot(_snapshot);
        if (!SignatureChecker.isValidSignatureNow(AI_AGENT, digest, signature)) {
            revert InvalidSignature();
        }

        // Increment nonce to prevent replay attacks
        unchecked {
            crossChainBalanceNonce++;
        }

        crossChainInvestedAssets = _snapshot.balance;

        return MOCK_TOTAL_ASSETS;
    }

    function maxDeposit(address) public pure override returns (uint256) {
        return MOCK_TOTAL_ASSETS;
    }

    function _withdraw(address, address, address, uint256, uint256) internal virtual override {
        revert("not implemented");
    }

    /*//////////////////////////////////////////////////////////////
                         INTERNAL FUNCTIONS
    //////////////////////////////////////////////////////////////*/

    function getAvailableAssets() internal pure returns (uint256) {
        return MOCK_TOTAL_ASSETS;
    }

    /*//////////////////////////////////////////////////////////////
                        EIP-712 SNAPSHOT FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function _hashSnapshot(CrossChainBalanceSnapshot memory _snapshot) internal view returns (bytes32) {
        return _hashTypedDataV4(
            keccak256(
                abi.encode(
                    SNAPSHOT_TYPEHASH,
                    _snapshot.balance,
                    _snapshot.nonce,
                    _snapshot.deadline,
                    _snapshot.assets,
                    _snapshot.receiver
                )
            )
        );
    }
}
