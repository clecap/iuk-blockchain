pragma solidity ^0.4.23;

import "./openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract Documents is Ownable {

    struct Document {
        address author;
        bytes32 hash;
        bytes32 next;
        bool exists;
        bool revoked;
    }

    uint newDocumentFee = 0.001 ether;

    mapping(bytes32 => Document) public documents;

    event DocumentAdded(bytes32 hash, address author);
    event HashUpdated(bytes32 oldHash, bytes32 newHash, address author);
    event RevokeUpdated(bytes32 hash, address author, bool newStatus);

    modifier onlyAuthor(bytes32 hash) {
        require(documents[hash].author == msg.sender);
        _;
    }

    function withdraw() external onlyOwner {
        owner.transfer(address(this).balance);
    }

    function setDocumentFee(uint fee) external onlyOwner {
        newDocumentFee = fee;
    }

    function addDocument(bytes32 hash) external payable {
        require(msg.value == newDocumentFee);

        addDocumentForFree(hash);
    }

    function addDocumentForFree(bytes32 hash) private {
        require(!documents[hash].exists);

        documents[hash] = Document(msg.sender, hash, 0, true, false);
        emit DocumentAdded(hash, msg.sender);
    }

    function updateDocument(bytes32 oldHash, bytes32 newHash) public
        onlyAuthor(oldHash) {
        
        bytes32 c = oldHash;
        while (documents[c].next != 0) {
            c = documents[c].next;
            require(documents[c].exists);
            require(documents[c].author == msg.sender);
        }

        documents[c].next = newHash;
        addDocumentForFree(newHash);

        emit HashUpdated(oldHash, newHash, msg.sender);
    }

    function setRevoke(bytes32 hash, bool revoke) public
        onlyAuthor(hash) {
        
        bool current = documents[hash].revoked;
        if (current != revoke) {
            documents[hash].revoked = revoke;
        }
        
        emit RevokeUpdated(hash, msg.sender, revoke);
    }

    function getAuthor(bytes32 hash) public constant returns (address) {
        return documents[hash].author;
    }
}
