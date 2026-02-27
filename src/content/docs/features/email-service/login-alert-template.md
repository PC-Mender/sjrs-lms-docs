---
title: "Login Alert Template"
---

# 🔐 Login Alert Email Template

This document describes the login alert email template for SJRS LMS, which sends security notifications to users whenever they log into their account.

## 📧 Template Overview

The login alert template is designed to enhance account security by notifying users of new login attempts. This helps users:

- **Detect unauthorized access** to their account
- **Monitor account activity** across different devices and locations
- **Take immediate action** if they didn't initiate the login
- **Maintain awareness** of their account security status

## 🎨 Template Features

### **Security-Focused Design**
- 🔐 Clear security alert styling
- ⚠️ Prominent warning sections for suspicious activity
- ✅ Reassuring sections for legitimate logins
- 📅 Detailed login information display

### **Comprehensive Information**
- **Login Time**: Exact timestamp of the login
- **Location**: Geographic location (if available)
- **IP Address**: Source IP address for tracking
- **Device Information**: Browser and device details
- **User Agent**: Full user agent string for technical details

### **Action-Oriented Content**
- **Security Tips**: Best practices for account protection
- **Immediate Actions**: Steps to take if login wasn't authorized
- **Support Contact**: How to get help with security issues

## 📋 Template Data Structure

```typescript
interface LoginAlertData {
  recipientName: string;
  loginTime: string;           // ISO timestamp
  loginLocation?: string;      // Geographic location
  deviceInfo?: string;         // Device/browser info
  ipAddress?: string;          // Source IP address
  userAgent?: string;          // Full user agent string
}
```

## 🔧 Usage Examples

### **Basic Usage**
```typescript
import { generateLoginAlertTemplate } from '../../functions/email-templates';

const emailContent = generateLoginAlertTemplate({
  recipientName: "John Doe",
  loginTime: "2024-01-15T14:30:25.123Z",
  loginLocation: "New York, NY, USA",
  deviceInfo: "Chrome 120.0.0.0 on Windows 11",
  ipAddress: "192.168.1.100",
  userAgent: "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36"
});
```

### **Integration with Authentication System**
```typescript
// In your login handler
async function handleLogin(request: Request, env: any) {
  // ... existing login logic ...
  
  // After successful login, send alert email
  try {
    const deviceInfo = getDeviceInfo(userAgent);
    const loginTime = new Date().toISOString();
    
    // Queue login alert email
    await env.EMAIL_QUEUE.send({
      type: 'login_alert',
      data: {
        userId: user.id,
        email: user.email,
        name: `${user.first_name} ${user.last_name}`,
        loginTime: loginTime,
        loginLocation: 'Unknown Location', // Could be enhanced with IP geolocation
        deviceInfo: deviceInfo,
        ipAddress: ipAddress,
        userAgent: userAgent
      },
      priority: 'high'
    });
  } catch (emailError) {
    console.error('Failed to send login alert email:', emailError);
    // Don't fail the login if email sending fails
  }
}
```

### **Email Processing Integration**
```typescript
// In your email processing code
emailContent = generateLoginAlertTemplate(data);

generateLoginAlert(data: any) {
  const emailContent = generateLoginAlertTemplate({
    recipientName: data.name,
    loginTime: data.loginTime,
    loginLocation: data.loginLocation,
    deviceInfo: data.deviceInfo,
    ipAddress: data.ipAddress,
    userAgent: data.userAgent
  });
  
  return {
    subject: emailContent.subject,
    body: emailContent.textPart,
    html: emailContent.htmlPart
  };
}
```

## 🎯 Template Sections

### **1. Header Section**
- 🔐 Security alert icon and title
- Clear indication this is a login notification
- Professional SJRS LMS branding

### **2. Login Details Card**
- 📅 **Login Time**: Formatted timestamp
- 📍 **Location**: Geographic information (if available)
- 🌐 **IP Address**: Source IP for tracking
- 💻 **Device**: Browser and device information

### **3. Security Guidance**
- ✅ **"This Was You?"**: Reassurance for legitimate logins
- ⚠️ **"Not You?"**: Action steps for suspicious activity
- 🔒 **Security Tips**: Best practices for account protection

### **4. Action Buttons**
- 🔐 **Secure My Account**: Link to security settings
- 📞 **Contact Support**: Direct support access

## 🔒 Security Considerations

### **Privacy Protection**
- IP addresses are included for legitimate security tracking
- Device information helps users identify their own logins
- Location data is optional and can be disabled

### **Rate Limiting**
- Login alerts are sent for every login attempt
- Consider implementing rate limiting for high-frequency users
- Template includes clear "this was you" messaging to reduce false alarms

### **User Experience**
- Non-intrusive design that doesn't create panic
- Clear distinction between legitimate and suspicious activity
- Actionable steps for both scenarios

## 🚀 Implementation Steps

### **1. Add Template to Email System**
```typescript
// In functions/email-templates/index.ts
export function generateLoginAlertTemplate(data: LoginAlertData): EmailContent {
  // Template implementation
}
```

### **2. Update Email Processing**
```typescript
// In functions/email-templates/index.ts
emailContent = generateLoginAlertTemplate(data);
```

### **3. Integrate with Authentication**
```typescript
// In your login handler
await env.EMAIL_QUEUE.send({
  type: 'login_alert',
  data: loginData,
  priority: 'high'
});
```

### **4. Test the Template**
```typescript
// Use the email preview page to test
// Navigate to /email-preview and select "Login Alert"
```

## 📊 Analytics and Monitoring

### **Email Metrics**
- Track open rates for login alerts
- Monitor user engagement with security links
- Analyze patterns in suspicious activity reports

### **Security Metrics**
- Monitor login patterns across different locations
- Track device usage patterns
- Identify potential security threats

## 🔧 Customization Options

### **Template Variations**
- **Basic Alert**: Essential information only
- **Detailed Alert**: Full device and location information
- **Suspicious Activity**: Enhanced warning styling
- **New Device**: Special styling for first-time device logins

### **Localization**
- Support for multiple languages
- Region-specific security tips
- Local support contact information

## 🎨 Design System

### **Color Scheme**
- **Primary**: `#667eea` (Security Blue)
- **Success**: `#28a745` (Legitimate Login)
- **Warning**: `#ffc107` (Suspicious Activity)
- **Danger**: `#dc3545` (Security Threat)

### **Typography**
- Clear, readable fonts
- Proper hierarchy for information
- Emphasis on security-related content

## 📱 Responsive Design

### **Mobile Optimization**
- Full-width layout on mobile devices
- Touch-friendly buttons
- Readable text at all screen sizes

### **Email Client Compatibility**
- Tested across major email clients
- Fallback styling for older clients
- Consistent rendering across platforms

## 🔄 Future Enhancements

### **Advanced Features**
- **Geolocation Integration**: Real-time location detection
- **Device Fingerprinting**: Unique device identification
- **Risk Scoring**: Automated threat assessment
- **Two-Factor Integration**: MFA status in alerts

### **User Preferences**
- **Alert Frequency**: Allow users to control alert frequency
- **Information Level**: Choose detail level in alerts
- **Delivery Preferences**: Email, SMS, or push notifications

## 📞 Support and Maintenance

### **Troubleshooting**
- Monitor email delivery rates
- Check for template rendering issues
- Verify queue processing status

### **Updates**
- Regular security content updates
- Template design improvements
- New feature integrations

---

This login alert template enhances the security posture of SJRS LMS by providing users with immediate visibility into their account activity while maintaining a professional and reassuring user experience. 