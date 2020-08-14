DROP DATABASE IF EXISTS WAPLE;
CREATE DATABASE WAPLE;
USE WAPLE;

DROP TABLE IF EXISTS USERS;

CREATE TABLE USERS
(
    USER_ID      BIGINT      NOT NULL,
    LAST_DATE    DATE        NOT NULL,
    NAME         VARCHAR(10) NOT NULL,
    MANAGER_FLAG BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (USER_ID)
);

DROP TABLE IF EXISTS `GROUPS`;

CREATE TABLE `GROUPS`
(
    GROUP_ID INT         NOT NULL AUTO_INCREMENT,
    NAME     VARCHAR(20) NOT NULL,
    TOKEN    TEXT DEFAULT NULL,
    PRIMARY KEY (GROUP_ID),
    UNIQUE KEY `UNQ_TOKEN` (TOKEN) USING HASH
);

DROP TABLE IF EXISTS GROUP_MEMBERS;

CREATE TABLE GROUP_MEMBERS
(
    USER_ID  BIGINT NOT NULL,
    GROUP_ID INT    NOT NULL,
    PRIMARY KEY (USER_ID, GROUP_ID),
    CONSTRAINT FK_USERS_GROUP_MEMBERS FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_GROUPS_GROUP_MEMBERS FOREIGN KEY (GROUP_ID) REFERENCES `GROUPS` (GROUP_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS THEMES;

CREATE TABLE THEMES
(
    GROUP_ID INT         NOT NULL,
    THEME_ID INT         NOT NULL,
    NAME     VARCHAR(50) NOT NULL,
    ICON     VARCHAR(50) NOT NULL,
    PRIMARY KEY (GROUP_ID, THEME_ID),
    CONSTRAINT FK_GROUPS_THEMES FOREIGN KEY (GROUP_ID) REFERENCES `GROUPS` (GROUP_ID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS PLACES;

CREATE TABLE PLACES
(
    PLACE_ID VARCHAR(50)  NOT NULL,
    NAME     VARCHAR(50)  NOT NULL,
    ADDRESS  VARCHAR(200) NOT NULL,
    LNG      VARCHAR(20)  NOT NULL,
    LAT      VARCHAR(20)  NOT NULL,
    URL      VARCHAR(200),
    TEL      VARCHAR(20),
    CATEGORY VARCHAR(20),
    PRIMARY KEY (PLACE_ID)
);

DROP TABLE IF EXISTS BOOKMARKS;

CREATE TABLE BOOKMARKS
(
    GROUP_ID INT         NOT NULL,
    THEME_ID INT         NOT NULL,
    PLACE_ID VARCHAR(50) NOT NULL,
    USER_ID  BIGINT,
    PRIMARY KEY (GROUP_ID, THEME_ID, PLACE_ID),
    CONSTRAINT FK_PLACES_BOOKMARKS FOREIGN KEY (PLACE_ID) REFERENCES PLACES (PLACE_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_THEMES_BOOKMARKS FOREIGN KEY (GROUP_ID, THEME_ID) REFERENCES THEMES (GROUP_ID, THEME_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_USERS_BOOKMARKS FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

DROP TABLE IF EXISTS REVIEWS;

CREATE TABLE REVIEWS
(
    REVIEW_ID  INT AUTO_INCREMENT NOT NULL,
    GROUP_ID   INT                NOT NULL,
    PLACE_ID   VARCHAR(50)        NOT NULL,
    USER_ID    BIGINT,
    VISIT_DATE DATE               NOT NULL,
    TITLE      VARCHAR(200)       NOT NULL,
    CONTENT    TEXT(3000),
    MEDIA      TEXT(500),
    PRIMARY KEY (REVIEW_ID),
    CONSTRAINT FK_GROUPS_REVIEWS FOREIGN KEY (GROUP_ID) REFERENCES `GROUPS` (GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_PLACES_REVIEWS FOREIGN KEY (PLACE_ID) REFERENCES PLACES (PLACE_ID) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT FK_USERS_REVIEWS FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE SET NULL ON UPDATE CASCADE
);

DROP TABLE IF EXISTS NOTIFICATIONS;

CREATE TABLE NOTIFICATIONS
(
    GROUP_ID          INT          NOT NULL,
    NOTIFICATION_ID   INT          NOT NULL,
    MESSAGE           VARCHAR(200) NOT NULL,
    NOTIFICATION_DATE DATE         NOT NULL,
    PRIMARY KEY (GROUP_ID, NOTIFICATION_ID),
    CONSTRAINT FK_GROUPS_NOTIFICATIONS FOREIGN KEY (GROUP_ID) REFERENCES `GROUPS` (GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS PROMISES;

CREATE TABLE PROMISES
(
    GROUP_ID     INT          NOT NULL,
    PROMISE_ID   INT          NOT NULL,
    TITLE        VARCHAR(200) NOT NULL,
    PROMISE_DATE DATETIME     NOT NULL,
    PRIMARY KEY (GROUP_ID, PROMISE_ID),
    CONSTRAINT FK_GROUPS_PROMISES FOREIGN KEY (GROUP_ID) REFERENCES `GROUPS` (GROUP_ID) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS PROMISES_AND_PLACES;

CREATE TABLE PROMISES_AND_PLACES
(
    GROUP_ID   INT         NOT NULL,
    PROMISE_ID INT         NOT NULL,
    USER_ID    BIGINT,
    PLACE_ID   VARCHAR(50) NOT NULL,
    PRIMARY KEY (GROUP_ID, PROMISE_ID, PLACE_ID),
    CONSTRAINT FK_PROMISES_PROMISES_AND_PLACES FOREIGN KEY (GROUP_ID, PROMISE_ID) REFERENCES PROMISES (GROUP_ID, PROMISE_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_USERS_PROMISES_AND_PLACES FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT FK_PLACES_PROMISES_AND_PLACES FOREIGN KEY (PLACE_ID) REFERENCES PLACES (PLACE_ID) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS VOTES;

CREATE TABLE VOTES
(
    GROUP_ID   INT         NOT NULL,
    PROMISE_ID INT         NOT NULL,
    USER_ID    BIGINT      NOT NULL,
    PLACE_ID   VARCHAR(50) NOT NULL,
    PRIMARY KEY (GROUP_ID, PROMISE_ID, USER_ID, PLACE_ID),
    CONSTRAINT FK_PROMISES_AND_PLACES_VOTES FOREIGN KEY (GROUP_ID, PROMISE_ID, PLACE_ID) REFERENCES PROMISES_AND_PLACES (GROUP_ID, PROMISE_ID, PLACE_ID) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FK_USERS_VOTES FOREIGN KEY (USER_ID) REFERENCES USERS (USER_ID) ON DELETE CASCADE ON UPDATE CASCADE
);
