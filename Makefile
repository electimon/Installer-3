SUBDIRS = Framework Installer
IP = ${IP}
HEAVENLY = /usr/local/share/iphone-filesystem
CC = arm-apple-darwin-gcc
CFLAGS = -Wall -x objective-c -mmacosx-version-min=10.4
LD = arm-apple-darwin-ld
LDFLAGS = -ObjC -syslibroot $(HEAVENLY) \
	  -F$(HEAVENLY)/System/Library/Frameworks \
	  -framework CoreFoundation -framework Foundation \
	  -framework UIKit -framework LayerKit -framework CoreGraphics \
	  -framework WebCore -framework GraphicsServices \
	  -framework CoreSurface -framework AppSupport \
	  -L/usr/local/arm-apple-darwin/lib/ -lSystem -lobjc \
	  -./Framework -framework AppTapp

APPFLAGS=-lcrt1.o


all:			bundle


.PHONY: clean
clean:	
			make -C Installer clean
			make -C Framework clean
			rm -rf Product/*

%.o:			%.m
			$(CC) -c $(CFLAGS) $< -o $@


.PHONY: Framework
Framework:
	$(MAKE) -C $@ 

.PHONY: Installer
Installer: Framework
	$(MAKE) -C $@

bundle:			Framework Installer 
			mkdir -p Product/Installer.app
			cp -rf ./Framework/AppTapp.framework Product/Installer.app/AppTapp.framework
			cp Installer/Installer Product/Installer.app/Installer
			cp Installer/Info.plist Product/Installer.app/Info.plist
			cp Installer/*.png Product/Installer.app/
			cp -Rf Installer/resources/* Product/Installer.app/

tar:			bundle
			rm -rf Product/installer-DEBUG.tar
			@cd Product
			tar -czvf Product/installer-DEBUG.tar -C Product/ Installer.app

deploy:			all
			scp -r Installer.app root@${IP}:/Applications/
			ssh root@${IP} chown -R root:wheel /Applications/Installer.app; chmod 4755 /Applications/Installer.app/Installer; chmod 4755 /Applications/Installer.app/AppTapp.framework/AppTapp; killall -9 SpringBoard

test:
			@echo *Cleaning*
			make clean
			@echo *Testing Multi-Jobs build*
			@make -j2 || (echo *Multi-Jobs build failed!*; make clean; exit 1)
			@echo *Success*
			@echo *Testing Tar target with Multi-Jobs*
			@make -j2 tar || (echo *Tar target with Multi-Jobs failed!*; make clean; exit 1)
			@echo *Success* 
			@echo *Cleaning*
			make clean
			@echo *Test Suite Completed!*
