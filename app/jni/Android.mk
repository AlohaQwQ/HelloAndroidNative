# Copyright (C) The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# 源文件在开发树中的位置, 宏函数 my-dir 将返回当前目录
LOCAL_PATH:= $(call my-dir)

# CLEAR_VARS 变量，其值由构建系统提供，指向特殊 GNU Makefile，可为您清除许多 LOCAL_XXX 变量，
# 例如 LOCAL_MODULE、LOCAL_SRC_FILES 和 LOCAL_STATIC_LIBRARIES。
# 请注意，它不会清除 LOCAL_PATH。此变量必须保留其值，因为系统在单一 GNU Make 执行环境（其中所有变量都是全局的）中解析所有构建控制文件。
include $(CLEAR_VARS)

JNI_SRC_PATH := $(call abspath_wa, $(LOCAL_PATH)/src/main/cpp)

# LOCAL_MODULE 变量将存储您要构建的模块的名称。请在应用中每个模块使用一个此变量。 每个模块名称必须唯一，且不含任何空格。
# 构建系统在生成最终共享库文件时，会将正确的前缀和后缀自动添加到您分配给 LOCAL_MODULE 的名称。如果模块名称的开头已是 lib，
# 则构建系统不会附加额外的前缀 lib；而是按原样采用模块名称，并添加 .so 扩展名。 因此，比如原来名为 libfoo.c 的源文件仍会生成名为 libfoo.so 的共享对象文件。
# 此行为是为了支持 Android 平台源文件从 Android.mk 文件生成的库；所有这些库的名称都以 lib 开头。
LOCAL_MODULE    := hello-native

# 枚举源文件，以空格分隔多个文件,必须包含要构建到模块中的 C 和/或 C++ 源文件列表
LOCAL_SRC_FILES := $(JNI_SRC_PATH)/native-lib.cpp

abspath_wa = $(join $(filter %:,$(subst :,: ,$1)),$(abspath $(filter-out %:,$(subst :,: ,$1))))



LOCAL_CFLAGS    := -Werror -std=c++11

# 链接外部库，库名称之前添加 -l（链接）选项
# log 是一个日志库
# android 包含用于 NDK 的标准 Android 支持 API。如需了解有关 Android 和 NDK 支持的 API 的详细信息，请参阅 Android NDK 原生 API。
# EGL 与图形 API 中针对特定平台的部分相对应。
# GLESv1_CM 与 OpenGL ES（即适用于 Android 的 OpenGL 版本）相对应。此库依赖 EGL。
# 在每个库中：
# 实际文件名以 lib 开头，以 .so 扩展名结尾。 例如，log 库的实际文件名是 liblog.so。
# 库位于 NDK 根目录下的以下目录中：<ndk>/platforms/android-<sdk_version>/arch-<abi>/usr/lib/
LOCAL_LDLIBS    := -llog -lGLESv2 -landroid -lEGL -lGLESv1_CM

# 链接静态库
# 应用使用它管理 NativeActivity 生命周期事件和触摸输入
LOCAL_STATIC_LIBRARIES := android_native_app_glue

# 向构建系统下达构建此静态库的指令。ndk-build 脚本将构建库 (libandroid_native_app_glue.a) 放入在构建过程中生成的 obj 目录。
# 如需了解有关 android_native_app_glue 库的详细信息，请参阅它的 android_native_app_glue.h 标头和相应的 .c 源文件。
$(call import-module,android/native_app_glue)

# 帮助系统将所有内容连接到一起，BUILD_SHARED_LIBRARY 变量指向 GNU Makefile 脚本，
# 用于收集您自最近 include 后在 LOCAL_XXX 变量中定义的所有信息。 此脚本确定要构建的内容及其操作方法。
include $(BUILD_SHARED_LIBRARY)
