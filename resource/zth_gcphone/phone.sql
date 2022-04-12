-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Versione server:              5.7.32-log - MySQL Community Server (GPL)
-- S.O. server:                  Win64
-- HeidiSQL Versione:            10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

SELECT COUNT(*)
  INTO @exist
  FROM information_schema.columns
  WHERE table_schema = 'esfx'
  and COLUMN_NAME = 'phone_number'
  AND table_name = 'users' LIMIT 1;
  set @query = IF(@exist <= 0, 'ALTER TABLE `users` ADD COLUMN `phone_number` varchar(255) DEFAULT NULL', 'select \'Column Exists\' status');
  prepare stmt from @query;
EXECUTE stmt;

SELECT COUNT(*)
  INTO @exist
  FROM information_schema.columns
  WHERE table_schema = 'esfx'
  and COLUMN_NAME = 'iban'
  AND table_name = 'users' LIMIT 1;
  set @query = IF(@exist <= 0, 'ALTER TABLE `users` ADD COLUMN `iban` varchar(255) DEFAULT NULL', 'select \'Column Exists\' status');
  prepare stmt from @query;
EXECUTE stmt;

INSERT INTO `items` (`name`, `label`, `weight`) VALUES
  ('phone', 'Phone', 1),
  ('sim', 'Sim', 1),
  ('modem', 'Modem', 1);

-- Dump della struttura di tabella esfx.phone_app_chat
CREATE TABLE IF NOT EXISTS `phone_app_chat` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_app_chat: ~0 rows (circa)
DELETE FROM `phone_app_chat`;
/*!40000 ALTER TABLE `phone_app_chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_app_chat` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_azienda_messages
CREATE TABLE IF NOT EXISTS `phone_azienda_messages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `azienda` varchar(255) DEFAULT NULL,
  `authorIdentifier` varchar(255) DEFAULT NULL,
  `authorName` varchar(255) DEFAULT NULL,
  `authorNumber` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dump dei dati della tabella esfx.phone_azienda_messages: ~0 rows (circa)
DELETE FROM `phone_azienda_messages`;
/*!40000 ALTER TABLE `phone_azienda_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_azienda_messages` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_bank_movements
CREATE TABLE IF NOT EXISTS `phone_bank_movements` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `amount` bigint(20) NOT NULL DEFAULT '0',
  `type` varchar(255) DEFAULT NULL,
  `to` varchar(255) DEFAULT NULL,
  `from` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_bank_movements: ~0 rows (circa)
DELETE FROM `phone_bank_movements`;
/*!40000 ALTER TABLE `phone_bank_movements` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_bank_movements` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_calls
CREATE TABLE IF NOT EXISTS `phone_calls` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `owner` varchar(10) NOT NULL,
  `num` varchar(10) NOT NULL,
  `incoming` int(11) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `accepts` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_calls: ~0 rows (circa)
DELETE FROM `phone_calls`;
/*!40000 ALTER TABLE `phone_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_calls` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_cell_towers
CREATE TABLE IF NOT EXISTS `phone_cell_towers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tower_label` varchar(255) DEFAULT NULL,
  `x` double NOT NULL DEFAULT '0',
  `y` double NOT NULL DEFAULT '0',
  `broken` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `coordinate` (`x`,`y`)
) ENGINE=InnoDB AUTO_INCREMENT=48 DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_cell_towers: ~46 rows (circa)
DELETE FROM `phone_cell_towers`;
/*!40000 ALTER TABLE `phone_cell_towers` DISABLE KEYS */;
INSERT INTO `phone_cell_towers` (`id`, `tower_label`, `x`, `y`, `broken`) VALUES
	(1, 'torre1', -1288.63, -444.78, 0),
	(2, 'torre2', -900.5, -1245.9, 0),
	(3, 'torre3', -65.25, -1282.9, 0),
	(4, 'torre4', 470.5, -1015.85, 0),
	(5, 'torre5', 26.51, 6468.7, 0),
	(6, 'torre6', -143.746, -637.036, 0),
	(7, 'torre7', -429.904, 263.826, 0),
	(8, 'torre8', 1694.717, 3616.178, 0),
	(9, 'torre9', 999.895, 3577.541, 0),
	(10, 'torre10', 2319.618, 2953.879, 0),
	(11, 'torre11', 761.229, 2575.218, 0),
	(12, 'torre12', 1029.065, -3116.018, 0),
	(13, 'torre13', 333.17, 430.42, 0),
	(14, 'torre14', 1555.881, 797.882, 0),
	(15, 'torre15', 1400.267, 2121.764, 0),
	(16, 'torre16', 2972.253, 3489.116, 0),
	(17, 'torre17', -2312.738, 350.847, 0),
	(18, 'torre18', 795.717, -2285.257, 0),
	(19, 'torre19', 38.156, -1836.739, 0),
	(20, 'torre20', 1362.364, -1523.894, 0),
	(21, 'torre21', -2309.044, -370.694, 0),
	(22, 'torre22', 1073.043, 201.276, 0),
	(23, 'torre23', -2062.99, 1984.061, 0),
	(24, 'torre24', -1487.747, -1021.537, 0),
	(25, 'torre25', -2958.35, 474.732, 0),
	(26, 'torre26', -2677.426, 1324.919, 0),
	(27, 'torre27', -914.82, -2519.14, 0),
	(28, 'torre28', -742.06, 5595.33, 0),
	(29, 'torre29', -1579.81, 776.25, 0),
	(30, 'torre30', -637.89, 863.06, 0),
	(31, 'torre31', 2248.84, 5160.42, 0),
	(32, 'torre32', -268.55, 2201.62, 0),
	(33, 'torre33', 2557.87, 395.71, 0),
	(34, 'torre34', 2484.55, 1584.72, 0),
	(35, 'torre35', 1701.67, 6422.1, 0),
	(36, 'torre36', 1032.44, -503.17, 0),
	(37, 'torre37', 3495.63, 4856.12, 0),
	(38, 'torre38', -1521.47, 134.61, 0),
	(40, 'torre40', -1714.13, 5050.15, 0),
	(41, 'torre41', -1118.66, 2695.86, 0),
	(42, 'torre42', 1304.26, 4365.69, 0),
	(43, 'torre43', 109.35, 3581.54, 0),
	(44, 'torre44', 142.26, -2890.87, 0),
	(45, 'torre45', 415.76, -212.23, 0),
	(46, 'torre46', -1511.35, 1507.06, 0),
	(47, 'torre47', -2191.29, 4276.4, 0);
