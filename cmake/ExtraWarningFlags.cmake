# This is basically supposed to be the CMake equivalent of
# https://git.gnome.org/browse/gnome-common/tree/macros2/gnome-compiler-flags.m4

INCLUDE(AddCompilerFlags)

IF (MSVC)
    SET(EXTRA_WARNING_FLAGS
        /W4         #/W4 會顯示層級 1、層級 2 和層級 3 警告，以及預設不會關閉的所有層級 4 (參考) 警告。 建議您使用此選項來提供類似 lint 的警告。 針對新的專案，最好在所有編譯中使用 /W4 。 此選項可協助確保最少可能難以尋找的程式碼瑕疵。
        #/Wall 显示 /W4 显示的所有警告以及 /W4 不包括的所有其他警告 - 例如，默认情况下关闭的警告。
        #/WX 将所有编译器警告视为错误。 对于新项目，最好在所有编译中使用 /WX；对所有警告进行解析可确保将可能难以发现的代码缺陷减至最少。
        /analyze    #打开代码分析。 使用 /analyze- 显式关闭分析。 默认行为是 /analyze-。默认情况下，分析输出会像其他错误消息一样进入控制台或 Visual Studio 输出窗口。 代码分析还会创建一个名为 filename.nativecodeanalysis.xml 的日志文件，其中 filename 是分析的源文件的名称。
        )           #/analyze:WX- 告知编译器不要将代码分析警告视为错误，即使使用了 /WX 选项也是如此
ELSE ()
    SET(EXTRA_WARNING_FLAGS
        -Wall #https://gcc.gnu.org/onlinedocs/gcc/Warning-Options.html
        -Wcast-align    #Warn whenever a pointer is cast such that the required alignment of the target is increased. For example, warn if a char * is cast to an int * on machines where integers can only be accessed at two- or four-byte boundaries.
        -Wextra
        #-Wclobbered    #Warn for variables that might be changed by longjmp or vfork. This warning is also enabled by -Wextra.
        #-Wempty-body   #This warning is also enabled by -Wextra.
        -Werror=format=2 #-Werror Make all warnings into errors.
        -Werror=format-security
        -Werror=implicit-function-declaration
        -Werror=init-self #警告使用自身初始化的未初始化变量。请注意，此选项只能与 -Wuninitialized 选项一起使用。
        -Wuninitialized
        -Werror=missing-include-dirs #如果用户提供的包含目录不存在，则发出警告。对于 C、C++、Objective-C 和 Objective-C++，此选项默认禁用。
        -Werror=missing-prototypes #在 C 中，对于先前具有非原型声明的函数不会发出警告；使用 -Wmissing-prototypes 来检测丢失的原型。在 C++ 中，不会对函数模板、内联函数或匿名命名空间中的函数发出警告。
        -Werror=pointer-arith #警告任何依赖于函数类型或 void “大小”的内容。 GNU C 将这些类型的大小指定为 1，以便于使用 void * 指针和函数指针进行计算。在 C++ 中，当算术运算涉及 NULL 时也会发出警告。此警告也由 -Wpedantic 启用。
        -Wformat-nonliteral
        -Wformat-security
        #-Wignored-qualifiers #如果函数的返回类型具有类型限定符（例如 const ），则发出警告。对于 ISO C，此类类型限定符无效，因为函数返回的值不是左值。对于 C++，仅针对标量类型或 void 发出警告。 ISO C 禁止在函数定义上限定 void 返回类型，因此即使没有此选项，此类返回类型也始终会收到警告。
                             #此警告也由 -Wextra 启用。
        -Winit-self
        -Winvalid-pch
        -Wlogical-op
        -Wmissing-declarations
        -Wmissing-format-attribute
        -Wmissing-include-dirs
        -Wmissing-noreturn
        -Wmissing-parameter-type
        -Wmissing-prototypes
        -Wnested-externs
        -Wno-missing-field-initializers
        -Wno-strict-aliasing
        -Wno-uninitialized
        -Wno-unused-parameter
        -Wold-style-definition
        -Woverride-init
        -Wpacked
        -Wpointer-arith
        -Wredundant-decls
        -Wreturn-type
        -Wshadow
        -Wsign-compare
        -Wstrict-prototypes
        -Wswitch-enum
        -Wsync-nand
        -Wtype-limits
        -Wundef
        -WUnsafe-loop-optimizations
        -Wwrite-strings
        -Wsuggest-attribute=format)
ENDIF ()

MARK_AS_ADVANCED(EXTRA_WARNING_FLAGS)

FUNCTION(TARGET_ADD_EXTRA_WARNING_FLAGS target)
    TARGET_ADD_COMPILER_FLAGS(${target} ${EXTRA_WARNING_FLAGS})
ENDFUNCTION(TARGET_ADD_EXTRA_WARNING_FLAGS)

FUNCTION(SOURCE_FILE_ADD_EXTRA_WARNING_FLAGS file)
    SOURCE_FILE_ADD_COMPILER_FLAGS(${file} ${EXTRA_WARNING_FLAGS})
ENDFUNCTION(SOURCE_FILE_ADD_EXTRA_WARNING_FLAGS)
