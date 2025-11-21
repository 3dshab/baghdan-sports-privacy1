#!/bin/bash

# ═══════════════════════════════════════════════════════════════
# سكريبت رفع سياسة الخصوصية إلى GitHub
# ═══════════════════════════════════════════════════════════════

echo "═══════════════════════════════════════════════════════════════"
echo "🚀 رفع سياسة الخصوصية إلى GitHub"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# التحقق من وجود Git
if ! command -v git &> /dev/null; then
    echo "❌ Git غير مثبت. يرجى تثبيت Git أولاً:"
    echo "   brew install git"
    exit 1
fi

echo "✅ Git مثبت"
echo ""

# طلب اسم المستخدم على GitHub
echo "📝 أدخل اسم المستخدم على GitHub:"
read -p "Username: " GITHUB_USERNAME

if [ -z "$GITHUB_USERNAME" ]; then
    echo "❌ يجب إدخال اسم المستخدم"
    exit 1
fi

echo ""
echo "📝 أدخل اسم الـ Repository (مثال: baghdan-sports-privacy):"
read -p "Repository Name: " REPO_NAME

if [ -z "$REPO_NAME" ]; then
    REPO_NAME="baghdan-sports-privacy"
    echo "✅ سيتم استخدام الاسم الافتراضي: $REPO_NAME"
fi

echo ""
echo "════════════════════════════════════════════════════════════════"
echo "📋 الخطوات التالية:"
echo "════════════════════════════════════════════════════════════════"
echo ""
echo "1️⃣ أنشئ Repository جديد على GitHub:"
echo "   🔗 https://github.com/new"
echo ""
echo "   Repository name: $REPO_NAME"
echo "   Description: Privacy Policy for Baghdan Sports App"
echo "   ✅ Public"
echo "   ❌ لا تضف README أو .gitignore"
echo ""
echo "2️⃣ بعد إنشاء الـ Repository، اضغط Enter للمتابعة..."
read -p ""

# إنشاء مجلد مؤقت
TEMP_DIR="$HOME/Desktop/privacy-policy-temp"
echo ""
echo "📁 إنشاء مجلد مؤقت..."

if [ -d "$TEMP_DIR" ]; then
    echo "⚠️  المجلد موجود مسبقاً. سيتم حذفه..."
    rm -rf "$TEMP_DIR"
fi

mkdir -p "$TEMP_DIR"
cd "$TEMP_DIR"

echo "✅ تم إنشاء المجلد: $TEMP_DIR"
echo ""

# نسخ ملف سياسة الخصوصية
echo "📄 نسخ ملف سياسة الخصوصية..."
SOURCE_FILE="/Users/ebrahimshahbain/Desktop/baghdan_sports/PRIVACY_POLICY.md"

if [ ! -f "$SOURCE_FILE" ]; then
    echo "❌ لم يتم العثور على ملف سياسة الخصوصية"
    exit 1
fi

cp "$SOURCE_FILE" "./privacy-policy.md"
echo "✅ تم نسخ الملف"
echo ""

# إنشاء ملف README
echo "📝 إنشاء ملف README..."
cat > README.md << 'EOF'
# سياسة الخصوصية - تطبيق بعدان سبورت

هذا الـ Repository يحتوي على سياسة الخصوصية لتطبيق بعدان سبورت.

## الرابط

يمكنك الوصول إلى سياسة الخصوصية عبر:
- [privacy-policy.md](privacy-policy.md)

## التطبيق

تطبيق بعدان سبورت هو التطبيق الرسمي لبطولة كأس بعدان 18.

## المطور

تطوير: ابراهيم شهبين

---

آخر تحديث: نوفمبر 2024
EOF

echo "✅ تم إنشاء README"
echo ""

# تهيئة Git
echo "🔧 تهيئة Git Repository..."
git init
git add .
git commit -m "Add privacy policy for Baghdan Sports App"
echo "✅ تم عمل Commit"
echo ""

# ربط بـ GitHub
echo "🔗 ربط بـ GitHub..."
REPO_URL="https://github.com/$GITHUB_USERNAME/$REPO_NAME.git"
git remote add origin "$REPO_URL"
echo "✅ تم الربط بـ: $REPO_URL"
echo ""

# رفع الملفات
echo "📤 رفع الملفات إلى GitHub..."
echo "⚠️  قد يطلب منك إدخال اسم المستخدم وكلمة المرور..."
echo ""

git branch -M main
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "✅ تم رفع الملفات بنجاح!"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "🎉 الخطوة التالية: تفعيل GitHub Pages"
    echo ""
    echo "1️⃣ اذهب إلى:"
    echo "   🔗 https://github.com/$GITHUB_USERNAME/$REPO_NAME/settings/pages"
    echo ""
    echo "2️⃣ في قسم 'Source':"
    echo "   - Branch: main"
    echo "   - Folder: / (root)"
    echo "   - اضغط Save"
    echo ""
    echo "3️⃣ انتظر 2-3 دقائق، ثم سيكون الرابط:"
    echo "   🔗 https://$GITHUB_USERNAME.github.io/$REPO_NAME/privacy-policy"
    echo ""
    echo "4️⃣ ضع هذا الرابط في App Store Connect!"
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    
    # حفظ الرابط في ملف
    LINK_FILE="/Users/ebrahimshahbain/Desktop/baghdan_sports/PRIVACY_POLICY_LINK.txt"
    echo "Privacy Policy URL:" > "$LINK_FILE"
    echo "https://$GITHUB_USERNAME.github.io/$REPO_NAME/privacy-policy" >> "$LINK_FILE"
    echo "" >> "$LINK_FILE"
    echo "GitHub Repository:" >> "$LINK_FILE"
    echo "https://github.com/$GITHUB_USERNAME/$REPO_NAME" >> "$LINK_FILE"
    
    echo "💾 تم حفظ الرابط في: PRIVACY_POLICY_LINK.txt"
    echo ""
else
    echo ""
    echo "════════════════════════════════════════════════════════════════"
    echo "❌ حدث خطأ أثناء الرفع"
    echo "════════════════════════════════════════════════════════════════"
    echo ""
    echo "الحلول الممكنة:"
    echo ""
    echo "1️⃣ تأكد من أنك أنشأت الـ Repository على GitHub"
    echo "2️⃣ تأكد من اسم المستخدم صحيح"
    echo "3️⃣ قد تحتاج إلى Personal Access Token بدلاً من كلمة المرور"
    echo ""
    echo "لإنشاء Token:"
    echo "   🔗 https://github.com/settings/tokens"
    echo "   - اضغط 'Generate new token (classic)'"
    echo "   - اختر 'repo' permissions"
    echo "   - استخدم الـ Token بدلاً من كلمة المرور"
    echo ""
    echo "أو استخدم الطريقة اليدوية من الدليل:"
    echo "   📄 GITHUB_PRIVACY_POLICY_GUIDE.md"
    echo ""
fi

echo "🧹 تنظيف..."
cd ~
# rm -rf "$TEMP_DIR"
echo "✅ تم!"
echo ""
