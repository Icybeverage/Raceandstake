// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./NFT.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Marketplace is ReentrancyGuard, Ownable {
    struct Item {
        address nftContract;
        uint256 tokenId;
        address payable seller;
        uint256 price;
        bool sold;
    }

    struct Bet {
        address player;
        uint256 amount;
        bool isLeverage;
        uint256 leverageFactor;
    }

    struct Stake {
        address staker;
        uint256 amount;
        uint256 startTime;
    }

    Item[] public items;
    mapping(address => mapping(uint256 => bool)) public activeItems;
    mapping(uint256 => Bet[]) public bets;
    mapping(address => Stake) public stakes;

    uint256 public stakingDuration = 30 days; // example duration
    uint256 public stakingInterestRate = 10; // example interest rate (10%)

    event ItemListed(address indexed nftContract, uint256 indexed tokenId, uint256 price, address indexed seller);
    event ItemSold(address indexed nftContract, uint256 indexed tokenId, uint256 price, address indexed buyer);
    event BetPlaced(address indexed player, uint256 indexed raceId, uint256 amount, bool isLeverage, uint256 leverageFactor);
    event BetWon(address indexed player, uint256 indexed raceId, uint256 payout);
    event BetLost(address indexed player, uint256 indexed raceId);
    event Staked(address indexed staker, uint256 amount, uint256 startTime);
    event Unstaked(address indexed staker, uint256 amount, uint256 reward);
    event CarPurchased(address indexed buyer, uint256 price);

    function listItem(address nftContract, uint256 tokenId, uint256 price) external nonReentrant {
        require(!activeItems[nftContract][tokenId], "Item is already listed");
        require(price > 0, "Price must be greater than zero");

        NFT(nftContract).safeTransferFrom(msg.sender, address(this), tokenId);

        items.push(Item(nftContract, tokenId, payable(msg.sender), price, false));
        activeItems[nftContract][tokenId] = true;

        emit ItemListed(nftContract, tokenId, price, msg.sender);
    }

    function buyItem(uint256 itemId) external payable nonReentrant {
        Item storage item = items[itemId];
        require(!item.sold, "Item is already sold");
        require(msg.value >= item.price, "Insufficient payment");

        item.seller.transfer(msg.value);
        item.sold = true;
        activeItems[item.nftContract][item.tokenId] = false;

        NFT(item.nftContract).safeTransferFrom(address(this), msg.sender, item.tokenId);

        emit ItemSold(item.nftContract, item.tokenId, item.price, msg.sender);
    }

    function placeBet(uint256 raceId, uint256 amount, bool isLeverage, uint256 leverageFactor) external payable nonReentrant {
        require(amount > 0, "Bet amount must be greater than zero");
        require(msg.value == amount, "Sent value must match bet amount");

        if (isLeverage) {
            require(leverageFactor > 1 && leverageFactor <= 5, "Leverage factor must be between 2 and 5");
        }

        bets[raceId].push(Bet(msg.sender, amount, isLeverage, leverageFactor));

        emit BetPlaced(msg.sender, raceId, amount, isLeverage, leverageFactor);
    }

    function resolveBet(uint256 raceId, address winner, bool isWinner) external onlyOwner nonReentrant {
        Bet[] storage raceBets = bets[raceId];
        for (uint256 i = 0; i < raceBets.length; i++) {
            Bet storage bet = raceBets[i];
            if (bet.player == winner && isWinner) {
                uint256 payout = bet.isLeverage ? bet.amount * bet.leverageFactor : bet.amount * 2;
                payable(winner).transfer(payout);
                emit BetWon(winner, raceId, payout);
            } else {
                emit BetLost(bet.player, raceId);
            }
        }

        delete bets[raceId];
    }

    function stake(uint256 amount) external payable {
        require(amount > 0, "Stake amount must be greater than zero");
        require(msg.value == amount, "Sent value must match stake amount");

        stakes[msg.sender] = Stake(msg.sender, amount, block.timestamp);
        emit Staked(msg.sender, amount, block.timestamp);
    }

    function unstake() external {
        Stake storage userStake = stakes[msg.sender];
        require(userStake.amount > 0, "No active stake found");
        require(block.timestamp >= userStake.startTime + stakingDuration, "Staking duration not yet completed");

        uint256 reward = (userStake.amount * stakingInterestRate) / 100;
        uint256 totalPayout = userStake.amount + reward;

        delete stakes[msg.sender];
        payable(msg.sender).transfer(totalPayout);

        emit Unstaked(msg.sender, userStake.amount, reward);
    }

    function purchaseCar() external payable {
        uint256 carPrice = 30 ether; // Example price
        require(msg.value >= carPrice, "Insufficient payment");

        emit CarPurchased(msg.sender, carPrice);
    }

    function getItems() external view returns (Item[] memory) {
        return items;
    }
}
