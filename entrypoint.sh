#!/bin/sh
flutter pub get
flutter build web -o /github/workspace/web-artifact --base-href /myapp/  --wasm
flutter build apk
cp ./build/app/outputs/flutter-apk/app-release.apk /github/workspace/app-release.apk