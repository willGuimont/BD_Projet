DROP DATABASE IF EXISTS Memer;

CREATE DATABASE Memer;
use Memer;

DROP TABLE IF EXISTS Memes;
DROP TABLE IF EXISTS Users;
DROP TABLE IF EXISTS Liked;
DROP TABLE IF EXISTS Disliked;
DROP TABLE IF EXISTS Seen;
DROP TABLE IF EXISTS Uploaded;
DROP TABLE IF EXISTS Comment;
DROP TABLE IF EXISTS Token;
DROP TABLE IF EXISTS Top;

CREATE TABLE Memes
(
    id       VARCHAR(36) UNIQUE NOT NULL,
    title    VARCHAR(100),
    url      VARCHAR(200),
    category VARCHAR(100),

    PRIMARY KEY (id)
);

CREATE TABLE Users
(
    id             VARCHAR(36) UNIQUE NOT NULL,
    username       VARCHAR(30) UNIQUE,
	avatar		   VARCHAR(200),
    email          VARCHAR(50) UNIQUE,
    hashedPassword VARCHAR(128),
    salt           VARCHAR(36),

    PRIMARY KEY (id)
);

CREATE TABLE Follow
(
    followee VARCHAR(36) NOT NULL,
    follower VARCHAR(36) NOT NULL,

    FOREIGN KEY (follower) REFERENCES Users (id)
        ON UPDATE CASCADE,
    FOREIGN KEY (followee) REFERENCES Users (id)
        ON UPDATE CASCADE
);


CREATE TABLE Seen
(
    userId VARCHAR(36) NOT NULL,
    memeId VARCHAR(36) NOT NULL,
    date   DATE,


    FOREIGN KEY (userId) REFERENCES Users (id)
        ON UPDATE CASCADE,
    FOREIGN KEY (memeId) REFERENCES Memes (id)
        ON UPDATE CASCADE
);

