---
title: "Quick Start Guide"
---

# 🚀 API Quick Start Guide

Get started with the SJRS LMS API in **5 minutes** with this step-by-step guide.

## ⚡ Quick Start (5 Minutes)

### **1. Get Your API Credentials** ⏱️ 1 min
```bash
# You'll need these environment variables
JWT_SECRET=your-secure-jwt-secret-key
MAILJET_API_KEY=your_mailjet_api_key
MAILJET_API_SECRET=your_mailjet_api_secret
```

### **2. Test the Health Endpoint** ⏱️ 1 min
```bash
# Test if the API is running
curl -X GET "https://your-worker.your-subdomain.workers.dev/api/health"
```

**Expected Response:**
```json
{
  "status": "ok",
  "timestamp": "2024-01-15T10:30:00Z",
  "version": "2.2.0"
}
```

### **3. Register a Test User** ⏱️ 1 min
```bash
curl -X POST "https://your-worker.your-subdomain.workers.dev/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpass123",
    "first_name": "Test",
    "last_name": "User",
    "user_type": "student"
  }'
```

### **4. Login and Get Token** ⏱️ 1 min
```bash
curl -X POST "https://your-worker.your-subdomain.workers.dev/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{
    "email": "test@example.com",
    "password": "testpass123"
  }'
```

**Save the JWT token from the response!**

### **5. Make Your First API Call** ⏱️ 1 min
```bash
# Replace YOUR_JWT_TOKEN with the token from step 4
curl -X GET "https://your-worker.your-subdomain.workers.dev/api/books" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

**🎉 Congratulations! You're now using the SJRS LMS API!**

## 🔧 Setup for Development

### **Environment Setup**

#### **Option 1: Local Development**
```bash
# Clone the repository
git clone https://github.com/your-username/sjrslms.git
cd sjrslms

# Install dependencies
npm install

# Set environment variables
cp .env.example .env
# Edit .env with your credentials

# Start development server
npm run dev
```

#### **Option 2: Remote API Only**
```bash
# Just set the API base URL
export VITE_API_BASE_URL=https://your-worker.your-subdomain.workers.dev
```

### **Required Environment Variables**
```bash
# JWT Configuration (choose one)
JWT_SECRET=your-secure-jwt-secret-key

# OR for key rotation (recommended)
JWT_KEYS_JSON={"key-2025-01":"super-secret-1","key-2025-07":"super-secret-2"}
JWT_DEFAULT_KID=key-2025-01
JWT_ISS=your-jwt-issuer
JWT_AUD=https://your-worker.your-subdomain.workers.dev

# Email Service
MAILJET_API_KEY=your_mailjet_api_key
MAILJET_API_SECRET=your_mailjet_api_secret
MAILJET_FROM_EMAIL=noreply@yourdomain.com

# Database (if using local D1)
DB_NAME=your-database-name
```

## 📱 Client Setup Examples

### **JavaScript/TypeScript (Frontend)**
```typescript
// api-client.ts
class SJRSLMSAPI {
  private baseUrl = 'https://your-worker.your-subdomain.workers.dev';
  private token: string | null = null;
  private csrfToken: string | null = null;

  async login(email: string, password: string) {
    const response = await fetch(`${this.baseUrl}/api/auth/login`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email, password })
    });

    const data = await response.json();
    if (data.success) {
      this.token = data.token;
      this.csrfToken = data.csrf_token;
    }
    return data;
  }

  async getBooks() {
    if (!this.token) throw new Error('Not authenticated');

    const response = await fetch(`${this.baseUrl}/api/books`, {
      headers: {
        'Authorization': `Bearer ${this.token}`,
        'X-XSRF-TOKEN': this.csrfToken || ''
      }
    });

    return response.json();
  }
}

// Usage
const api = new SJRSLMSAPI();
await api.login('user@example.com', 'password123');
const books = await api.getBooks();
```

### **Python**
```python
import requests
import json

class SJRSLMSAPI:
    def __init__(self, base_url="https://your-worker.your-subdomain.workers.dev"):
        self.base_url = base_url
        self.token = None
        self.csrf_token = None

    def login(self, email, password):
        response = requests.post(
            f"{self.base_url}/api/auth/login",
            json={"email": email, "password": password}
        )
        
        data = response.json()
        if data.get("success"):
            self.token = data["token"]
            self.csrf_token = data.get("csrf_token")
        
        return data

    def get_books(self):
        if not self.token:
            raise Exception("Not authenticated")

        headers = {
            "Authorization": f"Bearer {self.token}",
            "X-XSRF-TOKEN": self.csrf_token or ""
        }
        
        response = requests.get(
            f"{self.base_url}/api/books",
            headers=headers
        )
        
        return response.json()

