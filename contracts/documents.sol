pragma solidity ^0.4.24;

contract Documents {

    // https://crypto.stackexchange.com/questions/18105/how-does-recovering-the-public-key-from-an-ecdsa-signature-work
    struct Document {
        address author;
        Signature sig;
        bytes32 hash;
        bool exists;
    }

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    mapping(bytes32 => Document) public documents;

    function addDocument(bytes32 hash, uint8 v, bytes32 r, bytes32 s) public {
        require(!documents[hash].exists);
        require(verifySignature(msg.sender, hash, v, r, s));

        documents[hash] = Document(msg.sender, Signature(v, r, s), hash, true);
    }

    function removeDocument(bytes32 hash) public {
        require(documents[hash].exists);
        require(documents[hash].author == msg.sender);

        delete documents[hash];
    }

    function verifySignature(address p, bytes32 hash, uint8 v, bytes32 r, bytes32 s) private pure returns(bool) {
        return ecrecover(hash, v, r, s) == p;
    }
}
