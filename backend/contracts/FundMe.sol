// SPDX-License-Identifier: MIT

pragma solidity ^0.6.6;

// importing from chainlink npm package
// google: npm @chainlink/contracts
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

contract FundMe {
    using SafeMathChainlink for uint256;
    // use safemath anytime youre using version < 0.8.0

    // buttons are blue cause theyre "views"
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;
    address public owner;
    AggregatorV3Interface public priceFeed;

    constructor(address _priceFeed) public {
        priceFeed = AggregatorV3Interface(_priceFeed);
        owner = msg.sender;
    }

    function fund() public payable {
        // $50
        uint256 minimumUSD = 50 * 10**18;
        // 1gwei < $50
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function getVersion() public view returns (uint256) {
        // here AggregatorV3Interface is th type
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        (, int256 answer, , , ) = priceFeed.latestRoundData();

        return uint256(answer * 10000000000); // returns price w 18 decimal places
        // 346992340857 == $3,469.92340857 USD
    }

    // 1 gwei == 1000000000 wei
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
        return ethAmountInUsd;
        // 0.000003471445878830 - GWEI x 1_000_000_000 = 3,471 ETH/USD
    }

    function getEntranceFee() public view returns (uint256) {
        // minimum USD
        uint256 minimumUSD = 50 * 10**18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10**18;
        return (minimumUSD * precision) / price;
    }

    //modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
    // is used to change the behavior of a function in a declarative way
    modifier onlyOwner() {
        //is the message sender owner of the contract?
        require(msg.sender == owner, "Youre not the owner!!");
        _;
    }

    function withdraw() public payable onlyOwner {
        // address(this) == address of the contract we're currently in
        msg.sender.transfer(address(this).balance); // transfer is a func we can call on any address
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);
    }
}

//Smart contract that lets anyone deposit ETH into the contract
//Only the owner of the contract can withdraw the ETH
// pragma solidity >=0.6.6 <0.9.0;

// // Get the latest ETH/USD price from chainlink price feed
// import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";
// import "@chainlink/contracts/src/v0.6/vendor/SafeMathChainlink.sol";

// contract FundMe {
// 	// safe math library check uint256 for integer overflows
//     using SafeMathChainlink for uint256;

//     //mapping to store which address depositeded how much ETH
//     mapping(address => uint256) public addressToAmountFunded;
//     // array of addresses who deposited
//     address[] public funders;
//     //address of the owner (who deployed the contract)
//     address public owner;

//     // the first person to deploy the contract is
//     // the owner
//     constructor() public {
//         owner = msg.sender;
//     }

//     function fund() public payable {
//     	// 18 digit number to be compared with donated amount
//         uint256 minimumUSD = 50 * 10 ** 18;
//         //is the donated amount less than 50USD?
//         require(getConversionRate(msg.value) >= minimumUSD, "You need to spend more ETH!");
//         //if not, add to mapping and funders array
//         addressToAmountFunded[msg.sender] += msg.value;
//         funders.push(msg.sender);
//     }

//     //function to get the version of the chainlink pricefeed
//     function getVersion() public view returns (uint256){
//         AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
//         return priceFeed.version();
//     }

//     function getPrice() public view returns(uint256){
//         AggregatorV3Interface priceFeed = AggregatorV3Interface(0x8A753747A1Fa494EC906cE90E9f37563A8AF630e);
//         (,int256 answer,,,) = priceFeed.latestRoundData();
//          // ETH/USD rate in 18 digit
//          return uint256(answer * 10000000000);
//     }

//     // 1000000000
//     function getConversionRate(uint256 ethAmount) public view returns (uint256){
//         uint256 ethPrice = getPrice();
//         uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1000000000000000000;
//         // the actual ETH/USD conversation rate, after adjusting the extra 0s.
//         return ethAmountInUsd;
//     }

//     //modifier: https://medium.com/coinmonks/solidity-tutorial-all-about-modifiers-a86cf81c14cb
//     modifier onlyOwner {
//     	//is the message sender owner of the contract?
//         require(msg.sender == owner);

//         _;
//     }

//     // onlyOwner modifer will first check the condition inside it
//     // and
//     // if true, withdraw function will be executed
//     function withdraw() payable onlyOwner public {

//     	// If you are using version eight (v0.8) of chainlink aggregator interface,
// 	// you will need to change the code below to
// 	// payable(msg.sender).transfer(address(this).balance);
//         msg.sender.transfer(address(this).balance);

//         //iterate through all the mappings and make them 0
//         //since all the deposited amount has been withdrawn
//         for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
//             address funder = funders[funderIndex];
//             addressToAmountFunded[funder] = 0;
//         }
//         //funders array will be initialized to 0
//         funders = new address[](0);
//     }
// }
