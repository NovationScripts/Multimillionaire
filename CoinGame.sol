    // SPDX-License-Identifier: MIT

    pragma solidity ^0.8.0;


   contract Multimillionaire {
   // Constants for fund distribution
   uint256 public constant contractCommission = 50; // 0.5% Contract commission percentage, The contract owner's earnings without token rewards.
   uint256 public constant referralCommission = 50; // 0.5% Referral commission percentage
   uint256 public payoutMultiplier = 109; // Payout multiplier
   uint256 public ratioMultiplier = 9;
   uint256 public reservePercentage = 0;  // Процент депозита, который идёт в резервный бюджет
   uint256 public contractEarnings; // Переменная для хранения заработков контракта
   uint256 public reserveBudget; // Переменная для резервного бюджета
   uint256 public referralReservePercentage = 0;  // Процент, направляемый в резервный бюджет при выводе реферальных заработков
   uint256 public ownerReservePercentage = 0;  // Процент, направляемый в резервный бюджет при выводе заработков владельцем
   mapping(uint256 => uint256) public payoutsPerDeposit;
   mapping(uint256 => uint256) public depositBudgets; // Бюджеты для депозитов
   uint256 public totalDepositsCount;

   address[] public playersArray; // Массив для хранения всех адресов игроков
   
   // Contract state variables
   address public owner; // Owner of the contract
   uint256 public totalReferralEarnings = 0; // Total referral earnings
   uint256 public totalReferralWithdrawals = 0; // Total referral withdrawals
   uint256 public totalPlayerCount; // Total number of players counter
   uint256 public payoutAttemptInterval = 30 hours;  //

	constructor() {
    owner = msg.sender; // Назначаем владельца контракта
    players[owner].referrer = address(0); // Регистрируем владельца контракта как первого игрока
    }


	
	
	
    uint256[] public DEPOSIT_AMOUNTS = [
    0.1202 ether,  // Cost of a step on level 1
    0.1310 ether,   // Cost of a step on level 2
    0.1407 ether,   // Cost of a step on level 3
    0.1513 ether,     // Cost of a step on level 4
    0.1629 ether,     // Cost of a step on level 5
    0.1755 ether,     // Cost of a step on level 6
    0.1892 ether,    // Cost of a step on level 7
    0.2042 ether,    // Cost of a step on level 8
    0.2205 ether,     // Cost of a step on level 9
    0.2383 ether,    // Cost of a step on level 10

    0.2577 ether,  // Cost of a step on level 11
    0.2788 ether,   // Cost of a step on level 12
    0.3018 ether,   // Cost of a step on level 13
    0.3269 ether,     // Cost of a step on level 14
    0.3543 ether,     // Cost of a step on level 15
    0.3841 ether,     // Cost of a step on level 16
    0.4166 ether,    // Cost of a step on level 17
    0.4520 ether,    // Cost of a step on level 18
    0.4906 ether,     // Cost of a step on level 19
    0.5327 ether,    // Cost of a step on level 20

    0.5786 ether,  // Cost of a step on level 21
    0.6286 ether,   // Cost of a step on level 22
    0.6831 ether,   // Cost of a step on level 23
    0.7425 ether,     // Cost of a step on level 24
    0.8073 ether,     // Cost of a step on level 25
    0.8779 ether,     // Cost of a step on level 26
    0.9549 ether,    // Cost of a step on level 27
    1.0388 ether,    // Cost of a step on level 28
    1.1302 ether,     // Cost of a step on level 29
    1.2299 ether,    // Cost of a step on level 30

    1.3385 ether,  // Cost of a step on level 31
    1.4569 ether,   // Cost of a step on level 32
    1.5860 ether,   // Cost of a step on level 33
    1.7267 ether,     // Cost of a step on level 34
    1.8801 ether,     // Cost of a step on level 35
    2.0473 ether,     // Cost of a step on level 36
    2.2295 ether,    // Cost of a step on level 37
    2.4281 ether,    // Cost of a step on level 38
    2.6446 ether,     // Cost of a step on level 39
    2.8806 ether,    // Cost of a step on level 40

    3.1378 ether,  // Cost of a step on level 41
    3.4182 ether,   // Cost of a step on level 42
    3.7238 ether,   // Cost of a step on level 43
    4.0569 ether,     // Cost of a step on level 44
    4.4200 ether,    // Cost of a step on level 45
    4.8158 ether,     // Cost of a step on level 46
    5.2472 ether,     // Cost of a step on level 47
    5.7174 ether,    // Cost of a step on level 48
    6.2299 ether,    // Cost of a step on level 49
    6.7885 ether,     // Cost of a step on level 50

    7.3974 ether,  // Cost of a step on level 51
    8.0611 ether,   // Cost of a step on level 52
    8.7845 ether,   // Cost of a step on level 53
    9.5731 ether,     // Cost of a step on level 54
    10.4326 ether,     // Cost of a step on level 55
    11.3695 ether,     // Cost of a step on level 56
    12.3907 ether,    // Cost of a step on level 57
    13.5038 ether,    // Cost of a step on level 58
    14.7171 ether,     // Cost of a step on level 59
    16.0396 ether,    // Cost of a step on level 60

    17.4811 ether,  // Cost of a step on level 61
    19.0523 ether,   // Cost of a step on level 62
    20.7650 ether,   // Cost of a step on level 63
    22.6318 ether,     // Cost of a step on level 64
    24.6666 ether,     // Cost of a step on level 65
    26.8845 ether,     // Cost of a step on level 66
    29.3021 ether,    // Cost of a step on level 67
    31.9372 ether,    // Cost of a step on level 68
    34.8095 ether,     // Cost of a step on level 69
    37.9403 ether,    // Cost of a step on level 70

    41.3529 ether,  // Cost of a step on level 71
    45.0726 ether,   // Cost of a step on level 72
    49.1271 ether,   // Cost of a step on level 73
    53.5465 ether,     // Cost of a step on level 74
    58.3636 ether,     // Cost of a step on level 75
    63.6143 ether,     // Cost of a step on level 76
    69.3375 ether,    // Cost of a step on level 77
    75.5758 ether,    // Cost of a step on level 78
    82.3756 ether,     // Cost of a step on level 79
    89.7874 ether,    // Cost of a step on level 80

    97.8662 ether,  // Cost of a step on level 81
    106.6721 ether,   // Cost of a step on level 82
    116.2705 ether,   // Cost of a step on level 83
    126.7328 ether,     // Cost of a step on level 84
    138.1367 ether,     // Cost of a step on level 85
    150.5670 ether,     // Cost of a step on level 86
    164.1160 ether,    // Cost of a step on level 87
    178.8844 ether,    // Cost of a step on level 88
    194.9819 ether,     // Cost of a step on level 89
    212.5282 ether,    // Cost of a step on level 90

    231.6537 ether,  // Cost of a step on level 91
    252.5005 ether,   // Cost of a step on level 92
    275.2235 ether,   // Cost of a step on level 93
    299.9916 ether,     // Cost of a step on level 94
    326.9888 ether,     // Cost of a step on level 95
    356.4157 ether,     // Cost of a step on level 96
    388.4911 ether,    // Cost of a step on level 97
    423.4532 ether,    // Cost of a step on level 98
    461.5619 ether  ];   // Cost of a step on level 99






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
    function makeDeposit() public payable onlyPlayer {
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

    // Переводим eth на контракт
    require(msg.value == depositAmount, "Incorrect deposit amount");

    // Рассчёт 10% в резервный бюджет
    uint256 reserveAmount = (depositAmount * reservePercentage) / 100;

    // Рассчёт комиссии контракта и реферальной комиссии
    contractEarnings += (depositAmount * contractCommission) / 10000;  // 0.5% от депозита
    uint256 referralFee = (depositAmount * referralCommission) / 10000;  // 0.5% от депозита

     // Обновляем бюджет депозита
    depositBudgets[player.depositIndex] += (
    depositAmount 
    - referralFee  // Уже рассчитано с учётом деления на 10000
    - (depositAmount * contractCommission) / 10000  // Корректное вычитание комиссии контракта 0.5%
);
    reserveBudget += reserveAmount;  // Пополняем резервный бюджет
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

    // Если есть реферер, начисляем реферальные вознаграждения
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
             // Перевод ETH из резервного бюджета игроку
            (bool success, ) = msg.sender.call{value: payout}("");
            require(success, "ETH transfer from reserve failed");
            emit ReservePaymentMade(msg.sender, payout);
        } else {
            // Проверяем, достаточно ли средств в бюджете депозита для обычной выплаты
            require(depositBudgets[player.depositIndex] >= payout, "Insufficient deposit budget");

            // Выплачиваем игроку из бюджета депозита
            depositBudgets[player.depositIndex] -= payout;
            (bool success, ) = msg.sender.call{value: payout}("");
            require(success, "ETH transfer failed");
            emit ReceivedPayment(msg.sender, payout);
        }

        // Увеличиваем количество успешных выплат для текущего депозита только после успешной выплаты
        payoutsPerDeposit[player.depositIndex]++;
    } else {
        // Выплата происходит из бюджета депозита для всех остальных случаев
        require(depositBudgets[player.depositIndex] >= payout, "Insufficient deposit budget");
        depositBudgets[player.depositIndex] -= payout;
        (bool success, ) = msg.sender.call{value: payout}("");
        require(success, "ETH transfer failed");
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
    function withdrawReferralEarnings() external payable onlyPlayer {
    Player storage player = players[msg.sender];
    uint256 amount = player.referralEarnings;

    // Проверяем, что есть реферальные заработки для вывода
    require(amount > 0, "No referral earnings to withdraw");

    // Рассчёт части, которая идёт в резервный бюджет
    uint256 reserveAmount = (amount * referralReservePercentage) / 100;

    // Присваиваем сумму заработков переменной для вывода
    uint256 withdrawalAmount = amount;

    // Обновляем данные о выводе для игрока
    player.referralWithdrawals += withdrawalAmount;
    totalReferralWithdrawals += withdrawalAmount;

    // Уменьшаем общую сумму реферальных заработков
    totalReferralEarnings -= amount;

    // Обнуляем реферальные заработки игрока
    player.referralEarnings = 0;

   // Отправляем реферальные заработки в виде ETH рефереру
    (bool success, ) = msg.sender.call{value: withdrawalAmount}("");
    require(success, "ETH transfer to referrer failed");

    // Логируем событие вывода реферальных средств
    emit ReferralWithdrawalMade(msg.sender, withdrawalAmount);

    // Увеличиваем резервный бюджет на резервную часть
    reserveBudget += reserveAmount;
    }



    // Функция для вывода заработка владельцем контракта
    function withdrawOwnerEarnings() external payable onlyOwner {
    // Проверяем, что есть заработанные токены для вывода
    require(contractEarnings > 0, "No contract earnings to withdraw");

    // Рассчёт части, которая идёт в резервный бюджет
    uint256 reserveAmount = (contractEarnings * ownerReservePercentage) / 100;

    // Выводим всю сумму заработка владельцем
    uint256 withdrawalAmount = contractEarnings;

    // Переводим токены владельцу
    (bool success, ) = owner.call{value: withdrawalAmount}("");
    require(success, "ETH transfer to owner failed");

    // Увеличиваем резервный бюджет на резервную часть
    reserveBudget += reserveAmount;

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

    
    // Функция для изменения значения payoutMultiplier, доступная только владельцу контракта
    function setPayoutMultiplier(uint256 newMultiplier) external onlyOwner {
    require(newMultiplier > 0, "Multiplier must be greater than 0");
    payoutMultiplier = newMultiplier;
    }


    // Функция для пополнения резервного бюджета
    function depositToReserve() external payable onlyOwner {
    // Проверяем, что отправленная сумма больше нуля
    require(msg.value > 0, "Amount must be greater than zero");
    // Увеличиваем резервный бюджет на переданную сумму
    reserveBudget += msg.value;
    }


    // Функция для изменения процента в резервный бюджет, доступна только владельцу
    function setReservePercentage(uint256 newPercentage) external onlyOwner {
    require(newPercentage >= 0 && newPercentage <= 100, "Percentage must be between 0 and 100");
    reservePercentage = newPercentage;
    }

    // Функция для изменения процента реферальных заработков, которые идут в резервный бюджет
    function setReferralReservePercentage(uint256 newPercentage) external onlyOwner {
    require(newPercentage >= 0 && newPercentage <= 100, "Percentage must be between 0 and 100");
    referralReservePercentage = newPercentage;
    }

    // Функция для изменения процента контрактных заработков, которые идут в резервный бюджет
    function setOwnerReservePercentage(uint256 newPercentage) external onlyOwner {
    require(newPercentage >= 0 && newPercentage <= 100, "Percentage must be between 0 and 100");
    ownerReservePercentage = newPercentage;
    }

    // Функция для изменения всего массива DEPOSIT_AMOUNTS
    function setDepositAmounts(uint256[] memory newDepositAmounts) external onlyOwner {
    require(newDepositAmounts.length > 0, "Deposit amounts array cannot be empty");
    DEPOSIT_AMOUNTS = newDepositAmounts;
    }

    // Функция для изменения отдельного элемента массива DEPOSIT_AMOUNTS
    function setDepositAmount(uint256 index, uint256 newAmount) external onlyOwner {
    require(index < DEPOSIT_AMOUNTS.length, "Index out of bounds");
    require(newAmount > 0, "Deposit amount must be greater than zero");
    DEPOSIT_AMOUNTS[index] = newAmount;
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

    // Функция для просмотра текущего процента
    function getReservePercentage() external view returns (uint256) {
    return reservePercentage;
    }

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
