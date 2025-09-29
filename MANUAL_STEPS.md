# Manual Database Setup Steps

After running `./deploy-complete.sh`, follow these steps to configure the database:

## 1. Connect to EC2

```bash
# Get Instance ID
INSTANCE_ID=$(aws cloudformation describe-stacks --stack-name dynamo-hub-simple-rds-dev --region <region> --query 'Stacks[0].Outputs[?OutputKey==`BastionInstanceId`].OutputValue' --output text)

# Connect via Session Manager
aws ssm start-session --target $INSTANCE_ID --region <region>
```

## 2. Connect to MySQL

```bash
mysql -h dynamo-hub-dev.cxekm8qgy6vr.<region>.rds.amazonaws.com -u dynamohub -p123456789
```

## 3. Execute SQL Commands (one by one)

```sql
-- 1. Create database
CREATE DATABASE IF NOT EXISTS lola_dev;
USE lola_dev;

-- 2. Create accounts table
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

-- Continue with remaining tables and data...
-- (See complete_database_setup.sql for all commands)
```

## 4. Insert Initial Data

```sql
-- Insert account
INSERT INTO `accounts` VALUES (1,'2015-12-18 04:12:51','2021-03-03 19:50:16','00000000-000000','(PWS Master Account)','None','999-999-9999','ops@pws.bz','None','999-999-9999','ops@pws.bz','452 Oakmead Pkwy',NULL,'Sunnyvale','California','United States','94805',37.3688,-122.036,'extended_calamp',0,'(PWS Master Account)','not-billed-misc',50,'Other',NULL,NULL,NULL,0,NULL,NULL,0,0);

-- Insert carriers
INSERT INTO `carriers` VALUES (1,'No Carrier','DNE',NOW(),NOW()),(2,'Verizon','VZW',NOW(),NOW()),(3,'AT&T','ATT',NOW(),NOW()),(4,'Vodafone','VDF',NOW(),NOW()),(5,'Sprint','SPR',NOW(),NOW()),(6,'Any Carrier','ANY',NOW(),NOW()),(7,'Sierra','SRA',NOW(),NOW()),(8,'T-Mobile','TMO',NOW(),NOW()),(9,'Telus','TLS',NOW(),NOW()),(10,'T-Mobile Direct','TMD',NOW(),NOW()),(11,'Premier Wireless (Teal)','PWS',NOW(),NOW());

-- Insert carrier accounts (including Verizon)
INSERT INTO `carrier_accounts` VALUES (12,11,'12345678','Premier Wireless (Webbing)',NULL,NULL,NULL,NOW(),NOW(),1,NULL,NULL,NULL,0.002,'Unknown',1,'none',0);
INSERT INTO `carrier_accounts` VALUES (15,2,'verizon-default','Verizon Default Account',NULL,NULL,NULL,NOW(),NOW(),1,NULL,NULL,NULL,0,'Unknown',1,'rest',0);

-- Insert rate plan
INSERT INTO `rate_plans` VALUES (1,'(PWS_DEFAULT)',6,1,NOW(),NOW(),1,0,0,0,1048576,1,0.2500000,0.0100000,0.0000000,1.0000000,0.0000000,0.0000000,1,NULL,NULL,4,NULL);
```

## 5. Exit MySQL

```sql
exit;
```

Database setup complete! ✅