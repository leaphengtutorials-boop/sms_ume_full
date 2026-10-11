<?php
require '../config.php';

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    respond(['error' => 'Method not allowed'], 405);
}

$data = input();
$username = trim($data['username'] ?? '');
$password = $data['password'] ?? '';

if (!$username || !$password) {
    respond(['error' => 'សូមបំពេញឈ្មោះ និងលេខសម្ងាត់'], 400);
}

$stmt = $pdo->prepare("SELECT * FROM users WHERE username = ?");
$stmt->execute([$username]);
$user = $stmt->fetch();

if (!$user || !password_verify($password, $user['password'])) {
    respond(['error' => 'ឈ្មោះអ្នកប្រើ ឬលេខសម្ងាត់មិនត្រឹមត្រូវ'], 401);
}

// Generate simple token (សម្រាប់ Demo)
$token = bin2hex(random_bytes(32));

respond([
    'success' => true,
    'token' => $token,
    'user' => [
        'id' => $user['id'],
        'username' => $user['username'],
        'full_name' => $user['full_name'],
        'role' => $user['role'],
    ],
]);