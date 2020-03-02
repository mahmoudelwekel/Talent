-- phpMyAdmin SQL Dump
-- version 4.6.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 19, 2019 at 02:49 AM
-- Server version: 5.7.14
-- PHP Version: 5.6.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `talent`
--
CREATE DATABASE IF NOT EXISTS `talent` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
USE `talent`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `image_details` (IN `vid` INT)  begin

if exists (select * from rating where media_id=vid)
then
select m.upload_date,m.description,t.img,u.fullname,ts.tname,ifnull(avg(r.rate),0),m.state
from media m
join talented t on (m.talent_id=t.id)
join users u on (m.talent_id=u.id)
join talents ts on(t.talent_cat_id=ts.id)
join rating r on(r.media_id=m.id)
where m.id=vid
group by m.id;
else 
select m.upload_date,m.description,t.img,u.fullname,ts.tname,ifnull(avg(r.rate),0),m.state
from media m
join talented t on (m.talent_id=t.id)
join users u on (m.talent_id=u.id)
join talents ts on(t.talent_cat_id=ts.id)
join rating r on(r.media_id=m.id)
where m.id=vid;
END IF;


end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `judge_comment` (IN `vid` INT, IN `com` VARCHAR(255))  begin
	insert into notifications (content,media_id) values(com,vid);
SET @TID = LAST_INSERT_ID();
set @UID=(select talent_id from media where id=vid);
	insert into user_notification(notification_id, user_id, is_opened) values (@TID,@UID,0);

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `judge_notify` (IN `vid` INT, IN `com` VARCHAR(255))  begin
	insert into notifications (content,media_id) values(com,vid);
	SET @TID = LAST_INSERT_ID();
	insert into user_notification(notification_id, user_id, is_opened) select @TID,id,0 from users where role='judge';

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `new_img` (IN `im` VARCHAR(255), IN `tid` INT)  begin

insert into images (media_id,img) values (tid,im);

end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `rate_media` (IN `vid` INT, IN `uid` INT, IN `rat` INT)  begin
if exists (select id from rating where media_id=vid and ffrom=uid)
then
update rating 
    set rate=rat
    where media_id=vid and ffrom=uid;
