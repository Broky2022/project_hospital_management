class BacSi {
  String _idBacSi;
  String _hoTen;
  DateTime _namSinh;
  String _chuyenMon;
  String _trinhDo;
  String _khoa;

  BacSi(this._idBacSi, this._hoTen, this._namSinh, this._chuyenMon, this._trinhDo, this._khoa);

  String get idBacSi => _idBacSi;
  String get hoTen => _hoTen;
  DateTime get namSinh => _namSinh;
  String get chuyenMon => _chuyenMon;
  String get trinhDo => _trinhDo;
  String get khoa => _khoa;

  set idBacSi(String idBacSi) {
    if(idBacSi.isNotEmpty) {
      _idBacSi = idBacSi;
    }
  }

  set hoTen(String hoTen) {
    if(hoTen.isNotEmpty) {
      _hoTen = hoTen;
    }
  }

  set namSinh(DateTime namSinh) {
    if(namSinh.isAfter(DateTime.now())) {
      _namSinh = namSinh;
    }
  }

  set chuyenMon(String chuyenMon) {
    if(chuyenMon.isNotEmpty) {
      _chuyenMon = chuyenMon;
    }
  }

  set trinhDo(String trinhDo) {
    if(trinhDo.isNotEmpty) {
      _trinhDo = trinhDo;
    }
  }

  set khoa(String khoa) {
    if(khoa.isNotEmpty) {
      _khoa = khoa;
    }
  }
}