<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Illuminate\Support\Facades\Hash;

class UserController extends Controller
{
        @return \Illuminate\Http\Response
    public function index()
    {


    }

        @return \Illuminate\Http\Response
    public function login(Request $request)
    {
        $request->validate([
            'email'=>'required|email',
            'password'=>'required',
        ]);
        //kiểm tra đúng user hay không
        $user = User::where('email', $request->email)->first();

        //kiểm tra password
        if(!$user || ! Hash::check($request->password, $user->password)){
            throw ValidationException::withMessages([
                'email'=>['the provider credentials are incorrect'],
            ]);
        }

        return $user->createToken($request->email)->plainTextToken;
    }

        @return \Illuminate\Http\Response
    public function register(Request $request)
    {
        $request->validate([
           'name'=>'required|string',
           'email'=>'required|email',
           'password'=>'required',
        ]);

        $user = User::create([
            'name'=>$request->name,
            'email'=>$request->email,
            'type'=>'user',
            'password'=>Hash::make($request->password),
        ]);

        $userInfo = UserDetail::create([
            'user_id'=>$user->id,
            'status'=>'active',
        ]);

        return $user;
    }
}
