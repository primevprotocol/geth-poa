pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Swap {
    IERC20 public erc20Token;
    address public admin;

    constructor(address _erc20Address) {
        erc20Token = IERC20(_erc20Address);
        admin = msg.sender;
    }

    function depositEth() external payable {
        require(msg.sender == admin, "Only admin can deposit ETH");
    }

    receive() external payable {
        require(msg.sender == admin, "Only admin can send ETH directly");
    }

    function swapErc20ForEth(uint256 amount) external {
        require(address(this).balance >= amount, "Insufficient ETH balance in contract");
        erc20Token.transferFrom(msg.sender, address(this), amount);
        payable(msg.sender).transfer(amount);
    }

    function swapEthForErc20() external payable {
        uint256 ethAmount = msg.value;
        require(erc20Token.balanceOf(address(this)) >= ethAmount, "Insufficient ERC20 balance in contract");
        erc20Token.transfer(msg.sender, ethAmount);
    }
}