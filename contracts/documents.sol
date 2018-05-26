pragma solidity ^0.4.23;

contract Documents {

    struct Document {
        address author;
        bytes32 hash;
        bytes32 next;
        bool exists;
        bool revoked;
    }

    mapping(bytes32 => Document) public documents;
    mapping(bytes32 => address) public approvals;

    event DocumentAdded(bytes32 hash, address author);
    event HashUpdated(bytes32 oldHash, bytes32 newHash, address author);
    event RevokeUpdated(bytes32 hash, address author, bool newStatus);
    event Approval(bytes32 hash, address from, address to);
    event OwnershipTransfer(bytes32 hash, address from, address to);
    
    modifier onlyAuthor(bytes32 hash) {
        require(documents[hash].author == msg.sender);
        _;
    }

    function addDocument(bytes32 hash) public {
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
        addDocument(newHash);

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
    
    function approve(address to, bytes32 hash) public
        onlyAuthor(hash) {
        
        approvals[hash] = msg.sender;
        emit Approval(hash, msg.sender, to);
    }
    
    function takeOwnership(bytes32 hash) public {
        require(approvals[hash] == msg.sender);
        address prevAuthor = documents[hash].author;
        documents[hash].author = msg.sender;
        emit OwnershipTransfer(hash, prevAuthor, msg.sender);
    }
}
