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

    event DocumentAdded(bytes32 hash, address author);
    event DocumentUpdated(bytes32 oldHash, bytes32 newHash, address author);
    event DocumentRevoked(bytes32 hash, address author);

    function addDocument(bytes32 hash) public {
        require(!documents[hash].exists);

        documents[hash] = Document(msg.sender, hash, 0, true, false);
        emit DocumentAdded(hash, msg.sender);
    }

    function updateDocument(bytes32 oldHash, bytes32 newHash) public {
        require(documents[oldHash].exists);
        require(documents[oldHash].author == msg.sender);

        bytes32 c = oldHash;
        while (documents[c].next != 0) {
            c = documents[c].next;
            require(documents[c].exists);
            require(documents[c].author == msg.sender);
        }

        documents[c].next = newHash;
        addDocument(newHash);

        emit DocumentUpdated(oldHash, newHash, msg.sender);
    }

    function revokeDocument(bytes32 hash) public {
        require(documents[hash].exists);
        require(documents[hash].author == msg.sender);

        documents[hash].revoked = true;
        emit DocumentRevoked(hash, msg.sender);
    }
}