else
	insert into rating (rate,ffrom,media_id) values (rat,uid,vid);
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registertalent` (IN `fname` VARCHAR(255), IN `uname` VARCHAR(255), IN `pass` VARCHAR(255), IN `mob` VARCHAR(20), IN `address` VARCHAR(255), IN `img` VARCHAR(255), IN `talent_id` INT)  BEGIN

insert into users (`fullname`, `username`, `pass`, `role`)  values (fname,uname,pass,'talent');

SET @TID = LAST_INSERT_ID();
insert into talented (id,mobile,address,talented.img,talent_cat_id) values( @TID, mob,address,img,talent_id);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `registerusers` (IN `fname` VARCHAR(255), IN `uname` VARCHAR(255), IN `pass` VARCHAR(255), IN `role` VARCHAR(255))  BEGIN

insert into users (`fullname`, `username`, `pass`, `role`)  values (fname,uname,pass,role);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upload_image` (IN `tid` INT, IN `des` VARCHAR(255))  BEGIN
insert into media (description, state, media_type, talent_id)  values (des,'pending','images',tid);

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upload_video` (IN `tid` INT, IN `des` VARCHAR(255), IN `vidpath` VARCHAR(255))  BEGIN

insert into media (description, state, media_type, talent_id)  values (des,'pending','video',tid);

SET @TID = LAST_INSERT_ID();
insert into  videos (id, video) values( @TID,vidpath);
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `userannouncement` (IN `uid` INT)  BEGIN
select  au.id,a.content,au.is_opened,m.id,m.media_type
from notifications a join user_notification au 
on a.id=au.notification_id
join media m on m.id=a.media_id
where au.user_id=uid
order by a.announ_date DESC limit 8;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `video_details` (IN `vid` INT)  begin
if exists (select * from rating where media_id=vid)
then
select m.upload_date,m.description,v.video,t.img,u.fullname,ts.tname,avg(r.rate),m.state
from media m
join videos v on (m.id=v.id)
join talented t on (m.talent_id=t.id)
join users u on (m.talent_id=u.id)
join talents ts on(t.talent_cat_id=ts.id)
join rating r on(r.media_id=m.id)
where m.id=vid
group by m.id;
else
select m.upload_date,m.description,v.video,t.img,u.fullname,ts.tname,ifnull(avg(r.rate),0),m.state
from media m
join videos v on (m.id=v.id)
join talented t on (m.talent_id=t.id)
join users u on (m.talent_id=u.id)
join talents ts on(t.talent_cat_id=ts.id)
join rating r on(r.media_id=m.id)
where m.id=vid;
end if;
end$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `check_login` (`uname` VARCHAR(255), `pass` VARCHAR(255)) RETURNS VARCHAR(50) CHARSET utf8 BEGIN
    RETURN  (SELECT role FROM users WHERE uname = username AND pass = users.pass and users.role  like role);
end$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(11) NOT NULL,
  `message` varchar(255) NOT NULL,
  `ffrom` int(11) NOT NULL,
  `media_id` int(11) NOT NULL,
  `comment_date` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `message`, `ffrom`, `media_id`, `comment_date`) VALUES
(2, 'ÙÙŠØ¯ÙŠÙˆ Ù…Ù…ØªØ§Ø²', 1, 1, '2019-03-13 01:04:38'),
(3, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ù…Ù…ØªØ§Ø²Ù‡ Ø¨Ø§Ù„ØªÙˆÙÙŠÙ‚', 1, 1, '2019-03-13 01:06:13'),
(4, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ø¬Ù…ÙŠÙ„Ù‡', 1, 2, '2019-03-13 01:24:48'),
(5, 'ÙÙŠØ¯ÙŠÙˆ Ø±Ø§Ø¦Ø¹', 4, 1, '2019-03-13 01:37:53'),
(6, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ù…Ù…ØªØ§Ø²Ù‡ Ø¨Ø§Ù„ØªÙˆÙÙŠÙ‚', 4, 1, '2019-03-13 01:40:44'),
(7, 'Ø±Ø³Ù… Ø±Ø§Ø¦Ø¹', 4, 2, '2019-03-13 01:43:32'),
(8, '', 4, 2, '2019-03-13 03:53:34'),
(9, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ø¬Ù…ÙŠÙ„Ù‡', 4, 2, '2019-03-13 04:02:07'),
(10, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ù…Ù…ØªØ§Ø²Ù‡ Ø¨Ø§Ù„ØªÙˆÙÙŠÙ‚', 1, 2, '2019-03-13 10:52:57'),
(11, 'ÙÙŠØ¯ÙŠÙˆ Ù…Ù…ØªØ§Ø²', 4, 25, '2019-03-15 22:50:33'),
(12, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ù…Ù…ØªØ§Ø²Ù‡ Ø¨Ø§Ù„ØªÙˆÙÙŠÙ‚', 4, 25, '2019-03-15 22:52:51'),
(13, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ù…Ø¶Ø­ÙƒÙ‡', 7, 26, '2019-03-16 00:48:41'),
(14, 'Ù…ÙˆÙ‡Ø¨Ù‡ Ù…Ø¶Ø­ÙƒÙ‡', 7, 26, '2019-03-16 00:51:00'),
(15, 'Ø±Ø§Ø¦Ø¹', 4, 24, '2019-03-16 01:00:38'),
(16, 'Ù…Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ø±Ù‡ Ø­Ù„Ø¤Ø¤Ø¤Ø¤Ø¤Ø©', 7, 2, '2019-03-18 03:18:19'),
(17, 'ÙÙŠØ¯ÙŠÙˆÙˆÙˆ Ø±Ø§Ø§Ø§Ø§Ø§Ø§Ø§Ø§Ø¦Ø¦Ø¦Ø¦Ø¦Ø¦Ø¦Ø¦Ø¦Ø¦Ø¹', 8, 25, '2019-03-19 01:40:49');

-- --------------------------------------------------------

--
-- Table structure for table `images`
--

CREATE TABLE `images` (
  `id` int(11) NOT NULL,
  `media_id` int(11) NOT NULL,
  `img` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `images`
--

INSERT INTO `images` (`id`, `media_id`, `img`) VALUES
(5, 2, 'uimg/talents/1.jpg'),
(6, 2, 'uimg/talents/2.jpg'),
(7, 2, 'uimg/talents/3.jpg'),
(16, 27, 'uimg/talents/120190314121913.png'),
(17, 27, 'uimg/talents/220190314121913.jpg'),
(18, 27, 'uimg/talents/320190314121913.jpg'),
(19, 27, 'uimg/talents/420190314121913.jpg');

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` int(11) NOT NULL,
  `upload_date` datetime DEFAULT CURRENT_TIMESTAMP,
  `description` varchar(255) NOT NULL,
  `state` enum('pending','accepted','refused') DEFAULT NULL,
  `media_type` enum('video','images') DEFAULT NULL,
  `talent_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `media`
--

INSERT INTO `media` (`id`, `upload_date`, `description`, `state`, `media_type`, `talent_id`) VALUES
(1, '2019-03-12 18:49:04', 'Description Description Description\r\nDescription Description Description\r\nDescription Description Description\r\nDescription Description Description\r\nDescription Description Description', 'accepted', 'video', 3),
(2, '2019-03-12 20:34:08', 'art art art cat dog elephant', 'accepted', 'images', 3),
(24, '2019-03-14 01:40:00', 'Ø¹Ø¨Ø¯Ø§Ù„Ù„Ù‡ Ø§Ù„Ø¹ÙŠØ§Ø¯Ù‡', 'accepted', 'video', 3),
(25, '2019-03-14 02:02:12', 'Ø¹Ø¨Ø¯Ø§Ù„Ù„Ù‡ Ø§Ù„Ø¹ÙŠØ§Ø¯Ù‡', 'accepted', 'video', 3),
(26, '2019-03-14 02:02:38', 'Ø¹Ø¨Ø¯Ø§Ù„Ù„Ù‡ Ø§Ù„Ø¹ÙŠØ§Ø¯Ù‡', 'accepted', 'video', 3),
(27, '2019-03-14 02:19:13', 'ØªØ¬Ø±Ø¨Ù‡', 'accepted', 'images', 3);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `content` varchar(255) NOT NULL,
  `media_id` int(11) DEFAULT NULL,
  `announ_date` datetime DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `content`, `media_id`, `announ_date`) VALUES
(11, 'Ù„Ù‚Ø¯ Ø¹Ù„Ù‚ Ø¹Ù„ÙŠ ÙƒÙ†Ø¹Ø§Ù† Ø¹Ù„ÙŠ Ù…ÙˆÙ‡Ø¨ØªÙƒ', 25, '2019-03-15 22:50:33'),
(12, 'aa', 25, '2019-03-15 22:52:13'),
(13, 'Ù„Ù‚Ø¯ Ø¹Ù„Ù‚ Ø¹Ù„ÙŠ ÙƒÙ†Ø¹Ø§Ù† Ø¹Ù„ÙŠ Ù…ÙˆÙ‡Ø¨ØªÙƒ', 25, '2019-03-15 22:52:51'),
(14, 'test', 25, '2019-03-15 23:03:47'),
(15, 'Ù„Ù‚Ø¯ Ù†Ø´Ø±Øª Ù…ÙˆÙ‡Ø¨Ù‡ Ø¬Ø¯ÙŠØ¯Ù‡', 24, '2019-03-15 23:08:14'),
(16, 'tesst', 2, '2019-03-16 00:50:15'),
(17, 'Ù„Ù‚Ø¯ Ø¹Ù„Ù‚ Ø¨Ø´Ø§ÙŠØ± Ø¹Ù‚Ø§Ø¨ Ø§Ù„Ø´Ù…Ø±Ù‰ Ø¹Ù„ÙŠ Ù…ÙˆÙ‡Ø¨ØªÙƒ', 26, '2019-03-16 00:51:00'),
(18, 'Ù„Ù‚Ø¯ Ø¹Ù„Ù‚ Ø¹Ù„ÙŠ ÙƒÙ†Ø¹Ø§Ù† Ø¹Ù„ÙŠ Ù…ÙˆÙ‡Ø¨ØªÙƒ', 24, '2019-03-16 01:00:39'),
(19, 'Ù„Ù‚Ø¯ Ø¹Ù„Ù‚ Ø¨Ø´Ø§ÙŠØ± Ø¹Ù‚Ø§Ø¨ Ø§Ù„Ø´Ù…Ø±Ù‰ Ø¹Ù„ÙŠ Ù…ÙˆÙ‡Ø¨ØªÙƒ', 2, '2019-03-18 03:18:19'),
(20, 'Ù„Ù‚Ø¯ Ø¹Ù„Ù‚ ÙŠØ­ÙŠÙŠ Ø§Ø´Ø±Ù Ø¹Ù„ÙŠ Ù…ÙˆÙ‡Ø¨ØªÙƒ', 25, '2019-03-19 01:40:49');

-- --------------------------------------------------------

--
-- Table structure for table `rating`
--

CREATE TABLE `rating` (
  `id` int(11) NOT NULL,
  `rate` int(11) NOT NULL,
  `ffrom` int(11) NOT NULL,
  `media_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `rating`
