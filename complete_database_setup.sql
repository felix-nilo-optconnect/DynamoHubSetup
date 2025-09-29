-- Complete Database Setup for DynamoHub
-- Based on VerizonIntegration/docs/DatabaseSetup.md

-- Create database
CREATE DATABASE IF NOT EXISTS lola_dev;
USE lola_dev;

-- Create accounts table
CREATE TABLE `accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `account_number` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `account_name` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  `primary_contact` varchar(80) COLLATE utf8_unicode_ci NOT NULL,
  `primary_phone` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `primary_email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `billing_contact` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_phone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_email` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_address_1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_address_2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_city` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_country` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `billing_zip` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `latitude` float DEFAULT NULL,
  `longitude` float DEFAULT NULL,
  `api_permissions` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'omgno',
  `billing_enabled` tinyint(1) DEFAULT '1',
  `qb_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `account_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'active',
  `max_rules` int(11) NOT NULL DEFAULT '50',
  `sales_rep` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_audited` datetime DEFAULT NULL,
  `last_audited_by` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_audit_results` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enable_usage_notifications` tinyint(1) DEFAULT '1',
  `notification_emails` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `activation_notes` text COLLATE utf8_unicode_ci,
  `activations_enabled` tinyint(1) NOT NULL DEFAULT '0',
  `allows_restricted_states` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `index_accounts_on_account_number` (`account_number`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Create carriers table
CREATE TABLE `carriers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carrier_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carrier_code` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Create carrier_accounts table
CREATE TABLE `carrier_accounts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `carrier_id` int(11) DEFAULT NULL,
  `carrier_account_number` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carrier_account_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `username` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `license_key` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `billing_cycle_day` int(11) DEFAULT NULL,
  `client_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `client_secret` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `root_url` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `surcharge_rate` float DEFAULT '0',
  `billing_class` varchar(255) COLLATE utf8_unicode_ci DEFAULT 'Unknown',
  `uses_static_ips` tinyint(1) NOT NULL DEFAULT '1',
  `api_type` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'none',
  `uses_lead_reps` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Create rate_plans table
CREATE TABLE `rate_plans` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `carrier_id` int(11) DEFAULT NULL,
  `account_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `locked` tinyint(1) DEFAULT '0',
  `term_days` int(11) DEFAULT '730',
  `mrc_data` bigint(20) DEFAULT '5368709120',
  `mrc_sms` bigint(20) DEFAULT '0',
  `ovg_data_unit` bigint(20) DEFAULT '1073741824',
  `ovg_sms_unit` bigint(20) DEFAULT '1',
  `price_ovg_sms_unit` decimal(14,7) DEFAULT '0.2500000',
  `price_ovg_data_unit` decimal(14,7) DEFAULT '15.0000000',
  `price_mrc_sms` decimal(14,7) DEFAULT '0.0000000',
  `price_mrc_data` decimal(14,7) DEFAULT '60.0000000',
  `price_activation` decimal(14,7) DEFAULT '0.0000000',
  `price_deactivation` decimal(14,7) DEFAULT '100.0000000',
  `enabled` tinyint(1) DEFAULT '1',
  `verizon_lead_rep_id` bigint(20) DEFAULT NULL,
  `carrier_plan_bundle_id` bigint(20) DEFAULT NULL,
  `carrier_account_id` bigint(20) DEFAULT NULL,
  `pws_note` text,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_rate_plans_on_name_and_account_id` (`name`,`account_id`),
  KEY `index_rate_plans_on_verizon_lead_rep_id` (`verizon_lead_rep_id`),
  KEY `index_rate_plans_on_carrier_plan_bundle_id` (`carrier_plan_bundle_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Create devices table
CREATE TABLE `devices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `device_name` varchar(45) COLLATE utf8_unicode_ci NOT NULL,
  `ip_address` varchar(24) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note` varchar(255) COLLATE utf8_unicode_ci DEFAULT '-----',
  `state` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mdn` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `meid` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `imsi` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `imei` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `iccid` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `esn` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `msisdn` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `min` varchar(25) COLLATE utf8_unicode_ci DEFAULT NULL,
  `connected` varchar(20) COLLATE utf8_unicode_ci DEFAULT NULL,
  `last_connection_date` datetime DEFAULT NULL,
  `cost_center` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `last_activation_date` datetime DEFAULT NULL,
  `latitude` decimal(18,8) DEFAULT NULL,
  `longitude` decimal(18,8) DEFAULT NULL,
  `address` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `bytes_used` bigint(20) DEFAULT '0',
  `sms_used` bigint(20) DEFAULT '0',
  `carrier_account_id` int(11) NOT NULL,
  `carrier_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `note1` varchar(255) COLLATE utf8_unicode_ci DEFAULT '-----',
  `note2` varchar(255) COLLATE utf8_unicode_ci DEFAULT '-----',
  `note3` varchar(255) COLLATE utf8_unicode_ci DEFAULT '-----',
  `time_of_fix` datetime DEFAULT NULL,
  `slug` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `pws_note` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `contract_end_date` date DEFAULT NULL,
  `location_confidence` int(11) DEFAULT NULL,
  `carrier_rate_plan` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `sku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `presku` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ipv6` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `raw_carrier_state` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `eid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_devices_on_device_name` (`device_name`),
  KEY `index_devices_on_ip_address` (`ip_address`),
  KEY `index_devices_on_note` (`note`),
  KEY `index_devices_on_mdn` (`mdn`),
  KEY `index_devices_on_carrier_account_id` (`carrier_account_id`),
  KEY `index_devices_on_iccid` (`iccid`),
  KEY `index_devices_on_imei` (`imei`),
  KEY `index_devices_on_state` (`state`),
  KEY `index_devices_on_meid` (`meid`),
  KEY `index_devices_on_slug` (`slug`),
  KEY `index_devices_on_carrier_rate_plan` (`carrier_rate_plan`),
  KEY `index_devices_on_cost_center` (`cost_center`),
  KEY `index_devices_on_imsi` (`imsi`),
  KEY `index_devices_on_eid` (`eid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Create assignments table
CREATE TABLE `assignments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) DEFAULT NULL,
  `device_id` int(11) DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `rate_plan_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_assignments_on_device_id` (`device_id`),
  KEY `index_assignments_on_account_id` (`account_id`),
  KEY `index_assignments_on_rate_plan_id` (`rate_plan_id`),
  KEY `index_assignments_on_created_at` (`created_at`),
  KEY `index_assignments_on_created_at_and_rate_plan_id` (`created_at`,`rate_plan_id`),
  CONSTRAINT `fk_rails_898fa97dde` FOREIGN KEY (`device_id`) REFERENCES `devices` (`id`),
  CONSTRAINT `fk_rails_f5a17fb20b` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Create daily_data_usages table
CREATE TABLE `daily_data_usages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date_for` date DEFAULT NULL,
  `bytes_used` bigint(20) DEFAULT '0',
  `sms_used` bigint(20) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_daily_data_usages_on_device_id_and_date_for` (`device_id`,`date_for`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Create monthly_data_usages table
CREATE TABLE `monthly_data_usages` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `device_id` int(11) DEFAULT NULL,
  `date_for` date DEFAULT NULL,
  `bytes_used` bigint(20) DEFAULT '0',
  `sms_used` bigint(20) DEFAULT '0',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_monthly_data_usages_on_device_id_and_date_for` (`device_id`,`date_for`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- Insert initial data
INSERT INTO `accounts` VALUES (1,'2015-12-18 04:12:51','2021-03-03 19:50:16','00000000-000000','(PWS Master Account)','None','999-999-9999','ops@pws.bz','None','999-999-9999','ops@pws.bz','452 Oakmead Pkwy',NULL,'Sunnyvale','California','United States','94805',37.3688,-122.036,'extended_calamp',0,'(PWS Master Account)','not-billed-misc',50,'Other',NULL,NULL,NULL,0,NULL,NULL,0,0);

INSERT INTO `carriers` VALUES (1,'No Carrier','DNE',NOW(),NOW()),(2,'Verizon','VZW',NOW(),NOW()),(3,'AT&T','ATT',NOW(),NOW()),(4,'Vodafone','VDF',NOW(),NOW()),(5,'Sprint','SPR',NOW(),NOW()),(6,'Any Carrier','ANY',NOW(),NOW()),(7,'Sierra','SRA',NOW(),NOW()),(8,'T-Mobile','TMO',NOW(),NOW()),(9,'Telus','TLS',NOW(),NOW()),(10,'T-Mobile Direct','TMD',NOW(),NOW()),(11,'Premier Wireless (Teal)','PWS',NOW(),NOW());

INSERT INTO `carrier_accounts` VALUES (12,11,'12345678','Premier Wireless (Webbing)',NULL,NULL,NULL,NOW(),NOW(),1,NULL,NULL,NULL,0.002,'Unknown',1,'none',0);

-- Add Verizon carrier account for integration
INSERT INTO `carrier_accounts` VALUES (15,2,'verizon-default','Verizon Default Account',NULL,NULL,NULL,NOW(),NOW(),1,NULL,NULL,NULL,0,'Unknown',1,'rest',0);

INSERT INTO `rate_plans` VALUES (1,'(PWS_DEFAULT)',6,1,NOW(),NOW(),1,0,0,0,1048576,1,0.2500000,0.0100000,0.0000000,1.0000000,0.0000000,0.0000000,1,NULL,NULL,4,NULL);