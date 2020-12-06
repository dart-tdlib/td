# td

# deprecated
Deprecated again because isolates with Flutter on mobile devices isnt very reliable choose, maybe it'll get used on desktop (windows, linux) later.

Basic wrapper for [tdlib](https://github.com/tdlib/td) which is using ffi instead of platform channels.
Currently supports only android, almost the latest libraries for all popular platforms have been prebuilt.
It should be possible to easily reuse the wrapper on iOS devices, maybe even on Desktops or Browsers.
TdApi is taken from [this](https://github.com/i-naji/tdlib) repository, check it out too.
The goal of this project is to make it possible to use tdlib with dart/flutter without relying on platform code.

To start using the library, check out the example in the example folder or at the "Example" tab on pub.dev.
It shows the easiest way to display tdlib's version with Flutter.


## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

