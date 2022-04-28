from brownie import network, config, accounts

FORKED_LOCAL_ENVIRONMENTS = ["mainnet-fork", "mainnet-fork-dev"]
LOCAL_BLOCKCHAIN_ENVIRONMENTS = ["development", "ganache-local"]

DECIMALS = 8
STARTING_PRICE = 200000000000


def get_account(index=None, id=None):
    if index:
        return accounts[index]
    if id:
        return accounts.load(id)
    if (
        network.show_active() in LOCAL_BLOCKCHAIN_ENVIRONMENTS
        or network.show_active() in FORKED_LOCAL_ENVIRONMENTS
    ):
        return accounts[0]
    return accounts.add(config["wallets"]["from_key"])


# def deploy_mocks():
#     print(f"The active network is {network.show_active()}")
#     print("Deploying Mocks...")
#     if len(MockV3Aggregator) <= 0:
#         MockV3Aggregator.deploy(DECIMALS, STARTING_PRICE, {"from": get_account()})
#     print("Mocks Deployed!")