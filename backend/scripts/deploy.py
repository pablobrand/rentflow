from brownie import accounts, config, interface, network
from web3 import Web3
from scripts.get_weth import get_weth
from scripts.helpful_scripts import get_account

amount = Web3.toWei(0.01, "ether")


def main():
    tenant_account = get_account(index=1)
    erc20_address = config["networks"][network.show_active()]["weth_token"]
    # if network.show_active() in ["mainnet-fork"]:
    #     get_weth(account=tenant_account)
    lending_pool = get_lending_pool()
    approve_erc20(amount, lending_pool.address, erc20_address, tenant_account)
    print("Depositing...")
    lending_pool.deposit(erc20_address, amount, tenant_account.address, 0, {"from": tenant_account, "gas_limit": 100000})
    print("Deposited!")
    # borrowable_eth, total_debt_eth = get_borrowable_data(lending_pool, account)
    # print(f"LETS BORROW IT ALL")
    # erc20_eth_price = get_asset_price()
    # amount_erc20_to_borrow = (1 / erc20_eth_price) * (borrowable_eth * 0.95)
    # print(f"We are going to borrow {amount_erc20_to_borrow} DAI")
    # borrow_erc20(lending_pool, amount_erc20_to_borrow, account)

    # borrowable_eth, total_debt_eth = get_borrowable_data(lending_pool, account)
    # # amount_erc20_to_repay = (1 / erc20_eth_price) * (total_debt_eth * 0.95)
    # repay_all(amount_erc20_to_borrow, lending_pool, account)
    # # Then print out our borrowable data
    # get_borrowable_data(lending_pool, account)


# def get_account():
#     if network.show_active() in ["hardhat", "development", "mainnet-fork"]:
#         return accounts[0]
#     if network.show_active() in config["networks"]:
#         account = accounts.add(config["wallets"]["from_key"])
#         return account
#     return None


def get_lending_pool():
    lending_pool_addresses_provider = interface.ILendingPoolAddressesProvider(
        config["networks"][network.show_active()]["lending_pool_addresses_provider"]
    )
    lending_pool_address = lending_pool_addresses_provider.getLendingPool()
    lending_pool = interface.ILendingPool(lending_pool_address)
    return lending_pool


def approve_erc20(amount, lending_pool_address, erc20_address, account):
    print("Approving ERC20...")
    erc20 = interface.IERC20(erc20_address)
    tx_hash = erc20.approve(lending_pool_address, amount, {"from": account})
    tx_hash.wait(1)
    print("Approved!")
    return True


def get_borrowable_data(lending_pool, account):
    (
        total_collateral_eth,
        total_debt_eth,
        available_borrow_eth,
        current_liquidation_threshold,
        tlv,
        health_factor,
    ) = lending_pool.getUserAccountData(account.address)
    available_borrow_eth = Web3.fromWei(available_borrow_eth, "ether")
    total_collateral_eth = Web3.fromWei(total_collateral_eth, "ether")
    total_debt_eth = Web3.fromWei(total_debt_eth, "ether")
    print(f"You have {total_collateral_eth} worth of ETH deposited.")
    print(f"You have {total_debt_eth} worth of ETH borrowed.")
    print(f"You can borrow {available_borrow_eth} worth of ETH.")
    return (float(available_borrow_eth), float(total_debt_eth))


def borrow_erc20(lending_pool, amount, account, erc20_address=None):
    erc20_address = (
        erc20_address
        if erc20_address
        else config["networks"][network.show_active()]["aave_dai_token"]
    )
    # 1 is stable interest rate
    # 0 is the referral code
    transaction = lending_pool.borrow(
        erc20_address,
        Web3.toWei(amount, "ether"),
        1,
        0,
        account.address,
        {"from": account},
    )
    transaction.wait(1)
    print(f"Congratulations! We have just borrowed {amount}")


