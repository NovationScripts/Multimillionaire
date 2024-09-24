            // SPDX-License-Identifier: MIT 

    pragma solidity ^0.8.0;
    import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
   
    // Интерфейс для взаимодействия с внешним контрактом
   interface IExternalContract {
   function getFlags(address _player) external view returns (uint256[] memory);
   }


   contract MultimillionaireToken is ReentrancyGuard {

   address public owner; // Owner of the contract
   address public externalContractAddress; //  Store address of external contract
   address[] public playersArray; // Массив для хранения всех адресов игроков
   mapping(address => Player) public players; // Mapping of player addresses to their PlayerData
   mapping(uint256 => uint256) public depositBudgets; // Бюджеты для депозитов
   mapping(uint256 => uint256) public payoutsPerDeposit;
   mapping(address => uint256) public totalPayouts;  // Mapping to track total payouts for each player
   mapping(address => bool) public canSponsorFirstDeposit; // Добавляем переменную-флаг для отслеживания состояния оплаты первого депозита реферером

   uint256 public contractCommission = 50; // 0.5% Contract commission percentage
   uint256 public firstLineReferralCommission = 40; // 0.4% с депозита первой линии
   uint256 public secondLineReferralCommission = 30; // 0.3% с депозита второй линии
   uint256 public payoutMultiplier = 109; // Payout multiplier
   uint256 public ratioMultiplier = 10; // Соотношение очереди при котором применяется резервный бюджет
   uint256 public payoutCycle = 5; // Число, кратное которому будут проверяться успешные выплаты
   uint256 public maxFreeUsers = 1000000; // Максимальное количество бесплатных первых депозитов
   uint256 public payoutAttemptInterval = 90 hours;  // Интервал между выплатами
   uint256 public minWaitingTime = 30 hours; // Минимальное время ожидания
   uint256 public reductionAmount = 30 hours; // Величина уменьшения времени
   uint256 public contractEarnings; // Переменная для хранения заработков контракта
   uint256 public reserveBudget; // Переменная для резервного бюджета
   
   uint256 public totalDepositsCount;
   uint256 public freeDepositsCount; // Счётчик пользователей с бесплатным депозитом
   uint256 public totalReferralEarnings = 0; // Total referral earnings
   uint256 public totalReferralWithdrawals = 0; // Total referral withdrawals
   uint256 public totalPlayerCount; // Total number of players counter
  


   // ERC-20 токен логика
   string public name = "Multimillionaire Token";
   string public symbol = "MTK";
   uint8 public decimals = 18;
   uint256 public totalSupply;
   mapping(address => uint256) public balanceOf;
   mapping(address => mapping(address => uint256)) public allowance;

   event Transfer(address indexed from, address indexed to, uint256 value);
   event Approval(address indexed owner, address indexed spender, uint256 value);

   constructor() {
      owner = msg.sender; // Назначаем владельца контракта
      totalSupply = 109999999999999999999999999999999999999999999999999999999999 * 10**18; // Инициализируем общее количество токенов
      reserveBudget = totalSupply; // Перемещаем все токены в резервный бюджет
      balanceOf[address(this)] = totalSupply;
      emit Transfer(address(0), address(this), totalSupply); // Событие минтинга
   }


   // /////////////////////////////////////////////////////////////

   

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


    modifier checkRegistrationFlagsWithExternalContracts(address _player) {
    require(externalContractAddress != address(0), "No external contract set");

    IExternalContract externalContract = IExternalContract(externalContractAddress);
    uint256[] memory externalFlags = externalContract.getFlags(_player);

    // Проверка флага 
    require(
        externalFlags[0] == 1,  // 0-й индекс — это флаг пожертвования
        "Donation has not been made"
    );

    _;
    }




    // /////////////////////////////////////////////////////

   // Функция для перевода токенов
   function transfer(address _to, uint256 _value) public returns (bool success) {
      require(balanceOf[msg.sender] >= _value, "Insufficient balance");
      balanceOf[msg.sender] -= _value;
      balanceOf[_to] += _value;
      emit Transfer(msg.sender, _to, _value);
      return true;
   }

   // Функция для одобрения перевода токенов
   function approve(address _spender, uint256 _value) public returns (bool success) {
      allowance[msg.sender][_spender] = _value;
      emit Approval(msg.sender, _spender, _value);
      return true;
   }

    // Функция для перевода токенов от имени владельца
   function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
      require(_value <= balanceOf[_from], "Insufficient balance");
      require(_value <= allowance[_from][msg.sender], "Allowance exceeded");
      balanceOf[_from] -= _value;
      balanceOf[_to] += _value;
      allowance[_from][msg.sender] -= _value;
      emit Transfer(_from, _to, _value);
      return true;
   }
	
	
	
    uint256[] public depositAmounts = [
    120200000000000000,  // 0.1202 токена  - самый первый депозит
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
    mapping(uint256 => bool) flags; // Массив флагов игрока после прохождения игры
    mapping(uint256 => bool) registrationFlags; // Mapping флагов для регистрации
    }




    // /////////////////////////////////////////////////////////

    // Функция для регистрации игрока
    function register(address _referrer) external checkRegistrationFlagsWithExternalContracts(msg.sender) {
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


    
    
    
    function makeDeposit() public onlyPlayer {
    Player storage player = players[msg.sender];

    // Проверяем, что игрок может внести депозит
    require(
        !player.madeDeposit || player.depositIndex == 0, 
        "Deposit already made, waiting for payout"
    );

    // Получаем сумму депозита для текущего индекса
    uint256 depositAmount = depositAmounts[player.depositIndex];

    // Объявляем переменную реферера на уровне всей функции
    address referrer = player.referrer;

    if (player.depositIndex == 0) {
        // Если это первый депозит, проверяем, может ли реферер его оплатить
        if (canSponsorFirstDeposit[referrer] && players[referrer].referralEarnings >= depositAmount) {
            // Реферер оплачивает первый депозит из своих реферальных заработков
            players[referrer].referralEarnings -= depositAmount;
        } else {
            // Игрок сам оплачивает первый депозит
            require(balanceOf[msg.sender] >= depositAmount, "Insufficient token balance");
            balanceOf[msg.sender] -= depositAmount;
        }

        // Если это первый депозит и игрок попадает в число пользователей с бесплатным депозитом
        if (freeDepositsCount < maxFreeUsers) {
            freeDepositsCount++;
        }

    } else {
        // Для последующих депозитов игрок сам платит
        require(balanceOf[msg.sender] >= depositAmount, "Insufficient token balance");
        balanceOf[msg.sender] -= depositAmount;
    }

    // Переводим депозит на баланс контракта
    balanceOf[address(this)] += depositAmount;

    // Рассчёт комиссии контракта
    contractEarnings += (depositAmount * contractCommission) / 10000; // 0.5%

    // Рассчёт реферальных комиссий
    uint256 firstLineReferralFee = (depositAmount * firstLineReferralCommission) / 10000;  // 0.4% от депозита
    uint256 secondLineReferralFee = 0;

    // Если есть реферер, начисляем ему и его рефереру реферальные вознаграждения
    if (referrer != address(0)) {
        // Начисляем 0.4% с первой линии
        players[referrer].referralEarnings += firstLineReferralFee;

        // Проверяем, есть ли у реферера свой реферер (вторая линия)
        address secondLineReferrer = players[referrer].referrer;
        if (secondLineReferrer != address(0)) {
            // Начисляем 0.3% со второй линии
            secondLineReferralFee = (depositAmount * secondLineReferralCommission) / 10000;
            players[secondLineReferrer].referralEarnings += secondLineReferralFee;
        }
    }

    // Обновляем бюджет депозита, вычитая все комиссии
    depositBudgets[player.depositIndex] += (depositAmount - firstLineReferralFee - secondLineReferralFee - (depositAmount * contractCommission) / 10000);
    totalDepositsCount++; // Увеличиваем количество депозитов

    // Устанавливаем флаг "сделал депозит"
    player.madeDeposit = true;
    player.receivedPayout = false;  // Сбрасываем флаг выплаты

    // Запоминаем время депозита
    player.lastDepositTime = block.timestamp;

    // Сохраняем сумму депозита
    player.deposit += depositAmount;

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
    if (player.nextPayoutAttemptTime > currentTime + minWaitingTime) {
        player.nextPayoutAttemptTime -= reductionAmount;
    } else {
        player.nextPayoutAttemptTime = currentTime + minWaitingTime;
    }
    }


    



    function processPayments() internal nonReentrant onlyPlayer {
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
        
        // Если это четвёртая успешная выплата
        if (payoutsPerDeposit[player.depositIndex] % payoutCycle == 0) {
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
            balanceOf[msg.sender] += payout; // Добавляем выплату к балансу игрока
            emit Transfer(address(this), msg.sender, payout); // Логируем событие перевода токенов
            emit ReservePaymentMade(msg.sender, payout);
        } else {
            // Проверяем, достаточно ли средств в бюджете депозита для обычной выплаты
            require(depositBudgets[player.depositIndex] >= payout, "Insufficient deposit budget");

            // Выплачиваем игроку из бюджета депозита
            depositBudgets[player.depositIndex] -= payout;
            balanceOf[msg.sender] += payout; // Добавляем выплату к балансу игрока
            emit Transfer(address(this), msg.sender, payout); // Логируем событие перевода токенов
            emit ReceivedPayment(msg.sender, payout);
        }

        // Увеличиваем количество успешных выплат для текущего депозита только после успешной выплаты
        payoutsPerDeposit[player.depositIndex]++;
    } else {
        // Выплата происходит из бюджета депозита для всех остальных случаев
        require(depositBudgets[player.depositIndex] >= payout, "Insufficient deposit budget");
        depositBudgets[player.depositIndex] -= payout;
        balanceOf[msg.sender] += payout; // Добавляем выплату к балансу игрока
        emit Transfer(address(this), msg.sender, payout); // Логируем событие перевода токенов
        emit ReceivedPayment(msg.sender, payout);

        // Увеличиваем количество успешных выплат для текущего депозита
        payoutsPerDeposit[player.depositIndex]++;
    }

    // Обновляем флаги депозита и выплаты
    player.madeDeposit = false;
    player.receivedPayout = true;




    // Переход на следующий депозит
    if (player.depositIndex < depositAmounts.length - 1) {
        player.depositIndex += 1;
    } else {
        player.hasFinished = true;  // Игрок завершил все депозиты
    }
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



    // //////////////////////////////////////////////////////////

    // Функция для активации/деактивации оплаты первого депозита реферером
    function toggleSponsorFirstDeposit() external onlyPlayer {
    Player storage referrer = players[msg.sender];
    require(referrer.referralEarnings > 0, "Insufficient referral earnings");

    // Переключаем флаг
    canSponsorFirstDeposit[msg.sender] = !canSponsorFirstDeposit[msg.sender];
    }


    // Функция для вывода реферальных заработков
    function withdrawReferralEarnings() external nonReentrant onlyPlayer {
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
    balanceOf[msg.sender] += withdrawalAmount; // Добавляем реферальные заработки к балансу реферера
    emit Transfer(address(this), msg.sender, withdrawalAmount); // Логируем событие перевода токенов
    }



    // Функция для вывода заработка владельцем контракта
    function withdrawOwnerEarnings() external nonReentrant onlyOwner {
    // Проверяем, что есть заработанные токены для вывода
    require(contractEarnings > 0, "No contract earnings to withdraw");

    // Выводим всю сумму заработка владельцем
    uint256 withdrawalAmount = contractEarnings;

    // Переводим токены владельцу
    balanceOf[owner] += withdrawalAmount; // Добавляем заработки к балансу владельца

    // Обнуляем контрактные заработки
    contractEarnings = 0;

    // Логируем событие вывода
    emit Transfer(address(this), owner, withdrawalAmount); // Логируем событие перевода токенов
     }
    
    

    // ////////////////////////////////////////////////////




     function changePayoutAttemptTime(uint256 newInterval) public onlyOwner {
    payoutAttemptInterval = newInterval;
    }

    function setWaitingTimeValues(uint256 newMinWaitingTime, uint256 newReductionAmount) public onlyOwner {
    require(newMinWaitingTime > 0, "Minimum waiting time must be greater than 0");
    require(newReductionAmount > 0, "Reduction amount must be greater than 0");
    
    minWaitingTime = newMinWaitingTime;
    reductionAmount = newReductionAmount;
    }
    

    function setPayoutMultiplier(uint256 newPayoutMultiplier) external onlyOwner {
    require(newPayoutMultiplier > 100, "Multiplier must be greater than 100"); // Можно установить минимальное ограничение
    payoutMultiplier = newPayoutMultiplier;
    }


    // Функция для изменения коэффициента, доступная только владельцу контракта
    function setRatioMultiplier(uint256 _newMultiplier) external onlyOwner {
    require(_newMultiplier > 0, "Multiplier must be greater than 0");
    ratioMultiplier = _newMultiplier;
    }


    function setPayoutCycle(uint256 newPayoutCycle) external onlyOwner {
    require(newPayoutCycle > 0, "Payout cycle must be greater than 0");
    payoutCycle = newPayoutCycle;
    }
    
    // Функция для изменения значения maxFreeUsers
    function setMaxFreeUsers(uint256 newMaxFreeUsers) public onlyOwner {
    require(newMaxFreeUsers > freeDepositsCount, "New value must be greater than current freeDepositsCount");
    maxFreeUsers = newMaxFreeUsers;
    }


    function setDepositAmount(uint256 index, uint256 newAmount) external onlyOwner {
    require(index < depositAmounts.length, "Index out of bounds");
    require(newAmount > 0, "Deposit amount must be greater than zero");
    depositAmounts[index] = newAmount;
    }

    function setDepositAmounts(uint256[] memory newDepositAmounts) external onlyOwner {
    require(newDepositAmounts.length > 0, "Deposit amounts array cannot be empty");
    require(newDepositAmounts.length == depositAmounts.length, "New array length must match the existing array length");
    depositAmounts = newDepositAmounts;
    }



    // Функция для изменения комиссии контракта
    function setContractCommission(uint256 newCommission) external onlyOwner {
    require(newCommission >= 0 && newCommission <= 10000, "Invalid commission value");
    contractCommission = newCommission;
    }

    // Функция для изменения реферальной комиссии первой линии
    function setFirstLineReferralCommission(uint256 newCommission) external onlyOwner {
    require(newCommission >= 0 && newCommission <= 10000, "Invalid commission value");
    firstLineReferralCommission = newCommission;
    }

    // Функция для изменения реферальной комиссии второй линии
    function setSecondLineReferralCommission(uint256 newCommission) external onlyOwner {
    require(newCommission >= 0 && newCommission <= 10000, "Invalid commission value");
    secondLineReferralCommission = newCommission;
    }

    // ///////////////////////////////////////////////////////////

    // Функция для изменения адреса внешнего контракта
    function setExternalContract(address _newExternalContract) external onlyOwner {
    require(_newExternalContract != address(0), "Invalid external contract address");
    externalContractAddress = _newExternalContract;
    }




    // ////////////////////////////////////////////////////////////////////

     
   


     
   
     // Функция для получения данных о текущем депозите игрока
    function getCurrentDepositData() external view returns (uint256 depositAmount, uint256 depositIndex, uint256 budget) {
    // Получаем данные игрока из хранилища
    Player storage player = players[msg.sender];

    // Убедимся, что индекс депозита игрока в допустимых пределах (0 - 98)
    require(player.depositIndex >= 0 && player.depositIndex < depositAmounts.length, "Invalid deposit index");

    // Возвращаем данные о текущем депозите
    return (
        depositAmounts[player.depositIndex],  // Сумма депозита
        player.depositIndex,                   // Индекс текущего депозита
        depositBudgets[player.depositIndex]    // Бюджет для текущего депозита
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

    



    // //////////////////////////////////////////////////////
    
    
     // Events for logging actions in the contract
     event Registered(address indexed player, address indexed referrer); // Triggered when a player registers
     event DepositMade(address indexed player, uint256 depositIndex); // Triggered when a player makes a deposit
     event ReceivedPayment(address indexed player, uint256 amount); // Triggered when a player receives a payment
     event ReservePaymentMade(address indexed player, uint256 amount); // Вызов при выплате из резервного бюджета
     event OwnerWithdrawal(address indexed owner, uint256 withdrawalAmount); // Triggered when the owner withdraws funds
     event ReferralWithdrawalMade(address indexed referrer, uint256 amount); // Triggered when a referrer successfully withdraws referral earnings
     // Остальное логирование ...
    
    
    }
