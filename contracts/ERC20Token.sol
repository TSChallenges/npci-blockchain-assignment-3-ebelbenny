// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ERC20Token {
    string public name = "MyToken";
    string public symbol = "MTK";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** decimals; // Initialize totalSupply with decimals
        balances[msg.sender] = totalSupply; // Assign the total supply to the deployer's balance
        emit Transfer(address(0), msg.sender, totalSupply);
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances[account]; // Return the balance of the given account
    }

    function transfer(address to, uint256 value) public returns (bool) {
        require(balances[msg.sender] >= value, "Insufficient balance");
        require(to != address(0), "Cannot transfer to zero address");

        balances[msg.sender] -= value; // Deduct value from sender's balance
        balances[to] += value; // Add value to recipient's balance

        emit Transfer(msg.sender, to, value);
        return true;
    }

    function approve(address spender, uint256 value) public returns (bool) {
        require(spender != address(0), "Cannot approve zero address");

        allowances[msg.sender][spender] = value; // Set allowance

        emit Approval(msg.sender, spender, value);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return allowances[owner][spender]; // Return the allowance
    }

    function transferFrom(address from, address to, uint256 value) public returns (bool) {
        require(balances[from] >= value, "Insufficient balance");
        require(allowances[from][msg.sender] >= value, "Allowance exceeded");
        require(to != address(0), "Cannot transfer to zero address");

        balances[from] -= value; // Deduct value from sender's balance
        balances[to] += value; // Add value to recipient's balance

        allowances[from][msg.sender] -= value; // Deduct value from allowance

        emit Transfer(from, to, value);
        return true;
    }

    function mint(uint256 value) public {
        uint256 amount = value * 10 ** decimals; // Adjust for decimals

        totalSupply += amount; // Increase total supply
        balances[msg.sender] += amount; // Add to caller's balance

        emit Transfer(address(0), msg.sender, amount);
    }

    function burn(uint256 value) public {
        uint256 amount = value * 10 ** decimals; // Adjust for decimals

        require(balances[msg.sender] >= amount, "Insufficient balance");

        balances[msg.sender] -= amount; // Subtract from caller's balance
        totalSupply -= amount; // Decrease total supply

        emit Transfer(msg.sender, address(0), amount);
    }
}