/*!40000 ALTER TABLE `phone_cell_towers` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_crypto_market
CREATE TABLE IF NOT EXISTS `phone_crypto_market` (
  `name` varchar(50) NOT NULL DEFAULT 'BTC',
  `price` double NOT NULL DEFAULT '0',
  `old_price` double NOT NULL DEFAULT '0',
  `last_fluctuation` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_crypto_market: ~3 rows (circa)
DELETE FROM `phone_crypto_market`;
/*!40000 ALTER TABLE `phone_crypto_market` DISABLE KEYS */;
INSERT INTO `phone_crypto_market` (`name`, `price`, `old_price`, `last_fluctuation`) VALUES
	('BTC', 11.489, 17.863, '2021-05-29 16:13:55'),
	('DODGE', 37.063, 3.663, '2021-05-29 16:13:55'),
	('HTR', 1.153, 29.763, '2021-05-29 16:13:55');
/*!40000 ALTER TABLE `phone_crypto_market` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_darkweb_messages
CREATE TABLE IF NOT EXISTS `phone_darkweb_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `author` varchar(255) DEFAULT NULL,
  `message` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dump dei dati della tabella esfx.phone_darkweb_messages: ~0 rows (circa)
DELETE FROM `phone_darkweb_messages`;
/*!40000 ALTER TABLE `phone_darkweb_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_darkweb_messages` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_emails
CREATE TABLE IF NOT EXISTS `phone_emails` (
  `id` int(55) NOT NULL AUTO_INCREMENT,
  `sender` varchar(255) DEFAULT NULL,
  `receiver` varchar(255) DEFAULT NULL,
  `title` varchar(255) DEFAULT NULL,
  `message` mediumtext NOT NULL,
  `pic` varchar(255) DEFAULT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_emails: ~0 rows (circa)
DELETE FROM `phone_emails`;
/*!40000 ALTER TABLE `phone_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_emails` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_instagram_accounts
CREATE TABLE IF NOT EXISTS `phone_instagram_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `avatar_url` varchar(255) NOT NULL DEFAULT '/html/static/img/app_instagram/default_profile.png',
  PRIMARY KEY (`id`),
  UNIQUE KEY `Indice 2` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_instagram_accounts: ~0 rows (circa)
DELETE FROM `phone_instagram_accounts`;
/*!40000 ALTER TABLE `phone_instagram_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_instagram_accounts` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_instagram_likes
CREATE TABLE IF NOT EXISTS `phone_instagram_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL DEFAULT '0',
  `postId` bigint(20) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_instagram_likes_instagram_accounts` (`authorId`),
  KEY `FK_instagram_likes_instagram_posts` (`postId`),
  CONSTRAINT `FK_instagram_likes_instagram_accounts` FOREIGN KEY (`authorId`) REFERENCES `phone_instagram_accounts` (`id`),
  CONSTRAINT `FK_instagram_likes_instagram_posts` FOREIGN KEY (`postId`) REFERENCES `phone_instagram_posts` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_instagram_likes: ~0 rows (circa)
DELETE FROM `phone_instagram_likes`;
/*!40000 ALTER TABLE `phone_instagram_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_instagram_likes` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_instagram_posts
CREATE TABLE IF NOT EXISTS `phone_instagram_posts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `authorId` varchar(255) NOT NULL,
  `image` mediumtext NOT NULL,
  `didascalia` mediumtext NOT NULL,
  `filter` varchar(50) NOT NULL DEFAULT 'Originale',
  `likes` mediumint(9) NOT NULL DEFAULT '0',
  `data` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_instagram_posts: ~1 rows (circa)
DELETE FROM `phone_instagram_posts`;
/*!40000 ALTER TABLE `phone_instagram_posts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_instagram_posts` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_messages
CREATE TABLE IF NOT EXISTS `phone_messages` (
  `id` bigint(50) NOT NULL AUTO_INCREMENT,
  `transmitter` varchar(255) NOT NULL,
  `receiver` varchar(255) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isRead` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) NOT NULL DEFAULT '0',
  `received` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `transmitter` (`transmitter`),
  KEY `receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_messages: 0 rows
DELETE FROM `phone_messages`;
/*!40000 ALTER TABLE `phone_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_messages` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_twitter_accounts
CREATE TABLE IF NOT EXISTS `phone_twitter_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `password` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `avatar_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dump dei dati della tabella esfx.phone_twitter_accounts: ~0 rows (circa)
DELETE FROM `phone_twitter_accounts`;
/*!40000 ALTER TABLE `phone_twitter_accounts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_twitter_accounts` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_twitter_likes
CREATE TABLE IF NOT EXISTS `phone_twitter_likes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) DEFAULT NULL,
  `tweetId` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `FK_twitter_likes_twitter_accounts` (`authorId`),
  KEY `FK_twitter_likes_twitter_tweets` (`tweetId`),
  CONSTRAINT `FK_twitter_likes_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `phone_twitter_accounts` (`id`),
  CONSTRAINT `FK_twitter_likes_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `phone_twitter_tweets` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Dump dei dati della tabella esfx.phone_twitter_likes: ~0 rows (circa)
DELETE FROM `phone_twitter_likes`;
/*!40000 ALTER TABLE `phone_twitter_likes` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_twitter_likes` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_twitter_tweets
CREATE TABLE IF NOT EXISTS `phone_twitter_tweets` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `likes` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `FK_twitter_tweets_twitter_accounts` (`authorId`),
  CONSTRAINT `FK_twitter_tweets_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `phone_twitter_accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Dump dei dati della tabella esfx.phone_twitter_tweets: ~0 rows (circa)
DELETE FROM `phone_twitter_tweets`;
/*!40000 ALTER TABLE `phone_twitter_tweets` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_twitter_tweets` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_users_contacts
CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
  `number` varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
  `display` varchar(64) CHARACTER SET utf8mb4 DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `Indice 2` (`identifier`,`number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_users_contacts: 0 rows
DELETE FROM `phone_users_contacts`;
/*!40000 ALTER TABLE `phone_users_contacts` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_users_contacts` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_users_emails
CREATE TABLE IF NOT EXISTS `phone_users_emails` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_users_emails: ~0 rows (circa)
DELETE FROM `phone_users_emails`;
/*!40000 ALTER TABLE `phone_users_emails` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_users_emails` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_user_covers
CREATE TABLE IF NOT EXISTS `phone_user_covers` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL DEFAULT '0',
  `cover` varchar(250) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_user_covers: ~0 rows (circa)
DELETE FROM `phone_user_covers`;
/*!40000 ALTER TABLE `phone_user_covers` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_user_covers` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_user_crypto
CREATE TABLE IF NOT EXISTS `phone_user_crypto` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `amount` int(11) NOT NULL DEFAULT '0',
  `price` double NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_user_crypto: ~0 rows (circa)
DELETE FROM `phone_user_crypto`;
/*!40000 ALTER TABLE `phone_user_crypto` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_user_crypto` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_whatsapp_groups
CREATE TABLE IF NOT EXISTS `phone_whatsapp_groups` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `icona` varchar(255) NOT NULL,
  `gruppo` varchar(255) NOT NULL DEFAULT 'Nessun nome',
  `partecipanti` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_whatsapp_groups: ~0 rows (circa)
DELETE FROM `phone_whatsapp_groups`;
/*!40000 ALTER TABLE `phone_whatsapp_groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_whatsapp_groups` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_whatsapp_messages
CREATE TABLE IF NOT EXISTS `phone_whatsapp_messages` (
  `id` bigint(255) NOT NULL AUTO_INCREMENT,
  `idgruppo` bigint(255) NOT NULL DEFAULT '0',
  `sender` varchar(255) DEFAULT NULL,
  `message` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_whatsapp_messages: ~0 rows (circa)
DELETE FROM `phone_whatsapp_messages`;
/*!40000 ALTER TABLE `phone_whatsapp_messages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_whatsapp_messages` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_wifi_nets
CREATE TABLE IF NOT EXISTS `phone_wifi_nets` (
  `steam_id` varchar(50) NOT NULL DEFAULT '',
  `label` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(32) NOT NULL DEFAULT '',
  `x` double NOT NULL,
  `y` double NOT NULL,
  `z` double NOT NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `due_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `not_expire` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`steam_id`),
  UNIQUE KEY `coordinate` (`x`,`y`,`z`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_wifi_nets: ~2 rows (circa)
DELETE FROM `phone_wifi_nets`;
/*!40000 ALTER TABLE `phone_wifi_nets` DISABLE KEYS */;
INSERT INTO `phone_wifi_nets` (`steam_id`, `label`, `password`, `x`, `y`, `z`, `created`, `due_date`, `not_expire`) VALUES
	('lifeinvader', 'Life Invader', 'llifeinvader', -1075.832, -248.41, 37.763, '2020-12-18 21:11:10', '2020-12-18 21:11:25', 1),
	('polizia', 'Centrale', 'policeenforce', 447.118, -985.24, 30.69, '2020-12-18 21:11:10', '2020-12-18 21:11:25', 1);
