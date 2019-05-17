HEAVENLY = /usr/local/share/iphone-filesystem
CC = arm-apple-darwin-gcc -w
CFLAGS = -Wall -x objective-c -mmacosx-version-min=10.4
LD = arm-apple-darwin-ld
LDFLAGS = -ObjC -syslibroot $(HEAVENLY) \
	  -F$(HEAVENLY)/System/Library/Frameworks \
	  -framework CoreFoundation -framework Foundation \
	  -framework UIKit -framework LayerKit -framework CoreGraphics \
	  -framework WebCore -framework GraphicsServices \
	  -framework CoreSurface -framework AppSupport \
	  -L/usr/local/arm-apple-darwin/lib/ -lSystem -lobjc \
	  -F../Framework -framework AppTapp

APPFLAGS=-lcrt1.o


all:			Installer


clean:	
			rm -rf *.o Installer Installer.app installer-3.12.zip ../Framework/AppTapp ../Framework/AppTapp.framework ../Framework/*.o


%.o:			%.m
			$(CC) -c $(CFLAGS) $< -o $@

Installer:		main.o ATInstaller.o ATPackageDataSource.o ATDetailCell.o ATController.o ATFeaturedController.o ATInstallController.o ATUpdateController.o ATUninstallController.o ATSourcesController.o
			$(LD) $(LDFLAGS) $(APPFLAGS) -o $@ $^
			install_name_tool -change AppTapp /Applications/Installer.app/AppTapp.framework/AppTapp $@
