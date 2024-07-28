# Race and Stake

## Overview

Race and Stake is a racing game where players can collect NFT upgrades for their virtual cars. Players can also place bets on the outcomes of the races. By participating in the game and collecting NFTs, players have the chance to redeem a real RC car when they accumulate 30 DOT (9 NFTs).

## Features

- **NFT Upgrades**: Players can collect NFTs that provide upgrades to their cars, enhancing attributes such as speed, handling, and boost.
- **Betting**: Players can place bets on the outcomes of races, betting on themselves or other players to win or lose.
- **Rewards**: Collect 30 DOT (9 NFTs) to redeem a real RC car.

## Getting Started

### Prerequisites

- Node.js
- npm
- Unique Network SDK
- Polkadot.js API

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/icybeverage/race-and-stake.git
   cd race-and-stake

   Install dependencies:
bash
Copy code
npm install @unique-nft/sdk @polkadot/api
Configuration
Create a config.js file in the root directory with the following content:

javascript
Copy code
module.exports = {
  endpoint: 'https://rest.unique.network/opal',
  ownerSeed: '//Alice',
  contractAddress: '5E5NhBNE1cAcQ6VXS79tdL6KehgXi6qKJ5KzzCy79NMKkCjd',
  imagePartsFolder: './images',
  imagePrefix: 'upgrade_',
  imageWidth: 1024,
  requiredCount: 10, // Number of NFTs to generate
};
Scripts
Generate NFT Properties:

bash
Copy code
node race-and-stake-nft-generator.js
Generate NFT Images:

bash
Copy code
node race-and-stake-image-generator.js
Create NFT Collection:

bash
Copy code
node race-and-stake-create-collection.js
Mint NFT Upgrades:

Replace YOUR_COLLECTION_ID in race-and-stake-create-items.js with the actual collection ID obtained from the previous step.
bash
Copy code
node race-and-stake-create-items.js
Run the Racing Game with Betting:

bash
Copy code
node race-and-stake-game.js
Game Logic

Adding Players: 
Players can be added to the game with their NFT attributes.

Placing Bets: 
Bets can be placed on players to win or lose.

Starting the Race: 
The race is run, and results are calculated based on the players' attributes.
Calculating Payouts: Bets are evaluated, and winnings or losses are calculated and displayed.

Example Usage
javascript
Copy code
const game = new RacingGame();
const nft1 = {
  attributes: { speed: 8, handling: 7, boost: 9 },
};
const nft2 = {
  attributes: { speed: 6, handling: 8, boost: 8 },
};
const nft3 = {
  attributes: { speed: 9, handling: 5, boost: 6 },
};

game.addPlayer('player1', nft1);
game.addPlayer('player2', nft2);
game.addPlayer('player3', nft3);

// Place bets
game.placeBet('bettor1', 'player1', 50, true);  // Bettor 1 bets 50 on Player 1 to win
game.placeBet('bettor2', 'player2', 30, false); // Bettor 2 bets 30 on Player 2 to lose

// Start the race and get the results
const raceResults = game.startRace();
console.log(raceResults);
Contribution
Contributions are welcome! Please feel free to submit a pull request or open an issue.

License
This project is licensed under the MIT License.

Contact
If you have any questions or suggestions, please open an issue or reach out to the project maintainers.

