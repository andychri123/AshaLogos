pragma solidity ^0.5.0;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./Owned.sol";

// ----------------------------------------------------------------------------
//
// Symbol      : AVT
// Name        : Autonomous Venture Token
// Total supply: 0 at the time of initialization
// Decimals    : 18
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// ERC Token Standard #20 Interface
// https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
// ----------------------------------------------------------------------------

// ----------------------------------------------------------------------------
// ERC20 Token, with the addition of symbol, name and decimals and an
// initial fixed supply
// ----------------------------------------------------------------------------

interface IERC20{

    function totalSupply() external view returns (uint);

    function balanceOf(address tokenOwner) external view returns (uint balance);

    function allowance(address tokenOwner, address spender) external view returns (uint remaining);

    function transfer(address to, uint tokens) external returns (bool success);

    function approve(address spender, uint tokens) external returns (bool success);

    function transferFrom(address from, address to, uint tokens) external returns (bool success);


    event Transfer(address indexed from, address indexed to, uint tokens);

    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);

//    event Burn(address indexed owner, uint tokens);

}
contract Token is IERC20, Owned {

    using SafeMath for uint;
    string  public _symbol;
    string  public  _name;
    uint public _decimals;
    uint public _totalSupply;
    uint public INITIAL_SUPPLY;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    // ------------------------------------------------------------------------
    // Constructor
    // ------------------------------------------------------------------------

    constructor () public {
        _name     = "Autonomous Venture Token"; // solium-disable-line uppercase
        _symbol   = "AVT"; // solium-disable-line uppercase
        _decimals = 18; // solium-disable-line uppercase
        INITIAL_SUPPLY = 1000000 * (10 ** uint(_decimals));
        _totalSupply = INITIAL_SUPPLY;
        balances[owner] = _totalSupply;
        emit Transfer(address(0), owner, _totalSupply);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    /**
     * @return the symbol of the token.
     */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /**
     * @return the number of decimals of the token.
     */
    function decimals() public view returns (uint) {
        return _decimals;
    }

    // ------------------------------------------------------------------------
    // Total supply
    // ------------------------------------------------------------------------

    function totalSupply() public view returns (uint) {

        return _totalSupply;
    }

    function balanceOf(address tokenOwner) public view returns (uint balance) {

        return balances[tokenOwner];
    }

    // ------------------------------------------------------------------------
    // Transfer the balance from token owner's account to `to` account
    // - Owner's account must have sufficient balance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------

    function transfer(address to, uint tokens) public returns (bool success) {

        balances[msg.sender] = balances[msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Token owner can approve for `spender` to transferFrom(...) `tokens`
    // from the token owner's account
    //
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md
    // recommends that there are no checks for the approval double-spend attack
    // as this should be implemented in user interfaces 
    // ------------------------------------------------------------------------

    function approve(address spender, uint tokens) public returns (bool success) {

        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Transfer `tokens` from the `from` account to the `to` account
    // 
    // The calling account must already have sufficient tokens approve(...)-d
    // for spending from the `from` account and
    // - From account must have sufficient balance to transfer
    // - Spender must have sufficient allowance to transfer
    // - 0 value transfers are allowed
    // ------------------------------------------------------------------------

    function transferFrom(address from, address to, uint tokens) public returns (bool success) {

        balances[from] = balances[from].sub(tokens);
        allowed[from][msg.sender] = allowed[from][msg.sender].sub(tokens);
        balances[to] = balances[to].add(tokens);
        emit Transfer(from, to, tokens);
        return true;
    }

    // ------------------------------------------------------------------------
    // Returns the amount of tokens approved by the owner that can be
    // transferred to the spender's account
    // ------------------------------------------------------------------------

    function allowance(address tokenOwner, address spender) public view returns (uint remaining) {

        return allowed[tokenOwner][spender];
    }

    // ------------------------------------------------------------------------
    // Owner can withdraw ether if token received.
    // ------------------------------------------------------------------------
//    function withdraw() public onlyOwner returns (bool result) {
        
//        return owner.transfer(address(this).balance);
        
//    }
    
    // ------------------------------------------------------------------------
    // Owner can transfer out any accidentally sent ERC20 tokens
    // ------------------------------------------------------------------------

   //// function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyOwner returns (bool success) {

 //       return IERC20(tokenAddress).transfer(owner, tokens);

 //   }

    function burn(uint _value) public returns (bool success) {
        require(balances[msg.sender] >= _value);   // Check if the sender has enough
        balances[msg.sender] -= _value;            // Subtract from the sender
        _totalSupply -= _value;                      // Updates totalSupply
        //emit Burn(msg.sender, _value);
        return true;
    }

    /**

     * Destroy tokens from other account
     *
     * Remove `_value` tokens from the system irreversibly on behalf of `_from`.
     *
     * @param _from the address of the sender
     * @param _value the amount of money to burn
     */
    function burnFrom(address _from, uint256 _value) public returns (bool success) {
        require(balances[_from] >= _value);                // Check if the targeted balance is enough
        require(_value <= allowance(_from, msg.sender));   // Check allowance
        balances[_from] -= _value;                         // Subtract from the targeted balance
      //  allowance(_from, msg.sender) -= _value;            // Subtract from the sender's allowance
        _totalSupply -= _value;                            // Update totalSupply
       // emit Burn(_from, _value);
        return true;
    }

    function mint(address _to, uint am) public onlyOwner returns (bool success){
          // uint am  = amo * 10 ** uint(_decimals);
           //uint f = am * 18;
           uint amo = am * (10 ** uint(_decimals));
           _totalSupply = _totalSupply+amo;
           balances[_to] = balances[_to]+ am;
         //  emit Transfer(0x0, _to, am);
           emit Transfer(address(this), _to, amo);
           return true;
       }
}

//-------------------------------------------------------------------------------------------

library SafeMath {
    
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b > 0, errorMessage);
        uint256 c = a / b;

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}