CREATE TABLE Liked
(
    userId VARCHAR(36) NOT NULL,
    memeId VARCHAR(36) NOT NULL,


    FOREIGN KEY (userId) REFERENCES Users (id)
        ON UPDATE CASCADE,
    FOREIGN KEY (memeId) REFERENCES Memes (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Disliked
(
    userId VARCHAR(36) NOT NULL,
    memeId VARCHAR(36) NOT NULL,


    FOREIGN KEY (userId) REFERENCES Users (id)
        ON UPDATE CASCADE,
    FOREIGN KEY (memeId) REFERENCES Memes (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Uploaded
(
    userId VARCHAR(36) NOT NULL,
    memeId VARCHAR(36) NOT NULL,
    date   DATE,

    FOREIGN KEY (userId) REFERENCES Users (id)
        ON UPDATE CASCADE,
    FOREIGN KEY (memeId) REFERENCES Memes (id)
        ON DELETE CASCADE
);

CREATE TABLE Comment
(
    commentId VARCHAR(36) NOT NULL,
    userId    VARCHAR(36) NOT NULL,
    memeId    VARCHAR(36) NOT NULL,
    date      DATE,
    text      VARCHAR(1000),

    PRIMARY KEY (commentId),
    FOREIGN KEY (userId) REFERENCES Users (id)
        ON UPDATE CASCADE,
    FOREIGN KEY (memeId) REFERENCES Memes (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

CREATE TABLE Token
(
    id          INTEGER AUTO_INCREMENT,
    userId      VARCHAR(36) NOT NULL,
    token       VARCHAR(36) UNIQUE,
    expiredDate DATE,

    PRIMARY KEY (id),
    FOREIGN KEY (userId) REFERENCES Users (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);


CREATE TABLE Top
(
    memeId VARCHAR(36) NOT NULL,

    PRIMARY KEY (memeId),
    FOREIGN KEY (memeId) REFERENCES Memes (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- TODO remove before deposit
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt)
VALUES ('admin', 'admin', 'https://store.playstation.com/store/api/chihiro/00_09_000/container/FR/fr/999/EP0149-CUSA09988_00-AV00000000000001/1553560094000/image?w=240&h=240&bg_color=000000&opacity=100&_version=00_09_000', 'admin@admin.com', 'admin', 'admin');

INSERT INTO Token (userId, token, expiredDate)
VALUES ('admin', 'admin', '2021-01-01');

-- TODO add ONE DELETE and ON UPDATE
-- TODO trigger on Liked to Top
-- TODO trigger verify username validity
-- TODO trigger remove old token

-- Triggers
-- delimiter //
DROP PROCEDURE IF EXISTS remove_old_token;
CREATE DEFINER = 'memer_api' PROCEDURE remove_old_token() DELETE FROM Token WHERE expiredDate <= CURRENT_DATE();
-- delimiter ;

-- Indexes
CREATE UNIQUE INDEX token_index ON Token (token) USING HASH;
CREATE FULLTEXT INDEX username_index ON Users (username);

-- User
DROP USER IF EXISTS 'memer_api';
CREATE USER 'memer_api' IDENTIFIED BY '4215Hello!@';
GRANT SELECT, INSERT, UPDATE, DELETE ON Memer.* TO 'memer_api';
GRANT EXECUTE ON PROCEDURE Memer.remove_old_token TO 'memer_api';

-- Insert data
INSERT INTO Memes (id, title, url, category) VALUES ("a882eab7-5952-4a61-b482-46647ff559be", "Est magnam ipsum dolor aliquam ut voluptatem est.", "https://i.redd.it/00pwop4bjsy11.jpg", "classic");
INSERT INTO Memes (id, title, url, category) VALUES ("46069398-c65e-4bb2-93eb-ed658c6acf15", "Adipisci quisquam sed dolore ut amet est.", "https://i.redd.it/7fmda1cpwf421.jpg", "dank");
INSERT INTO Memes (id, title, url, category) VALUES ("f1eb2f13-a0bb-4514-b665-6699f4a26a03", "Dolore neque quiquia modi quisquam.", "https://preview.redd.it/hnikeip39ur21.jpg?width=640&crop=smart&auto=webp&s=72794533a67b87ffeb0fdb525281184da5320a75", "catz");
INSERT INTO Memes (id, title, url, category) VALUES ("611fb1c9-b832-447b-ac9b-e257a9658580", "Eius dolore quaerat velit voluptatem.", "https://preview.redd.it/tkbusgmmotr21.jpg?width=960&crop=smart&auto=webp&s=131994de6ebdf657687451229853be42b143da2b", "dank");
INSERT INTO Memes (id, title, url, category) VALUES ("c908d39a-78e7-4741-8191-dc7d5bb0311d", "Eius ut dolor quisquam porro dolorem numquam.", "https://preview.redd.it/bq2j0dw68tr21.png?width=960&crop=smart&auto=webp&s=b490cefdf787c73e562e699adfd961541045e857", "holdmybeer");
INSERT INTO Memes (id, title, url, category) VALUES ("b6fd72fe-5a0a-4d5a-b289-b169dc9e69aa", "Sed est porro quaerat non quaerat dolor ut.", "https://preview.redd.it/tkbusgmmotr21.jpg?width=960&crop=smart&auto=webp&s=131994de6ebdf657687451229853be42b143da2b", "catz");
INSERT INTO Memes (id, title, url, category) VALUES ("0feabeb0-e1b2-4c36-85e2-54c08039b4b4", "Etincidunt non est ut non non labore dolorem.", "https://preview.redd.it/bq2j0dw68tr21.png?width=960&crop=smart&auto=webp&s=b490cefdf787c73e562e699adfd961541045e857", "2meirl4meirl");
INSERT INTO Memes (id, title, url, category) VALUES ("752e57fa-18eb-44df-b84f-b529b90a5879", "Magnam aliquam magnam dolore quaerat.", "https://i.redd.it/efks3i9rhtr21.jpg", "catz");
INSERT INTO Memes (id, title, url, category) VALUES ("efcbcefc-d7ed-49b7-b1a3-a459dfd62fba", "Eius ut consectetur etincidunt.", "https://preview.redd.it/2ya4b0sjbtr21.jpg?width=960&crop=smart&auto=webp&s=fb8d1aa13ccdb73d6b4aa422d9f19b18cc8da05e", "2009");
INSERT INTO Memes (id, title, url, category) VALUES ("e0630205-c20f-49f7-a7e5-38cb870b5d4b", "Dolore dolor dolor quaerat.", "https://preview.redd.it/hnikeip39ur21.jpg?width=640&crop=smart&auto=webp&s=72794533a67b87ffeb0fdb525281184da5320a75", "dank");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "patate0", "https://banner2.kisspng.com/20180202/coq/kisspng-smiley-anger-angry-expression-5a74670b4552c0.292907191517577995284.jpg", "patate0@pfk.eu", "809", "974");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("eb2429f5-eb28-4c6d-a0f2-39162daab922", "yan1", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS0WMIMCWCCZ8LxgACZMv3eO441cvSIsUIFH_8aR_e7JGy3UTiJTA", "yan1@gmail.com", "474", "993");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("0dc65611-40ec-4f81-a2c6-a38302147389", "allo2", "https://images.alphacoders.com/476/thumb-1920-4761.jpg", "allo2@memer.ca", "778", "761");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "mark3", "https://cdn.shopify.com/s/files/1/1061/1924/products/Emoji_Icon_-_Smirk_face_large.png?v=1542436013", "mark3@memer.ca", "130", "125");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "patate4", "https://images.alphacoders.com/476/thumb-1920-4761.jpg", "patate4@null.null", "851", "768");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "hotdog5", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTVbs4YIhQrBTWQ-1pEj3mhyTOmFL2lVfsS37px81N1s7IazLG_", "hotdog5@memer.ca", "462", "802");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "hotdog6", "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQb2AfQjrtZnNtqy4diFZNyTSH4peeJCqJgIUPvJo5dHSNjcB17", "hotdog6@abc.uk", "696", "38");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("d14f2b64-07fd-433b-863c-a93db594ceb5", "will7", "https://banner2.kisspng.com/20180202/coq/kisspng-smiley-anger-angry-expression-5a74670b4552c0.292907191517577995284.jpg", "will7@pfk.eu", "757", "61");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("862e6e41-c538-4c06-aa6c-7fda8856fa35", "paul8", "https://images-na.ssl-images-amazon.com/images/I/51bolC6rJHL.jpg", "paul8@memer.ca", "356", "283");
INSERT INTO Users (id, username, avatar, email, hashedPassword, salt) VALUES ("07d2bcd4-8f92-43dc-8aec-2f39a14f1fbb", "hotdog9", "https://images.alphacoders.com/476/thumb-1920-4761.jpg", "hotdog9@pfk.eu", "817", "921");
INSERT INTO Follow (followee, follower) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "04ccff1d-1047-4873-938e-47a79d155c77");
INSERT INTO Follow (followee, follower) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "6b59d6d1-674f-4ee9-8ba1-9b157dc7c293");
INSERT INTO Follow (followee, follower) VALUES ("07d2bcd4-8f92-43dc-8aec-2f39a14f1fbb", "eb2429f5-eb28-4c6d-a0f2-39162daab922");
INSERT INTO Follow (followee, follower) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "862e6e41-c538-4c06-aa6c-7fda8856fa35");
INSERT INTO Follow (followee, follower) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "04ccff1d-1047-4873-938e-47a79d155c77");
INSERT INTO Follow (followee, follower) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "d14f2b64-07fd-433b-863c-a93db594ceb5");
INSERT INTO Follow (followee, follower) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "07d2bcd4-8f92-43dc-8aec-2f39a14f1fbb");
INSERT INTO Follow (followee, follower) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "04ccff1d-1047-4873-938e-47a79d155c77");
INSERT INTO Follow (followee, follower) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "1f71561a-527e-4652-a139-98d4f66267c0");
INSERT INTO Follow (followee, follower) VALUES ("eb2429f5-eb28-4c6d-a0f2-39162daab922", "0dc65611-40ec-4f81-a2c6-a38302147389");
INSERT INTO Seen (userId, memeId, date) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "b6fd72fe-5a0a-4d5a-b289-b169dc9e69aa", "2018-02-19");
INSERT INTO Seen (userId, memeId, date) VALUES ("0dc65611-40ec-4f81-a2c6-a38302147389", "efcbcefc-d7ed-49b7-b1a3-a459dfd62fba", "2018-05-05");
INSERT INTO Seen (userId, memeId, date) VALUES ("eb2429f5-eb28-4c6d-a0f2-39162daab922", "611fb1c9-b832-447b-ac9b-e257a9658580", "2018-03-17");
INSERT INTO Seen (userId, memeId, date) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "a882eab7-5952-4a61-b482-46647ff559be", "2016-10-12");
INSERT INTO Seen (userId, memeId, date) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "a882eab7-5952-4a61-b482-46647ff559be", "2017-12-12");
INSERT INTO Seen (userId, memeId, date) VALUES ("0dc65611-40ec-4f81-a2c6-a38302147389", "b6fd72fe-5a0a-4d5a-b289-b169dc9e69aa", "2019-01-21");
INSERT INTO Seen (userId, memeId, date) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4", "2016-12-25");
INSERT INTO Seen (userId, memeId, date) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "b6fd72fe-5a0a-4d5a-b289-b169dc9e69aa", "2016-09-17");
INSERT INTO Seen (userId, memeId, date) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "611fb1c9-b832-447b-ac9b-e257a9658580", "2018-11-28");
INSERT INTO Seen (userId, memeId, date) VALUES ("eb2429f5-eb28-4c6d-a0f2-39162daab922", "46069398-c65e-4bb2-93eb-ed658c6acf15", "2016-08-26");
INSERT INTO Liked (userId, memeId) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "c908d39a-78e7-4741-8191-dc7d5bb0311d");
INSERT INTO Liked (userId, memeId) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4");
INSERT INTO Liked (userId, memeId) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "752e57fa-18eb-44df-b84f-b529b90a5879");
INSERT INTO Liked (userId, memeId) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "752e57fa-18eb-44df-b84f-b529b90a5879");
INSERT INTO Liked (userId, memeId) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4");
INSERT INTO Liked (userId, memeId) VALUES ("862e6e41-c538-4c06-aa6c-7fda8856fa35", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4");
INSERT INTO Liked (userId, memeId) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "46069398-c65e-4bb2-93eb-ed658c6acf15");
INSERT INTO Liked (userId, memeId) VALUES ("0dc65611-40ec-4f81-a2c6-a38302147389", "e0630205-c20f-49f7-a7e5-38cb870b5d4b");
INSERT INTO Liked (userId, memeId) VALUES ("d14f2b64-07fd-433b-863c-a93db594ceb5", "e0630205-c20f-49f7-a7e5-38cb870b5d4b");
INSERT INTO Liked (userId, memeId) VALUES ("d14f2b64-07fd-433b-863c-a93db594ceb5", "752e57fa-18eb-44df-b84f-b529b90a5879");
INSERT INTO Disliked (userId, memeId) VALUES ("07d2bcd4-8f92-43dc-8aec-2f39a14f1fbb", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4");
INSERT INTO Disliked (userId, memeId) VALUES ("d14f2b64-07fd-433b-863c-a93db594ceb5", "c908d39a-78e7-4741-8191-dc7d5bb0311d");
INSERT INTO Disliked (userId, memeId) VALUES ("0dc65611-40ec-4f81-a2c6-a38302147389", "46069398-c65e-4bb2-93eb-ed658c6acf15");
INSERT INTO Disliked (userId, memeId) VALUES ("eb2429f5-eb28-4c6d-a0f2-39162daab922", "46069398-c65e-4bb2-93eb-ed658c6acf15");
INSERT INTO Disliked (userId, memeId) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "efcbcefc-d7ed-49b7-b1a3-a459dfd62fba");
INSERT INTO Disliked (userId, memeId) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "e0630205-c20f-49f7-a7e5-38cb870b5d4b");
INSERT INTO Disliked (userId, memeId) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "611fb1c9-b832-447b-ac9b-e257a9658580");
INSERT INTO Disliked (userId, memeId) VALUES ("eb2429f5-eb28-4c6d-a0f2-39162daab922", "a882eab7-5952-4a61-b482-46647ff559be");
INSERT INTO Disliked (userId, memeId) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "611fb1c9-b832-447b-ac9b-e257a9658580");
INSERT INTO Disliked (userId, memeId) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "e0630205-c20f-49f7-a7e5-38cb870b5d4b");
INSERT INTO Uploaded (userId, memeId) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "a882eab7-5952-4a61-b482-46647ff559be");
INSERT INTO Uploaded (userId, memeId) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "46069398-c65e-4bb2-93eb-ed658c6acf15");
INSERT INTO Uploaded (userId, memeId) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "f1eb2f13-a0bb-4514-b665-6699f4a26a03");
INSERT INTO Uploaded (userId, memeId) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "611fb1c9-b832-447b-ac9b-e257a9658580");
INSERT INTO Uploaded (userId, memeId) VALUES ("0dc65611-40ec-4f81-a2c6-a38302147389", "c908d39a-78e7-4741-8191-dc7d5bb0311d");
INSERT INTO Uploaded (userId, memeId) VALUES ("72b2fe31-1fd0-4caa-bb4c-5a234766a0a6", "b6fd72fe-5a0a-4d5a-b289-b169dc9e69aa");
INSERT INTO Uploaded (userId, memeId) VALUES ("d14f2b64-07fd-433b-863c-a93db594ceb5", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4");
INSERT INTO Uploaded (userId, memeId) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "752e57fa-18eb-44df-b84f-b529b90a5879");
INSERT INTO Uploaded (userId, memeId) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "efcbcefc-d7ed-49b7-b1a3-a459dfd62fba");
INSERT INTO Uploaded (userId, memeId) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "e0630205-c20f-49f7-a7e5-38cb870b5d4b");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("0d8be3b3-72f5-44ff-8788-f388a9dfc31a", "6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "c908d39a-78e7-4741-8191-dc7d5bb0311d", "2018-10-27", "Non sit magnam aliquam non sit est.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("10737250-08bc-4998-a7ef-f422bf148d04", "f2c17ef8-096f-460e-b926-eff0278d9883", "46069398-c65e-4bb2-93eb-ed658c6acf15", "2019-03-21", "Ut sed velit sit eius labore amet.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("17498a62-c99b-427c-8749-fffb57b51a2f", "eb2429f5-eb28-4c6d-a0f2-39162daab922", "e0630205-c20f-49f7-a7e5-38cb870b5d4b", "2017-06-05", "Quiquia quaerat sit sit adipisci amet.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("c8546c7b-5250-45b7-9e74-9f3463ee84d7", "04ccff1d-1047-4873-938e-47a79d155c77", "c908d39a-78e7-4741-8191-dc7d5bb0311d", "2018-05-18", "Tempora ut eius sed voluptatem est ut.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("f3177ee1-2033-466d-be35-ec1e8cb7bcf2", "f2c17ef8-096f-460e-b926-eff0278d9883", "c908d39a-78e7-4741-8191-dc7d5bb0311d", "2018-02-06", "Eius eius consectetur amet voluptatem neque.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("621941c7-3d64-488a-8b82-f8f84eef887f", "1f71561a-527e-4652-a139-98d4f66267c0", "f1eb2f13-a0bb-4514-b665-6699f4a26a03", "2017-02-04", "Non etincidunt magnam porro numquam velit.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("13cd4fde-a04b-4c7d-bca4-ebe969e8cd71", "1f71561a-527e-4652-a139-98d4f66267c0", "f1eb2f13-a0bb-4514-b665-6699f4a26a03", "2017-10-14", "Eius sit eius ut eius.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("4f6f95a7-4809-4e71-9e87-31af5676489d", "eb2429f5-eb28-4c6d-a0f2-39162daab922", "b6fd72fe-5a0a-4d5a-b289-b169dc9e69aa", "2017-07-20", "Sit non eius ut.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("960e0c64-4109-48ac-b8ef-5566d3c9b1df", "07d2bcd4-8f92-43dc-8aec-2f39a14f1fbb", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4", "2019-03-27", "Magnam eius consectetur dolore.");
INSERT INTO Comment (commentId, userId, memeId, date, text) VALUES ("84579f6a-f66e-4ad6-9409-ef231365cc23", "f2c17ef8-096f-460e-b926-eff0278d9883", "0feabeb0-e1b2-4c36-85e2-54c08039b4b4", "2017-07-15", "Voluptatem porro modi quisquam eius dolorem est.");
INSERT INTO Token (userId, token, expiredDate) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "18696eda-101b-45a8-82a6-aa46412d499d", "2019-03-21");
INSERT INTO Token (userId, token, expiredDate) VALUES ("862e6e41-c538-4c06-aa6c-7fda8856fa35", "abe9e069-9d2b-49b0-9512-70a7cb86f508", "2019-03-23");
INSERT INTO Token (userId, token, expiredDate) VALUES ("f2c17ef8-096f-460e-b926-eff0278d9883", "732e79ca-80e1-4c78-82ae-20a08b71dfdc", "2019-04-05");
INSERT INTO Token (userId, token, expiredDate) VALUES ("1f71561a-527e-4652-a139-98d4f66267c0", "b19f9d9b-5771-42c4-baf9-4a06622e7e0e", "2019-03-19");
INSERT INTO Token (userId, token, expiredDate) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "2c487f2d-2c2b-46ef-b338-eafdc410eeed", "2019-04-13");
INSERT INTO Token (userId, token, expiredDate) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "6ec55013-72e1-43e4-a9ad-a6376b5ff6e5", "2019-03-22");
INSERT INTO Token (userId, token, expiredDate) VALUES ("04ccff1d-1047-4873-938e-47a79d155c77", "3c4f9bd7-346e-41f1-8bad-cc481b9dc9a1", "2019-04-12");
INSERT INTO Token (userId, token, expiredDate) VALUES ("07d2bcd4-8f92-43dc-8aec-2f39a14f1fbb", "3eb86819-a3c5-4816-8450-eebbed34c5ff", "2019-04-13");
INSERT INTO Token (userId, token, expiredDate) VALUES ("862e6e41-c538-4c06-aa6c-7fda8856fa35", "51d5ea12-68e9-4bad-8666-463dfe2b60ee", "2019-04-11");
INSERT INTO Token (userId, token, expiredDate) VALUES ("6b59d6d1-674f-4ee9-8ba1-9b157dc7c293", "8e1952f6-4945-4e1a-a01f-16113b74de54", "2019-03-30");
INSERT INTO Top (memeId) VALUES ("611fb1c9-b832-447b-ac9b-e257a9658580");
INSERT INTO Top (memeId) VALUES ("0feabeb0-e1b2-4c36-85e2-54c08039b4b4");
INSERT INTO Top (memeId) VALUES ("752e57fa-18eb-44df-b84f-b529b90a5879");
INSERT INTO Top (memeId) VALUES ("c908d39a-78e7-4741-8191-dc7d5bb0311d");
INSERT INTO Top (memeId) VALUES ("46069398-c65e-4bb2-93eb-ed658c6acf15");
INSERT INTO Top (memeId) VALUES ("e0630205-c20f-49f7-a7e5-38cb870b5d4b");
INSERT INTO Top (memeId) VALUES ("f1eb2f13-a0bb-4514-b665-6699f4a26a03");
INSERT INTO Top (memeId) VALUES ("a882eab7-5952-4a61-b482-46647ff559be");
INSERT INTO Top (memeId) VALUES ("efcbcefc-d7ed-49b7-b1a3-a459dfd62fba");
INSERT INTO Top (memeId) VALUES ("b6fd72fe-5a0a-4d5a-b289-b169dc9e69aa");
