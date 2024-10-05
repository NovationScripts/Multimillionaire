// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DonationContract {
    // Маппинг для хранения информации о том, сделал ли игрок пожертвование
    mapping(address => bool) public donationMade;

    // Минимальная сумма доната (по умолчанию 0.01 ETH)
    uint256 public minimumDonationAmount = 0.01 ether;

    // Адреса для распределения донатов и их проценты
    address[] public donationWallets;
    uint256[] public donationPercentages;

    // Адрес владельца контракта
    address public owner;

    // События
    event DonationReceived(address indexed player, uint256 amount);
    event MinimumDonationAmountChanged(uint256 newAmount);
    event DonationWalletAdded(address wallet, uint256 percentage);
    event DonationWalletRemoved(address wallet);
    event DonationWalletUpdated(address wallet, uint256 percentage);

    // Конструктор для установки владельца контракта
    constructor() {
        owner = msg.sender;
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

        // Проверяем, что все проценты в сумме составляют 100%
        require(totalPercentage() == 100, "Total percentage must be 100%");

        // Распределяем средства по кошелькам согласно процентам
        for (uint256 i = 0; i < donationWallets.length; i++) {
            uint256 walletAmount = (msg.value * donationPercentages[i]) / 100;
            payable(donationWallets[i]).transfer(walletAmount);
        }

        // Логируем пожертвование
        emit DonationReceived(msg.sender, msg.value);
    }

    // Функция для изменения минимальной суммы доната (только для владельца)
    function setMinimumDonationAmount(uint256 _newAmount) external onlyOwner {
        require(_newAmount > 0, "Minimum donation amount must be greater than 0");
        minimumDonationAmount = _newAmount;

        // Логируем изменение минимальной суммы
        emit MinimumDonationAmountChanged(_newAmount);
    }

    // Функция для добавления нового кошелька и процента (только для владельца)
    function addDonationWallet(address _wallet, uint256 _percentage) external onlyOwner {
        require(_wallet != address(0), "Invalid wallet address");
        require(_percentage > 0, "Percentage must be greater than 0");
        require(totalPercentage() + _percentage <= 100, "Total percentage exceeds 100");

        donationWallets.push(_wallet);
        donationPercentages.push(_percentage);

        // Логируем добавление кошелька
        emit DonationWalletAdded(_wallet, _percentage);
    }

    // Функция для удаления кошелька (только для владельца)
    function removeDonationWallet(uint256 index) external onlyOwner {
        require(index < donationWallets.length, "Index out of bounds");

        // Логируем удаление кошелька
        emit DonationWalletRemoved(donationWallets[index]);

        // Удаляем кошелек и его процент
        for (uint256 i = index; i < donationWallets.length - 1; i++) {
            donationWallets[i] = donationWallets[i + 1];
            donationPercentages[i] = donationPercentages[i + 1];
        }
        donationWallets.pop();
        donationPercentages.pop();
    }

    // Функция для обновления кошелька и его процента (только для владельца)
    function updateDonationWallet(uint256 index, address _newWallet, uint256 _newPercentage) external onlyOwner {
        require(index < donationWallets.length, "Index out of bounds");
        require(_newWallet != address(0), "Invalid wallet address");
        require(_newPercentage > 0, "Percentage must be greater than 0");

        // Обновляем адрес кошелька и его процент
        donationWallets[index] = _newWallet;
        donationPercentages[index] = _newPercentage;

        // Проверяем, что общая сумма процентов все еще равна 100%
        require(totalPercentage() == 100, "Total percentage must be 100%");

        // Логируем изменение кошелька
        emit DonationWalletUpdated(_newWallet, _newPercentage);
    }

    // Функция для расчета общей суммы процентов
    function totalPercentage() public view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 0; i < donationPercentages.length; i++) {
            total += donationPercentages[i];
        }
        return total;
    }

    // Функция для вывода средств с контракта владельцем (в случае, если на контракте остались средства)
    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}

