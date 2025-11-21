#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# سكريبت بناء التطبيق للـ App Store
# ═══════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════════"
echo "🏗️  بناء تطبيق Baghdan Sports للـ App Store"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# الانتقال إلى مجلد المشروع
cd /Users/ebrahimshahbain/Desktop/baghdan_sports

echo "📁 المجلد الحالي: $(pwd)"
echo ""

# التحقق من Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter غير مثبت"
    exit 1
fi

echo "✅ Flutter مثبت: $(flutter --version | head -n 1)"
echo ""

# تنظيف المشروع
echo "🧹 تنظيف المشروع..."
flutter clean
echo "✅ تم التنظيف"
echo ""

# تحديث الحزم
echo "📦 تحديث الحزم..."
flutter pub get
echo "✅ تم تحديث الحزم"
echo ""

# تثبيت Pods
echo "🍎 تثبيت iOS Pods..."
cd ios
pod install
cd ..
echo "✅ تم تثبيت Pods"
echo ""

# بناء التطبيق
echo "🔨 بناء التطبيق للإصدار..."
echo "⏳ هذا قد يستغرق عدة دقائق..."
echo ""

flutter build ios --release

if [ $? -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "✅ تم بناء التطبيق بنجاح!"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "📋 الخطوات التالية:"
    echo ""
    echo "1️⃣ افتح Xcode:"
    echo "   open ios/Runner.xcworkspace"
    echo ""
    echo "2️⃣ في Xcode:"
    echo "   - اختر Product → Archive"
    echo "   - انتظر حتى يكتمل الـ Archive"
    echo ""
    echo "3️⃣ في Organizer:"
    echo "   - اختر الـ Archive"
    echo "   - اضغط Distribute App"
    echo "   - اختر App Store Connect"
    echo "   - اتبع الخطوات"
    echo ""
    echo "4️⃣ راجع الدليل الكامل:"
    echo "   APP_STORE_UPLOAD_GUIDE.md"
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "🚀 هل تريد فتح Xcode الآن؟ (y/n)"
    read -p "الإجابة: " answer
    
    if [ "$answer" = "y" ] || [ "$answer" = "Y" ]; then
        echo "📱 فتح Xcode..."
        open ios/Runner.xcworkspace
    fi
else
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "❌ فشل بناء التطبيق"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "الحلول الممكنة:"
    echo ""
    echo "1️⃣ تحقق من الأخطاء أعلاه"
    echo "2️⃣ تأكد من تثبيت Xcode"
    echo "3️⃣ تأكد من تثبيت CocoaPods"
    echo "4️⃣ جرب:"
    echo "   cd ios"
    echo "   pod deintegrate"
    echo "   pod install"
    echo "   cd .."
    echo "   flutter clean"
    echo "   flutter build ios --release"
    echo ""
fi

echo ""
