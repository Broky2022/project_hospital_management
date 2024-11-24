class PhongBenh{
  String _idPhong;
  String _tenPhong;

  PhongBenh(this._idPhong, this._tenPhong);

  String get idPhong => _idPhong;
  String get tenPhong => _tenPhong;

  set idPhong(String idPhong){
    if(idPhong.isNotEmpty){
      _idPhong = idPhong;
    }
  }

  set tenPhong(String tenPhong){
    if(tenPhong.isNotEmpty){
      _tenPhong = tenPhong;
    }
  }
}