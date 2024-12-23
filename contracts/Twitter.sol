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
// -------------------------------
// 1. Create Event for creating the tweet,called TweetCreated use parameters like id, author,content,timestamp
// 2. Emit the Event in the createTweet() funtion below
// 3. Create Event for liking the tweet, called TweetLiked use parameters like ,liker,tweetAuthor,tweetId,newLikeCount
// 4. Emit the event in the likeTweet() funtion below
// -------------------------------
// 1. Create a function ,getTotalLikes, to get total Tweet Likes for the user , USE parameters of author
// 2. Loop over all the tweets
// 3. Sum up totalLikes
// 4. Return totalLikes
// -----------------------------------
// 1. Import Ownable.sol contract from OpenZeppelin
// 2. Inherit Ownable Contract
// 3. Replace current onlyOwner

// 2. Add a getProfile() function to the interface
// 3. Initialize the IProfile in the contructor
// HINT: don't forget to include the _profileContract address as input
// 4. Create a modifier called onlyRegistered that require the msg.sender to have a profile
// HINT: user the getProfile() to get the user
// 5. ADD the onlyRegistred modifier to createTweet,likeTweet, and unlikeTweet

import "@openzeppelin/contracts/access/Ownable.sol";

interface IProfile {
    struct UserProfile {
        string displayNAme;
        string bio;
    }

    function getProfile(address _userAddress)
        external
        view
        returns (UserProfile memory);
}

contract Twitter is Ownable {
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
    // address public owner;

    IProfile profileContract;

    event TweetCreated(
        uint256 id,
        address author,
        string content,
        uint256 timestamp
    );

    event TweetLiked(
        address liker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newLikecount
    );
    event TweetUnliked(
        address unliker,
        address tweetAuthor,
        uint256 tweetId,
        uint256 newLikecount
    );

    constructor(address _profileContract) Ownable(msg.sender) {
        profileContract = IProfile(_profileContract);
    }

    // modifier onlyOwner() {
    //     require(msg.sender == owner, "YOU ARE NOT THE OWNER!");
    //     _;
    // }
    modifier onlyRegistred() {
        IProfile.UserProfile memory userProfileTemp = profileContract
            .getProfile(msg.sender);
        require(
            bytes(userProfileTemp.displayNAme).length > 0,
            "USER NOT REGISTRED"
        );
        _;
    }

    function changeTweetLength(uint16 _newTweetLength) public onlyOwner {
        MAX_TWEET_LENGTH = _newTweetLength;
    }

    function getTotalLikes(address _author) external view returns (uint256) {
        uint256 totalLikes = 0;
        for (uint256 i = 0; i < tweets[_author].length; i++) {
            totalLikes += tweets[_author][i].likes;
        }
        return totalLikes;
    }

    function createTweet(string memory _tweet) public onlyRegistred {
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

        emit TweetCreated(
            newTweet.id,
            newTweet.author,
            newTweet.content,
            newTweet.timestamp
        );
    }

    function likeTweet(address author, uint256 id) external onlyRegistred {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        tweets[author][id].likes++;

        emit TweetLiked(msg.sender, author, id, tweets[author][id].likes);
    }

    function unlikeTweet(address author, uint256 id) external onlyRegistred {
        require(tweets[author][id].id == id, "TWEET DOES NOT EXIST");
        require(tweets[author][id].likes > 0, "TWEET HAS NO LIKES");
        tweets[author][id].likes--;
        emit TweetUnliked(msg.sender, author, id, tweets[author][id].likes);
    }

    function getTweet(uint256 i) public view returns (Tweet memory) {
        return tweets[msg.sender][i];
    }

    function getAllTweets(address _owner) public view returns (Tweet[] memory) {
        return tweets[_owner];
    }
}
