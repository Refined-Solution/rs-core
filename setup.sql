CREATE TABLE IF NOT EXISTS `rs_rplayer` (
    `identifier` VARCHAR(255) NOT NULL,
    `first_joined` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `last_seen` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    `last_character_id` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`identifier`)    
);

CREATE TABLE IF NOT EXISTS `rs_account` (
    `account_id` VARCHAR(255) NOT NULL,
    `balance` DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (`account_id`)
);

/*
 * Account for none transactional purposes, such as state funding, or
 * other balance changes that cannot be explained by a transaction.
*/
INSERT INTO `rs_account` (`account_id`, `balance`) VALUES ('STATE', 0.00);

CREATE TABLE IF NOT EXISTS `rs_account_transaction` (
    `transaction_id` INT AUTO_INCREMENT PRIMARY KEY,
    `from_account_id` VARCHAR(255) NOT NULL,
    `to_account_id` VARCHAR(255) NOT NULL,
    `amount` DECIMAL(15, 2) NOT NULL,
    `transaction_type` ENUM('deposit', 'withdrawal', 'transfer') NOT NULL,
    `timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (`from_account_id`) REFERENCES `rs_account`(`account_id`) ON DELETE CASCADE,
    FOREIGN KEY (`to_account_id`) REFERENCES `rs_account`(`account_id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `rs_inventory` (
    `inventory_id` INT AUTO_INCREMENT PRIMARY KEY,
    `slot_id` INT NOT NULL,
    `item_type` VARCHAR(255) NOT NULL,
    `amount` INT NOT NULL,
    `meta` TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS `rs_character` (
    `citizen_id` VARCHAR(255) NOT NULL,
    `first_name` VARCHAR(255) NOT NULL,
    `last_name` VARCHAR(255) NOT NULL,
    `date_of_birth` DATE NOT NULL,
    `gender` BOOLEAN NOT NULL DEFAULT FALSE,
    `account_id` VARCHAR(255) NOT NULL,
    `inventory_id` INT NOT NULL,
    PRIMARY KEY (`citizen_id`)
);

CREATE TABLE IF NOT EXISTS `rs_character_organization` (
    `citizen_id` VARCHAR(255) NOT NULL,
    `organization_id` INT NOT NULL,
    `rank` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`citizen_id`, `organization_id`),
    FOREIGN KEY (`citizen_id`) REFERENCES `rs_character`(`citizen_id`) ON DELETE CASCADE,
    FOREIGN KEY (`organization_id`) REFERENCES `rs_organization`(`id`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `rs_organization` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL,
    `account_id` VARCHAR(255) NOT NULL,
    `funding` DECIMAL(15, 2) NOT NULL DEFAULT 0.00,
    `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS `rs_organization_rank` (
    `organization_id` INT NOT NULL,
    `rank_id` INT NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`organization_id`, `rank_id`),
    FOREIGN KEY (`organization_id`) REFERENCES `rs_organization`(`id`) ON DELETE CASCADE
);