--

INSERT INTO `rating` (`id`, `rate`, `ffrom`, `media_id`) VALUES
(1, 56, 3, 27),
(2, 70, 7, 2),
(3, 70, 3, 26),
(4, 52, 3, 25),
(5, 96, 5, 25);

-- --------------------------------------------------------

--
-- Table structure for table `talented`
--

CREATE TABLE `talented` (
  `id` int(11) NOT NULL,
  `mobile` varchar(15) NOT NULL,
  `address` varchar(255) NOT NULL,
  `img` varchar(255) NOT NULL,
  `talent_cat_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `talented`
--

INSERT INTO `talented` (`id`, `mobile`, `address`, `img`, `talent_cat_id`) VALUES
(1, '01201636485', 'alexandira', '../img/def.png', 1),
(3, '01201636485', 'alexandiraaa', 'uimg/users/ttest20190312014924.png', 1);

-- --------------------------------------------------------

--
-- Table structure for table `talents`
--

CREATE TABLE `talents` (
  `id` int(11) NOT NULL,
  `tname` varchar(255) NOT NULL,
  `img` varchar(255) NOT NULL,
  `description` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `talents`
--

INSERT INTO `talents` (`id`, `tname`, `img`, `description`) VALUES
(1, 'test', 'img/1.jpg', 'test test'),
(2, 'Ø§Ù„Ù…ÙˆÙ‡Ø¨Ù‡ Ø§Ù„Ø«Ø§Ù†ÙŠÙ‡', 'img/4.jpg', 'Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ '),
(3, 'Ø§Ù„Ù…ÙˆÙ‡Ø¨Ù‡ Ø§Ù„Ø«Ø§Ù„Ø«Ù‡', 'img/2.jpg', 'Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ Ø§Ù„ØªÙØ§ØµÙŠÙ„ '),
(4, 'test4', 'img/3.jpg', 'test test');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `fullname` varchar(52) NOT NULL,
  `username` varchar(52) NOT NULL,
  `pass` varchar(52) NOT NULL,
  `role` enum('admin','talent','audience','judge') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `fullname`, `username`, `pass`, `role`) VALUES
(1, 'Mohamed Mansour', 'Mmans', '123', 'talent'),
(2, 'audience test', 'atest', '123', 'audience'),
(3, 'talent test', 'ttest', '123', 'talent'),
(4, 'Ø¹Ù„ÙŠ ÙƒÙ†Ø¹Ø§Ù†', 'ali', '123', 'judge'),
(5, 'Admin test', 'adm', '123', 'admin'),
(7, 'Ø¨Ø´Ø§ÙŠØ± Ø¹Ù‚Ø§Ø¨ Ø§Ù„Ø´Ù…Ø±Ù‰', 'bashayer', '123', 'judge'),
(8, 'ÙŠØ­ÙŠÙŠ Ø§Ø´Ø±Ù', 'yahia', '123', 'judge');

-- --------------------------------------------------------

--
-- Table structure for table `user_notification`
--

CREATE TABLE `user_notification` (
  `id` int(11) NOT NULL,
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `is_opened` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `user_notification`
--

INSERT INTO `user_notification` (`id`, `notification_id`, `user_id`, `is_opened`) VALUES
(11, 13, 4, b'1'),
(12, 14, 4, b'0'),
(13, 14, 7, b'1'),
(15, 15, 4, b'1'),
(16, 15, 7, b'1'),
(18, 16, 3, b'1'),
(19, 17, 3, b'1'),
(20, 18, 3, b'1'),
(21, 19, 3, b'1'),
(22, 20, 3, b'1');

-- --------------------------------------------------------

--
-- Table structure for table `videos`
--

CREATE TABLE `videos` (
  `id` int(11) NOT NULL,
  `video` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `videos`
--

INSERT INTO `videos` (`id`, `video`) VALUES
(1, 'video/1.mp4'),
(24, 'video/1.mp4'),
(25, 'video/1.mp4'),
(26, 'video/1.mp4');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ffrom` (`ffrom`),
  ADD KEY `media_id` (`media_id`);

--
-- Indexes for table `images`
--
ALTER TABLE `images`
  ADD PRIMARY KEY (`id`),
  ADD KEY `media_id` (`media_id`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `talent_id` (`talent_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rating`
--
ALTER TABLE `rating`
  ADD PRIMARY KEY (`id`),
  ADD KEY `ffrom` (`ffrom`),
  ADD KEY `media_id` (`media_id`);

--
-- Indexes for table `talented`
--
ALTER TABLE `talented`
  ADD PRIMARY KEY (`id`),
  ADD KEY `talent_cat_id` (`talent_cat_id`);

--
-- Indexes for table `talents`
--
ALTER TABLE `talents`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `user_notification`
--
ALTER TABLE `user_notification`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notification_id` (`notification_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `videos`
--
ALTER TABLE `videos`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;
--
-- AUTO_INCREMENT for table `images`
--
ALTER TABLE `images`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;
--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;
--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
--
-- AUTO_INCREMENT for table `rating`
--
ALTER TABLE `rating`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `talents`
--
ALTER TABLE `talents`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `user_notification`
--
ALTER TABLE `user_notification`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_ibfk_1` FOREIGN KEY (`ffrom`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `comments_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`);

--
-- Constraints for table `images`
--
ALTER TABLE `images`
  ADD CONSTRAINT `images_ibfk_1` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`);

--
-- Constraints for table `media`
--
ALTER TABLE `media`
  ADD CONSTRAINT `media_ibfk_1` FOREIGN KEY (`talent_id`) REFERENCES `talented` (`id`);

--
-- Constraints for table `rating`
--
ALTER TABLE `rating`
  ADD CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`ffrom`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`);

--
-- Constraints for table `talented`
--
ALTER TABLE `talented`
  ADD CONSTRAINT `talented_ibfk_1` FOREIGN KEY (`id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `talented_ibfk_2` FOREIGN KEY (`talent_cat_id`) REFERENCES `talents` (`id`);

--
-- Constraints for table `user_notification`
--
ALTER TABLE `user_notification`
  ADD CONSTRAINT `user_notification_ibfk_1` FOREIGN KEY (`notification_id`) REFERENCES `notifications` (`id`),
  ADD CONSTRAINT `user_notification_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `videos`
--
ALTER TABLE `videos`
  ADD CONSTRAINT `videos_ibfk_1` FOREIGN KEY (`id`) REFERENCES `media` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
