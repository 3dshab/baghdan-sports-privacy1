# كيفية إنشاء GitHub Personal Access Token

## الخطوات:

### 1. افتح هذا الرابط:
https://github.com/settings/tokens/new

### 2. املأ المعلومات:
- **Note:** `Baghdan Sports Privacy Policy`
- **Expiration:** 90 days
- **Select scopes:** ✅ ضع علامة على `repo` فقط

### 3. اضغط "Generate token" في الأسفل

### 4. انسخ الـ Token
سيظهر شيء مثل:
```
ghp_xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

⚠️ **مهم:** انسخه الآن! لن تراه مرة أخرى!

### 5. استخدمه بدلاً من كلمة المرور
عند تنفيذ `git push`:
- Username: `3dshab`
- Password: الصق الـ Token هنا (وليس كلمة المرور!)

---

## بعد الحصول على الـ Token:

نفذ:
```bash
cd /Users/ebrahimshahbain/Desktop/baghdan_sports
git push -u origin main
```

ثم الصق الـ Token عند طلب Password.
