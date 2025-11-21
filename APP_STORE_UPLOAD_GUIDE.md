# 📱 دليل رفع تطبيق Baghdan Sports على App Store

## ✅ المتطلبات الأساسية

قبل البدء، تأكد من:
- ✅ حساب Apple Developer (99$/سنة)
- ✅ Xcode مثبت على جهازك
- ✅ شهادة التوقيع (Certificates)
- ✅ Provisioning Profile

---

## 📋 الخطوة 1: إعداد المشروع

### 1.1 تحديث معلومات التطبيق

افتح ملف `ios/Runner/Info.plist` وتأكد من:

```xml
<key>CFBundleDisplayName</key>
<string>بعدان سبورت</string>

<key>CFBundleIdentifier</key>
<string>com.baghdansports.app</string>

<key>CFBundleVersion</key>
<string>1</string>

<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
```

### 1.2 إضافة الأيقونة (App Icon)

1. افتح Xcode
2. اذهب إلى `ios/Runner.xcworkspace`
3. اختر `Runner` → `Assets.xcassets` → `AppIcon`
4. أضف الأيقونات بجميع الأحجام المطلوبة

**الأحجام المطلوبة:**
- 20x20 (2x, 3x)
- 29x29 (2x, 3x)
- 40x40 (2x, 3x)
- 60x60 (2x, 3x)
- 1024x1024 (App Store)

---

## 🔧 الخطوة 2: إعداد Xcode

### 2.1 فتح المشروع

```bash
cd /Users/ebrahimshahbain/Desktop/baghdan_sports
open ios/Runner.xcworkspace
```

⚠️ **مهم:** افتح `.xcworkspace` وليس `.xcodeproj`

### 2.2 إعداد Signing & Capabilities

1. في Xcode، اختر **Runner** من القائمة اليسرى
2. اذهب إلى تبويب **Signing & Capabilities**
3. اختر **Team** (حساب Apple Developer الخاص بك)
4. تأكد من:
   - ✅ Automatically manage signing
   - ✅ Bundle Identifier صحيح

### 2.3 تحديد الـ Deployment Target

- اذهب إلى **General** tab
- **Deployment Info** → **iOS Deployment Target**: 12.0 أو أعلى

---

## 🏗️ الخطوة 3: بناء التطبيق (Build)

### 3.1 تنظيف المشروع

```bash
cd /Users/ebrahimshahbain/Desktop/baghdan_sports
flutter clean
flutter pub get
cd ios
pod install
cd ..
```

### 3.2 بناء التطبيق للإصدار

```bash
flutter build ios --release
```

### 3.3 في Xcode

1. اختر **Product** → **Scheme** → **Runner**
2. اختر **Any iOS Device (arm64)** كـ Destination
3. اختر **Product** → **Archive**
4. انتظر حتى يكتمل البناء

---

## 📤 الخطوة 4: رفع التطبيق

### 4.1 بعد اكتمال الـ Archive

1. سيفتح **Organizer** تلقائياً
2. اختر الـ Archive الذي تم إنشاؤه
3. اضغط **Distribute App**

### 4.2 اختر طريقة التوزيع

1. اختر **App Store Connect**
2. اضغط **Next**

### 4.3 خيارات التوزيع

1. اختر **Upload**
2. اضغط **Next**

### 4.4 خيارات App Store Connect

- ✅ Include bitcode for iOS content
- ✅ Upload your app's symbols
- اضغط **Next**

### 4.5 إعادة التوقيع

- اختر **Automatically manage signing**
- اضغط **Next**

### 4.6 المراجعة والرفع

1. راجع المعلومات
2. اضغط **Upload**
3. انتظر حتى يكتمل الرفع (قد يستغرق 5-15 دقيقة)

---

## 🌐 الخطوة 5: إعداد App Store Connect

### 5.1 إنشاء التطبيق

1. اذهب إلى: https://appstoreconnect.apple.com
2. اضغط **My Apps** → **+** → **New App**
3. املأ المعلومات:
   - **Platform:** iOS
   - **Name:** بعدان سبورت
   - **Primary Language:** Arabic
   - **Bundle ID:** اختر الـ Bundle ID الخاص بك
   - **SKU:** baghdan-sports-001
   - **User Access:** Full Access

### 5.2 معلومات التطبيق (App Information)

اذهب إلى **App Information** وأضف:

**Privacy Policy URL:**
```
https://github.com/3dshab/baghdan-sports-privacy1/blob/main/PRIVACY_POLICY.md
```

