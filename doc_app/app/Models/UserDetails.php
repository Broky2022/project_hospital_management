<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserDetails extends Model
{
    protected $fillable = [
        'user_id',
        'status'
        'bio_data',
        //'fav',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }
}
