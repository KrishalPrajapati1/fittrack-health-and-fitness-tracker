-- Updated FitTrack Database Schema
-- This file contains the correct table structure for the diet plan management system

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `fittrack`
--

-- --------------------------------------------------------

--
-- Drop existing diet_plans table if it exists
--

DROP TABLE IF EXISTS `diet_plans`;

--
-- Table structure for table `diet_plans` (Updated)
--

CREATE TABLE `diet_plans` (
  `diet_plan_id` int(11) NOT NULL AUTO_INCREMENT,
  `plan_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `total_calories` int(11) NOT NULL,
  `total_protein` decimal(8,2) NOT NULL,
  `total_carbs` decimal(8,2) NOT NULL,
  `total_fat` decimal(8,2) NOT NULL,
  `plan_type` varchar(50) NOT NULL,
  `difficulty_level` varchar(20) NOT NULL,
  `duration_days` int(11) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp(),
  PRIMARY KEY (`diet_plan_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Table structure for table `meals`
--

CREATE TABLE `meals` (
  `meal_id` int(11) NOT NULL AUTO_INCREMENT,
  `diet_plan_id` int(11) NOT NULL,
  `meal_name` varchar(100) NOT NULL,
  `meal_type` varchar(50) NOT NULL,
  `calories` int(11) NOT NULL,
  `protein` decimal(8,2) NOT NULL,
  `carbs` decimal(8,2) NOT NULL,
  `fat` decimal(8,2) NOT NULL,
  `meal_time` time DEFAULT NULL,
  `instructions` text DEFAULT NULL,
  `ingredients` text DEFAULT NULL,
  `preparation_time` int(11) DEFAULT NULL,
  `serving_size` varchar(50) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`meal_id`),
  KEY `diet_plan_id` (`diet_plan_id`),
  CONSTRAINT `meals_ibfk_1` FOREIGN KEY (`diet_plan_id`) REFERENCES `diet_plans` (`diet_plan_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Insert sample diet plans
--

INSERT INTO `diet_plans` (`plan_name`, `description`, `total_calories`, `total_protein`, `total_carbs`, `total_fat`, `plan_type`, `difficulty_level`, `duration_days`) VALUES
('Weight Loss Plan', 'A balanced diet plan for healthy weight loss', 1800, 150.00, 180.00, 60.00, 'weight_loss', 'intermediate', 30),
('Muscle Building Plan', 'High protein diet for muscle growth', 2500, 200.00, 250.00, 80.00, 'muscle_building', 'advanced', 60),
('Maintenance Plan', 'Balanced diet for maintaining current weight', 2200, 120.00, 220.00, 70.00, 'maintenance', 'beginner', 90),
('Keto Diet Plan', 'Low carb, high fat ketogenic diet', 2000, 150.00, 50.00, 150.00, 'keto', 'intermediate', 30),
('Vegan Plan', 'Plant-based diet plan', 2000, 100.00, 250.00, 60.00, 'vegan', 'beginner', 45);

--
-- Update user_logs table to reference the new diet_plan_id
--

ALTER TABLE `user_logs` 
DROP FOREIGN KEY `user_logs_ibfk_3`,
DROP COLUMN `diet_id`,
ADD COLUMN `diet_plan_id` int(11) DEFAULT NULL AFTER `workout_id`,
ADD CONSTRAINT `user_logs_ibfk_3` FOREIGN KEY (`diet_plan_id`) REFERENCES `diet_plans` (`diet_plan_id`) ON DELETE SET NULL;

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */; 