def get_asset_price():
    # For mainnet we can just do:
    # return Contract(f"{pair}.data.eth").latestAnswer() / 1e8
    dai_eth_price_feed = interface.AggregatorV3Interface(
        config["networks"][network.show_active()]["dai_eth_price_feed"]
    )
    latest_price = Web3.fromWei(dai_eth_price_feed.latestRoundData()[1], "ether")
    print(f"The DAI/ETH price is {latest_price}")
    return float(latest_price)


def repay_all(amount, lending_pool, account):
    approve_erc20(
        Web3.toWei(amount, "ether"),
        lending_pool,
        config["networks"][network.show_active()]["aave_dai_token"],
        account,
    )
    tx = lending_pool.repay(
        config["networks"][network.show_active()]["aave_dai_token"],
        Web3.toWei(amount, "ether"),
        1,
        account.address,
        {"from": account},
    )
    tx.wait(1)
    print("Repaid!")


if __name__ == "__main__":
    main()










# from operator import add
# from brownie import LandLord, network, config, AaveLending, interface
# from scripts.helpful_scripts import get_account
# from scripts import get_weth
# from web3 import Web3


# # test this as a contribution. work
# def deploy_contract():
#     landlord_account = get_account(index=0)
#     landlord_contract = LandLord.deploy({"from": landlord_account})
#     print(f"Contract deployed to {landlord_contract.address}")


# def add_tenant(acc_index):
#     landlord_account = get_account(index=0)
#     tenant_address = get_account(index=acc_index)
#     land_contract = LandLord[-1]
#     print(f"MEEE TENANT ADDRESS {tenant_address.address}")
#     land_contract.addTenant(tenant_address.address, {"from": landlord_account})


# def pay_rent(acc_index, value_amount: 0.001):
#     tenant_address = get_account(index=acc_index)
#     land_contract = LandLord[-1]
#     value = Web3.toWei(value_amount, "ether")
#     print(f"Amount paid -> {value}")
#     land_contract.payRent({"from": tenant_address, "value": value})
#     print("SUCCESSFULLY PAID")


# def islord(acc_index):
#     tenant_address = get_account(index=acc_index)
#     land_contract = LandLord[-1]
#     check = land_contract.isOwner({"from": tenant_address})
#     print(f"Are you the Owner?: {check}")


# def get_balance():
#     landlord_account = get_account(index=0)
#     land_contract = LandLord[-1]
#     wei_balance = land_contract.getBalance({"from": landlord_account})
#     value = Web3.fromWei(wei_balance, "ether")
#     return value


# def approve_erc20(amount, address_to_approve, erc20_address, account):
#     print("Approving ERC20...")
#     erc20 = interface.IERC20(erc20_address)
#     tx_hash = erc20.approve(address_to_approve, amount, {"from": account})
#     tx_hash.wait(1)
#     print("Approved!")
#     return True


# def make_aave_pool():
#     pool_address_provider = interface.IPoolAddressesProvider(
#         config["networks"][network.show_active()]["lending_pool_addresses_provider"]
#     )
#     lending_pool_address = pool_address_provider.getPool()
#     pool_address = interface.IPool(lending_pool_address)
#     return pool_address


# def transfer_to_aave(amount, erc20_address, aave_pool):
#     tenant_address = get_account(index=1)
#     landlord_account = get_account(index=0)
#     land_contract = LandLord[-1]
#     # amount = Web3.toWei(0.1, "ether")
#     # amount = 0.01 * 1e18

#     approve_erc20(amount, land_contract.address, erc20_address, tenant_address)
#     approve_erc20(amount, aave_pool.address, erc20_address, tenant_address)
#     # tx = land_contract.approveTransfer({"from": tenant_address})
#     # tx.wait(1)
#     land_contract.transferToAave({"from": tenant_address, "gas_limit": 100000})


# def deploy_aave_lending():
#     landlord_account = get_account(index=0)
#     erc20_address = config["networks"][network.show_active()]["weth_token"]
#     # make the pool here and send it in
#     pool_address = make_aave_pool()
#     aave_contract = AaveLending.deploy(
#         erc20_address, pool_address, {"from": landlord_account}
#     )
#     print(f"Aave Contract Deployed!!: {aave_contract.address}")
#     return aave_contract, pool_address


