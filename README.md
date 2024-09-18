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







**We enjoy doing what we love, and we have a talent for it**.
