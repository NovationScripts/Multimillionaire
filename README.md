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

If 10 players make deposits of $1 each, 9 players will receive $1.09, leaving 10 cents in the budget, and one player will remain in the queue while the other 9 will have passed through.

If you don't account for the contract's earnings and referral earnings, this scenario holds. However, if you include those earnings, it might be necessary to adjust the compensator's value to 8 or 7, or even fewer, if the contract fee and referral earnings amount to 10% (5% + 5%) of each deposit.

If the compensator value is set to 8, every eighth successful payout is made from the reserve budget, thereby saving the current deposit budget.

And earnings of 5% from one referral would be approximately ~$50,000 if the referred player reaches the finish line.

Based on the certainty that the rate on the DEX P2P will be 1 token equal to no less than 1 ETH.

In the best-case scenario, it could take no less than 2970 hours to complete the game, which is 123.75 days, or 4.125 months.

This game is only a part of our ecosystem, and you can't even begin to estimate how liquid the token will be.

Multi-accounting is not prohibited.

How do you think, is it possible to launch such a project, including the token and interfaces, with a zero budget?

**We enjoy doing what we love, and we have a talent for it**.
