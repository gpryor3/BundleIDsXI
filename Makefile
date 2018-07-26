ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = BundleIDsXI
BundleIDsXI_FILES = main.m BundleIDsAppDelegate.m RootViewController.m
BundleIDsXI_FRAMEWORKS = UIKit CoreGraphics
BundleIDsXI_LIBRARIES = applist 

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"BundleIDsXI\"" || true
