# Hospital Management Project

## Overview
A Flutter-based hospital management application that facilitates the interaction between doctors and patients. The application uses MySQL for data storage and provides separate interfaces for doctors and patients. The user interface is primarily in Vietnamese, making it accessible for Vietnamese healthcare providers and patients.

## Features

### Authentication
- User registration with role selection (Doctor/Patient)
- Secure login system
- Role-based access control

### Doctor Features
- View and manage patient list
- Schedule appointments
- View appointment calendar
- Update patient information and diagnoses
- Add and manage diseases in the system
- Professional profile management
- View and update appointment status

### Patient Features
- View personal medical profile
- Schedule appointments with doctors
- View appointment history
- Access medical records
- Update personal information
- View assigned doctor information

### Appointment Management
- Create new appointments
- View appointment details
- Update appointment status (Pending/Confirmed/Cancelled)
- Delete appointments
- Date and time selection

## Technical Architecture

### Frontend (Flutter)
- **Screens**:
  - Login/Signup forms
  - Doctor & Patient home screens
  - Appointment management
  - Profile management
  - Disease management
  
- **Components**:
  - Custom form widgets
  - Date/Time pickers
  - List views with search functionality
  - Status indicators
  - Information cards

### Backend (MySQL)
- **Tables**:
  - Users (Authentication)
  - Doctors
  - Patients
  - Appointments
  - Diseases
  - Prescriptions

### Data Models
- User
- Doctor
- Patient
- Appointment
- Disease

## Project Structure
```
lib/
├── database/
│   ├── database_service.dart    # Database operations
│   └── mysql_config.dart        # MySQL configuration
├── models/
│   ├── appointments.dart        # Appointment data model
│   ├── doctor.dart             # Doctor data model
│   ├── patient.dart            # Patient data model
│   └── user.dart               # User base model
├── providers/
│   └── auth_provider.dart      # Authentication state management
└── screens/
    ├── signup_form.dart        # User registration
    ├── doctor_home.dart        # Doctor main screen
    ├── patient_home.dart       # Patient main screen
    ├── patientsTab.dart        # Patient list view
    ├── appointmentsTab.dart    # Appointments view
    ├── appointmentDetail.dart  # Appointment details
    ├── doctor_profile.dart     # Doctor profile
    ├── addDiseaseScreen.dart   # Disease management
    └── dateTimePickerDialog.dart # Appointment scheduling
```

## Installation

### Prerequisites
- Flutter SDK
- XAMPP/WAMP (for local development)

### Setup Steps
1. Clone the repository
   ```bash
   git clone [repository-url]
   ```

2. Install dependencies
   ```bash
   flutter pub get
   ```

3. Configure MySQL
   - Create a new database named 'hospital_management'
   - Import the provided SQL schema
   - Update database configuration in `lib/database/mysql_config.dart` with your MySQL server details:
     ```dart
     static const String _host = 'your_mysql_host';
     static const int _port = 3306;
     static const String _user = 'your_username';
     static const String _password = 'your_password';
     static const String _db = 'hospital_management';
     ```

4. Run the application
   ```bash
   flutter run
   ```

## Development
- Built with Flutter for cross-platform compatibility
- Uses Provider pattern for state management
- Implements clean architecture principles with separation of models, screens, and database services
- Features responsive UI design with Material Design components
- Includes error handling and loading states
- Authentication implemented using a custom AuthProvider

## Security Features
- Secure password handling
- Role-based authorization
- Input validation
- SQL injection prevention
- Session management

## Current Status
The application is functional with core features implemented including user authentication, appointment management, patient and doctor profiles, and disease tracking. The system is ready for testing in a clinical environment.

## Future Enhancements
- Push notifications for appointments
- Electronic health records
- Medical history tracking
- Prescription management
- Online consultation features
- Payment integration
- Multi-language support
- Dark mode theme
