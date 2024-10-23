// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

// 1. Create a Twitter Contract
// 2. Create a mapping between user and tweet
// 3. Add gunction to create a tweet and save it in mapping
// 4. Create a funtion to get Tweet
// 5. Get all Tweet based on owner Address
// ---------------------------
// 1. Define a Tweet Struct with author,content,timestamp,likes
// 2. Add stuct to Array
// 3. Test Tweets
//----------------------------------
// 1. Use require to limit the length of the tweet to be only 280 characters
//-------------------------------------------
// 1. Add a function called changeTweetLength to change max tweet length
// 2. Create a construnvtor function to set an owner of contract
// 3. Create a modifier called onlyOwner
// 4. Use onlyOwner on the changeTweetLength function
// -------------------------
// 1. Add id to Tweet Struct to make every Tweet Unique
// 2. Set the id yo be the Tweet[] length
// HINT: You can do it in createTweet function
// 3. Add a function to like the tweet.
// HINT: make sure you can unlike only if count is greater then 0
// 4. Add a function to unlike the tweet.
// 5. Make both function external.

contract Twitter {
    // define stuct
    uint16 public MAX_TWEET_LENGTH = 250;
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 timestamp;
        uint256 likes;
    }

    mapping(address => Tweet[]) public tweets;
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "YOU ARE NOT THE OWNER!");
        _;
    }

    function changeTweetLength(uint16 _newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = _newTweetLength;
    }

    function createTweet(string memory _tweet) public {
        //  if tweet length <=20 characters then we are good , otherwise revert.
        require(
            bytes(_tweet).length <= MAX_TWEET_LENGTH,
            "Tweet is too long bro!"
        );

        Tweet memory newTweet = Tweet({
            id: tweets[msg.sender].length,
            author: msg.sender,
            content: _tweet,
            timestamp: block.timestamp,
            likes: 0
        });
        tweets[msg.sender].push(newTweet);
    }

    function likeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        tweets[author][id].likes++;
    }

    function unlikeTweet(address author, uint256 id) external {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes > 0, "TWEET HAS NO LIKES");
        tweets[author][id].likes--;
    }

    function getTweet(uint256 i) public view returns (Tweet memory) {
        return tweets[msg.sender][i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
