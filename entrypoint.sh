#!/bin/sh
flutter pub get
flutter build web -o docs --base-href /myapp/
cp ./build/web /github/workspace/web-built -r