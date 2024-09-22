**The Path of the Multimillionaire**

The game [Multimillionaire](https://github.com/NovationScripts/Multimillionaire/tree/main) [TokenGame.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/TokenGame.sol) has been adapted to a token-based system.

**In this game, there are 99 different and sequential deposits, 99 separate budgets, and 99 separate queues**.

A new customizable mechanism has been added, such as an exponential queue growth compensator (**ratioMultiplier**).

A **reserve budget** has been added.


By using the **reserve budget** and configuring the ratio between **those who have made a deposit and those awaiting payment**, we can balance between the exponential queue growth and the capabilities of our reserve budget.





The game [Multimillionaire](https://github.com/NovationScripts/Multimillionaire) [CoinGame.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/CoinGame.sol), has been **adapted for Ethereum**.



The ratioMultiplier protects against the exponential growth of players in the payout queue and prevents cheating with the game’s economy. However, if there is an exponential increase in new players, the compensator may not be needed, or needed only rarely. I hope that cheaters won't be able to harm the game’s economy. Try to imagine (or simulate) the gameplay to understand how it works.





Multi-accounting is not prohibited.


And one more tiny contract here.



[Token+Game.sol](https://github.com/NovationScripts/Multimillionaire/blob/main/Token+Game.sol) In this case, the token is integrated into the game, making the token and the game a unified whole.

In this scenario, the reserve budget is filled to the maximum, and no one else has tokens. However, it can be configured so that a certain number of players can make their first deposit for free, using the reserve budget. The option to make the first deposit at the referrer's expense has also been added if the referrer activates this feature. We added a second referral line. From the first line, the player earns 0.4%, and from the second line, 0.3%, making a total of the same ~50000$+ from one refferal if we assume that on the P2P DEX, 1 ETH = 1 Token. With two referral lines, a player can potentially earn more, but it will take more time. This is because there could be at least twice as many referrals on the second line, especially considering that some may start creating multiple accounts for themselves. In such a case, having two lines could be more beneficial.

In this version, the economy is the most sustainable. If we assume that the equivalent of all the money on planet Earth is a septillion, then the reserve budget would be enough for 109,999,999,999,999,999,999,999 such planets. But tokens can be taken from the reserve budget only after every fifth successful payout if the ratio of players in the queue is greater than 10 waiting for payout to 1 making a deposit.  This is a fairly optimized and safe budget expenditure. Primarily, users will be transferring deposits between each other, but if the queue starts to stall, the reserve budget will kick in. In this case, a few cents remain in the deposit budget from every 10 people who pass through. Out of every 10 people who pass through, 12% goes to referral and contract payouts, 87.2% goes to paying eight players, and the reserve budget covers the payouts for the other two. This means we can set the ratio to 10/5 in the settings.


This version includes flag verification during registration and the addition of flags after completing the game. Theoretically, it is possible to create contracts with different conditions based on the configuration of flags. For example, to access a shared P2P liquidity pool or other complex contracts, and to set the sequence of access to contracts. The current flags can be pre-programmed variables and constants.

We could say that players confirm blocks with their deposits.

At this stage, the contract has reached its maximum possible size.

If the errors are fixed, it might actually work.

If you have any thoughts, you can leave them in the discussions of this repository. https://github.com/NovationScripts/Multimillionaire/discussions

**We enjoy doing what we love, and we have a talent for it**.
