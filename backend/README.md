# Backend requirements (not deployed)

The mobile app currently uses demo/local data. A production backend still needs to be implemented and hosted.

Suggested endpoints:
- POST /v1/products/track — validate a product URL and create a tracking request.
- GET /v1/products — list the signed-in user's tracked products.
- GET /v1/products/{id}/history — return timestamped price observations.
- POST /v1/alerts — set target price and notification preference.
- POST /v1/device-tokens — register push notification token.
- GET /v1/plans — return server-controlled subscription entitlements.

Suggested services:
- PostgreSQL for users, products, offers, price observations, alerts, and subscriptions.
- A queue + scheduled workers for periodic checks.
- Firebase Cloud Messaging for Android and APNs via a supported push provider for iOS.
- Apple/Google in-app purchase validation on the server.

Store integrations must use official APIs or authorized data providers and comply with store terms. Do not assume a product page can be reliably scraped.
