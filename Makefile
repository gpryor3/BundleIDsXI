ARCHS = arm64

include $(THEOS)/makefiles/common.mk

APPLICATION_NAME = BundleIDs
BundleIDs_FILES = main.m BundleIDsAppDelegate.m RootViewController.m
BundleIDs_FRAMEWORKS = UIKit CoreGraphics
BundleIDs_LIBRARIES = applist 

include $(THEOS_MAKE_PATH)/application.mk

after-install::
	install.exec "killall \"BundleIDs\"" || true
