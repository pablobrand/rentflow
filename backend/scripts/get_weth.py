from brownie import accounts, config, network, interface


def main():
    """
    Runs the get_weth function to get WETH
    """
    get_weth()


def get_weth(account=None, value_amount: int = 0.1 * 1e18):
    """
    Mints WETH by depositing ETH.
    """
    account = (
        account if account else accounts.add(config["wallets"]["from_key_2"])
    )  # add your keystore ID as an argument to this call

    weth = interface.WethInterface(
        config["networks"][network.show_active()]["weth_token"]
    )
    tx = weth.deposit({"from": account, "value": value_amount})
    print(f"Received {value_amount} WETH")
    return tx
