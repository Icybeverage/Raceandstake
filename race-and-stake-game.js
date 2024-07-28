class RacingGame {
  constructor() {
    this.players = {};
    this.bets = [];
  }

  // Add a player to the race with their NFT attributes
  addPlayer(playerId, nft) {
    this.players[playerId] = {
      speed: nft.attributes.speed,
      handling: nft.attributes.handling,
      boost: nft.attributes.boost,
    };
  }

  // Place a bet on a player
  placeBet(bettorId, playerId, amount, betOnWinning) {
    this.bets.push({
      bettorId,
      playerId,
      amount,
      betOnWinning,
    });
  }

  // Calculate the race result for each player
  calculateResult(stats) {
    return stats.speed + stats.handling + stats.boost;
  }

  // Start the race and determine the winner
  startRace() {
    const results = Object.entries(this.players).map(([playerId, stats]) => {
      return {
        playerId,
        result: this.calculateResult(stats),
      };
    });

    results.sort((a, b) => b.result - a.result);
    const winner = results[0];

    console.log('Race Results:', results);
    console.log('Winner:', winner);

    this.calculatePayouts(winner.playerId);

    return results;
  }

  // Calculate and print payouts based on bets
  calculatePayouts(winnerId) {
    this.bets.forEach(bet => {
      if ((bet.betOnWinning && bet.playerId === winnerId) || (!bet.betOnWinning && bet.playerId !== winnerId)) {
        console.log(`Bettor ${bet.bettorId} wins ${bet.amount * 2}!`);
      } else {
        console.log(`Bettor ${bet.bettorId} loses ${bet.amount}.`);
      }
    });
  }
}

// Example usage
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
