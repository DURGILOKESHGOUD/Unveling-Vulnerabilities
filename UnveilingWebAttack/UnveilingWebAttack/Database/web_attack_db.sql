-- phpMyAdmin SQL Dump
-- version 4.0.4
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jun 29, 2025 at 08:42 PM
-- Server version: 5.6.12-log
-- PHP Version: 5.4.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `web_attack_db`
--
CREATE DATABASE IF NOT EXISTS `web_attack_db` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `web_attack_db`;

-- --------------------------------------------------------

--
-- Table structure for table `attackapp_admin`
--

CREATE TABLE IF NOT EXISTS `attackapp_admin` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `attackapp_predictionresult`
--

CREATE TABLE IF NOT EXISTS `attackapp_predictionresult` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(50) NOT NULL,
  `timestamp` datetime(6) NOT NULL,
  `source_port` int(11) NOT NULL,
  `destination_port` int(11) NOT NULL,
  `packet_size` int(11) NOT NULL,
  `duration_sec` double NOT NULL,
  `model_name` varchar(20) NOT NULL,
  `mitm_prediction` varchar(10) NOT NULL,
  `destination_ip` char(39) NOT NULL,
  `protocol` varchar(10) NOT NULL,
  `session_hijack_prediction` varchar(10) NOT NULL,
  `source_ip` char(39) NOT NULL,
  `tcp_flags` varchar(20) NOT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `attackapp_predictionresult`
--

