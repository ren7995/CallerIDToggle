ARCHS = arm64 arm64e
TARGET := iphone:clang:latest:13.0
INSTALL_TARGET_PROCESSES = SpringBoard
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CallerIDHelper

CallerIDHelper_FILES = Tweak/Tweak.m
CallerIDHelper_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

SUBPROJECTS += CallerIDModule
include $(THEOS_MAKE_PATH)/aggregate.mk
