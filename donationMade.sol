 // SPDX-License-Identifier: MIT
    pragma solidity ^0.8.0;
    
    // Интерфейс для взаимодействия с внешним контрактом
interface IExternalContract {
    function getFlags(address _player) external view returns (uint256[] memory);
}

// Контракт для донатов, разрешающий донат только один раз
contract DonationContract {
    // Маппинг для хранения информации о том, сделал ли игрок пожертвование
    mapping(address => bool) public donationMade;

    // Минимальная сумма доната (по умолчанию 0.01 ETH)
    uint256 public minimumDonationAmount = 0.01 ether;

    // Процентные доли для распределения донатов
    uint256 public mainDonationPercentage = 90;
    uint256 public secondaryDonationPercentage = 10;

    // Адреса для распределения донатов
    address public mainDonationAddress;
    address public secondaryDonationAddress;

    // Адрес владельца контракта
    address public owner;

    // Адрес внешнего контракта для проверки флагов
    address public externalContractAddress;

    // Событие для логирования донатов
    event DonationReceived(address indexed player, uint256 amount);
    event MinimumDonationAmountChanged(uint256 newAmount);
    event DonationAddressesChanged(address newMainAddress, address newSecondaryAddress);
    event DonationPercentagesChanged(uint256 newMainPercentage, uint256 newSecondaryPercentage);

    // Конструктор для установки владельца контракта и адресов донатов
    constructor(address _mainDonationAddress, address _secondaryDonationAddress) {
        require(_mainDonationAddress != address(0), "Main donation address cannot be the zero address");
        require(_secondaryDonationAddress != address(0), "Secondary donation address cannot be the zero address");

        owner = msg.sender;
        mainDonationAddress = _mainDonationAddress;
        secondaryDonationAddress = _secondaryDonationAddress;
    }

    // Модификатор для функций, которые может вызывать только владелец
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can call this function");
        _;
    }

    // Функция для выполнения пожертвования, доступная только один раз для каждого игрока
    function makeDonation() external payable {
        // Проверяем, сделал ли игрок уже пожертвование
        require(!donationMade[msg.sender], "You can only make a donation once");

        // Проверяем, что сумма доната не меньше минимальной
        require(msg.value >= minimumDonationAmount, "Donation amount is too low");

        // Обновляем статус пожертвования игрока
        donationMade[msg.sender] = true;

        // Вычисляем суммы для основного и вторичного адресов на основе процентных долей
        uint256 mainDonationAmount = (msg.value * mainDonationPercentage) / 100;
        uint256 secondaryDonationAmount = (msg.value * secondaryDonationPercentage) / 100;

        // Проверяем, что процентные доли составляют ровно 100%
        require(mainDonationPercentage + secondaryDonationPercentage == 100, "Percentages must sum to 100");

        // Отправляем средства на основной и вторичный адреса
        payable(mainDonationAddress).transfer(mainDonationAmount);
        payable(secondaryDonationAddress).transfer(secondaryDonationAmount);

        // Логируем пожертвование
        emit DonationReceived(msg.sender, msg.value);
    }

    // Функция для получения флагов (например, сделал ли игрок пожертвование) через внешний контракт
    function getFlags(address _player) external view returns (uint256[] memory) {
        // Подключаемся к внешнему контракту
        IExternalContract externalContract = IExternalContract(externalContractAddress);
        
        // Вызываем метод getFlags для получения флагов игрока
        return externalContract.getFlags(_player);
    }

    // Функция для изменения минимальной суммы доната (только для владельца)
    function setMinimumDonationAmount(uint256 _newAmount) external onlyOwner {
        require(_newAmount > 0, "Minimum donation amount must be greater than 0");
        minimumDonationAmount = _newAmount;

        // Логируем изменение минимальной суммы
        emit MinimumDonationAmountChanged(_newAmount);
    }

    // Функции для изменения адресов донатов (только для владельца)
    function setDonationAddresses(address _newMainAddress, address _newSecondaryAddress) external onlyOwner {
        require(_newMainAddress != address(0), "Main donation address cannot be the zero address");
        require(_newSecondaryAddress != address(0), "Secondary donation address cannot be the zero address");

        mainDonationAddress = _newMainAddress;
        secondaryDonationAddress = _newSecondaryAddress;

        // Логируем изменение адресов
        emit DonationAddressesChanged(_newMainAddress, _newSecondaryAddress);
    }

    // Функция для изменения процентных долей распределения донатов (только для владельца)
    function setDonationPercentages(uint256 _newMainPercentage, uint256 _newSecondaryPercentage) external onlyOwner {
        require(_newMainPercentage + _newSecondaryPercentage == 100, "Percentages must sum to 100");

        mainDonationPercentage = _newMainPercentage;
        secondaryDonationPercentage = _newSecondaryPercentage;

        // Логируем изменение процентных долей
        emit DonationPercentagesChanged(_newMainPercentage, _newSecondaryPercentage);
    }

    // Функция для вывода средств с контракта владельцем (в случае, если на контракте остались средства)
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }

    // Функция для установки адреса внешнего контракта
    function setExternalContractAddress(address _externalContractAddress) external onlyOwner {
        require(_externalContractAddress != address(0), "Invalid external contract address");
        externalContractAddress = _externalContractAddress;
    }
}

