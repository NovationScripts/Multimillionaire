**The Path of the Multimillionaire**

The game [Multimillionaire](https://github.com/NovationScripts/Multimillionaire/tree/main) [TokenGame.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGame.sol) is an updated version of the game [GetEthTop](https://github.com/NovationScripts/GetEthTop/) with some bug fixes and several improvements.

In this game, there are no levels or steps; the game has been adapted to a token-based system.

**In this game, there are 99 different and sequential deposits, 99 separate budgets, and 99 separate queues**.

A new customizable mechanism has been added, such as an exponential queue growth compensator (**ratioMultiplier**).

A **reserve budget** has been added.

Without redistribution.

By using the **reserve budget** and configuring the ratio between **those who have made a deposit and those awaiting payment**, we can balance between the exponential queue growth and the capabilities of our reserve budget.










The game [Multimillionaire](https://github.com/NovationScripts/Multimillionaire/tree/main) [TokenGameWithRedistribution.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGameWithRedistribution.sol), is a more flexible version of [TokenGame.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGame.sol).

There is a customizable **redistribution to the reserve budget from each deposit, from each contract earnings withdrawal, and from each referrer earnings withdrawal**.

Here, after deploying the contract, we can change payoutMultiplier, ratioMultiplier, reservePercentage, referralReservePercentage, ownerReservePercentage, and DEPOSIT_AMOUNTS, which allows for flexibility in any situation.









The game [Multimillionaire](https://github.com/NovationScripts/Multimillionaire) [CoinGame.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/CoinGame.sol), has the exact same logic as [TokenGameWithRedistribution.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGameWithRedistribution.sol) but is **adapted for Ethereum**.



The ratioMultiplier protects against the exponential growth of players in the payout queue and prevents cheating with the game’s economy. However, if there is an exponential increase in new players, the compensator may not be needed, or needed only rarely. I hope that cheaters won't be able to harm the game’s economy. Try to imagine (or simulate) the gameplay to understand how it works.

If 10 players make deposits of $1 each, 9 players will receive $1.09, leaving 10 cents in the budget, and one player will remain in the queue while the other 9 will have passed through. If you don't account for the contract's earnings and referral earnings, this scenario holds. 

However, if you include those earnings, it might be necessary to adjust the compensator's value to 5. Such a payout frequency from the reserve budget can stabilize the system, provided there is a stable or slightly increasing influx of new players. If the compensator value is set to 5, every fifth successful payout is made from the reserve budget, thereby saving the current deposit budget.

To prevent the game from feeling too easy and boring, we can also use the compensator to vary the difficulty level of achieving a successful payout by gradually increasing its value and then decreasing it, or by bringing the queue to a certain level of difficulty and keeping it there. After all, this is the path to millions, and with many multiaccounts, a bit of difficulty will actually benefit the token's liquidity.

Increasing the token supply and sending them to the reserve budget to ensure every fifth payout, can be compared to mining. However, in our game, the "mining" process is more engaging and intricate.

At the same time, it's accessible to a larger number of users, with approximately equal chances and conditions for everyone, even after a long period of time.

And earnings of 5% from one referral would be approximately ~$50,000 if the referred player reaches the finish line.

https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGame2Lines.sol

In TokenGame2Lines.sol version, we added a second referral line. From the first line, the player earns 3%, and from the second line, 2%, making a total of the same 5%. With two referral lines, a player can potentially earn more, but it will take more time. This is because there could be at least twice as many referrals on the second line, especially considering that some may start creating multiple accounts for themselves. In such a case, having two lines could be more beneficial.

Based on the certainty that the rate on the **Decentralized Exchange P2P** will be 1 token equal to no less than 1 ETH.

If the payoutAttemptInterval is 30 hours, in the best-case scenario, it could take no less than 2,970 hours to complete the game, which is 123.75 days or 4.125 months. But if we double this time, it will take twice as long to complete the game. As a result, players will have ample time to attract new players and withdraw their referral earnings without delays.

This game is only a part of our ecosystem, and you can't even begin to estimate how liquid the token will be.

Multi-accounting is not prohibited.

After completing the game, each player will receive some of the most valuable tokens, which will be in high demand because these tokens are essential to play the game.

Our ecosystem is inherently closed, independent, and self-sufficient, not relying on **centralized** cryptocurrency exchanges or anything of the sort.

We create the demand and set the exchange rate ourselves.

If it gets listed, great, but if not, it doesn't matter anyway.

Participants in our ecosystem will only need to farm some of the most valuable tokens.

What do you think, who would want to sell tokens that can be farmed and exchanged for Ethereum at a stable rate with high demand?

How do you think, is it possible to launch such a project, including the token and interfaces, with a zero budget?

We can release the equivalent of up to two billion dollars to investors, which will be converted into Ethereum at the exchange rate at the time of the transaction if it's not in Ethereum. When issued in tokens, the amount will be multiplied by 1.5, provided that there is a thorough audit and, if necessary, assistance in launching the project. In any case, we will calculate it so that investors receive the equivalent +50%, if there are any.

But investing is not the main or mandatory aspect; the key is a thorough audit and support.

Over time, we will not allow the cryptocurrency on which we launch our project to drop in value, and later this cryptocurrency will become the leading one.

We assume that the TokenGame.sol version might suit us because we don't need to redistribute to the reserve budget, but instinctively, we want to have more flexible settings.

For example, later on, theoretically, we could increase the payout at the finish line and/or extend the duration, but that doesn't mean we will do it. It's just a backup option to have the ability to make adjustments in the future.

Since the game will be based on tokens, we don’t need to account for network fees in the calculations. Therefore, we can recalculate, and for this, we only need to divide the final amount by 1.09 or multiply it by 0.91 for 99 iterations to get the required deposit amounts. However, we need to know which numerical system to use in order to get more accurate fractional amounts.

**We enjoy doing what we love, and we have a talent for it**.