# Usage
api = SJRSLMSAPI()
api.login("user@example.com", "password123")
books = api.get_books()
```

### **cURL Scripts**
```bash
#!/bin/bash
# api-test.sh

BASE_URL="https://your-worker.your-subdomain.workers.dev"
EMAIL="test@example.com"
PASSWORD="testpass123"

echo "🔑 Logging in..."
LOGIN_RESPONSE=$(curl -s -X POST "$BASE_URL/api/auth/login" \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"$EMAIL\",\"password\":\"$PASSWORD\"}")

TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.token')
CSRF_TOKEN=$(echo $LOGIN_RESPONSE | jq -r '.csrf_token')

echo "📚 Getting books..."
curl -s -X GET "$BASE_URL/api/books" \
  -H "Authorization: Bearer $TOKEN" \
  -H "X-XSRF-TOKEN: $CSRF_TOKEN" | jq '.'
```

## 🧪 Testing Your Setup

### **Quick Test Commands**
```bash
# 1. Health check
curl -X GET "https://your-worker.your-subdomain.workers.dev/api/health"

# 2. Register user
curl -X POST "https://your-worker.your-subdomain.workers.dev/api/auth/register" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123","first_name":"Test","last_name":"User","user_type":"student"}'

# 3. Login
curl -X POST "https://your-worker.your-subdomain.workers.dev/api/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"test123"}'

# 4. Get books (replace YOUR_TOKEN)
curl -X GET "https://your-worker.your-subdomain.workers.dev/api/books" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### **Expected Results**
- ✅ **Health Check**: Returns system status
- ✅ **Registration**: Returns 201 with user data
- ✅ **Login**: Returns 200 with JWT token
- ✅ **Books**: Returns 200 with books list

## 🚨 Common Issues & Solutions

### **Issue: "Invalid credentials"**
**Solution:** Check email/password spelling, ensure user exists

### **Issue: "Authentication required"**
**Solution:** Include `Authorization: Bearer <token>` header

### **Issue: "CORS error"**
**Solution:** API supports CORS, check your client configuration

### **Issue: "Rate limit exceeded"**
**Solution:** Wait a moment and retry, implement exponential backoff

### **Issue: "Service unavailable"**
**Solution:** Check system status, wait for maintenance to complete

## 📚 Next Steps

### **1. Explore the API**
- Check [Complete Endpoints List](./endpoints.md)
- Review [Detailed Examples](./detailed-endpoints.md)
- Test with [API Testing Collection](./api-testing-collection.md)

### **2. Understand Authentication**
- Read [Token Requirements](./token-requirements.md)
- Use [Token Quick Reference](./token-quick-reference.md)
- Learn about [Session Management](../development/session-management.md)

### **3. Build Your Application**
- Follow [API Patterns](./api-patterns.md)
- Use [Error Codes Reference](./error-codes-reference.md)
- Implement proper error handling

### **4. Advanced Features**
- Set up [Continuous Integration Testing](./api-testing-collection.md#continuous-integration-testing)
- Monitor [API Performance](./api-testing-collection.md#performance-benchmarks)
- Implement [Rate Limiting Strategies](./error-codes-reference.md#rate-limiting-errors)

## 🎯 Success Checklist

- [ ] API health check returns "ok"
- [ ] User registration successful
- [ ] User login returns JWT token
- [ ] Authenticated API call works
- [ ] Error handling implemented
- [ ] Environment variables configured
- [ ] Client library working

## 📞 Need Help?

### **Documentation**
- **[API README](./index.md)** - Main documentation index
- **[Error Codes](./error-codes-reference.md)** - Troubleshooting guide
- **[Testing Collection](./api-testing-collection.md)** - Test examples

### **Support**
- Check [Error Codes Reference](./error-codes-reference.md) for common issues
- Review [API Testing Collection](./api-testing-collection.md) for examples
- Use [cURL examples](./api-testing-collection.md#cURL-examples) for testing

---

**⏱️ Time to Complete:** 5 minutes  
**🎯 Difficulty:** Beginner  
**📚 Prerequisites:** Basic HTTP knowledge  
**Last Updated:** November 2025  
**Version:** 1.0.0  
**Status:** ✅ Complete

