-- Adminer 4.7.6 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

SET NAMES utf8mb4;

DROP TABLE IF EXISTS `cron`;
CREATE TABLE `cron` (
  `command` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `last_run` bigint(20) NOT NULL,
  PRIMARY KEY (`command`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `labels`;
CREATE TABLE `labels` (
  `label_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `layer_id` bigint(20) NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`label_id`),
  KEY `layer_id` (`layer_id`),
  CONSTRAINT `labels_ibfk_2` FOREIGN KEY (`layer_id`) REFERENCES `layers` (`layer_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `layers`;
CREATE TABLE `layers` (
  `layer_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `layer_uid` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`layer_id`),
  UNIQUE KEY `space_uid` (`layer_uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `projects`;
CREATE TABLE `projects` (
  `project_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `layer_id` bigint(20) NOT NULL,
  `project_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`project_id`),
  KEY `layer_id` (`layer_id`),
  CONSTRAINT `projects_ibfk_2` FOREIGN KEY (`layer_id`) REFERENCES `layers` (`layer_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `tasks`;
CREATE TABLE `tasks` (
  `task_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `layer_id` bigint(20) NOT NULL,
  `parent_task_id` bigint(20) DEFAULT NULL,
  `project_id` bigint(20) DEFAULT NULL,
  `category_id` bigint(20) NOT NULL,
  `task_name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` longtext COLLATE utf8mb4_unicode_ci NOT NULL,
  `state` tinyint(4) NOT NULL COMMENT '0-New,1-Planned,2-In Work,3-Ready,4-Completed',
  `user` bigint(20) DEFAULT NULL,
  `maintainer` bigint(20) NOT NULL,
  `plan_hours` bigint(20) NOT NULL,
  `plan_begin` date DEFAULT NULL COMMENT 'DateTime by UTC',
  `plan_end` date DEFAULT NULL COMMENT 'DateTime by UTC',
  `real_begin` datetime DEFAULT NULL COMMENT 'DateTime by UTC',
  `real_end` datetime DEFAULT NULL COMMENT 'DateTime by UTC',
  `real_hours` bigint(20) NOT NULL,
  PRIMARY KEY (`task_id`),
  KEY `project_id` (`project_id`),
  KEY `parent_task_id` (`parent_task_id`),
  KEY `layer_id` (`layer_id`),
  KEY `state` (`state`),
  CONSTRAINT `tasks_ibfk_3` FOREIGN KEY (`project_id`) REFERENCES `projects` (`project_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tasks_ibfk_5` FOREIGN KEY (`parent_task_id`) REFERENCES `tasks` (`task_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `tasks_ibfk_7` FOREIGN KEY (`layer_id`) REFERENCES `layers` (`layer_id`) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `tasks_labels`;
CREATE TABLE `tasks_labels` (
  `task_id` bigint(20) NOT NULL,
  `label_id` bigint(20) NOT NULL,
  PRIMARY KEY (`task_id`,`label_id`),
  KEY `label_id` (`label_id`),
  CONSTRAINT `tasks_labels_ibfk_4` FOREIGN KEY (`label_id`) REFERENCES `labels` (`label_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `tasks_labels_ibfk_5` FOREIGN KEY (`task_id`) REFERENCES `tasks` (`task_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `top_menu`;
CREATE TABLE `top_menu` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `href` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `pos` bigint(20) NOT NULL,
  `sync_timestamp` bigint(20) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `login` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_unicode_ci NOT NULL,
  `banned` tinyint(4) NOT NULL,
  `is_deleted` tinyint(4) NOT NULL,
  `sync_timestamp` bigint(20) NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `login` (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- 2020-10-31 12:02:36