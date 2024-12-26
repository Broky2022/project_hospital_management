<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserDetails extends Model
{
    protected $fillable = [
        'user_id',
        'bio_data',
        //'fav',
        'status',
    ];

    public function user(){
        return $this->belongsTo(User::class);
    }
}
