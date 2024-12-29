<?php

namespace App\Http\Controllers;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;
use App\Models\User;
use App\Models\UserDetail;


class UsersController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {

    }

public function login(Request $request)
    {
        $request -> validate([
        'email' => 'required|email',
        'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if(!$user || ! Hash::check($request -> password, $user -> password)){
        throw ValidationException :: withMessages([
        'email' => ['The provided credentials are incorrect'],
        ]);
      }
    return $user -> createToken($request -> email) -> plainTextToken;
    }
    /**
     * Show the form for creating a new resource.
     */

     public function register(Request $request)
     {
         try {
             $request->validate([
                 'name' => 'required|string',
                 'email' => 'required|email|unique:users', // Thêm unique để tránh email trùng
                 'password' => 'required|min:6', // Thêm min:6 để đảm bảo độ dài tối thiểu
             ]);

             $user = User::create([
                 'name' => $request->name,
                 'email' => $request->email,
                 'type' => 'user',
                 'password' => Hash::make($request->password),
             ]);

             $userInfo = UserDetail::create([
                 'user_id' => $user->id,
                 'status' => 'active',
             ]);

             return response()->json([
                 'user' => $user,
                 'message' => 'Registration successful'
             ], 201);

         } catch (\Exception $e) {
             \Log::error('Registration error: ' . $e->getMessage());
             return response()->json([
                 'message' => 'Registration failed',
                 'error' => $e->getMessage()
             ], 500);
         }
     }

    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        //
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}
