// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract EventExample {
    // 1️. Add an event called "NewUserRegistered" with 2 arguments
    // 👉 user as address type
    // 👉 username as string type
    // CODE HERE 👇
    event NewUserRegistered(address indexed user, string userName); // indexded is like indexing in the database for quick filter

    struct User {
        string username;
        uint256 age;
    }

    mapping(address => User) public users;

    function registerUser(string memory _username, uint256 _age) public {
        User storage newUser = users[msg.sender];
        newUser.username = _username;
        newUser.age = _age;

        // 2. Emit the event with msg.sender and username as the inputs
        // CODE HERE 👇
        emit NewUserRegistered(msg.sender, _username);
    }
}
