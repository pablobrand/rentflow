from brownie import LandLord, network, config
from scripts.helpful_scripts import get_account
from web3 import Web3


# test this as a contribution. work
def deploy_contract():
    landlord_account = get_account(index=0)
    landlord_contract = LandLord.deploy({"from": landlord_account})
    print(f"Contract deployed to {landlord_contract.address}")


def add_tenant(acc_index):
    landlord_account = get_account(index=0)
    tenant_address = get_account(index=acc_index)
    land_contract = LandLord[-1]
    print(f"MEEE TENANT ADDRESS {tenant_address.address}")
    land_contract.addTenant(tenant_address.address, {"from": landlord_account})


def pay_rent(acc_index):
    tenant_address = get_account(index=acc_index)
    land_contract = LandLord[-1]
    value = Web3.toWei(1, "ether")
    print(f"value -> {value}")
    land_contract.payRent({"from": tenant_address, "value": value})
    print("SUCCESSFULLY PAID")


def islord(acc_index):
    tenant_address = get_account(index=acc_index)
    land_contract = LandLord[-1]
    check = land_contract.isOwner({"from": tenant_address})
    print(f"Are you the Owner?: {check}")


def get_balance():
    landlord_account = get_account(index=0)
    land_contract = LandLord[-1]
    wei_balance = land_contract.getBalance({"from": landlord_account})
    value = Web3.fromWei(wei_balance, "ether")
    return value


def check_upkeep():
    landlord_account = get_account(index=0)
    land_contract = LandLord[-1]
    account = get_account()
    erc20_address = config["networks"][network.show_active()]["weth_token"]
    if network.show_active() in ["mainnet-fork"]:
        get_weth(account=account)
    lending_pool = get_lending_pool()
    approve_erc20(amount, lending_pool.address, erc20_address, account)
    print("Depositing...")
    lending_pool.deposit(erc20_address, amount, account.address, 0, {"from": account})
    print("Deposited!")
    borrowable_eth, total_debt_eth = get_borrowable_data(lending_pool, account)
    print(f"LETS BORROW IT ALL")
    erc20_eth_price = get_asset_price()
    amount_erc20_to_borrow = (1 / erc20_eth_price) * (borrowable_eth * 0.95)
    print(f"We are going to borrow {amount_erc20_to_borrow} DAI")
    borrow_erc20(lending_pool, amount_erc20_to_borrow, account)


def send_to_aave():
    landlord_account = get_account(index=0)
    land_contract = LandLord[-1]


def main():
    deploy_contract()
    add_tenant()
    pay_rent()
    send_to_aave()

    # deploy_fund_me()
    # print(f"Acct balance BEFORE paying rent: {get_balance()}")

    # # for account in range(1, 5):
    # #     add_tenant(account)
    # #     pay_rent(account)
    # islord(0)
    # print(f"Acct balance AFTER paying rent: {get_balance()}")


# class DeployLottery:

#     def __init__(self, account_number: int = 0) -> None:
#         self.__account_number = account_number

#     def deploy_lottery(self):
#         account = get_account(self.__account_number)
#         lottery = Lottery.deploy(
#             get_contract("eth_usd_price_feed").address,
#             get_contract("vrf_coordinator").address,
#             get_contract("link_token").address,
#             config["networks"][network.show_active()]["fee"],
#             config["networks"][network.show_active()]["keyhash"],
#             {"from": account},
#             publish_source=config["networks"][network.show_active()].get("verify", False),
#         )
#         print("Deployed lottery!")
#         return lottery

#     def start_lottery(self):
#         account = get_account(self.__account_number)
#         lottery = Lottery[-1]
#         starting_tx = lottery.startLottery({"from": account})
#         starting_tx.wait(1)
#         print("The lottery is started!")

#     def enter_lottery(self):
#         account = get_account(self.__account_number)
#         lottery = Lottery[-1]
#         value = lottery.getEntranceFee() + 100000000
#         tx = lottery.enter({"from": account, "value": value})
#         tx.wait(1)
#         print("You entered the lottery!")

#     def end_lottery(self):
#         account = get_account(self.__account_number)
#         lottery = Lottery[-1]
#         # fund the contract
#         # then end the lottery
#         tx = fund_with_link(lottery.address)
#         tx.wait(1)
#         ending_transaction = lottery.endLottery({"from": account})
#         ending_transaction.wait(1)
#         time.sleep(180)
#         print(f"{lottery.recentWinner()} is the new winner!")


# def main():
#     DeployLottery()
