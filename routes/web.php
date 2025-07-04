<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\ContactController;
use Illuminate\Support\Facades\Route;

// Public routes
Route::middleware('guest')->group(function () {
    Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
    Route::post('/login', [AuthController::class, 'login']);
});

// Protected routes
Route::middleware('auth')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout'])->name('logout');
    Route::resource('contacts', ContactController::class);
});

// Redirect root to contacts if authenticated, otherwise to login
Route::get('/', function () {
    return auth()->check() 
        ? redirect()->route('contacts.index') 
        : redirect()->route('login');
});
