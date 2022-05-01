from brownie import LandLord, network, config
from scripts.helpful_scripts import get_account
from web3 import Web3

# test this
def deploy_fund_me():
    landlord_account = get_account(index=0)
    landlord_contract = LandLord.deploy({"from": landlord_account})
    print(f"Contract deployed to {landlord_contract}")


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


def main():
    deploy_fund_me()
    print(f"Acct balance BEFORE paying rent: {get_balance()}")

    for account in range(1, 5):
        add_tenant(account)
        pay_rent(account)

    islord(0)
    print(f"Acct balance AFTER paying rent: {get_balance()}")


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
