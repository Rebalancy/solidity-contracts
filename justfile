set dotenv-load
set export

# deployments
deploy_aave_vault JSON_RPC_URL SENDER:
    echo "Deploying Aave Vault"
    forge script script/001_deploy_aave_vault.s.sol:DeployAaveVaultScript --rpc-url $JSON_RPC_URL --sender $SENDER --broadcast --ffi -vvvv

deploy_mock_usdc JSON_RPC_URL SENDER:
    echo "Deploying MockUSDC"
    forge script script/000_deploy_mock_usdc.s.sol:DeployMockUSDCScript --rpc-url $JSON_RPC_URL --sender $SENDER --broadcast --ffi -vvvv

deploy_local:
    echo "Deploying contracts locally"
    NETWORK_ID=$CHAIN_ID_LOCAL MNEMONIC=$MNEMONIC_LOCAL just deploy_mock_usdc $RPC_URL_LOCAL $SENDER_LOCAL
    NETWORK_ID=$CHAIN_ID_LOCAL MNEMONIC=$MNEMONIC_LOCAL just deploy_aave_vault $RPC_URL_LOCAL $SENDER_LOCAL

deploy_base_sepolia:
    echo "Deploying contracts to Base Sepolia"
    NETWORK_ID=$CHAIN_ID_BASE_SEPOLIA MNEMONIC=$MNEMONIC_TESTNET just deploy_mock_usdc $RPC_URL_BASE_SEPOLIA $SENDER_TESTNET
    sleep 10
    NETWORK_ID=$CHAIN_ID_BASE_SEPOLIA MNEMONIC=$MNEMONIC_TESTNET just deploy_aave_vault $RPC_URL_BASE_SEPOLIA $SENDER_TESTNET
    
# anvil
start_anvil:
    echo "Starting Anvil"
    anvil --port 8555 --chain-id 1337 --mnemonic "$MNEMONIC_LOCAL"

# forge
compile: 
    echo "Compiling contracts"
    forge build

# testing
test_unit:
    echo "Running unit tests"
    forge test --match-path "test/unit/**/*.sol" --rpc-url $RPC_URL_ETHEREUM_MAINNET -vvvv

test_coverage:
    forge coverage --rpc-url $RPC_URL_ETHEREUM_MAINNET --report lcov 
    lcov --remove ./lcov.info --output-file ./lcov.info 'script' 'DeployerUtils.sol' 'DeploymentUtils.sol' 'config/*' 'helpers/*'
    genhtml lcov.info -o coverage --branch-coverage --ignore-errors category

test CONTRACT:
    forge test --mc {{CONTRACT}} --ffi -vvvv

test_only CONTRACT TEST:
    forge test --mc {{CONTRACT}} --mt {{TEST}} --rpc-url $RPC_URL_ETHEREUM_MAINNET --ffi -vvvv

# formatting
format: 
    echo "Formatting contracts"
    forge fmt

format-check:
    echo "Checking contract formatting"
    forge fmt --check