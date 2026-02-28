---
title: "Glossary & Terminology"
description: "A comprehensive guide to terms, roles, and concepts used in the SJRS Library Management System."
---

# 📚 Glossary & Terminology

This glossary defines key terms, roles, and technical concepts used throughout the SJRS Library Management System (LMS) documentation.

## 👥 User Roles & Access

Understanding the different user roles is crucial for managing permissions and access levels.

### **Student**
The base user role for students.
- **Permissions**: Can browse the catalog, borrow books (with limits), reserve books, and view their own history.
- **Loan Limits**: Typically restricted to a specific number of books (e.g., 5) for a set period (e.g., 14 days).

### **Professor**
An enhanced user role for faculty members.
- **Permissions**: All Student permissions plus extended borrowing privileges.
- **Loan Limits**: Higher book limit (e.g., 10) and longer loan periods (e.g., 30 days).

### **Dean**
Senior administrative role with oversight capabilities.

### **Librarian**
The primary operational role for library staff.
- **Permissions**: Can manage books (add/edit), process loans/returns, manage user accounts, and view reports.
- **Access**: Access to the Librarian Dashboard for daily operations.

### **Admin**
A system administrator role.
- **Permissions**: All Librarian permissions plus system configuration, advanced user management, and security settings.
- **Access**: Access to the Admin Dashboard for system-wide management.

### **Superuser**
The highest level of access.
- **Permissions**: Unrestricted access to all system features, including database management, role configuration, and critical system settings.
- **Note**: This role is reserved for technical administrators and developers.

---

## 🔐 Security & Authentication

Terms related to how the system secures data and manages user access.

### **Profile Completion**
A mandatory step for new users to provide additional details (phone, stream) after email verification.

### **Pending Approval**
A state where a new user account awaits administrator review before being granted full access.

### **Authentication (AuthN)**
The process of verifying a user's identity (e.g., logging in with email and password).

### **Authorization (AuthZ)**
The process of determining what an authenticated user is allowed to do (e.g., checking permissions to delete a book).

### **Session**
A period of active use by a logged-in user.
- **Session ID**: A unique identifier for the user's current session.
- **Session Timeout**: The duration after which an inactive session expires (e.g., 15 minutes) to protect unauthorized access.
- **Cross-Tab Sync**: The feature that keeps your login state consistent across multiple browser tabs.

### **Token**
A digital key used to access the system securely.
- **JWT (JSON Web Token)**: A compact, URL-safe means of representing claims to be transferred between two parties. Used for API authentication.
- **CSRF Token**: A unique token used to prevent Cross-Site Request Forgery attacks, ensuring that actions are intentionally performed by the user.

### **Permission**
A specific right to perform an action (e.g., `books:create`, `users:read`). Roles are collections of permissions.

### **MFA (Multi-Factor Authentication)**
An extra layer of security that requires not only a password and username but also something that only the user has on them (e.g., a code from an email or authenticator app).

---

## 🛠️ Technical Concepts

Brief explanations of the underlying technology stack.

### **Cloudflare Workers**
The serverless platform that runs the backend logic of the LMS. It ensures high performance and low latency by running code close to the user.

### **D1 (Cloudflare D1)**
The serverless SQL database used to store all system data, including books, users, and loans. It is built on SQLite.

### **R2 (Cloudflare R2)**
The object storage system used for storing files like book cover images and user avatars.

### **Soft Delete**
A data management strategy where a record is not permanently removed from the database but is flagged as "deleted" (or status changed to 'lost'/'unavailable'). This allows for data recovery if needed.

### **Hard Delete**
The permanent removal of a record from the database. Once hard-deleted, data cannot be recovered via the application interface.

### **Migration**
A script or process used to update the database schema (structure) to a new version (e.g., adding a new column to a table).

---

## 📖 Library Operations

Terms specific to the day-to-day management of the library.

### **Catalog**
The complete collection of books and resources available in the library.

### **Circulation**
The process of lending and returning library materials.

### **Reservation**
The act of placing a hold on a book that is currently checked out or available, ensuring the user is next in line to borrow it.

### **Renewal**
Extending the loan period for a borrowed book, provided it has not been reserved by another user.

### **Fine / Penalty**
A fee or restriction applied to a user for overdue, lost, or damaged books.

### **ISBN (International Standard Book Number)**
A unique numeric commercial book identifier.

### **Copy Number**
A unique number assigned to each specific physical copy of a book title. A single book title (e.g., "Clean Code") may have multiple copies (Copy 1, Copy 2, etc.).
