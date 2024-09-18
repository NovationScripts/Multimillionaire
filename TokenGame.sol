    // SPDX-License-Identifier: MIT

    pragma solidity ^0.8.0;

    interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    }

   contract Multimillionaire {
   // Constants for fund distribution
   uint256 public constant contractCommission = 5; // Contract commission percentage, The contract owner's earnings without token rewards.
   uint256 public constant referralCommission = 5; // Referral commission percentage
   uint256 public constant payoutMultiplier = 109; // Payout multiplier
   uint256 public ratioMultiplier = 9;
   uint256 public contractEarnings; // Переменная для хранения заработков контракта
   uint256 public reserveBudget; // Переменная для резервного бюджета
   mapping(uint256 => uint256) public payoutsPerDeposit;
   mapping(uint256 => uint256) public depositBudgets; // Бюджеты для депозитов
   uint256 public totalDepositsCount;

   address[] public playersArray; // Массив для хранения всех адресов игроков
   
   // Contract state variables
   IERC20 public token; // ERC-20
   address public owner; // Owner of the contract
   uint256 public totalReferralEarnings = 0; // Total referral earnings
   uint256 public totalReferralWithdrawals = 0; // Total referral withdrawals
   uint256 public totalPlayerCount; // Total number of players counter
   uint256 public payoutAttemptInterval = 30 hours;  //

	constructor(IERC20 _token) {
    owner = msg.sender; // Назначаем владельца контракта
    token = _token; // Инициализируем токен
    players[owner].referrer = address(0); // Регистрируем владельца контракта как первого игрока
    }


	
	
	
    uint256[] public DEPOSIT_AMOUNTS = [
    120200000000000000,  // 0.1202 токена
    131000000000000000,  // 0.1310 токена
    140700000000000000,  // 0.1407 токена
    151300000000000000,  // 0.1513 токена
    162900000000000000,  // 0.1629 токена
    175500000000000000,  // 0.1755 токена
    189200000000000000,  // 0.1892 токена
    204200000000000000,  // 0.2042 токена
    220500000000000000,  // 0.2205 токена
    238300000000000000,  // 0.2383 токена
    257700000000000000,  // 0.2577 токена
    278800000000000000,  // 0.2788 токена
    301800000000000000,  // 0.3018 токена
    326900000000000000,  // 0.3269 токена
    354300000000000000,  // 0.3543 токена
    384100000000000000,  // 0.3841 токена
    416600000000000000,  // 0.4166 токена
    452000000000000000,  // 0.4520 токена
    490600000000000000,  // 0.4906 токена
    532700000000000000,  // 0.5327 токена
    578600000000000000,  // 0.5786 токена
    628600000000000000,  // 0.6286 токена
    683100000000000000,  // 0.6831 токена
    742500000000000000,  // 0.7425 токена
    807300000000000000,  // 0.8073 токена
    877900000000000000,  // 0.8779 токена
    954900000000000000,  // 0.9549 токена
    1038800000000000000,  // 1.0388 токена
    1130200000000000000,  // 1.1302 токена
    1229900000000000000,  // 1.2299 токена
    1338500000000000000,  // 1.3385 токена
    1456900000000000000,  // 1.4569 токена
    1586000000000000000,  // 1.5860 токена
    1726700000000000000,  // 1.7267 токена
    1880100000000000000,  // 1.8801 токена
    2047300000000000000,  // 2.0473 токена
    2229500000000000000,  // 2.2295 токена
    2428100000000000000,  // 2.4281 токена
    2644600000000000000,  // 2.6446 токена
    2880600000000000000,  // 2.8806 токена
    3137800000000000000,  // 3.1378 токена
    3418200000000000000,  // 3.4182 токена
    3723800000000000000,  // 3.7238 токена
    4056900000000000000,  // 4.0569 токена
    4420000000000000000,  // 4.4200 токена
    4815800000000000000,  // 4.8158 токена
    5247200000000000000,  // 5.2472 токена
    5717400000000000000,  // 5.7174 токена
    6229900000000000000,  // 6.2299 токена
    6788500000000000000,  // 6.7885 токена
    7397400000000000000,  // 7.3974 токена
    8061100000000000000,  // 8.0611 токена
    8784500000000000000,  // 8.7845 токена
    9573100000000000000,  // 9.5731 токена
    10432600000000000000,  // 10.4326 токена
    11369500000000000000,  // 11.3695 токена
    12390700000000000000,  // 12.3907 токена
    13503800000000000000,  // 13.5038 токена
    14717100000000000000,  // 14.7171 токена
    16039600000000000000,  // 16.0396 токена
    17481100000000000000,  // 17.4811 токена
    19052300000000000000,  // 19.0523 токена
    20765000000000000000,  // 20.7650 токена
    22631800000000000000,  // 22.6318 токена
    24666600000000000000,  // 24.6666 токена
    26884500000000000000,  // 26.8845 токена
    29302100000000000000,  // 29.3021 токена
    31937200000000000000,  // 31.9372 токена
    34809500000000000000,  // 34.8095 токена
    37940300000000000000,  // 37.9403 токена
    41352900000000000000,  // 41.3529 токена
    45072600000000000000,  // 45.0726 токена
    49127100000000000000,  // 49.1271 токена
    53546500000000000000,  // 53.5465 токена
    58363600000000000000,  // 58.3636 токена
    63614300000000000000,  // 63.6143 токена
    69337500000000000000,  // 69.3375 токена
    75575800000000000000,  // 75.5758 токена
    82375600000000000000,  // 82.3756 токена
    89787400000000000000,  // 89.7874 токена
    97866200000000000000,  // 97.8662 токена
    106672100000000000000,  // 106.6721 токена
    116270500000000000000,  // 116.2705 токена
    126732800000000000000,  // 126.7328 токена
    138136700000000000000,  // 138.1367 токена
    150567000000000000000,  // 150.5670 токена
    164116000000000000000,  // 164.1160 токена
    178884400000000000000,  // 178.8844 токена
    194981900000000000000,  // 194.9819 токена
    212528200000000000000,  // 212.5282 токена
    231653700000000000000,  // 231.6537 токена
    252500500000000000000,  // 252.5005 токена
    275223500000000000000,  // 275.2235 токена
    299991600000000000000,  // 299.9916 токена
    326988800000000000000,  // 326.9888 токена
    356415700000000000000,  // 356.4157 токена
    388491100000000000000,  // 388.4911 токена
    423453200000000000000,  // 423.4532 токена
    461561900000000000000  // 461.5619 токена
    ];






    // Mapping to track total payouts for each player
    mapping(address => uint256) public totalPayouts; 

    // Mapping of player addresses to their PlayerData
     mapping(address => Player) public players;

    // Data structure for a player
    struct Player {
    address referrer; // Address of the player who referred this player
    uint256 referralEarnings; // Amount earned by the player from referrals
    uint256 depositIndex;  // Индекс депозита, который игрок должен внести следующим
    uint256 deposit; // Amount of token deposited by the player
    bool madeDeposit;  // Флаг, указывающий, сделал ли игрок депозит
    bool receivedPayout;  // Флаг, указывающий, получил ли игрок выплату
    bool hasFinished; // Flag to track whether the player has finished the game
    uint256 referralWithdrawals; // Variable added to track the total amount of withdrawals made by referrals
    uint256 lastDepositTime; // Time of the player's last deposit;
    uint256 nextPayoutAttemptTime; // Time of the player's next payout attempt
    }




    // /////////////////////////////////////////////////////////

    // Функция для регистрации игрока
    function register(address _referrer) external {
    // Проверяем, что игрок не зарегистрирован
    require(players[msg.sender].referrer == address(0), "Player already registered");

    // Проверяем, что реферер существует и не является текущим игроком
    require(_referrer != address(0) && _referrer != msg.sender, "Invalid referrer");

    // Регистрируем игрока с указанным реферером
    Player storage player = players[msg.sender];
    player.referrer = _referrer;
    
    // Инициализируем индекс депозита с 0, чтобы начать с первого депозита
    player.depositIndex = 0;

    // Инициализируем остальные переменные
    player.lastDepositTime = 0;
    player.nextPayoutAttemptTime = 0;
    player.deposit = 0;
    player.referralEarnings = 0;
    player.referralWithdrawals = 0;
    player.madeDeposit = false;  // Флаг депозита
    player.receivedPayout = false;  // Флаг выплаты


    playersArray.push(msg.sender); // Добавляем игрока в массив

    // Вызываем событие регистрации
    emit Registered(msg.sender, _referrer);



    }

    // ////////////////////////////////////////////////////////

    // Функция для проверки, может ли игрок сделать следующий депозит
    function canMakeNextDeposit(address playerAddress) public view returns (bool) {
    Player storage player = players[playerAddress];

      // Игрок может сделать депозит, если это его первый депозит (индекс депозита 0)
    // или если он получил выплату за предыдущий депозит
    return player.depositIndex == 0 || player.receivedPayout;
    }


    
    
    
    // Функция для внесения депозита
    function makeDeposit() public onlyPlayer {
    Player storage player = players[msg.sender];

    // Проверяем, что игрок может внести депозит. Игрок может внести депозит, если:
    // - Он еще не сделал депозит, и это его первый депозит (индекс депозита равен 0)
    // - Или он сделал депозит ранее, но уже получил выплату
    require(
        !player.madeDeposit || player.depositIndex == 0, 
        "Deposit already made, waiting for payout"
    );

    // Получаем сумму депозита для текущего индекса
    uint256 depositAmount = DEPOSIT_AMOUNTS[player.depositIndex];

    // Переводим токены на контракт
    require(token.transferFrom(msg.sender, address(this), depositAmount), "Token transfer failed");

    
    // Рассчёт комиссии контракта и реферальной комиссии
    contractEarnings += (depositAmount * contractCommission) / 100;
    uint256 referralFee = (depositAmount * referralCommission) / 100;

     // Обновляем бюджет депозита
    depositBudgets[player.depositIndex] += (depositAmount - referralFee - contractCommission);
    totalDepositsCount++; // Увеличиваем количество депозитов


    // Устанавливаем флаг "сделал депозит"
    player.madeDeposit = true;
    player.receivedPayout = false;  // Сбрасываем флаг выплаты

    // Запоминаем время депозита
    player.lastDepositTime = block.timestamp;

    // Сохраняем сумму депозита
    player.deposit += depositAmount;

    
    // Получаем адрес реферера
    address referrer = player.referrer;

    // Если есть реферал, начисляем реферальные вознаграждения
    if (referrer != address(0)) {
        players[referrer].referralEarnings += referralFee;
    }

    

    // Устанавливаем время ожидания для следующей выплаты
    player.nextPayoutAttemptTime = block.timestamp + payoutAttemptInterval;
    }

	


    // ///////////////////////////////////////////////////

    function isPayoutAvailableFor(address playerAddress) public view returns (bool) {
    Player storage player = players[playerAddress];

    // Рассчитываем сумму выплаты
    uint256 payout = player.deposit * payoutMultiplier / 100;

    // Проверяем, достаточно ли средств в бюджете депозита и прошло ли время ожидания
    bool isBudgetAvailable = depositBudgets[player.depositIndex] >= payout;
    bool isTimeElapsed = block.timestamp >= player.nextPayoutAttemptTime;

    return isBudgetAvailable && isTimeElapsed;
    }


    function requestPayout() external {
    Player storage player = players[msg.sender];

    // Проверяем, доступна ли выплата (время ожидания должно быть истекшим)
    require(block.timestamp >= player.nextPayoutAttemptTime, "Payout request too early");

    // Проверяем, доступна ли выплата
    if (!isPayoutAvailableFor(msg.sender)) {
        // Если выплата недоступна, обновляем время ожидания
        reduceWaitingTime(player);
        return;
    }

    // Выполняем выплату
    processPayments();
    }




	function reduceWaitingTime(Player storage player) internal {
    uint256 currentTime = block.timestamp;
    if (player.nextPayoutAttemptTime > currentTime + 10 hours) {
        player.nextPayoutAttemptTime -= 10 hours;
    } else {
        player.nextPayoutAttemptTime = currentTime + 10 hours;
    }
    }

    


    function processPayments() internal onlyPlayer {
    Player storage player = players[msg.sender];

    // Проверяем, что игрок внёс депозит и ещё не получил выплату
    require(player.madeDeposit, "Deposit not made");
    require(!player.receivedPayout, "Payout already received");

    // Рассчитываем сумму выплаты
    uint256 payout = player.deposit * payoutMultiplier / 100;

   
   // Получаем количество игроков с депозитами и ожидающих выплату
    uint256 playersWithDepositsCount = countPlayersWithDeposits(player.depositIndex);
    uint256 playersWaitingForPayoutCount = countPlayersWaitingForPayout(player.depositIndex);

    // Проверяем соотношение игроков с депозитами и ожидающих выплату
    if (playersWithDepositsCount > 0 && playersWaitingForPayoutCount >= playersWithDepositsCount * ratioMultiplier) {
        
        // Если это девятая успешная выплата
        if (payoutsPerDeposit[player.depositIndex] % 9 == 0) {
            // Проверяем, достаточно ли средств в бюджете депозита для девятой выплаты
            if (depositBudgets[player.depositIndex] >= payout) {
                // Выплачиваем из бюджета депозита
                depositBudgets[player.depositIndex] -= payout;
            } else {
                // Если недостаточно средств, обновляем время ожидания
                reduceWaitingTime(player);
                return;
            }

            // Выплата из резервного бюджета
            require(reserveBudget >= payout, "Insufficient reserve budget");
            reserveBudget -= payout;
            require(token.transfer(msg.sender, payout), "Token transfer from reserve failed");
            emit ReservePaymentMade(msg.sender, payout);
        } else {
            // Проверяем, достаточно ли средств в бюджете депозита для обычной выплаты
            require(depositBudgets[player.depositIndex] >= payout, "Insufficient deposit budget");

            // Выплачиваем игроку из бюджета депозита
            depositBudgets[player.depositIndex] -= payout;
            require(token.transfer(msg.sender, payout), "Token transfer failed");
            emit ReceivedPayment(msg.sender, payout);
        }

        // Увеличиваем количество успешных выплат для текущего депозита только после успешной выплаты
        payoutsPerDeposit[player.depositIndex]++;
    } else {
        // Выплата происходит из бюджета депозита для всех остальных случаев
        require(depositBudgets[player.depositIndex] >= payout, "Insufficient deposit budget");
        depositBudgets[player.depositIndex] -= payout;
        require(token.transfer(msg.sender, payout), "Token transfer failed");
        emit ReceivedPayment(msg.sender, payout);

        // Увеличиваем количество успешных выплат для текущего депозита
        payoutsPerDeposit[player.depositIndex]++;
    }

    // Обновляем флаги депозита и выплаты
    player.madeDeposit = false;
    player.receivedPayout = true;




    // Переход на следующий депозит
    if (player.depositIndex < DEPOSIT_AMOUNTS.length - 1) {
        player.depositIndex += 1;
    } else {
        player.hasFinished = true;  // Игрок завершил все депозиты
    }
    }









    // //////////////////////////////////////////////////////////

    // Функция для вывода реферальных заработков
    function withdrawReferralEarnings() external onlyPlayer {
    Player storage player = players[msg.sender];
    uint256 amount = player.referralEarnings;

    // Проверяем, что есть реферальные заработки для вывода
    require(amount > 0, "No referral earnings to withdraw");

    // Присваиваем сумму заработков переменной для вывода
    uint256 withdrawalAmount = amount;

    // Обновляем данные о выводе для игрока
    player.referralWithdrawals += withdrawalAmount;
    totalReferralWithdrawals += withdrawalAmount;

    // Уменьшаем общую сумму реферальных заработков
    totalReferralEarnings -= amount;

    // Обнуляем реферальные заработки игрока
    player.referralEarnings = 0;

    // Логируем событие вывода реферальных средств
    emit ReferralWithdrawalMade(msg.sender, withdrawalAmount);

    // Отправляем реферальные заработки в виде токенов рефереру
    require(token.transfer(msg.sender, withdrawalAmount), "Token transfer to referrer failed");
    }



    // Функция для вывода заработка владельцем контракта
    function withdrawOwnerEarnings() external onlyOwner {
    // Проверяем, что есть заработанные токены для вывода
    require(contractEarnings > 0, "No contract earnings to withdraw");

    // Выводим всю сумму заработка владельцем
    uint256 withdrawalAmount = contractEarnings;

    // Переводим токены владельцу
    require(token.transfer(owner, withdrawalAmount), "Token transfer to owner failed");

    // Обнуляем контрактные заработки
    contractEarnings = 0;

    // Логируем событие вывода
    emit OwnerWithdrawal(owner, withdrawalAmount); 
     }
    
    

    // ////////////////////////////////////////////////////




     function changePayoutAttemptTime(uint256 newInterval) public onlyOwner {
    payoutAttemptInterval = newInterval;
    }
    
    // Функция для изменения коэффициента, доступная только владельцу контракта
    function setRatioMultiplier(uint256 _newMultiplier) external onlyOwner {
    require(_newMultiplier > 0, "Multiplier must be greater than 0");
    ratioMultiplier = _newMultiplier;
    }

    

    // Функция для пополнения резервного бюджета
    function depositToReserve(uint256 amount) external onlyOwner {
    // Переводим токены с кошелька владельца на контракт
    require(token.transferFrom(msg.sender, address(this), amount), "Token transfer failed");

    // Увеличиваем резервный бюджет на переданную сумму
    reserveBudget += amount; 
    }

    // ///////////////////////////////////////////////////////////

    
     // Modifier to ensure that only the contract owner can call certain functions
    modifier onlyOwner() {
    // Check that the message sender is the owner of the contract
    require(msg.sender == owner, "Caller is not the owner");
    _; // Continue execution of the function
    }

    // Modifier to ensure that only registered players can call certain functions
    modifier onlyPlayer() {
    // Check that the message sender is a registered player and has not finished the game
    require(players[msg.sender].referrer != address(0), "Not a registered player");
    require(!players[msg.sender].hasFinished, "Player has finished the game");
    _; // Continue execution of the function
    }

    // /////////////////////////////////////////////////////

    function getTotalPlayers() public view returns(uint256) {
    return totalPlayerCount;
    }

    // Функция для получения текущего значения ratioMultiplier
    function getRatioMultiplier() external view returns (uint256) {
    return ratioMultiplier;
    }

    // Функция для получения данных о текущем депозите игрока
    function getCurrentDepositData() external view returns (uint256 depositAmount, uint256 depositIndex, uint256 budget) {
    // Получаем данные игрока из хранилища
    Player storage player = players[msg.sender];

    // Убедимся, что индекс депозита игрока в допустимых пределах (0 - 98)
    require(player.depositIndex >= 0 && player.depositIndex < DEPOSIT_AMOUNTS.length, "Invalid deposit index");

    // Возвращаем данные о текущем депозите
    return (
        DEPOSIT_AMOUNTS[player.depositIndex],  // Сумма депозита
        player.depositIndex,                   // Индекс текущего депозита
        depositBudgets[player.depositIndex]    // Бюджет для текущего депозита
    );
    }


    function countPlayersWithDeposits(uint256 depositIndex) internal view returns (uint256) {
    uint256 count = 0;
    for (uint256 i = 0; i < playersArray.length; i++) {  // playersArray — массив всех игроков
        if (players[playersArray[i]].depositIndex == depositIndex && players[playersArray[i]].madeDeposit) {
            count++;
        }
    }
    return count;
    }

    function countPlayersWaitingForPayout(uint256 depositIndex) internal view returns (uint256) {
    uint256 count = 0;
    for (uint256 i = 0; i < playersArray.length; i++) {  // playersArray — массив всех игроков
        if (players[playersArray[i]].depositIndex == depositIndex && !players[playersArray[i]].receivedPayout) {
            count++;
        }
    }
    return count;
}



    // Функция для получения информации о конкретном игроке
    function getPlayerInfo(address _playerAddress) external view returns(uint256 currentDepositIndex, uint256 depositsCompleted, bool hasFinished) {
    // Получаем данные игрока из хранилища
    Player storage player = players[_playerAddress];

    // Возвращаем текущий индекс депозита, количество завершённых депозитов и статус завершения
    return (
        player.depositIndex,    // Текущий индекс депозита (с какого депозита начнётся следующий)
        player.depositIndex,    // Количество завершённых депозитов (совпадает с индексом)
        player.hasFinished      // Статус завершения игры (все депозиты выполнены)
    );
    }


    // Функция для получения бюджетов всех депозитов
    function getBudgetsByDeposit() public view returns (uint256[] memory) {
    // Инициализируем массив для хранения бюджетов каждого депозита
    uint256[] memory budgets = new uint256[](totalDepositsCount);

    // Итерируем по каждому депозиту и сохраняем его бюджет в массив
    for (uint256 i = 0; i < totalDepositsCount; i++) {
        budgets[i] = depositBudgets[i]; // Сохраняем бюджет депозита
    }

    // Возвращаем массив бюджетов
    return budgets;
    }



    //  //////////////////////////////////////////////

    // Function to get the contract commission percentage.
    function getContractEarningsPercentage() public pure returns (uint256) {
    // Return the constant value of the contract commission.
    return contractCommission;
    }

    // Function to get the total earnings of the contract.
    function getTotalContractEarnings() public view returns (uint256) {
    // Return the total earnings accumulated by the contract.
    return contractEarnings;
    }

    // Function to get the referral earnings percentage.
    function getReferralEarningsPercentage() public pure returns (uint256) {
    // Return the constant value of the referral commission.
    return referralCommission;
    }

     // Function to retrieve a player's referral earnings.
    function getReferralEarnings() public view returns (uint256) {
    // Returns the amount of referral earnings for the message sender.
    return players[msg.sender].referralEarnings;
    }
    
    // Function to get the total referral earnings.
    function getTotalReferralEarnings() public view returns (uint256) {
    // Return the total amount of referral earnings.
    return totalReferralEarnings;
    }

    // Function to get referral earnings by wallet address
    function getReferralEarningsByWallet(address referrer) public view returns (uint256) {
    // Return the referral earnings of the specified referrer address.
    return players[referrer].referralEarnings;
    }

    // Function to get referral withdrawals by wallet address
    function getReferralWithdrawalsByWallet(address referrer) public view returns (uint256) {
    // Return the total amount of referral withdrawals of the specified referrer address.
    return players[referrer].referralWithdrawals;
    }


    // //////////////////////////////////////////////////////
    
    
     // Events for logging actions in the contract
     event Registered(address indexed player, address indexed referrer); // Triggered when a player registers
     event DepositMade(address indexed player, uint256 depositIndex); // Triggered when a player makes a deposit
     event ReceivedPayment(address indexed player, uint256 amount); // Triggered when a player receives a payment
     event ReservePaymentMade(address indexed player, uint256 amount); // Вызов при выплате из резервного бюджета
     event OwnerWithdrawal(address indexed owner, uint256 withdrawalAmount); // Triggered when the owner withdraws funds
     event ReferralWithdrawalMade(address indexed referrer, uint256 amount); // Triggered when a referrer successfully withdraws referral earnings

    
    
    }
