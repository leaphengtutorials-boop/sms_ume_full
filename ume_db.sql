-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 11, 2026 at 10:28 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ume_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `academic_years`
--

CREATE TABLE `academic_years` (
  `id` int(11) NOT NULL,
  `year_name` varchar(50) NOT NULL,
  `start_date` date DEFAULT NULL,
  `end_date` date DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `academic_years`
--

INSERT INTO `academic_years` (`id`, `year_name`, `start_date`, `end_date`, `is_active`, `created_at`) VALUES
(1, '2023-2024', '2023-10-01', '2024-07-31', 0, '2026-10-08 17:16:00'),
(2, '2024-2025', '2024-10-01', '2025-07-31', 0, '2026-10-08 17:16:00'),
(3, '2025-2026', '2025-10-01', '2026-07-31', 1, '2026-10-08 17:16:00'),
(4, '2026-2027', '2026-10-01', '2027-07-31', 0, '2026-10-08 17:16:00');

-- --------------------------------------------------------

--
-- Table structure for table `attendance`
--

CREATE TABLE `attendance` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `week_no` tinyint(4) NOT NULL,
  `attend_date` date DEFAULT NULL,
  `status` enum('present','late','absent','permission') DEFAULT 'absent',
  `note` varchar(255) DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attendance`
--

INSERT INTO `attendance` (`id`, `subject_id`, `student_id`, `week_no`, `attend_date`, `status`, `note`, `recorded_by`, `updated_at`) VALUES
(1, 1, 1, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(2, 1, 1, 2, '2026-10-12', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(3, 1, 1, 3, '2026-10-19', 'late', NULL, NULL, '2026-10-08 17:16:01'),
(4, 1, 1, 4, '2026-10-26', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(5, 1, 1, 5, '2026-11-02', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(6, 1, 2, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(7, 1, 2, 2, '2026-10-12', 'absent', NULL, NULL, '2026-10-08 17:16:01'),
(8, 1, 2, 3, '2026-10-19', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(9, 1, 2, 4, '2026-10-26', 'permission', NULL, NULL, '2026-10-08 17:16:01'),
(10, 1, 2, 5, '2026-11-02', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(11, 1, 3, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(12, 1, 3, 2, '2026-10-12', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(13, 1, 3, 3, '2026-10-19', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(14, 1, 3, 4, '2026-10-26', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(15, 1, 3, 5, '2026-11-02', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(16, 1, 4, 1, '2026-10-05', 'late', NULL, NULL, '2026-10-08 17:16:01'),
(17, 1, 4, 2, '2026-10-12', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(18, 1, 4, 3, '2026-10-19', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(19, 1, 4, 4, '2026-10-26', 'absent', NULL, NULL, '2026-10-08 17:16:01'),
(20, 1, 4, 5, '2026-11-02', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(21, 1, 5, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(22, 1, 5, 2, '2026-10-12', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(23, 1, 5, 3, '2026-10-19', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(24, 1, 5, 4, '2026-10-26', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(25, 1, 5, 5, '2026-11-02', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(26, 3, 11, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(27, 3, 11, 2, '2026-10-12', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(28, 3, 12, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(29, 3, 12, 2, '2026-10-12', 'late', NULL, NULL, '2026-10-08 17:16:01'),
(30, 3, 13, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(31, 3, 13, 2, '2026-10-12', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(32, 3, 14, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(33, 3, 14, 2, '2026-10-12', 'absent', NULL, NULL, '2026-10-08 17:16:01'),
(34, 3, 15, 1, '2026-10-05', 'present', NULL, NULL, '2026-10-08 17:16:01'),
(35, 3, 15, 2, '2026-10-12', 'present', NULL, NULL, '2026-10-08 17:16:01');

-- --------------------------------------------------------

--
-- Table structure for table `attendance_rules`
--

CREATE TABLE `attendance_rules` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `present_score` decimal(5,2) DEFAULT 1.00,
  `late_deduction` decimal(5,2) DEFAULT 0.50,
  `absent_deduction` decimal(5,2) DEFAULT 1.00,
  `permission_deduction` decimal(5,2) DEFAULT 0.30,
  `allow_negative` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `attendance_rules`
--

INSERT INTO `attendance_rules` (`id`, `subject_id`, `present_score`, `late_deduction`, `absent_deduction`, `permission_deduction`, `allow_negative`) VALUES
(1, 1, 1.00, 0.50, 1.00, 0.30, 0),
(2, 2, 1.00, 0.50, 1.00, 0.30, 0),
(3, 3, 1.00, 0.50, 1.00, 0.30, 0),
(4, 4, 1.00, 0.50, 1.00, 0.30, 0),
(5, 5, 1.00, 0.50, 1.00, 0.30, 0),
(7, 7, 1.00, 0.50, 1.00, 0.30, 0);

-- --------------------------------------------------------

--
-- Table structure for table `cohorts`
--

CREATE TABLE `cohorts` (
  `id` int(11) NOT NULL,
  `cohort_name` varchar(100) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `is_current` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cohorts`
--

INSERT INTO `cohorts` (`id`, `cohort_name`, `description`, `is_active`, `is_current`, `created_at`) VALUES
(1, 'ជំនាន់ទី ១', 'និស្សិតឆ្នាំ 2023', 1, 0, '2026-10-08 17:16:00'),
(2, 'ជំនាន់ទី ២', 'និស្សិតឆ្នាំ 2024', 1, 0, '2026-10-08 17:16:00'),
(3, 'ជំនាន់ទី ៣', 'និស្សិតឆ្នាំ 2025', 1, 0, '2026-10-08 17:16:00'),
(4, 'ជំនាន់ទី ៤', 'និស្សិតឆ្នាំ 2026', 1, 1, '2026-10-08 17:16:00');

-- --------------------------------------------------------

--
-- Table structure for table `enrollments`
--

CREATE TABLE `enrollments` (
  `id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `study_year` tinyint(1) NOT NULL DEFAULT 1,
  `semester` tinyint(1) NOT NULL DEFAULT 1,
  `enrolled_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `is_active` tinyint(1) DEFAULT 1,
  `status` enum('active','completed','dropped') NOT NULL DEFAULT 'active',
  `completed_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `enrollments`
--

INSERT INTO `enrollments` (`id`, `student_id`, `subject_id`, `study_year`, `semester`, `enrolled_at`, `is_active`, `status`, `completed_at`) VALUES
(1, 1, 1, 1, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(2, 2, 1, 1, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(3, 3, 1, 1, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(4, 4, 1, 1, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(5, 5, 1, 1, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(6, 6, 2, 1, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(7, 7, 2, 1, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(8, 8, 2, 1, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(9, 9, 2, 1, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(10, 10, 2, 1, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(11, 11, 3, 2, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(12, 12, 3, 2, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(13, 13, 3, 2, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(14, 14, 3, 2, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(15, 15, 3, 2, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(16, 16, 4, 2, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(17, 17, 4, 2, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(18, 18, 4, 2, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(19, 19, 4, 2, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(20, 20, 4, 2, 2, '2026-10-08 17:16:01', 1, 'active', NULL),
(21, 21, 5, 3, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(22, 22, 5, 3, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(23, 23, 5, 3, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(24, 24, 5, 3, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(25, 25, 5, 3, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(31, 31, 7, 4, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(32, 32, 7, 4, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(33, 33, 7, 4, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(34, 34, 7, 4, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(35, 35, 7, 4, 1, '2026-10-08 17:16:01', 1, 'active', NULL),
(41, 1, 2, 1, 2, '2026-10-08 17:16:01', 1, 'completed', '2025-03-15 10:00:00'),
(42, 2, 2, 1, 2, '2026-10-08 17:16:01', 1, 'completed', '2025-03-15 10:00:00'),
(43, 3, 2, 1, 2, '2026-10-08 17:16:01', 1, 'completed', '2025-03-15 10:00:00'),
(44, 4, 2, 1, 2, '2026-10-08 17:16:01', 1, 'completed', '2025-03-15 10:00:00'),
(45, 5, 2, 1, 2, '2026-10-08 17:16:01', 1, 'completed', '2025-03-15 10:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `homework`
--

CREATE TABLE `homework` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `cohort_id` int(11) DEFAULT NULL,
  `type` enum('homework','quiz','assignment') DEFAULT 'homework',
  `title` varchar(200) NOT NULL,
  `description` text DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `max_score` decimal(5,2) DEFAULT 100.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `homework`
--

INSERT INTO `homework` (`id`, `subject_id`, `cohort_id`, `type`, `title`, `description`, `due_date`, `max_score`, `created_at`) VALUES
(1, 1, 4, 'homework', 'H1 — HTML Basic', 'HTML', '2026-10-20', 100.00, '2026-10-08 17:16:01'),
(2, 1, 4, 'quiz', 'Q1 — CSS', 'CSS', '2026-10-25', 100.00, '2026-10-08 17:16:01'),
(3, 1, 4, 'assignment', 'ASS — Layout', 'Layout', '2026-11-01', 100.00, '2026-10-08 17:16:01'),
(4, 2, 4, 'homework', 'H2 — JS', 'JS', '2026-10-22', 100.00, '2026-10-08 17:16:01'),
(5, 2, 4, 'quiz', 'Q2 — DOM', 'DOM', '2026-10-28', 100.00, '2026-10-08 17:16:01'),
(6, 3, 3, 'homework', 'HW1 — React', 'React', '2026-10-20', 100.00, '2026-10-08 17:16:01'),
(7, 3, 3, 'quiz', 'Quiz1 — Hooks', 'Hooks', '2026-10-25', 100.00, '2026-10-08 17:16:01'),
(8, 5, 2, 'homework', 'HW1 — Flutter', 'Flutter', '2026-10-20', 100.00, '2026-10-08 17:16:01'),
(9, 7, 1, 'assignment', 'Asg1 — Project', 'Project', '2026-11-01', 100.00, '2026-10-08 17:16:01'),
(10, 1, 4, 'homework', 'H1', '', NULL, 100.00, '2026-10-11 18:48:14');

-- --------------------------------------------------------

--
-- Table structure for table `homework_submissions`
--

CREATE TABLE `homework_submissions` (
  `id` int(11) NOT NULL,
  `homework_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `submitted` tinyint(1) DEFAULT 0,
  `score` decimal(5,2) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `homework_submissions`
--

INSERT INTO `homework_submissions` (`id`, `homework_id`, `student_id`, `submitted`, `score`) VALUES
(1, 1, 1, 1, 85.00),
(2, 1, 2, 1, 90.00),
(3, 1, 3, 1, 78.00),
(4, 1, 4, 1, 88.00),
(5, 1, 5, 1, 92.00),
(6, 2, 1, 1, 80.00),
(7, 2, 2, 1, 95.00),
(8, 2, 3, 1, 72.00),
(9, 2, 4, 1, 85.00),
(10, 2, 5, 1, 78.00),
(11, 3, 1, 1, 90.00),
(12, 3, 2, 1, 85.00),
(13, 3, 3, 1, 88.00),
(14, 3, 4, 1, 92.00),
(15, 3, 5, 1, 75.00),
(16, 4, 6, 1, 88.00),
(17, 4, 7, 1, 92.00),
(18, 4, 8, 1, 85.00),
(19, 4, 9, 1, 78.00),
(20, 4, 10, 1, 90.00),
(21, 5, 6, 1, 80.00),
(22, 5, 7, 1, 85.00),
(23, 5, 8, 1, 90.00),
(24, 5, 9, 1, 88.00),
(25, 5, 10, 1, 92.00),
(26, 6, 11, 1, 88.00),
(27, 6, 12, 1, 92.00),
(28, 6, 13, 1, 85.00),
(29, 6, 14, 1, 78.00),
(30, 6, 15, 1, 90.00),
(31, 7, 11, 1, 85.00),
(32, 7, 12, 1, 90.00),
(33, 7, 13, 1, 88.00),
(34, 7, 14, 1, 82.00),
(35, 7, 15, 1, 92.00),
(36, 8, 21, 1, 88.00),
(37, 8, 22, 1, 92.00),
(38, 8, 23, 1, 85.00),
(39, 8, 24, 1, 78.00),
(40, 8, 25, 1, 90.00),
(41, 9, 31, 1, 90.00),
(42, 9, 32, 1, 88.00),
(43, 9, 33, 1, 85.00),
(44, 9, 34, 1, 92.00),
(45, 9, 35, 1, 78.00);

-- --------------------------------------------------------

--
-- Table structure for table `scores`
--

CREATE TABLE `scores` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `student_id` int(11) NOT NULL,
  `score_type` enum('homework','quiz','midterm','assignment','final') NOT NULL,
  `title` varchar(100) DEFAULT NULL,
  `score` decimal(5,2) DEFAULT 0.00,
  `max_score` decimal(5,2) DEFAULT 100.00,
  `exam_date` date DEFAULT NULL,
  `note` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `scores`
--

INSERT INTO `scores` (`id`, `subject_id`, `student_id`, `score_type`, `title`, `score`, `max_score`, `exam_date`, `note`, `created_at`) VALUES
(1, 1, 1, 'midterm', 'Midterm', 78.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(2, 1, 2, 'midterm', 'Midterm', 88.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(3, 1, 3, 'midterm', 'Midterm', 72.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(4, 1, 4, 'midterm', 'Midterm', 85.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(5, 1, 5, 'midterm', 'Midterm', 92.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(6, 2, 6, 'midterm', 'Midterm', 82.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(7, 2, 7, 'midterm', 'Midterm', 90.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(8, 2, 8, 'midterm', 'Midterm', 78.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(9, 2, 9, 'midterm', 'Midterm', 85.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(10, 2, 10, 'midterm', 'Midterm', 88.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(11, 3, 11, 'midterm', 'Midterm', 88.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(12, 3, 12, 'midterm', 'Midterm', 92.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(13, 3, 13, 'midterm', 'Midterm', 85.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(14, 3, 14, 'midterm', 'Midterm', 78.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(15, 3, 15, 'midterm', 'Midterm', 90.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(16, 5, 21, 'midterm', 'Midterm', 85.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(17, 5, 22, 'midterm', 'Midterm', 90.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(18, 5, 23, 'midterm', 'Midterm', 88.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(19, 5, 24, 'midterm', 'Midterm', 82.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(20, 5, 25, 'midterm', 'Midterm', 92.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(21, 7, 31, 'midterm', 'Midterm', 90.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(22, 7, 32, 'midterm', 'Midterm', 88.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(23, 7, 33, 'midterm', 'Midterm', 85.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(24, 7, 34, 'midterm', 'Midterm', 92.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(25, 7, 35, 'midterm', 'Midterm', 78.00, 100.00, '2026-11-15', NULL, '2026-10-08 17:16:01'),
(26, 1, 1, 'final', 'Final', 82.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(27, 1, 2, 'final', 'Final', 91.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(28, 1, 3, 'final', 'Final', 75.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(29, 1, 4, 'final', 'Final', 88.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(30, 1, 5, 'final', 'Final', 94.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(31, 3, 11, 'final', 'Final', 85.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(32, 3, 12, 'final', 'Final', 92.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(33, 3, 13, 'final', 'Final', 78.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(34, 3, 14, 'final', 'Final', 88.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(35, 3, 15, 'final', 'Final', 90.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(36, 5, 21, 'final', 'Final', 88.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(37, 5, 22, 'final', 'Final', 92.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(38, 5, 23, 'final', 'Final', 85.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(39, 5, 24, 'final', 'Final', 78.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01'),
(40, 5, 25, 'final', 'Final', 90.00, 100.00, '2027-03-20', NULL, '2026-10-08 17:16:01');

-- --------------------------------------------------------

--
-- Table structure for table `students`
--

CREATE TABLE `students` (
  `id` int(11) NOT NULL,
  `student_code` varchar(30) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `gender` enum('M','F') NOT NULL,
  `cohort_id` int(11) DEFAULT NULL,
  `entry_year_id` int(11) DEFAULT NULL,
  `status` enum('active','graduated','dropped') NOT NULL DEFAULT 'active',
  `dob` date DEFAULT NULL,
  `photo` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `students`
--

INSERT INTO `students` (`id`, `student_code`, `full_name`, `gender`, `cohort_id`, `entry_year_id`, `status`, `dob`, `photo`, `phone`, `email`, `address`, `created_at`) VALUES
(1, 'T1001', 'Y1 — សុខ ដារា', 'M', 4, 3, 'active', NULL, NULL, '010100001', NULL, NULL, '2026-10-08 17:16:00'),
(2, 'T1002', 'Y1 — ចាន់ សុភា', 'F', 4, 3, 'active', NULL, NULL, '010100002', NULL, NULL, '2026-10-08 17:16:00'),
(3, 'T1003', 'Y1 — លី ម៉េង', 'M', 4, 3, 'active', NULL, NULL, '010100003', NULL, NULL, '2026-10-08 17:16:00'),
(4, 'T1004', 'Y1 — ហេង សុវណ្ណ', 'F', 4, 3, 'active', NULL, NULL, '010100004', NULL, NULL, '2026-10-08 17:16:00'),
(5, 'T1005', 'Y1 — គង់ រតនា', 'M', 4, 3, 'active', NULL, NULL, '010100005', NULL, NULL, '2026-10-08 17:16:00'),
(6, 'T1006', 'Y1 — ព្រាប សុភាព', 'F', 4, 3, 'active', NULL, NULL, '010100006', NULL, NULL, '2026-10-08 17:16:00'),
(7, 'T1007', 'Y1 — មាស ធារី', 'F', 4, 3, 'active', NULL, NULL, '010100007', NULL, NULL, '2026-10-08 17:16:00'),
(8, 'T1008', 'Y1 — សេង ហុង', 'M', 4, 3, 'active', NULL, NULL, '010100008', NULL, NULL, '2026-10-08 17:16:00'),
(9, 'T1009', 'Y1 — ញ៉ែម ចន្ធា', 'F', 4, 3, 'active', NULL, NULL, '010100009', NULL, NULL, '2026-10-08 17:16:00'),
(10, 'T1010', 'Y1 — ទូច សុវណ្ណ', 'M', 4, 3, 'active', NULL, NULL, '010100010', NULL, NULL, '2026-10-08 17:16:00'),
(11, 'T2001', 'Y2 — រ៉ា ស្រីនី', 'F', 3, 2, 'active', NULL, NULL, '020200001', NULL, NULL, '2026-10-08 17:16:00'),
(12, 'T2002', 'Y2 — ចេង សុវណ្ណ', 'M', 3, 2, 'active', NULL, NULL, '020200002', NULL, NULL, '2026-10-08 17:16:00'),
(13, 'T2003', 'Y2 — គឹម លីណា', 'F', 3, 2, 'active', NULL, NULL, '020200003', NULL, NULL, '2026-10-08 17:16:00'),
(14, 'T2004', 'Y2 — ណុប សុភ័ក្ត្រ', 'F', 3, 2, 'active', NULL, NULL, '020200004', NULL, NULL, '2026-10-08 17:16:00'),
(15, 'T2005', 'Y2 — លឹម ពិសិដ្ឋ', 'M', 3, 2, 'active', NULL, NULL, '020200005', NULL, NULL, '2026-10-08 17:16:00'),
(16, 'T2006', 'Y2 — អ៊ុក សុវណ្ណ', 'M', 3, 2, 'active', NULL, NULL, '020200006', NULL, NULL, '2026-10-08 17:16:00'),
(17, 'T2007', 'Y2 — ម៉ៅ ស្រីពៅ', 'F', 3, 2, 'active', NULL, NULL, '020200007', NULL, NULL, '2026-10-08 17:16:00'),
(18, 'T2008', 'Y2 — ហ៊ុន មករា', 'M', 3, 2, 'active', NULL, NULL, '020200008', NULL, NULL, '2026-10-08 17:16:00'),
(19, 'T2009', 'Y2 — ជា សុជាតា', 'F', 3, 2, 'active', NULL, NULL, '020200009', NULL, NULL, '2026-10-08 17:16:00'),
(20, 'T2010', 'Y2 — ស៊ីន បូរី', 'M', 3, 2, 'active', NULL, NULL, '020200010', NULL, NULL, '2026-10-08 17:16:00'),
(21, 'T3001', 'Y3 — គង់ សុភា', 'F', 2, 2, 'active', NULL, NULL, '030300001', NULL, NULL, '2026-10-08 17:16:00'),
(22, 'T3002', 'Y3 — សេង ដារា', 'M', 2, 2, 'active', NULL, NULL, '030300002', NULL, NULL, '2026-10-08 17:16:00'),
(23, 'T3003', 'Y3 — មាស ធារី', 'F', 2, 2, 'active', NULL, NULL, '030300003', NULL, NULL, '2026-10-08 17:16:00'),
(24, 'T3004', 'Y3 — ព្រាប ចន្ធា', 'F', 2, 2, 'active', NULL, NULL, '030300004', NULL, NULL, '2026-10-08 17:16:00'),
(25, 'T3005', 'Y3 — ណុប សុភ័ក្ត្រ', 'F', 2, 2, 'active', NULL, NULL, '030300005', NULL, NULL, '2026-10-08 17:16:00'),
(26, 'T3006', 'Y3 — ហេង រតនៈ', 'M', 2, 2, 'active', NULL, NULL, '030300006', NULL, NULL, '2026-10-08 17:16:00'),
(27, 'T3007', 'Y3 — ចេង សុវណ្ណ', 'M', 2, 2, 'active', NULL, NULL, '030300007', NULL, NULL, '2026-10-08 17:16:00'),
(28, 'T3008', 'Y3 — ទូច សុវណ្ណ', 'M', 2, 2, 'active', NULL, NULL, '030300008', NULL, NULL, '2026-10-08 17:16:00'),
(29, 'T3009', 'Y3 — រ៉ា ស្រីនី', 'F', 2, 2, 'active', NULL, NULL, '030300009', NULL, NULL, '2026-10-08 17:16:00'),
(30, 'T3010', 'Y3 — សុខ ដារា', 'M', 2, 2, 'active', NULL, NULL, '030300010', NULL, NULL, '2026-10-08 17:16:00'),
(31, 'T4001', 'Y4 — លី ម៉េង', 'M', 1, 1, 'active', NULL, NULL, '040400001', NULL, NULL, '2026-10-08 17:16:00'),
(32, 'T4002', 'Y4 — គឹម លីណា', 'F', 1, 1, 'active', NULL, NULL, '040400002', NULL, NULL, '2026-10-08 17:16:00'),
(33, 'T4003', 'Y4 — អ៊ុក សុវណ្ណ', 'M', 1, 1, 'active', NULL, NULL, '040400003', NULL, NULL, '2026-10-08 17:16:00'),
(34, 'T4004', 'Y4 — ម៉ៅ ស្រីពៅ', 'F', 1, 1, 'active', NULL, NULL, '040400004', NULL, NULL, '2026-10-08 17:16:00'),
(35, 'T4005', 'Y4 — ហ៊ុន មករា', 'M', 1, 1, 'active', NULL, NULL, '040400005', NULL, NULL, '2026-10-08 17:16:00'),
(36, 'T4006', 'Y4 — ជា សុជាតា', 'F', 1, 1, 'active', NULL, NULL, '040400006', NULL, NULL, '2026-10-08 17:16:00'),
(37, 'T4007', 'Y4 — ស៊ីន បូរី', 'M', 1, 1, 'active', NULL, NULL, '040400007', NULL, NULL, '2026-10-08 17:16:00'),
(38, 'T4008', 'Y4 — ចាន់ សុភា', 'F', 1, 1, 'active', NULL, NULL, '040400008', NULL, NULL, '2026-10-08 17:16:00'),
(39, 'T4009', 'Y4 — សេង ហុង', 'M', 1, 1, 'active', NULL, NULL, '040400009', NULL, NULL, '2026-10-08 17:16:00'),
(40, 'T4010', 'Y4 — ញ៉ែម ចន្ធា', 'F', 1, 1, 'active', NULL, NULL, '040400010', NULL, NULL, '2026-10-08 17:16:00'),
(41, 'sadf', 'sadf', 'F', 4, 3, 'active', NULL, NULL, '', '', '', '2026-10-08 17:23:47'),
(42, 'ume01', 'Van Leapheng', 'M', 4, 3, 'active', NULL, NULL, '123456', '', '', '2026-10-11 19:21:39');

-- --------------------------------------------------------

--
-- Table structure for table `subjects`
--

CREATE TABLE `subjects` (
  `id` int(11) NOT NULL,
  `subject_code` varchar(30) NOT NULL,
  `subject_name` varchar(100) NOT NULL,
  `academic_year_id` int(11) NOT NULL,
  `study_year` tinyint(1) NOT NULL DEFAULT 1,
  `semester` tinyint(1) NOT NULL DEFAULT 1,
  `teacher_id` int(11) DEFAULT NULL,
  `total_weeks` tinyint(4) DEFAULT 15,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `subjects`
--

INSERT INTO `subjects` (`id`, `subject_code`, `subject_name`, `academic_year_id`, `study_year`, `semester`, `teacher_id`, `total_weeks`, `description`, `is_active`, `created_at`) VALUES
(1, 'WEB101', 'Web Design I', 3, 2, 1, NULL, 13, '', 1, '2026-10-08 17:16:00'),
(2, 'WEB102', 'Web Design II', 3, 2, 2, NULL, 15, '', 1, '2026-10-08 17:16:00'),
(3, 'WEB201', 'Web Development I', 3, 3, 1, NULL, 15, '', 1, '2026-10-08 17:16:00'),
(4, 'WEB202', 'Web Development II', 3, 3, 2, NULL, 15, '', 1, '2026-10-08 17:16:00'),
(5, 'WEB301', 'Mobile App II', 3, 4, 2, NULL, 15, '', 1, '2026-10-08 17:16:00'),
(7, 'WEB401', 'Mobile App I', 3, 4, 1, NULL, 15, '', 1, '2026-10-08 17:16:00');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` enum('admin','teacher') DEFAULT 'teacher',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `full_name`, `email`, `role`, `created_at`) VALUES
(1, 'admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'អ្នកគ្រប់គ្រង', 'admin@school.edu', 'admin', '2026-10-08 17:16:00'),
(2, 'teacher1', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'លោកគ្រូ សុខ', 't1@school.edu', 'teacher', '2026-10-08 17:16:00');

-- --------------------------------------------------------

--
-- Table structure for table `weights`
--

CREATE TABLE `weights` (
  `id` int(11) NOT NULL,
  `subject_id` int(11) NOT NULL,
  `attendance_weight` decimal(5,2) DEFAULT 10.00,
  `homework_weight` decimal(5,2) DEFAULT 10.00,
  `quiz_weight` decimal(5,2) DEFAULT 10.00,
  `midterm_weight` decimal(5,2) DEFAULT 20.00,
  `assignment_weight` decimal(5,2) DEFAULT 15.00,
  `final_weight` decimal(5,2) DEFAULT 35.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `weights`
--

INSERT INTO `weights` (`id`, `subject_id`, `attendance_weight`, `homework_weight`, `quiz_weight`, `midterm_weight`, `assignment_weight`, `final_weight`) VALUES
(1, 1, 10.00, 10.00, 10.00, 20.00, 15.00, 35.00),
(2, 2, 10.00, 10.00, 10.00, 20.00, 15.00, 35.00),
(3, 3, 10.00, 10.00, 10.00, 20.00, 15.00, 35.00),
(4, 4, 10.00, 10.00, 10.00, 20.00, 15.00, 35.00),
(5, 5, 10.00, 10.00, 10.00, 20.00, 15.00, 35.00),
(7, 7, 10.00, 10.00, 10.00, 20.00, 15.00, 35.00);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `academic_years`
--
ALTER TABLE `academic_years`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `year_name` (`year_name`),
  ADD KEY `idx_active` (`is_active`);

--
-- Indexes for table `attendance`
--
ALTER TABLE `attendance`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_attendance` (`subject_id`,`student_id`,`week_no`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `attendance_rules`
--
ALTER TABLE `attendance_rules`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_id` (`subject_id`);

--
-- Indexes for table `cohorts`
--
ALTER TABLE `cohorts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cohort_name` (`cohort_name`),
  ADD KEY `idx_current` (`is_current`);

--
-- Indexes for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_enrollment` (`student_id`,`subject_id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `idx_enroll_status` (`status`),
  ADD KEY `idx_student_sem` (`student_id`,`study_year`,`semester`);

--
-- Indexes for table `homework`
--
ALTER TABLE `homework`
  ADD PRIMARY KEY (`id`),
  ADD KEY `subject_id` (`subject_id`),
  ADD KEY `cohort_id` (`cohort_id`);

--
-- Indexes for table `homework_submissions`
--
ALTER TABLE `homework_submissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_sub` (`homework_id`,`student_id`),
  ADD KEY `student_id` (`student_id`);

--
-- Indexes for table `scores`
--
ALTER TABLE `scores`
  ADD PRIMARY KEY (`id`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `idx_type` (`subject_id`,`student_id`,`score_type`);

--
-- Indexes for table `students`
--
ALTER TABLE `students`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_code` (`student_code`),
  ADD KEY `idx_cohort` (`cohort_id`),
  ADD KEY `idx_entry_year` (`entry_year_id`),
  ADD KEY `idx_status` (`status`);

--
-- Indexes for table `subjects`
--
ALTER TABLE `subjects`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_code` (`subject_code`),
  ADD KEY `academic_year_id` (`academic_year_id`),
  ADD KEY `teacher_id` (`teacher_id`),
  ADD KEY `idx_year_sem` (`study_year`,`semester`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `weights`
--
ALTER TABLE `weights`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `subject_id` (`subject_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `academic_years`
--
ALTER TABLE `academic_years`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `attendance`
--
ALTER TABLE `attendance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `attendance_rules`
--
ALTER TABLE `attendance_rules`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `cohorts`
--
ALTER TABLE `cohorts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `enrollments`
--
ALTER TABLE `enrollments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `homework`
--
ALTER TABLE `homework`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `homework_submissions`
--
ALTER TABLE `homework_submissions`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `scores`
--
ALTER TABLE `scores`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=41;

--
-- AUTO_INCREMENT for table `students`
--
ALTER TABLE `students`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- AUTO_INCREMENT for table `subjects`
--
ALTER TABLE `subjects`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `weights`
--
ALTER TABLE `weights`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `attendance`
--
ALTER TABLE `attendance`
  ADD CONSTRAINT `attendance_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `attendance_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `attendance_rules`
--
ALTER TABLE `attendance_rules`
  ADD CONSTRAINT `attendance_rules_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `enrollments`
--
ALTER TABLE `enrollments`
  ADD CONSTRAINT `enrollments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `enrollments_ibfk_2` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `homework`
--
ALTER TABLE `homework`
  ADD CONSTRAINT `homework_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `homework_ibfk_2` FOREIGN KEY (`cohort_id`) REFERENCES `cohorts` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `homework_submissions`
--
ALTER TABLE `homework_submissions`
  ADD CONSTRAINT `homework_submissions_ibfk_1` FOREIGN KEY (`homework_id`) REFERENCES `homework` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `homework_submissions_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `scores`
--
ALTER TABLE `scores`
  ADD CONSTRAINT `scores_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `scores_ibfk_2` FOREIGN KEY (`student_id`) REFERENCES `students` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `students`
--
ALTER TABLE `students`
  ADD CONSTRAINT `fk_stu_cohort` FOREIGN KEY (`cohort_id`) REFERENCES `cohorts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_stu_year` FOREIGN KEY (`entry_year_id`) REFERENCES `academic_years` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `subjects`
--
ALTER TABLE `subjects`
  ADD CONSTRAINT `subjects_ibfk_1` FOREIGN KEY (`academic_year_id`) REFERENCES `academic_years` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `subjects_ibfk_2` FOREIGN KEY (`teacher_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `weights`
--
ALTER TABLE `weights`
  ADD CONSTRAINT `weights_ibfk_1` FOREIGN KEY (`subject_id`) REFERENCES `subjects` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
