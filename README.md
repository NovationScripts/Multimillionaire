**The Path of the Multimillionaire**

The game [Multimillionaire](https://github.com/NovationScripts/Multimillionaire/tree/main) [TokenGame.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGame.sol) has been adapted to a token-based system.

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







In [TokenGame2Lines.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGame2Lines.sol) version, we added a second referral line. From the first line, the player earns 0.3%, and from the second line, 0.2%, making a total of the same 5%. With two referral lines, a player can potentially earn more, but it will take more time. This is because there could be at least twice as many referrals on the second line, especially considering that some may start creating multiple accounts for themselves. In such a case, having two lines could be more beneficial.

On the Ethereum network, using a single recovery phrase (seed phrase), an unlimited number of addresses can be generated, meaning one wallet can have many addresses. So, multi-accounting is definitely going to happen.

Based on the certainty that the rate on the **Decentralized Exchange P2P** will be 1 token equal to no less than 1 ETH.

If the payoutAttemptInterval is 30 hours, in the best-case scenario, it could take no less than 2,970 hours to complete the game, which is 123.75 days or 4.125 months. But if we double this time, it will take twice as long to complete the game. As a result, players will have ample time to attract new players and withdraw their referral earnings without delays.



Multi-accounting is not prohibited.


And one more tiny contract here.



[Token+Game.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/Token+Game.sol) In this case, the token is integrated into the game, making the token and the game a unified whole.

In this scenario, the reserve budget is filled to the maximum, and no one else has tokens. However, it can be configured so that a certain number of players can make their first deposit for free, using the reserve budget.

In this version, the economy is the most sustainable, and the reserve budget will be enough for at least 10 Earths for 10 generations.

We could say that players confirm blocks with their deposits.


[WithFlags.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/WithFlags.sol) This version includes flag verification during registration and the addition of flags after completing the game.



If the errors are fixed, it might actually work.

**We enjoy doing what we love, and we have a talent for it**.
