TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard
ARCHS = arm64 arm64e

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = CallerIDModule
CallerIDModule_BUNDLE_EXTENSION = bundle
CallerIDModule_FILES = $(wildcard *.m)
CallerIDModule_INSTALL_PATH = /Library/ControlCenter/Bundles/

include $(THEOS_MAKE_PATH)/bundle.mk