# def send_to_aave():
#     landlord_account = get_account(index=0)
#     tenant_address = get_account(index=1)
#     amount = 0.01 * 1e18
#     # value_amount = Web3.toWei(0.01, "ether")
#     # get_weth(value_amount=value_amount)
#     aave_lending_service, aave_pool = deploy_aave_lending()
#     erc20_address = config["networks"][network.show_active()]["weth_token"]
#     LandLord.deploy(
#         landlord_account.address,
#         tenant_address.address,
#         amount,
#         erc20_address,
#         aave_lending_service.address,
#         {"from": landlord_account},
#     )

#     # add_tenant(1)
#     # pay_rent(1, 0.001)
#     # print(f"Acct balance AFTER paying rent: {get_balance()}")
#     transfer_to_aave(
#         amount=amount,
#         erc20_address=erc20_address,
#         aave_pool=aave_pool,
#     )

    # land_contract = LandLord[-1]
    # # account = get_account()
    # if network.show_active() in ["mainnet-fork"]:
    #     get_weth(account=landlord_account)

    # approve_erc20(amount, lending_pool.address, erc20_address, account)
    # print("Depositing...")
    # lending_pool.deposit(erc20_address, amount, account.address, 0, {"from": account})
    # print("Deposited!")
    # borrowable_eth, total_debt_eth = get_borrowable_data(lending_pool, account)
    # print(f"LETS BORROW IT ALL")
    # erc20_eth_price = get_asset_price()
    # amount_erc20_to_borrow = (1 / erc20_eth_price) * (borrowable_eth * 0.95)
    # print(f"We are going to borrow {amount_erc20_to_borrow} DAI")
    # borrow_erc20(lending_pool, amount_erc20_to_borrow, account)


# def main():
#     # deploy_contract()
#     # add_tenant()
#     # pay_rent()
#     send_to_aave()

    # deploy_fund_me()
    # print(f"Acct balance BEFORE paying rent: {get_balance()}")

    # # for account in range(1, 5):
    # #     add_tenant(account)
    # #     pay_rent(account)
    # islord(0)
    # print(f"Acct balance AFTER paying rent: {get_balance()}")


# # class DeployLottery:

# #     def __init__(self, account_number: int = 0) -> None:
# #         self.__account_number = account_number

# #     def deploy_lottery(self):
# #         account = get_account(self.__account_number)
# #         lottery = Lottery.deploy(
# #             get_contract("eth_usd_price_feed").address,
# #             get_contract("vrf_coordinator").address,
# #             get_contract("link_token").address,
# #             config["networks"][network.show_active()]["fee"],
# #             config["networks"][network.show_active()]["keyhash"],
# #             {"from": account},
# #             publish_source=config["networks"][network.show_active()].get("verify", False),
# #         )
# #         print("Deployed lottery!")
# #         return lottery

# #     def start_lottery(self):
# #         account = get_account(self.__account_number)
# #         lottery = Lottery[-1]
# #         starting_tx = lottery.startLottery({"from": account})
# #         starting_tx.wait(1)
# #         print("The lottery is started!")

# #     def enter_lottery(self):
# #         account = get_account(self.__account_number)
# #         lottery = Lottery[-1]
# #         value = lottery.getEntranceFee() + 100000000
# #         tx = lottery.enter({"from": account, "value": value})
# #         tx.wait(1)
# #         print("You entered the lottery!")

# #     def end_lottery(self):
# #         account = get_account(self.__account_number)
# #         lottery = Lottery[-1]
# #         # fund the contract
# #         # then end the lottery
# #         tx = fund_with_link(lottery.address)
# #         tx.wait(1)
# #         ending_transaction = lottery.endLottery({"from": account})
# #         ending_transaction.wait(1)
# #         time.sleep(180)
# #         print(f"{lottery.recentWinner()} is the new winner!")


# # def main():
# #     DeployLottery()