INSERT INTO `attackapp_predictionresult` (`id`, `session_id`, `timestamp`, `source_port`, `destination_port`, `packet_size`, `duration_sec`, `model_name`, `mitm_prediction`, `destination_ip`, `protocol`, `session_hijack_prediction`, `source_ip`, `tcp_flags`, `user_id`) VALUES
(1, 'S-5322', '2025-06-29 19:09:47.810828', 61022, 21, 527, 0.94, 'Random Forest', 'Session Hi', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(2, 'S-6111', '2025-06-29 19:09:47.810828', 61022, 21, 527, 0.94, 'SVM', 'MITM', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(3, 'S-3675', '2025-06-29 19:09:47.817865', 61022, 21, 527, 0.94, 'Logistic Regression', 'MITM', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(4, 'S-3738', '2025-06-29 19:09:47.819181', 61022, 21, 527, 0.94, 'KNN', 'Session Hi', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(5, 'S-8564', '2025-06-29 19:09:47.819181', 61022, 21, 527, 0.94, 'ANN', 'Phishing', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(6, 'S-8157', '2025-06-29 19:13:36.653557', 61022, 21, 527, 0.94, 'Consensus', 'Session Hi', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(7, 'S-1354', '2025-06-29 19:14:15.792903', 61022, 21, 527, 0.94, 'Consensus', 'Session Hi', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(8, 'S-8342', '2025-06-29 19:14:25.131642', 61022, 21, 527, 0.94, 'Consensus', 'Session Hi', '10.0.0.130', 'SSH', 'Unknown', '192.168.1.122', 'ACK', 3),
(9, 'S-6952', '2025-06-29 19:15:22.111242', 36209, 443, 544, 0.79, 'Consensus', 'Phishing', '10.0.0.74', 'FTP', 'Unknown', '192.168.1.15', 'SYN', 3),
(10, 'S-5127', '2025-06-29 20:19:26.069882', 36209, 443, 544, 0.79, 'Consensus', 'Ransomware', '10.0.0.74', 'FTP', 'Unknown', '192.168.1.15', 'SYN', 4);

-- --------------------------------------------------------

--
-- Table structure for table `attackapp_uploadedsession`
--

CREATE TABLE IF NOT EXISTS `attackapp_uploadedsession` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `session_id` varchar(50) NOT NULL,
  `source_ip` char(39) NOT NULL,
  `destination_ip` char(39) NOT NULL,
  `source_port` int(11) NOT NULL,
  `destination_port` int(11) NOT NULL,
  `protocol` varchar(10) NOT NULL,
  `packet_size` int(11) NOT NULL,
  `tcp_flags` varchar(20) NOT NULL,
  `duration_sec` double NOT NULL,
  `is_mitm` tinyint(1) NOT NULL,
  `is_session_hijack` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `attackapp_user`
--

CREATE TABLE IF NOT EXISTS `attackapp_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `email` varchar(254) NOT NULL,
  `password` varchar(100) NOT NULL,
  `attack_type` varchar(50) NOT NULL,
  `dob` date NOT NULL,
  `phone` varchar(15) NOT NULL,
  `state` varchar(50) NOT NULL,
  `web_attack_type` varchar(100) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `attackapp_user`
--

INSERT INTO `attackapp_user` (`id`, `name`, `email`, `password`, `attack_type`, `dob`, `phone`, `state`, `web_attack_type`, `is_active`) VALUES
(3, 'manu', 'manu@gmail.com', 'pbkdf2_sha256$120000$Qcq7TF32bsrv$AXPbiePV2GyBefTWWZHm7uRGWQpOtpIMmKmiz8OykOE=', 'MITM', '1999-01-23', '07896541230', 'kurnool', 'Session Hijacking', 1),
(4, 'shaik', 'shaik@gmail.com', 'pbkdf2_sha256$120000$JWJky9SgQTSz$AhZuYR7Yx6RtpyAcpUvpGm9J9iA/Kd/fAYCfb0MIzMI=', 'MITM', '1987-01-23', '7896541230', 'ap', 'MITM', 1);

-- --------------------------------------------------------

--
-- Table structure for table `auth_group`
--

CREATE TABLE IF NOT EXISTS `auth_group` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(80) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_group_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_group_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_group_permissions_group_id_permission_id_0cd325b0_uniq` (`group_id`,`permission_id`),
  KEY `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_permission`
--

CREATE TABLE IF NOT EXISTS `auth_permission` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `content_type_id` int(11) NOT NULL,
  `codename` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_permission_content_type_id_codename_01ab375a_uniq` (`content_type_id`,`codename`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=41 ;

--
-- Dumping data for table `auth_permission`
--

INSERT INTO `auth_permission` (`id`, `name`, `content_type_id`, `codename`) VALUES
(1, 'Can add log entry', 1, 'add_logentry'),
(2, 'Can change log entry', 1, 'change_logentry'),
(3, 'Can delete log entry', 1, 'delete_logentry'),
(4, 'Can view log entry', 1, 'view_logentry'),
(5, 'Can add permission', 2, 'add_permission'),
(6, 'Can change permission', 2, 'change_permission'),
(7, 'Can delete permission', 2, 'delete_permission'),
(8, 'Can view permission', 2, 'view_permission'),
(9, 'Can add group', 3, 'add_group'),
(10, 'Can change group', 3, 'change_group'),
(11, 'Can delete group', 3, 'delete_group'),
(12, 'Can view group', 3, 'view_group'),
(13, 'Can add user', 4, 'add_user'),
(14, 'Can change user', 4, 'change_user'),
(15, 'Can delete user', 4, 'delete_user'),
(16, 'Can view user', 4, 'view_user'),
(17, 'Can add content type', 5, 'add_contenttype'),
(18, 'Can change content type', 5, 'change_contenttype'),
(19, 'Can delete content type', 5, 'delete_contenttype'),
(20, 'Can view content type', 5, 'view_contenttype'),
(21, 'Can add session', 6, 'add_session'),
(22, 'Can change session', 6, 'change_session'),
(23, 'Can delete session', 6, 'delete_session'),
(24, 'Can view session', 6, 'view_session'),
(25, 'Can add admin', 7, 'add_admin'),
(26, 'Can change admin', 7, 'change_admin'),
(27, 'Can delete admin', 7, 'delete_admin'),
(28, 'Can view admin', 7, 'view_admin'),
(29, 'Can add prediction result', 8, 'add_predictionresult'),
(30, 'Can change prediction result', 8, 'change_predictionresult'),
(31, 'Can delete prediction result', 8, 'delete_predictionresult'),
(32, 'Can view prediction result', 8, 'view_predictionresult'),
(33, 'Can add uploaded session', 9, 'add_uploadedsession'),
(34, 'Can change uploaded session', 9, 'change_uploadedsession'),
(35, 'Can delete uploaded session', 9, 'delete_uploadedsession'),
(36, 'Can view uploaded session', 9, 'view_uploadedsession'),
(37, 'Can add user', 10, 'add_user'),
(38, 'Can change user', 10, 'change_user'),
(39, 'Can delete user', 10, 'delete_user'),
(40, 'Can view user', 10, 'view_user');

-- --------------------------------------------------------

--
-- Table structure for table `auth_user`
--

CREATE TABLE IF NOT EXISTS `auth_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `password` varchar(128) NOT NULL,
  `last_login` datetime(6) DEFAULT NULL,
  `is_superuser` tinyint(1) NOT NULL,
  `username` varchar(150) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(150) NOT NULL,
  `email` varchar(254) NOT NULL,
  `is_staff` tinyint(1) NOT NULL,
  `is_active` tinyint(1) NOT NULL,
  `date_joined` datetime(6) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_groups`
--

CREATE TABLE IF NOT EXISTS `auth_user_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `group_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_groups_user_id_group_id_94350c0c_uniq` (`user_id`,`group_id`),
  KEY `auth_user_groups_group_id_97559544_fk_auth_group_id` (`group_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `auth_user_user_permissions`
--

CREATE TABLE IF NOT EXISTS `auth_user_user_permissions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `permission_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `auth_user_user_permissions_user_id_permission_id_14a6b632_uniq` (`user_id`,`permission_id`),
  KEY `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` (`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `django_admin_log`
--

CREATE TABLE IF NOT EXISTS `django_admin_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `action_time` datetime(6) NOT NULL,
  `object_id` longtext,
  `object_repr` varchar(200) NOT NULL,
  `action_flag` smallint(5) unsigned NOT NULL,
  `change_message` longtext NOT NULL,
  `content_type_id` int(11) DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `django_admin_log_content_type_id_c4bce8eb_fk_django_co` (`content_type_id`),
  KEY `django_admin_log_user_id_c564eba6_fk_auth_user_id` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `django_content_type`
--

CREATE TABLE IF NOT EXISTS `django_content_type` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app_label` varchar(100) NOT NULL,
  `model` varchar(100) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `django_content_type_app_label_model_76bd3d3b_uniq` (`app_label`,`model`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=11 ;

--
-- Dumping data for table `django_content_type`
--

INSERT INTO `django_content_type` (`id`, `app_label`, `model`) VALUES
(1, 'admin', 'logentry'),
(7, 'attackapp', 'admin'),
(8, 'attackapp', 'predictionresult'),
(9, 'attackapp', 'uploadedsession'),
(10, 'attackapp', 'user'),
(3, 'auth', 'group'),
(2, 'auth', 'permission'),
(4, 'auth', 'user'),
(5, 'contenttypes', 'contenttype'),
(6, 'sessions', 'session');

-- --------------------------------------------------------

--
-- Table structure for table `django_migrations`
--

CREATE TABLE IF NOT EXISTS `django_migrations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `app` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `applied` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=26 ;

--
-- Dumping data for table `django_migrations`
--

INSERT INTO `django_migrations` (`id`, `app`, `name`, `applied`) VALUES
(1, 'contenttypes', '0001_initial', '2025-06-29 17:10:27.346389'),
(2, 'auth', '0001_initial', '2025-06-29 17:10:28.043900'),
(3, 'admin', '0001_initial', '2025-06-29 17:10:28.202994'),
(4, 'admin', '0002_logentry_remove_auto_add', '2025-06-29 17:10:28.215045'),
(5, 'admin', '0003_logentry_add_action_flag_choices', '2025-06-29 17:10:28.219116'),
(7, 'contenttypes', '0002_remove_content_type_name', '2025-06-29 17:10:28.677065'),
(8, 'auth', '0002_alter_permission_name_max_length', '2025-06-29 17:10:28.727943'),
(9, 'auth', '0003_alter_user_email_max_length', '2025-06-29 17:10:28.782272'),
(10, 'auth', '0004_alter_user_username_opts', '2025-06-29 17:10:28.794388'),
(11, 'auth', '0005_alter_user_last_login_null', '2025-06-29 17:10:28.837487'),
(12, 'auth', '0006_require_contenttypes_0002', '2025-06-29 17:10:28.837487'),
(13, 'auth', '0007_alter_validators_add_error_messages', '2025-06-29 17:10:28.862330'),
(14, 'auth', '0008_alter_user_username_max_length', '2025-06-29 17:10:28.911346'),
(15, 'auth', '0009_alter_user_last_name_max_length', '2025-06-29 17:10:28.960520'),
(16, 'auth', '0010_alter_group_name_max_length', '2025-06-29 17:10:29.015241'),
(17, 'auth', '0011_update_proxy_permissions', '2025-06-29 17:10:29.028103'),
(18, 'auth', '0012_auto_20250629_0614', '2025-06-29 17:10:29.082228'),
(19, 'sessions', '0001_initial', '2025-06-29 17:10:29.140350'),
(21, 'attackapp', '0001_initial', '2025-06-29 17:35:46.016031'),
(22, 'attackapp', '0002_auto_20250629_2253', '2025-06-29 17:35:46.227889'),
(23, 'attackapp', '0003_auto_20250629_2305', '2025-06-29 17:35:46.585860'),
(24, 'attackapp', '0004_user_web_attack_type', '2025-06-29 19:07:45.700859'),
(25, 'attackapp', '0005_user_is_active', '2025-06-29 19:45:26.718623');

-- --------------------------------------------------------

--
-- Table structure for table `django_session`
--

CREATE TABLE IF NOT EXISTS `django_session` (
  `session_key` varchar(40) NOT NULL,
  `session_data` longtext NOT NULL,
  `expire_date` datetime(6) NOT NULL,
  PRIMARY KEY (`session_key`),
  KEY `django_session_expire_date_a5c62663` (`expire_date`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auth_group_permissions`
--
ALTER TABLE `auth_group_permissions`
  ADD CONSTRAINT `auth_group_permissio_permission_id_84c5c92e_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_group_permissions_group_id_b120cbf9_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`);

--
-- Constraints for table `auth_permission`
--
ALTER TABLE `auth_permission`
  ADD CONSTRAINT `auth_permission_content_type_id_2f476e4b_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

--
-- Constraints for table `auth_user_groups`
--
ALTER TABLE `auth_user_groups`
  ADD CONSTRAINT `auth_user_groups_group_id_97559544_fk_auth_group_id` FOREIGN KEY (`group_id`) REFERENCES `auth_group` (`id`),
  ADD CONSTRAINT `auth_user_groups_user_id_6a12ed8b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `auth_user_user_permissions`
--
ALTER TABLE `auth_user_user_permissions`
  ADD CONSTRAINT `auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm` FOREIGN KEY (`permission_id`) REFERENCES `auth_permission` (`id`),
  ADD CONSTRAINT `auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`);

--
-- Constraints for table `django_admin_log`
--
ALTER TABLE `django_admin_log`
  ADD CONSTRAINT `django_admin_log_user_id_c564eba6_fk_auth_user_id` FOREIGN KEY (`user_id`) REFERENCES `auth_user` (`id`),
  ADD CONSTRAINT `django_admin_log_content_type_id_c4bce8eb_fk_django_co` FOREIGN KEY (`content_type_id`) REFERENCES `django_content_type` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
