QT += qml quick

CONFIG += c++11

SOURCES += main.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
	build.txt

contains(ANDROID_TARGET_ARCH,armeabi-v7a) {
	ANDROID_EXTRA_LIBS = \
		C:/C/Lib/OpenSSL-Android/openssl-1.0.2/armeabi-v7a/lib/libcrypto.so \
		C:/C/Lib/OpenSSL-Android/openssl-1.0.2/armeabi-v7a/lib/libssl.so
}