/*!40000 ALTER TABLE `phone_wifi_nets` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.sim
CREATE TABLE IF NOT EXISTS `phone_sim` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(255) NOT NULL,
  `phone_number` varchar(50) DEFAULT NULL,
  `piano_tariffario` varchar(50) DEFAULT 'nessuno',
  `minuti` int(11) DEFAULT '0',
  `messaggi` int(11) DEFAULT '0',
  `dati` int(11) DEFAULT '0',
  `nome_sim` varchar(255) DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `phone_number` (`phone_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dump dei dati della tabella esfx.phone_sim: 0 rows
DELETE FROM `phone_sim`;
/*!40000 ALTER TABLE `phone_sim` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_sim` ENABLE KEYS */;

-- Dump della struttura di tabella esfx.phone_yellow_pages
CREATE TABLE IF NOT EXISTS `phone_yellow_pages` (
  `id` bigint(20) NOT NULL DEFAULT '0',
  `author` varchar(255) DEFAULT NULL,
  `number` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dump dei dati della tabella esfx.phone_yellow_pages: ~0 rows (circa)
DELETE FROM `phone_yellow_pages`;
/*!40000 ALTER TABLE `phone_yellow_pages` DISABLE KEYS */;
/*!40000 ALTER TABLE `phone_yellow_pages` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
