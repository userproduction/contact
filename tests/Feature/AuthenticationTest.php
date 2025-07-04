<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Session;
use Tests\TestCase;

class AuthenticationTest extends TestCase
{
    use RefreshDatabase;

    /**
     * Test that login page is accessible.
     */
    public function test_login_page_is_accessible(): void
    {
        $response = $this->get('/login');

        $response->assertStatus(200);
        $response->assertViewIs('auth.login');
        $response->assertSee('Contact Manager');
        $response->assertSee('Please sign in to continue');
    }

    /**
     * Test that admin user can be created using factory.
     */
    public function test_admin_user_can_be_created_using_factory(): void
    {
        $adminUser = User::factory()->admin()->create();

        $this->assertDatabaseHas('users', [
            'name' => 'Administrator',
            'email' => 'admin@admin.com',
        ]);

        // Verify password is correctly hashed
        $this->assertTrue(Hash::check('admin', $adminUser->password));
    }

    /**
     * Test successful login with admin credentials.
     */
    public function test_admin_can_login_with_correct_credentials(): void
    {
        // Create admin user
        User::factory()->admin()->create();

        // Attempt login
        $response = $this->post('/login', [
            'email' => 'admin@admin.com',
            'password' => 'admin',
        ]);

        // Assert authentication was successful
        $this->assertAuthenticated();
        $response->assertRedirect('/contacts');
        $response->assertSessionHas('success', 'Welcome back!');
    }

    /**
     * Test login with session facade usage.
     */
    public function test_login_creates_custom_session_data(): void
    {
        // Create admin user
        User::factory()->admin()->create();

        // Start session
        $this->startSession();

        // Attempt login
        $response = $this->post('/login', [
            'email' => 'admin@admin.com',
            'password' => 'admin',
        ]);

        // Assert custom session data is set
        $this->assertTrue(Session::get('user_authenticated'));
        $this->assertEquals('admin@admin.com', Session::get('user_email'));
        
        // Assert redirect to contacts
        $response->assertRedirect('/contacts');
    }

    /**
     * Test login with incorrect credentials.
     */
    public function test_login_fails_with_incorrect_credentials(): void
    {
        // Create admin user
        User::factory()->admin()->create();

        // Attempt login with wrong password
        $response = $this->post('/login', [
            'email' => 'admin@admin.com',
            'password' => 'wrong-password',
        ]);

        // Assert authentication failed
        $this->assertGuest();
        $response->assertSessionHasErrors(['email']);
        $response->assertSessionDoesntHave('user_authenticated');
        $response->assertSessionDoesntHave('user_email');
    }

    /**
     * Test logout functionality.
     */
    public function test_authenticated_user_can_logout(): void
    {
        // Create and authenticate admin user
        $user = User::factory()->admin()->create();
        $this->actingAs($user);

        // Set custom session data
        Session::put('user_authenticated', true);
        Session::put('user_email', 'admin@admin.com');

        // Attempt logout
        $response = $this->post('/logout');

        // Assert user is logged out
        $this->assertGuest();
        $response->assertRedirect('/login');
        $response->assertSessionHas('success', 'You have been logged out successfully.');

        // Assert custom session data is cleared
        $this->assertFalse(Session::has('user_authenticated'));
        $this->assertFalse(Session::has('user_email'));
    }

    /**
     * Test that contacts routes require authentication.
     */
    public function test_contacts_routes_require_authentication(): void
    {
        // Test contacts index
        $response = $this->get('/contacts');
        $response->assertRedirect('/login');

        // Test contacts create
        $response = $this->get('/contacts/create');
        $response->assertRedirect('/login');

        // Test contacts store
        $response = $this->post('/contacts', [
            'first_name' => 'John',
            'last_name' => 'Doe',
            'email' => 'john@example.com',
        ]);
        $response->assertRedirect('/login');
    }

    /**
     * Test that authenticated users can access contacts.
     */
    public function test_authenticated_users_can_access_contacts(): void
    {
        // Create and authenticate admin user
        $user = User::factory()->admin()->create();
        $this->actingAs($user);

        // Test contacts index
        $response = $this->get('/contacts');
        $response->assertStatus(200);
        $response->assertViewIs('contacts.index');

        // Test contacts create
        $response = $this->get('/contacts/create');
        $response->assertStatus(200);
        $response->assertViewIs('contacts.create');
    }

    /**
     * Test home page redirects correctly based on authentication.
     */
    public function test_home_page_redirects_correctly(): void
    {
        // Test unauthenticated user
        $response = $this->get('/');
        $response->assertRedirect('/login');

        // Test authenticated user
        $user = User::factory()->admin()->create();
        $this->actingAs($user);
        
        $response = $this->get('/');
        $response->assertRedirect('/contacts');
    }

    /**
     * Test session persistence after login.
     */
    public function test_session_persists_after_login(): void
    {
        // Create admin user
        User::factory()->admin()->create();

        // Login
        $this->post('/login', [
            'email' => 'admin@admin.com',
            'password' => 'admin',
        ]);

        // Make subsequent request to verify session persists
        $response = $this->get('/contacts');
        $response->assertStatus(200);
        
        // Check session data persists
        $this->assertTrue(Session::get('user_authenticated'));
        $this->assertEquals('admin@admin.com', Session::get('user_email'));
    }

    /**
     * Test remember me functionality.
     */
    public function test_remember_me_functionality(): void
    {
        // Create admin user
        User::factory()->admin()->create();

        // Login with remember me
        $response = $this->post('/login', [
            'email' => 'admin@admin.com',
            'password' => 'admin',
            'remember' => true,
        ]);

        $this->assertAuthenticated();
        $response->assertRedirect('/contacts');
        
        // Check that remember token is set
        $user = User::where('email', 'admin@admin.com')->first();
        $this->assertNotNull($user->remember_token);
    }
}