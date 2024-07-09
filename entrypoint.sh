#!/bin/sh
flutter pub get
flutter build web -o /github/workspace/web-artifact --base-href /myapp/
flutter build apk -o /github/workspace/apk-artifact
cp build/app/outputs/flutter-apk/app-release.apk /github/workspace/app-release.apk