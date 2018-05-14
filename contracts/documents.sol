pragma solidity ^0.4.23;

contract Documents {

    struct Author {
        bytes32 pubkey;
    }

    struct Document {
        Author author;
        Signature sig;
        bytes32 hash;
        bool published;
    }

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    mapping(address => Author) public authors;
    mapping(bytes32 => Document) public documents;

    function addDocument(bytes32 hash, bytes32 pubkey, uint8 v, bytes32 r, bytes32 s) public {
        require(!documents[hash].published);
        require(checkPubkey(msg.sender, pubkey));
        require(verify(msg.sender, hash, v, r, s));

        documents[hash] = Document(Author(pubkey), Signature(v, r, s), hash, true);
    }

    function checkPubkey(address p, bytes32 pubkey) private pure returns (bool){
        return (uint(keccak256(pubkey)) & 0x00FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) == uint(p);
    }

    function verify(address p, bytes32 hash, uint8 v, bytes32 r, bytes32 s) private pure returns(bool) {
        return ecrecover(hash, v, r, s) == p;
    }
}
