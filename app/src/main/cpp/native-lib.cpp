#include <jni.h>
#include <string>

extern "C"
jstring
Java_com_aloha_shiningstar_hellonative_MainActivity_stringFromJNI(
        JNIEnv *env,
        jobject /* this */) {
    std::string hello = "Hello Native from C++";
    return env->NewStringUTF(hello.c_str());
}
