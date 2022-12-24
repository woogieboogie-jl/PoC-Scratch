/* 
Q1.Epoch Naming?
Q2.Prefix-type naming?
Q3.Why not just mint everything to DecipherDAO and let the DAO distribute / interact?
Q4.Allowance has no meaning
*/


interface IERC20 {
    function totalSupply() external view returns (uint);
    function balanceOf(address _owner) external view returns (uint);
    function transfer(address _to, uint _value) external returns (bool);
    function approve(address _spender, uint_value) external returns (bool);
    function allowance(address _owner, address _spender) external view returns (uint);
    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner address indexed spender, uint value);
}

// question: is Epoch okay?
// maybe prefix-type naming is better?
interface ERC20Epoch is IERC20{
    function epochTotalSupply(uint _epoch) external view returns uint (uint);
    function epochBalanceOf(uint _epoch address _owner) external view returns (uint);
}


// why not just mint everything to DecipherDAO and let the DAO distribute?
contract POCTokenContract() is ERC20Epoch{
    string public name;
    string public symbol;
    uint8 public epoch;
    uint public totalSupply;
    address[] tokenManagers;

    // decipher managing commitee contract address initialization
    address public owner;
    
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowance;
    
    // mapping with epoch data
    mapping(uint8 => mapping(address => uint256)) public balancesEpoch;
    mapping(uint8 => uint256) public balancesTotalEpoch;
    
    // after change in epoch, resetting this feels more reasonable
    mapping(uint8 => mapping(address => mapping(address => uint256))) public allowances;

    // contructor for POCTokenContract
    constructor(string memory _name, string memory _symbol) public {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
    }

    // returns total supply of DCPH tokens for all epochs
    function totalSupply() public view returns (uint) {
        uint total = 0;
        for (uint256 i = 0; i <= epoch; i++) {
            total += balanceTotalEpoch[i];
        }
        return total;
    }
    
    // returns total supply of DCPH tokens dedicated to a certain epoch
    function epochTotalSupply(uint8 _epoch) public view returns (uint) {
        return balancesTotalEpoch[_epoch];
    }

    // returns total supply of DCPH tokens that certain user has in all epochs
    function balanceOf(address _owner) public view returns (uint) {
        uint total = 0;
        for (uint256 i=0; i <= epoch; i++) {
            total += balancesEpoch[i][_owner];
        }
        return total;
    }

    // returns total supply of DCPH tokens that certain user has for the current epoch
    function epochBalanceOf(address _owner) public view returns (uint) {
        return balancesEpoch[epoch][_owner];
    }

    // why not just mint everything to DecipherDAO? and then make the DAO distribute everything?
    function mint(address _to) {
        require(msg.sender == owner, "Not Authorized");
        balanceEpoch[epoch] += 1
        balancesEpoch[epoch][_to] += 1
    }

    // changing the owner of the token contract
    function changeOwner(address _to) public returns (bool) {
        require(msg.sender == owner, "Not Authorized");
        owner = _to;
        emit ChangeOwner(address msg.sender, address _to)
        return true;
    }

    // incrementing Epoch, should we increment? or let the user 'set' the epoch?
    function changeEpoch(uint8 _epoch) public returns (bool) {
        require(msg.sender == owner, "Not Authorized");
        epoch = _epoch
        emit ChangedEpoch(address msg.sender, uint8 epoch)
    }
    
    // transfer only available to - DecipherDAO, but isn't this too much?
    function transfer(address _to, uint _value) public returns (bool) {
        require(balancesEpoch[epoch][msg.sender] >= _value && _value > 0, "Insufficient Balance");
        require(contains(tokenManagers, _to), "Not An Authorized Receiver");
        balancesEpoch[epoch][msg.sender] -= _value;
        balancesEpoch[epoch][_to] += _value;
        emit Transfer(epoch, msg.sender, _to, _value);
        return true;
    }

    // approve - why is virtual needed?
    function approve(address _spender, uint256 _value) public {
        allowance[epoch][_spender][msg.sender] = _value;
        emit Approval(epoch, msg.sedner, _spender, _value);
    }
    
    // transferFrom
    function transferFrom(address _from, address _to, uint256 _value) public virtual returns (bool) {
        require(allowance[epoch][_from][msg.sender] >= _value && balancesEpoch[epoch][_from] >= _value && _value > 0 && _to != address(0)), "Wrong Epoch or Insufficient Allowance or Balance or Invalid Value or Recipient");
        balancesEpoch[epoch][_from] -= _value;
        balancesEpoch[epoch][_to] += _value;
        allowance[epoch][_from][msg.sender] -= value
        emit Transfer(epoch, _from, _to, _value);
        return true;
    }

    // transferfrom availiable to - DecipherDAO and maybe more entities?
    function transferFrom(address _to, uint) public returns (bool) {
        require(balancesEpoch[epoch][msg.sender])
    }
        require(balances)

    // Adding Token Manager
    function addTokenManager(_address) public returns (bool) {
        require(msg.sender == owner, "Not Authorized");
        require(!contains(tokenManangers, _address), "Address Already Added")
        tokenManagers.push(_address);
        return true;
        emit AddedTokenManager(msg.sender, _address);
    }

    // Deleting Token Mananger
    function removeTokenManager(_address) public returns (bool) {
        require(msg.sender == owner, "Not Authorized");
        require(contains(tokenManagers, _address), "Not In The Managers List");
        deleteItem(tokenManagers, _address);
        return true;
        emit RemovedTokenManager(msg.sender, _address);
    }


    /*Classic Utilities Functions for Custom Usage*/

    // classic deleteItem function by value for tokenmanager
    function deleteItem(uint[] memory _array, uint _value) public {
        uint index;
        for (uint i = 0; i < _array.length; i++) {
            if (_array[i] == _value) {
                index = i;
                break;
            }
        }
        for (uint i = index; i<_array.lenght-1; i++) {
            _array[i] = _array[i+1];
        }
        _array[_array.length -1] = 0;
    }

    // classic contains function for tokenmanger
    function contains(uint[] _list, uint _value) public view returns (bool) {
        for (uint i = 0; i < _list.length; i++) {
            if (_list[i] == _value) {
                return true;
            }
        }
        return false;
    }

    // events
    event ChangeOwner(address msg.sender, address _to);
    event Mint(uint8 epoch, address msg.sender, address _to);
    event ChangedEpoch(address msg.sender, uint8 epoch);
    event ChangeTokenManagers(address msg.sender, address _to);
    event Approval(uint8 epoch, address msg.sender, address _spender, uint256 _value);
    event Transfer(uint8 epoch, address _from, address _to, uint256 _value);
}
