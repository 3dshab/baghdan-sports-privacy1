# دليل رفع سياسة الخصوصية على GitHub

## الطريقة الأولى: استخدام GitHub Pages (الأسهل والأفضل) ⭐

### الخطوات:

#### 1️⃣ إنشاء Repository جديد

1. اذهب إلى: https://github.com
2. سجل الدخول
3. اضغط على **"+"** في الأعلى → **"New repository"**
4. املأ المعلومات:
   ```
   Repository name: baghdan-sports-privacy
   Description: Privacy Policy for Baghdan Sports App
   ✅ Public (مهم!)
   ✅ Add a README file
   ```
5. اضغط **"Create repository"**

#### 2️⃣ رفع ملف سياسة الخصوصية

**الطريقة الأولى: من الموقع مباشرة (الأسهل)**

1. في صفحة الـ Repository، اضغط **"Add file"** → **"Upload files"**
2. اسحب ملف `PRIVACY_POLICY.md` إلى الصفحة
3. أو اضغط **"choose your files"** واختر الملف
4. في الأسفل، اكتب:
   ```
   Commit message: Add privacy policy
   ```
5. اضغط **"Commit changes"**

**الطريقة الثانية: إنشاء ملف جديد**

1. اضغط **"Add file"** → **"Create new file"**
2. اسم الملف: `privacy-policy.md`
3. انسخ محتوى ملف `PRIVACY_POLICY.md` والصقه
4. اضغط **"Commit changes"**

#### 3️⃣ تفعيل GitHub Pages

1. في الـ Repository، اضغط **"Settings"** (الإعدادات)
2. من القائمة الجانبية، اضغط **"Pages"**
3. في قسم **"Source"**:
   - اختر: **"Deploy from a branch"**
   - Branch: **"main"** (أو master)
   - Folder: **"/ (root)"**
4. اضغط **"Save"**
5. انتظر دقيقة واحدة

#### 4️⃣ الحصول على الرابط

بعد التفعيل، سيظهر رابط مثل:
```
https://yourusername.github.io/baghdan-sports-privacy/privacy-policy
```

أو:
```
https://yourusername.github.io/baghdan-sports-privacy/PRIVACY_POLICY
```

**هذا هو الرابط الذي ستضعه في App Store Connect!** ✅

---

## الطريقة الثانية: استخدام Terminal (للمطورين)

### الخطوات:

#### 1️⃣ إنشاء Repository على GitHub

1. اذهب إلى: https://github.com/new
2. أنشئ repository جديد (نفس الخطوات أعلاه)
3. **لا تضف** README أو .gitignore

#### 2️⃣ رفع الملف من Terminal

```bash
# 1. انتقل إلى مجلد التطبيق
cd /Users/ebrahimshahbain/Desktop/baghdan_sports

# 2. إنشاء مجلد جديد لسياسة الخصوصية
mkdir privacy-policy-repo
cd privacy-policy-repo

# 3. نسخ ملف سياسة الخصوصية
cp ../PRIVACY_POLICY.md ./privacy-policy.md

# 4. تهيئة Git
git init

# 5. إضافة الملف
git add privacy-policy.md

# 6. عمل Commit
git commit -m "Add privacy policy"

# 7. ربط بـ GitHub (استبدل USERNAME باسم المستخدم)
git remote add origin https://github.com/USERNAME/baghdan-sports-privacy.git

# 8. رفع الملفات
git branch -M main
git push -u origin main
```

#### 3️⃣ تفعيل GitHub Pages

نفس الخطوات في الطريقة الأولى (Settings → Pages)

---

## الطريقة الثالثة: استخدام Gist (سريعة)

### الخطوات:

1. اذهب إلى: https://gist.github.com
2. املأ المعلومات:
   ```
   Gist description: Baghdan Sports Privacy Policy
   Filename: privacy-policy.md
   ```
3. انسخ محتوى `PRIVACY_POLICY.md` والصقه
4. اختر **"Create public gist"**
5. اضغط **"Raw"** في الأعلى
6. انسخ الرابط

