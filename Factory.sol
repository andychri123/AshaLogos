pragma solidity 0.5.0;

import "./Owned.sol";
import "./Crowdsale.sol";
import "./Venture.sol";
import "./Token.sol";
import "./VentureToken.sol";

//-----------------------------------------------------------------------------------------------------------
//                                 |\_______________ (_____\\______________
//     --      --          HH======#H###############H#######################        JOHN 3:16 KJV
//                                 ' ~""""""""""""""`##(_))#H\"""""Y########
//                                                   ))    \#H\       `"Y###
//                                                   "      }#H)
//-----------------------------------------------------------------------------------------------------------


contract Factory{

    function createVenture(string memory entityName, string memory missionDescription,
                           address creator, string memory tokenName, string memory tokenSymbol, 
                           uint rate)public payable returns(address newCon){
    	address manager = msg.sender;
        address newVenture = new Venture(manager,
                                         tokenRate,
                                         entityName,
                                         missionDescription);
        return newVenture;
        }

    function createCrowdsale(Token _token, uint rate, address _wallet)
                             public payable returns(address newCon){
    	address newCrowdsale = new Crowdsale(Token _token, uint rate, address _wallet); 
        return newCrowdsale;
    }

    function createToken(string memory name, string memory symbol, address payable creator)
                         public payable returns(address newCon){
    	address newToken = new Token(name, symbol, creator);
        return newToken;
    }

}