**Category:**
- Primary: Sports
- Secondary: News

**Content Rights:**
- ✅ Contains third-party content

### 5.3 التسعير والتوفر (Pricing and Availability)

1. اذهب إلى **Pricing and Availability**
2. **Price:** Free (مجاني)
3. **Availability:** جميع الدول أو حدد دول معينة

### 5.4 معلومات النسخة (Version Information)

اذهب إلى **1.0 Prepare for Submission**

#### Screenshots (لقطات الشاشة)

**مطلوب:**
- iPhone 6.7" Display (iPhone 15 Pro Max)
  - 3-10 صور بحجم 1290 x 2796 pixels
- iPhone 6.5" Display (iPhone 11 Pro Max)
  - 3-10 صور بحجم 1242 x 2688 pixels

**اختياري:**
- iPad Pro (6th Gen) 12.9"
  - 3-10 صور بحجم 2048 x 2732 pixels

#### App Preview (فيديو - اختياري)

- فيديو توضيحي للتطبيق (15-30 ثانية)

#### Promotional Text (نص ترويجي)

```
تابع بطولة كأس بعدان 18 مباشرة! نتائج حية، أهداف، إحصائيات، وقنوات مباشرة.
```

#### Description (الوصف)

```
تطبيق بطولة كأس بعدان 18 - التطبيق الرسمي

🏆 تابع البطولة لحظة بلحظة

⚽ المميزات:
• نتائج المباريات المباشرة
• جدول المباريات والمجموعات
• أهداف وملخصات الفيديو
• إحصائيات اللاعبين والفرق
• قنوات البث المباشر
• ترتيب الهدافين
• أخبار البطولة

📺 قنوات مباشرة
شاهد المباريات مباشرة من داخل التطبيق

📊 إحصائيات شاملة
تابع أداء فريقك المفضل واللاعبين

🎯 واجهة عربية سهلة
تصميم عصري وسهل الاستخدام

حمّل التطبيق الآن وكن جزءاً من بطولة كأس بعدان 18!
```

#### Keywords (الكلمات المفتاحية)

```
كرة قدم,بطولة,كأس,بعدان,مباريات,نتائج,أهداف,بث مباشر
```

#### Support URL

```
https://github.com/3dshab/baghdan-sports-privacy1
```

#### Marketing URL (اختياري)

```
https://github.com/3dshab/baghdan-sports-privacy1
```

### 5.5 معلومات البناء (Build)

1. في قسم **Build**
2. اضغط **+** أو **Select a build before you submit your app**
3. اختر الـ Build الذي رفعته
4. اضغط **Done**

⚠️ **ملاحظة:** قد يستغرق ظهور الـ Build 15-30 دقيقة بعد الرفع

### 5.6 App Review Information

**Contact Information:**
- First Name: ابراهيم
- Last Name: شهبين
- Phone: +967XXXXXXXXX
- Email: mohammedshahbain16@gmail.com

**Demo Account (إذا كان التطبيق يحتاج تسجيل دخول):**
- Username: demo@test.com
- Password: Demo123!
- Notes: حساب تجريبي للمراجعة

**Notes:**
```
تطبيق بطولة كأس بعدان 18 الرسمي
يعرض نتائج المباريات والإحصائيات والقنوات المباشرة
```

### 5.7 Version Release

اختر:
- **Automatically release this version** (رفع تلقائي بعد الموافقة)
- أو **Manually release this version** (رفع يدوي)

### 5.8 Age Rating (التصنيف العمري)

1. اضغط **Edit** بجانب Age Rating
2. أجب على الأسئلة:
   - Violence: None
   - Sexual Content: None
   - Profanity: None
   - Gambling: None
   - etc.
3. النتيجة المتوقعة: **4+**

---

## 🔒 الخطوة 6: App Privacy (خصوصية التطبيق)

### 6.1 اذهب إلى App Privacy

1. في القائمة الجانبية، اختر **App Privacy**
2. اضغط **Get Started**

### 6.2 Data Collection

**هل تجمع بيانات من هذا التطبيق؟**
- ✅ Yes

### 6.3 Data Types

اختر أنواع البيانات التي تجمعها:

**Contact Info:**
- ✅ Email Address

**Identifiers:**
- ✅ User ID

**Usage Data:**
- ✅ Product Interaction

### 6.4 لكل نوع بيانات:

**Email Address:**
- Used for: App Functionality, Analytics
- Linked to User: Yes”’|
- Used for Tracking: No

