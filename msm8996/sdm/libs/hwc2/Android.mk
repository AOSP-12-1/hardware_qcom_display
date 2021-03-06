LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
include $(LOCAL_PATH)/../../../common.mk

ifeq ($(use_hwc2),true)

LOCAL_MODULE                  := hwcomposer.$(TARGET_BOARD_PLATFORM)
LOCAL_LICENSE_KINDS           := SPDX-license-identifier-Apache-2.0 SPDX-license-identifier-BSD legacy_not_a_contribution
LOCAL_LICENSE_CONDITIONS      := by_exception_only not_allowed notice
LOCAL_MODULE_RELATIVE_PATH    := hw
LOCAL_PROPRIETARY_MODULE      := true
LOCAL_MODULE_TAGS             := optional
LOCAL_C_INCLUDES              := $(common_includes)

LOCAL_CFLAGS                  := -Wno-missing-field-initializers -Wno-unused-parameter \
                                 -fcolor-diagnostics\
                                 -DLOG_TAG=\"SDM\" $(common_flags) \
                                 -I $(display_top)/sdm/libs/hwc

LOCAL_CLANG                   := true

LOCAL_SHARED_LIBRARIES        := libsdmcore libqservice libbinder libhardware libhardware_legacy \
                                 libutils libcutils libsync libqdutils libqdMetaData libdl \
                                 libsdmutils libc++ liblog

ifneq ($(TARGET_USES_GRALLOC1), true)
    LOCAL_SHARED_LIBRARIES += libmemalloc
endif

# Allow implicit fallthroughs in hwc_display.cpp until they are fixed.
LOCAL_CFLAGS                  += -Wno-implicit-fallthrough

LOCAL_SRC_FILES               := hwc_session.cpp \
                                 hwc_display.cpp \
                                 hwc_display_primary.cpp \
                                 hwc_display_external.cpp \
                                 hwc_display_virtual.cpp \
                                 ../hwc/hwc_debugger.cpp \
                                 ../hwc/hwc_buffer_sync_handler.cpp \
                                 hwc_color_manager.cpp \
                                 hwc_layers.cpp \
                                 hwc_callbacks.cpp \
                                 ../hwc/cpuhint.cpp

ifneq ($(TARGET_USES_GRALLOC1), true)
    LOCAL_SRC_FILES += ../hwc/hwc_buffer_allocator.cpp
else
    LOCAL_SRC_FILES += hwc_buffer_allocator.cpp
endif

include $(BUILD_SHARED_LIBRARY)
endif
