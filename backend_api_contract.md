# API contract — المرحلة التالية

## إضافة منتج
`POST /functions/v1/add-tracked-product`

Headers:
- `Authorization: Bearer <user_access_token>`
- `Content-Type: application/json`

Body:
```json
{
  "product_url": "https://www.amazon.eg/dp/...",
  "product_name": "Adidas VS Pace 2.0",
  "store_name": "Amazon Egypt",
  "variant_label": "EU 45 1/3",
  "target_price": 2200
}
```

الاستجابة تحفظ المنتج بحالة `pending`. لا تعني أن السعر قد تم فحصه.

## المراحل غير المنفذة بعد
- عامل مجدول يقرأ المنتجات النشطة.
- موصلات رسمية/مرخصة لبيانات المتاجر.
- حفظ تغير السعر في `price_history`.
- إرسال Push Notifications بعد موافقة المستخدم.
- Webhooks موثوقة لتحديث حالة الاشتراك من Apple/Google.
