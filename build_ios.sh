#!/bin/bash

# سكريبت بناء ورفع تطبيق iOS إلى App Store
# Build and Upload iOS App to App Store

echo "🍎 بدء عملية بناء تطبيق iOS..."
echo "🍎 Starting iOS app build process..."
echo ""

# الألوان للرسائل
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# التحقق من وجود Flutter
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter غير مثبت. الرجاء تثبيت Flutter أولاً.${NC}"
    echo -e "${RED}❌ Flutter is not installed. Please install Flutter first.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Flutter مثبت${NC}"
echo ""

# الخطوة 1: تنظيف المشروع
echo -e "${YELLOW}📦 الخطوة 1: تنظيف المشروع...${NC}"
echo -e "${YELLOW}📦 Step 1: Cleaning project...${NC}"
flutter clean

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ تم التنظيف بنجاح${NC}"
else
    echo -e "${RED}❌ فشل التنظيف${NC}"
    exit 1
fi
echo ""

# الخطوة 2: تحديث Dependencies
echo -e "${YELLOW}📦 الخطوة 2: تحديث Dependencies...${NC}"
echo -e "${YELLOW}📦 Step 2: Updating dependencies...${NC}"
flutter pub get

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ تم التحديث بنجاح${NC}"
else
    echo -e "${RED}❌ فشل التحديث${NC}"
    exit 1
fi
echo ""

# الخطوة 3: تحديث iOS Pods
echo -e "${YELLOW}📦 الخطوة 3: تحديث iOS Pods...${NC}"
echo -e "${YELLOW}📦 Step 3: Updating iOS Pods...${NC}"
cd ios
rm -rf Pods
rm -f Podfile.lock
pod install

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ تم تحديث Pods بنجاح${NC}"
    cd ..
else
    echo -e "${RED}❌ فشل تحديث Pods${NC}"
    cd ..
    exit 1
fi
echo ""

# الخطوة 4: فحص المشروع
echo -e "${YELLOW}🔍 الخطوة 4: فحص المشروع...${NC}"
echo -e "${YELLOW}🔍 Step 4: Analyzing project...${NC}"
flutter analyze

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ لا توجد مشاكل${NC}"
else
    echo -e "${YELLOW}⚠️  توجد تحذيرات (يمكن المتابعة)${NC}"
fi
echo ""

# الخطوة 5: اختبار البناء
echo -e "${YELLOW}🔨 الخطوة 5: اختبار البناء...${NC}"
echo -e "${YELLOW}🔨 Step 5: Testing build...${NC}"
flutter build ios --release --no-codesign

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ البناء التجريبي نجح${NC}"
else
    echo -e "${RED}❌ فشل البناء التجريبي${NC}"
    exit 1
fi
echo ""

# الخطوة 6: بناء IPA
echo -e "${YELLOW}📱 الخطوة 6: بناء IPA للإصدار...${NC}"
echo -e "${YELLOW}📱 Step 6: Building IPA for release...${NC}"
echo -e "${YELLOW}⚠️  هذه الخطوة تحتاج Apple Developer Account${NC}"
echo ""

read -p "هل تريد المتابعة لبناء IPA؟ (y/n): " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    flutter build ipa --release
    
    if [ $? -eq 0 ]; then
        echo ""
        echo -e "${GREEN}✅ تم بناء IPA بنجاح!${NC}"
        echo -e "${GREEN}✅ IPA built successfully!${NC}"
        echo ""
        echo -e "${GREEN}📍 الملف موجود في:${NC}"
        echo -e "${GREEN}📍 File location:${NC}"
        echo "   build/ios/ipa/baghdan_sports.ipa"
        echo ""
        echo -e "${YELLOW}📤 الخطوات التالية:${NC}"
        echo -e "${YELLOW}📤 Next steps:${NC}"
        echo "   1. افتح Xcode"
        echo "   2. Window → Organizer"
        echo "   3. اختر Archive"
        echo "   4. Distribute App → App Store Connect"
        echo ""
    else
        echo -e "${RED}❌ فشل بناء IPA${NC}"
        echo ""
        echo -e "${YELLOW}💡 نصائح:${NC}"
        echo "   1. تأكد من تسجيل الدخول في Xcode"
        echo "   2. تأكد من وجود Apple Developer Account"
        echo "   3. تأكد من تكوين Signing & Capabilities"
        echo ""
        exit 1
    fi
else
    echo ""
    echo -e "${YELLOW}⏸️  تم إيقاف بناء IPA${NC}"
    echo -e "${YELLOW}⏸️  يمكنك بناء IPA لاحقاً بالأمر:${NC}"
    echo "   flutter build ipa --release"
    echo ""
fi

# الخطوة 7: معلومات إضافية
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✅ اكتملت عملية البناء!${NC}"
echo -e "${GREEN}✅ Build process completed!${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "${YELLOW}📋 معلومات التطبيق:${NC}"
echo "   الاسم: بطولة كأس بعدان 18"
echo "   Bundle ID: com.baghdansports.app"
echo "   Version: 1.0.0"
echo "   Build: 1"
echo ""
echo -e "${YELLOW}📚 للمزيد من المعلومات:${NC}"
echo "   اقرأ ملف: IOS_APP_STORE_COMPLETE_GUIDE.md"
echo ""
echo -e "${GREEN}🎉 حظاً موفقاً!${NC}"
echo ""
