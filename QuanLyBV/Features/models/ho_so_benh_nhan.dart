class HoSoBenhNhan {
  String _idHoSo;
  String _tenBenh;
  DateTime _ngayNhapVien;
  String _ketQua;

  HoSoBenhNhan(this._idHoSo, this._tenBenh, this._ngayNhapVien, this._ketQua);

  String get idHoSo => _idHoSo;
  String get tenBenh => _tenBenh;
  DateTime get ngayNhapVien => _ngayNhapVien;
  String get ketQua => _ketQua;

  set tenBenh(String tenBenh){
    if(tenBenh.isNotEmpty){
      _tenBenh = tenBenh;
    }
  }

  set ngayNhapVien(DateTime ngayNhapVien){
    if(ngayNhapVien.isBefore(DateTime.now())){
      _ngayNhapVien = ngayNhapVien;
    }
  }

  set ketQua(String ketQua){
    if(ketQua.isNotEmpty){
      _ketQua = ketQua;
    }
  }
}