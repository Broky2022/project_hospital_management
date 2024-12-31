# Project_hospital_management
>Flutter Project

## Ngày 4/1/2025 lúc 12h30 phòng E2-02.03 báo cáo đồ án môn học

### Cách câu lệnh:
- Git checkout <tên nhánh>: di chuyển ra nhánh 
- Git merge <tên nhánh>: hợp nhất nhánh (nhánh chọn vào nhánh hiện tại)
- Git push origin <tên nhánh>: đẩy source lên nhánh 
- Git pull origin main: tải các thay đổi từ main về dự án
- Git fetch: Tải về tất cả các thay đổi từ remote mà không tự động hợp nhất (fetch) vào nhánh hiện tại
- Git branch -r: kiểm tra các nhánh cục bộ hiện tại
- git reset --hard <tên-nhánh-hoặc-commit>


1. doctor: meanfuc@gmail.com / Fuc@123
2. patient:
    - ky@gmail.com / Ky@123
    - ci@gmail.com / Ci@123

## mô tả:
Model:
- 2 user (id, email, pass, role) (sử dụng oop):
- bác sĩ (doctor_id, chuyên ngành, số năm kinh nghiệm, mô tả, trạng thái): xem danh sách bệnh nhân, thông tin bệnh nhân và profile bản thân, kê đơn thuốc và kiểm tra lịch làm việc của bản thân, chọn bệnh nhân rồi đặt lịch hẹn khám bệnh
- bệnh nhân (patient_id, tên, tuổi, cân nặng, địa chỉ, id bệnh, mô tả): đọc thông tin bác sĩ hẹn khám, đọc đơn thuốc được kê
- Appointment: id, doctor_id,patient_id, thời gian, trạng thái
- diseas: id, tên bệnh, mô tả

- tạo 2 loại home page
- 1 cái cho bác sĩ, 1 cái cho bệnh nhân
- bác sĩ sẽ thấy danh sách bệnh nhân, bấm vào sẽ thấy thông tin chi tiết, có thể đặt lịch hẹn, thêm trang profile nữa
- bệnh nhân sẽ thấy mỗi profile bản thân, cuối cùng có thể thấy bác sĩ điều trị của bản thân, bấm vào đó có thể xem thông tin doctor

---

### đây là ở nhánh Phúc1

- Signup data: {email: 1@gmail.com, password: fuc@123, name: d, age: 2, weight: 1, address: v, description: t}
- Signup error: Bad state: databaseFactory not initialized
- databaseFactory is only initialized when using sqflite. When using `sqflite_common_ffi`
- You must call `databaseFactory = databaseFactoryFfi;` before using global openDatabase API



### đây là nhánh kỳ
- [x] danh sách ok
- [x] chức năng chuyển tab done
- [ ] đặt lịch thành công (chưa rõ vào database) và chưa hiện trong tab 
- [ ] Hồ sơ null

