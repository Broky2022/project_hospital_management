class BenhNhan{
  String _idBenhNhan;
  String _canCCD;
  String _hoTen;
  String _queQuan;
  DateTime _ngaySinh;
  String _danToc;
  String _ngheNghiep;

  BenhNhan(this._idBenhNhan, this._canCCD, this._hoTen, this._queQuan, this._ngaySinh, this._danToc, this._ngheNghiep);

  String get idBenhNhan => _idBenhNhan;
  String get canCCD => _canCCD;
  String get hoTen => _hoTen;
  String get queQuan => _queQuan;
  DateTime get ngaySinh => _ngaySinh;
  String get danToc => _danToc;
  String get ngheNghiep => _ngheNghiep;

  set idBenhNhan(String idBenhNhan){
    if(idBenhNhan.isNotEmpty){
      _idBenhNhan = idBenhNhan;
    }
  }

  set canCCD(String canCCD){
    if(canCCD.isNotEmpty){
      _canCCD = canCCD;
    }
  }

  set hoTen(String hoTen){
    if(hoTen.isNotEmpty){
      _hoTen = hoTen;
    }
  }

  set queQuan(String queQuan){
    if(queQuan.isNotEmpty){
      _queQuan = queQuan;
    }
  }

  set NgaySinh(DateTime ngaySinh){
    if(ngaySinh.isBefore(DateTime.now())){
      ngaySinh = _ngaySinh;
    }
  }

  set danToc(String danToc){
    if(danToc.isNotEmpty){
      _danToc = danToc;
    }
  }

  set ngheNghiep(String ngheNghiep){
    if(ngheNghiep.isNotEmpty){
      _ngheNghiep = ngheNghiep;
    }
  }
}