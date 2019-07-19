
export FGLRESOURCEPATH=../config
export FGLPROFILE=../config/fglprofile
export PATH+=/opt/fourjs/gst320/gma
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export ANDROID_SDK_ROOT=/opt/Android/android-sdk-linux

all: phonegap-plugin-barcodescanner quaggaJS bin/webcomponents
	gsmake barcodeScanning.4pw

bin/webcomponents:
	cd bin && ln -s ../webcomponents

run: bin/webcomponents
	cd bin; fglrun barcode.42r

phonegap-plugin-barcodescanner:
	git clone https://github.com/leopatras/phonegap-plugin-barcodescanner

addplugin: phonegap-plugin-barcodescanner
	$(GENERODIR)/gma/gmabuildtool scaffold --install-plugins phonegap-plugin-barcodescanner

quaggaJS:
	git clone https://github.com/serratus/quaggaJS

tar:
	tar cvzf barcodeScanning.tgz barcodeScanning.4pw makefile bin config  src/ webcomponents/

clean:
	rm bin/*.42?
