---
title: "Overview"
---

# 🚀 Getting Started

This directory contains getting started guides and basic setup instructions for the SJRS Library Management System.

## 📚 Quick Start Guides

### **For New Users**
- **[Setup Guide](./setup.md)** ⭐ **COMPLETE** - Initial system configuration and installation
- **First Login**: Understanding the login process and session management
- **Dashboard Navigation**: Getting familiar with the user interface
- **Basic Operations**: Common tasks and workflows

### **For Developers**
- **[Setup Guide](./setup.md)** - Local development environment configuration
- **API Integration**: Understanding the API structure and authentication
- **Session Management**: Cross-tab synchronization and security features
- **[Testing Guide](../development/testing-guide.md)** - Running tests and debugging

### **For System Administrators**
- **[Setup Guide](./setup.md)** - Production deployment configuration
- **[Database Setup](../deployment/d1-setup.md)** - D1 database configuration and migration
- **Security Configuration**: Security features and monitoring setup
- **Monitoring**: System monitoring and alert configuration

## 🎯 Getting Started Steps

### **1. System Access**
1. **Navigate to the application** at your deployment URL
2. **Register an account** or use provided credentials
3. **Complete profile setup** with required information
4. **Understand session management** and cross-tab synchronization

### **2. Basic Navigation**
1. **Explore the dashboard** based on your user role
2. **Review available features** and permissions
3. **Test cross-tab synchronization** by opening multiple tabs
4. **Understand security alerts** and session warnings

### **3. Common Operations**
1. **User Management**: Adding and managing users
2. **Book Management**: Adding and managing books
3. **Loan Management**: Processing book loans and returns
4. **System Monitoring**: Reviewing action logs and security events

## 🔗 Related Documentation

- **[User Guides](../user-guides/)** - Detailed user guides for different roles
- **[Features Documentation](../features/)** - Feature-specific guides and implementation
- **[Development Documentation](../development/)** - Technical implementation details
- **[Security Documentation](../security/)** - Security features and best practices

## 📋 System Overview

### **User Types**
- **Students**: Basic access to browse and borrow books
- **Professors**: Enhanced access with additional privileges
- **Librarians**: Library management and administrative functions
- **Admins**: System administration and user management
- **Superusers**: Complete system access and configuration

### **Key Features**
- **Dynamic Role System**: Database-driven role management
- **Advanced Session Management**: Cross-tab synchronization
- **Security Features**: Hash validation and activity monitoring
- **Action Logging**: Comprehensive audit trail
- **Email Notifications**: Automated communication system

### **Technology Stack**
- **Frontend**: React with TypeScript
- **Backend**: Cloudflare Workers
- **Database**: Cloudflare D1 (SQLite)
- **Storage**: Cloudflare R2
- **Email**: Mailjet integration

## 🚀 Quick Setup

### **For End Users**
1. **Access the system** through your provided URL
2. **Register or login** with your credentials
3. **Complete your profile** with required information
4. **Explore features** based on your role permissions

### **For Developers**
1. **Clone the repository** and install dependencies
2. **Configure environment variables** for local development
3. **Set up D1 database** with required schema
4. **Start development server** and test features

### **For Administrators**
1. **Deploy to Cloudflare** using Wrangler
2. **Configure D1 database** and run migrations
3. **Set up email service** with Mailjet
4. **Configure security features** and monitoring

## 🔧 Configuration

### **Environment Variables**
```bash
# Database configuration
DB_NAME=your-database-name

# Email service configuration
MAILJET_API_KEY=your_api_key
MAILJET_API_SECRET=your_api_secret
MAILJET_FROM_EMAIL=your_from_email

# Security configuration
SESSION_TIMEOUT=900000  # 15 minutes
SECURITY_HASH_ENABLED=true
ACTIVITY_MONITORING=true
```

### **Database Setup**
```sql
-- Run initial schema
-- See sql/d1-schema.sql for complete schema
```

### **Security Configuration**
- **Session Management**: Cross-tab synchronization enabled
- **Security Hash**: Browser fingerprint validation
- **Activity Monitoring**: Suspicious behavior detection
- **Session Limits**: 24-hour maximum session duration

## 📊 Monitoring and Support

### **System Monitoring**
- **Action Logs**: Monitor all system activities
- **Session Management**: Track login/logout events
- **Security Alerts**: Monitor security violations
- **Performance Metrics**: Track system performance

### **Support Resources**
- **[User Guides](../user-guides/)** - Detailed user documentation
- **[Features Documentation](../features/)** - Feature-specific guides
- **[Development Documentation](../development/)** - Technical implementation
- **[Security Documentation](../security/)** - Security features and best practices

## 🎯 Best Practices

### **For Users**
- **Regular logins** to maintain session activity
- **Cross-tab awareness** for consistent experience
- **Security alert attention** for potential issues
- **Profile completion** for full feature access

### **For Developers**
- **Session management testing** across multiple tabs
- **Security feature validation** for compliance
- **Performance monitoring** for optimization
- **Error handling** for robust operation

### **For Administrators**
- **Regular monitoring** of action logs and security events
- **User management** with proper role assignment
- **System maintenance** and regular updates
- **Security awareness** and incident response

---

**Last Updated:** November 2025  
**Version:** 2.1.0 (Session Management Enhanced) 