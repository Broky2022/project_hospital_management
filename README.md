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

meanfuc@gmail.com / Fuc@123

## mô tả:
Model:
- 2 user (id, email, pass, role) (sử dụng oop):
- bác sĩ (doctor_id, chuyên ngành, số năm kinh nghiệm, mô tả, trạng thái): xem danh sách bệnh nhân, thông tin bệnh nhân và profile bản thân, kê đơn thuốc và kiểm tra lịch làm việc của bản thân, chọn bệnh nhân rồi đặt lịch hẹn khám bệnh
- bệnh nhân (patient_id, tên, tuổi, cân nặng, địa chỉ, id bệnh, mô tả): đọc thông tin bác sĩ hẹn khám, đọc đơn thuốc được kê
- Appointment: id, doctor_id,patient_id, thời gian, trạng thái
- diseas: id, tên bệnh, mô tả