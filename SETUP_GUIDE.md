# دليل الإعداد والاستخدام - تطبيق بطولة كأس بعدان 18 للمستخدمين

## نظرة عامة

تم إنشاء تطبيق **baghdan_sports** كنسخة للمستخدمين من تطبيق **baghdan_admin**. هذا التطبيق يسمح للمستخدمين العاديين بمتابعة المباريات والنتائج دون القدرة على التعديل.

## الميزات الرئيسية

### ✅ ما تم إضافته

1. **نظام تسجيل المستخدمين المحسّن**
   - عند التسجيل، يتم إنشاء ملف مستخدم تلقائياً في Firebase Firestore
   - المسار: `users/{userId}`
   - البيانات المحفوظة:
     ```json
     {
       "email": "user@example.com",
       "displayName": "اسم المستخدم",
       "createdAt": "timestamp",
       "role": "user",
       "isActive": true
     }
     ```

2. **واجهة مستخدم مبسطة**
   - شاشة رئيسية بسيطة مع تبويبين: المباريات والهدافين
   - إزالة جميع أدوات الإدارة
   - تصميم نظيف وسهل الاستخدام

3. **صلاحيات القراءة فقط**
   - المستخدمون يمكنهم فقط مشاهدة البيانات
   - لا يمكنهم إضافة أو تعديل أو حذف أي بيانات

### ❌ ما تم إزالته

- شاشة لوحة التحكم الإدارية
- إدارة المباريات (إضافة، تعديل، حذف)
- إدارة الفرق
- إدارة الهدافين
- رفع الفيديوهات
- مزامنة البيانات
- الإعدادات الإدارية
- جميع أدوات التعديل

## قواعد Firestore المطلوبة

لضمان عمل التطبيق بشكل صحيح، يجب تحديث قواعد Firestore:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // قواعد مجموعة المستخدمين
    match /users/{userId} {
      // السماح للمستخدم بقراءة وكتابة بياناته الخاصة فقط
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
      
      // السماح للمسؤولين بقراءة جميع المستخدمين
      allow read: if request.auth != null && 
                     get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // قواعد المباريات - قراءة فقط للجميع
    match /match_summaries/{matchId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // قواعد الهدافين - قراءة فقط للجميع
    match /scorers/{scorerId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // قواعد المجموعات - قراءة فقط للجميع
    match /groups/{groupId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
    
    // قواعد الفرق - قراءة فقط للجميع
    match /teams/{teamId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
                      get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
    }
  }
}
```

## خطوات التشغيل

### 1. تثبيت المكتبات
```bash
cd /Users/ebrahimshahbain/Desktop/baghdan_sports
flutter pub get
```

### 2. التأكد من إعدادات Firebase
- التطبيق يستخدم نفس إعدادات Firebase من `firebase_options.dart`
- تأكد من أن Firebase مُعد بشكل صحيح

### 3. تشغيل التطبيق
```bash
flutter run
```

## الفروقات بين التطبيقين

| الميزة | baghdan_admin | baghdan_sports |
|--------|---------------|----------------|
| تسجيل الدخول | ✅ | ✅ |
| التسجيل | ✅ | ✅ |
| عرض المباريات | ✅ | ✅ |
| عرض الهدافين | ✅ | ✅ |
| تفاصيل المباراة | ✅ | ✅ |
| مشاهدة الفيديوهات | ✅ | ✅ |
| إضافة مباريات | ✅ | ❌ |
| تعديل مباريات | ✅ | ❌ |
| حذف مباريات | ✅ | ❌ |
| إدارة الهدافين | ✅ | ❌ |
| إدارة الفرق | ✅ | ❌ |
| رفع فيديوهات | ✅ | ❌ |
| لوحة التحكم | ✅ | ❌ |
| الإعدادات الإدارية | ✅ | ❌ |
| إنشاء ملف مستخدم | ❌ | ✅ |

## بنية قاعدة البيانات

### مجموعة users (جديدة)
```
users/
  └── {userId}/
      ├── email: string
      ├── displayName: string
      ├── createdAt: timestamp
      ├── role: string ("user" أو "admin")
      ├── isActive: boolean
      └── updatedAt: timestamp (اختياري)
```

### المجموعات الموجودة (للقراءة فقط)
- `match_summaries/` - ملخصات المباريات
- `scorers/` - الهدافين
- `groups/` - المجموعات
- `teams/` - الفرق

## ملاحظات مهمة

1. **الأمان**: جميع المستخدمين الجدد يحصلون على دور `user` افتراضياً
2. **الصلاحيات**: المستخدمون العاديون لديهم صلاحيات قراءة فقط
3. **قاعدة البيانات**: التطبيقان يستخدمان نفس قاعدة بيانات Firebase
4. **المصادقة**: نظام المصادقة منفصل - كل تطبيق له مستخدموه الخاصون
5. **التحديثات**: التحديثات في تطبيق الإدارة تظهر فوراً في تطبيق المستخدمين

## استكشاف الأخطاء

### مشكلة: لا يمكن قراءة البيانات
- تأكد من تحديث قواعد Firestore
- تأكد من تسجيل الدخول بنجاح

### مشكلة: خطأ في إنشاء ملف المستخدم
- تأكد من صلاحيات الكتابة في مجموعة `users`
- تحقق من اتصال الإنترنت

### مشكلة: الفيديوهات لا تعمل
- تأكد من صلاحيات Firebase Storage
- تحقق من رفع الفيديوهات في تطبيق الإدارة

## الدعم والتطوير

للمزيد من المعلومات أو الإبلاغ عن مشاكل، يرجى التواصل مع فريق التطوير.