**مثال على الرابط:**
```
https://gist.githubusercontent.com/USERNAME/abc123.../raw/.../privacy-policy.md
```

⚠️ **ملاحظة:** Gist أسرع لكن GitHub Pages أفضل وأكثر احترافية

---

## تنسيق الملف لـ GitHub Pages

### إنشاء صفحة HTML جميلة (اختياري)

إذا أردت صفحة أجمل، أنشئ ملف `index.html`:

```html
<!DOCTYPE html>
<html lang="ar" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>سياسة الخصوصية - بعدان سبورت</title>
    <style>
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Arial, sans-serif;
            line-height: 1.6;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            background: #f5f5f5;
        }
        .container {
            background: white;
            padding: 40px;
            border-radius: 10px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #1BA098;
            border-bottom: 3px solid #00ff88;
            padding-bottom: 10px;
        }
        h2 {
            color: #0a4d68;
            margin-top: 30px;
        }
        .last-updated {
            color: #666;
            font-size: 14px;
            margin-bottom: 30px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- انسخ محتوى PRIVACY_POLICY.md هنا -->
        <h1>سياسة الخصوصية</h1>
        <p class="last-updated">آخر تحديث: نوفمبر 2024</p>
        
        <!-- باقي المحتوى... -->
        
    </div>
</body>
</html>
```

---

## التحقق من الرابط

بعد الرفع، تأكد من:

✅ الرابط يعمل ويفتح الصفحة
✅ المحتوى يظهر بشكل صحيح
✅ الصفحة باللغة العربية
✅ لا توجد أخطاء

---

## استخدام الرابط في App Store Connect

### الخطوات:

1. اذهب إلى: https://appstoreconnect.apple.com
2. My Apps → اختر التطبيق
3. App Information
4. في حقل **"Privacy Policy URL"**:
   ```
   https://yourusername.github.io/baghdan-sports-privacy/privacy-policy
   ```
5. احفظ التغييرات

---

## نصائح مهمة

### ✅ افعل:
1. استخدم GitHub Pages (الأفضل)
2. تأكد من أن الـ Repository عام (Public)
3. اختبر الرابط قبل وضعه في App Store
4. احتفظ بنسخة من الرابط

### ❌ لا تفعل:
1. لا تجعل الـ Repository خاص (Private)
2. لا تحذف الـ Repository بعد رفع التطبيق
3. لا تغير الرابط بعد الموافقة على التطبيق

---

## مثال كامل

### البيانات:
```
GitHub Username: ebrahimshahbain
Repository Name: baghdan-sports-privacy
File Name: privacy-policy.md
```

### الرابط النهائي:
```
https://ebrahimshahbain.github.io/baghdan-sports-privacy/privacy-policy
```

---

## استكشاف الأخطاء

### المشكلة: الصفحة لا تظهر (404)

**الحلول:**
1. تأكد من تفعيل GitHub Pages في Settings
2. انتظر 2-3 دقائق بعد التفعيل
3. تأكد من اسم الملف صحيح
4. تأكد من أن الـ Repository عام

### المشكلة: الصفحة تظهر بدون تنسيق

**الحلول:**
1. استخدم ملف `.md` (Markdown)
2. أو أنشئ ملف `index.html`
3. تأكد من الترميز UTF-8

### المشكلة: النص بالعربية معكوس

**الحلول:**
1. أضف في بداية HTML:
   ```html
   <html lang="ar" dir="rtl">
   ```

---

## الخلاصة

### الطريقة الموصى بها:

1. ✅ أنشئ Repository على GitHub
2. ✅ ارفع ملف `PRIVACY_POLICY.md`
3. ✅ فعّل GitHub Pages
4. ✅ احصل على الرابط
5. ✅ ضعه في App Store Connect

**الوقت المتوقع:** 5-10 دقائق

---

## روابط مفيدة

- GitHub: https://github.com
- GitHub Pages Guide: https://pages.github.com
- Markdown Guide: https://guides.github.com/features/mastering-markdown

---

**حظاً موفقاً! 🚀**

إذا واجهت أي مشكلة، راجع قسم "استكشاف الأخطاء" أعلاه.