**User ID:**
- Used for: App Functionality
- Linked to User: Yes
- Used for Tracking: No

**Product Interaction:**
- Used for: Analytics, App Functionality
- Linked to User: No
- Used for Tracking: No

### 6.5 Privacy Policy

أضف رابط سياسة الخصوصية:
```
https://github.com/3dshab/baghdan-sports-privacy1/blob/main/PRIVACY_POLICY.md
```

---

## ✅ الخطوة 7: إرسال للمراجعة

### 7.1 التحقق النهائي

تأكد من:
- ✅ Screenshots مضافة
- ✅ Description مكتوب
- ✅ Keywords مضافة
- ✅ Build محدد
- ✅ Privacy Policy مضاف
- ✅ App Privacy مكتمل
- ✅ Contact Information صحيح

### 7.2 الإرسال

1. اضغط **Save** في الأعلى
2. اضغط **Submit for Review**
3. أجب على الأسئلة الإضافية إن وجدت
4. اضغط **Submit**

---

## ⏱️ الخطوة 8: انتظار المراجعة

### مدة المراجعة:
- عادة: 24-48 ساعة
- قد تصل إلى: 5-7 أيام

### الحالات المحتملة:

**✅ Approved (تمت الموافقة):**
- سيتم نشر التطبيق تلقائياً أو يدوياً حسب اختيارك

**❌ Rejected (مرفوض):**
- ستصلك رسالة توضح السبب
- قم بالتعديلات المطلوبة
- أعد الإرسال

**⚠️ Metadata Rejected:**
- مشكلة في الوصف أو الصور
- عدّل المعلومات وأعد الإرسال

---

## 🚨 مشاكل شائعة وحلولها

### 1. Build لا يظهر في App Store Connect

**الحل:**
- انتظر 15-30 دقيقة
- تحقق من البريد الإلكتروني (قد تكون هناك مشكلة)
- تأكد من رفع الـ Build بنجاح من Xcode Organizer

### 2. Invalid Bundle

**الحل:**
- تأكد من Bundle ID صحيح
- تأكد من Version و Build Number
- نظف المشروع وأعد البناء

### 3. Missing Compliance

**الحل:**
- في App Store Connect، اذهب إلى Build
- أجب على أسئلة Export Compliance
- عادة: No للتطبيقات البسيطة

### 4. Missing Screenshots

**الحل:**
- أضف لقطات شاشة بالأحجام المطلوبة
- استخدم Simulator لأخذ Screenshots
- أو استخدم أدوات مثل: https://www.appscreenshots.io

---

## 📸 كيفية أخذ Screenshots

### في Simulator:

```bash
# افتح Simulator
open -a Simulator

# اختر iPhone 15 Pro Max
# شغل التطبيق
flutter run

# في Simulator:
# Cmd + S لأخذ Screenshot
```

### الأحجام المطلوبة:

1. **iPhone 6.7"** (iPhone 15 Pro Max)
   - 1290 x 2796 pixels

2. **iPhone 6.5"** (iPhone 11 Pro Max)
   - 1242 x 2688 pixels

---

## 🎯 نصائح للموافقة السريعة

1. ✅ **وصف واضح ودقيق**
2. ✅ **Screenshots عالية الجودة**
3. ✅ **Privacy Policy واضحة**
4. ✅ **معلومات الاتصال صحيحة**
5. ✅ **التطبيق يعمل بدون أخطاء**
6. ✅ **لا يوجد محتوى مخالف**
7. ✅ **الأذونات المطلوبة واضحة**

---

## 📞 المساعدة

إذا واجهت مشاكل:
- Apple Developer Support: https://developer.apple.com/support/
- App Store Connect Help: https://help.apple.com/app-store-connect/

---

## ✅ Checklist النهائي

قبل الإرسال، تحقق من:

- [ ] التطبيق يعمل بدون أخطاء
- [ ] الأيقونة مضافة بجميع الأحجام
- [ ] Screenshots مضافة (6.7" و 6.5")
- [ ] الوصف مكتوب بالعربية والإنجليزية
- [ ] الكلمات المفتاحية مضافة
- [ ] Privacy Policy URL مضاف
- [ ] App Privacy مكتمل
- [ ] Build محدد
- [ ] معلومات الاتصال صحيحة
- [ ] Age Rating محدد
- [ ] التسعير محدد (Free)
- [ ] الدول المتاحة محددة

---

**بالتوفيق! 🚀**

آخر تحديث: نوفمبر 2024
