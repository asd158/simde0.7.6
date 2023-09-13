###############################################################################
# Check for the presence of SSE and figure out the flags to use for it.
FUNCTION(CHECK_FOR_SSE)
    SET(SSE_FLAGS)
    SET(SSE_DEFINITIONS)
    IF (NOT CMAKE_CROSSCOMPILING)
        # Test GCC/G++ and CLANG
        IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
            INCLUDE(CheckCXXCompilerFlag)
            CHECK_CXX_COMPILER_FLAG("-march=native" HAVE_MARCH)
        ENDIF ()
    ELSE ()
        RETURN()
    ENDIF ()

    # Unfortunately we need to check for SSE to enable "-mfpmath=sse" alongside
    # "-march=native". The reason for this is that by default, 32bit architectures
    # tend to use the x87 FPU (which has 80 bit internal precision), thus leading
    # to different results than 64bit architectures which are using SSE2 (64 bit internal
    # precision). One solution would be to use "-ffloat-store" on 32bit (see
    # http://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html), but that slows code down,
    # so the preferred solution is to try "-mpfmath=sse" first.
    INCLUDE(CheckCXXSourceRuns)
    ###############################################################################################################
    CHECK_CXX_SOURCE_RUNS("
    #include <immintrin.h>
    int main()
    {
      __m256i a = {0};
      a = _mm256_abs_epi16(a);
      return 0;
    }"
                          HAVE_AVX2)
    IF (NOT HAVE_AVX2)
        CHECK_CXX_SOURCE_RUNS("
      #include <immintrin.h>
      int main()
      {
        __m256 a;
        a = _mm256_set1_ps(0);
        return 0;
      }"
                              HAVE_AVX)
    ENDIF ()
    ###############################################################################################################
    IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
        SET(CMAKE_REQUIRED_FLAGS "-msse4.2") #CMAKE_REQUIRED_FLAGS是给CHECK_CXX_SOURCE_RUNS用的
    ENDIF ()
    CHECK_CXX_SOURCE_RUNS("
    #include <emmintrin.h>
    #include <nmmintrin.h>
    int main ()
    {
      long long a[2] = {  1, 2 };
      long long b[2] = { -1, 3 };
      long long c[2];
      __m128i va = _mm_loadu_si128 ((__m128i*)a);
      __m128i vb = _mm_loadu_si128 ((__m128i*)b);
      __m128i vc = _mm_cmpgt_epi64 (va, vb);

      _mm_storeu_si128 ((__m128i*)c, vc);
      if (c[0] == -1LL && c[1] == 0LL)
        return (0);
      else
        return (1);
    }"
                          HAVE_SSE4_2_EXTENSIONS)

    IF (HAVE_SSE4_2_EXTENSIONS)
        SET(SSE_LEVEL 4.2)
    ELSEIF (SSE_LEVEL LESS 4.2)
        IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
            SET(CMAKE_REQUIRED_FLAGS "-msse4.1")
        ENDIF ()

        CHECK_CXX_SOURCE_RUNS("
      #include <smmintrin.h>
      int main ()
      {
        __m128 a, b;
        float vals[4] = {1, 2, 3, 4};
        const int mask = 123;
        a = _mm_loadu_ps (vals);
        b = a;
        b = _mm_dp_ps (a, a, mask);
        _mm_storeu_ps (vals,b);
        return (0);
      }"
                              HAVE_SSE4_1_EXTENSIONS)

        IF (HAVE_SSE4_1_EXTENSIONS)
            SET(SSE_LEVEL 4.1)
        ENDIF ()
    ENDIF ()

    IF (SSE_LEVEL LESS 4.1)
        IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
            SET(CMAKE_REQUIRED_FLAGS "-mssse3")
        ENDIF ()

        CHECK_CXX_SOURCE_RUNS("
      #include <tmmintrin.h>
      int main ()
      {
        __m128i a, b;
        int vals[4] = {-1, -2, -3, -4};
        a = _mm_loadu_si128 ((const __m128i*)vals);
        b = _mm_abs_epi32 (a);
        _mm_storeu_si128 ((__m128i*)vals, b);
        return (0);
      }"
                              HAVE_SSSE3_EXTENSIONS)

        IF (HAVE_SSSE3_EXTENSIONS)
            SET(SSE_LEVEL 3.1)
        ENDIF ()
    ENDIF ()

    IF (SSE_LEVEL LESS 3.1)
        IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
            SET(CMAKE_REQUIRED_FLAGS "-msse3")
        ENDIF ()

        CHECK_CXX_SOURCE_RUNS("
      #include <pmmintrin.h>
      int main ()
      {
          __m128d a, b;
          double vals[2] = {0};
          a = _mm_loadu_pd (vals);
          b = _mm_hadd_pd (a,a);
          _mm_storeu_pd (vals, b);
          return (0);
      }"
                              HAVE_SSE3_EXTENSIONS)

        IF (HAVE_SSE3_EXTENSIONS)
            SET(SSE_LEVEL 3.0)
        ENDIF ()
    ENDIF ()

    IF (SSE_LEVEL LESS 3.0)
        IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
            SET(CMAKE_REQUIRED_FLAGS "-msse2")
        ELSEIF (MSVC AND NOT CMAKE_CL_64)
            SET(CMAKE_REQUIRED_FLAGS "/arch:SSE2")
        ENDIF ()

        CHECK_CXX_SOURCE_RUNS("
      #include <emmintrin.h>
      int main ()
      {
          __m128d a, b;
          double vals[2] = {0};
          a = _mm_loadu_pd (vals);
          b = _mm_add_pd (a,a);
          _mm_storeu_pd (vals,b);
          return (0);
      }"
                              HAVE_SSE2_EXTENSIONS)

        IF (HAVE_SSE2_EXTENSIONS)
            SET(SSE_LEVEL 2.0)
        ENDIF ()
    ENDIF ()

    IF (SSE_LEVEL LESS 2.0)
        IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
            SET(CMAKE_REQUIRED_FLAGS "-msse")
        ELSEIF (MSVC AND NOT CMAKE_CL_64)
            SET(CMAKE_REQUIRED_FLAGS "/arch:SSE")
        ENDIF ()

        CHECK_CXX_SOURCE_RUNS("
      #include <xmmintrin.h>
      int main ()
      {
          __m128 a, b;
          float vals[4] = {0};
          a = _mm_loadu_ps (vals);
          b = a;
          b = _mm_add_ps (a,b);
          _mm_storeu_ps (vals,b);
          return (0);
      }"
                              HAVE_SSE_EXTENSIONS)

        IF (HAVE_SSE_EXTENSIONS)
            SET(SSE_LEVEL 1.0)
        ENDIF ()
    ENDIF ()

    SET(CMAKE_REQUIRED_FLAGS)

    IF (CMAKE_COMPILER_IS_GNUCC OR CMAKE_COMPILER_IS_GNUCXX OR CMAKE_COMPILER_IS_CLANG)
        IF (HAVE_AVX2)
            STRING(APPEND SSE_FLAGS " -mavx2")
        ELSEIF (HAVE_AVX)
            STRING(APPEND SSE_FLAGS " -mavx")
        ENDIF ()
        IF (SSE_LEVEL GREATER_EQUAL 1.0)
            IF (SSE_LEVEL GREATER_EQUAL 4.2)
                STRING(APPEND SSE_FLAGS " -msse4.2")
            ELSEIF (SSE_LEVEL GREATER_EQUAL 4.1)
                STRING(APPEND SSE_FLAGS " -msse4.1")
            ELSEIF (SSE_LEVEL GREATER_EQUAL 3.1)
                STRING(APPEND SSE_FLAGS " -msse3")
            ELSEIF (SSE_LEVEL GREATER_EQUAL 3.0)
                STRING(APPEND SSE_FLAGS " -msse3")
            ELSEIF (SSE_LEVEL GREATER_EQUAL 2.0)
                STRING(APPEND SSE_FLAGS " -msse2")
            ELSE ()
                STRING(APPEND SSE_FLAGS " -msse")
            ENDIF ()
            STRING(APPEND SSE_FLAGS " -mfpmath=sse")
        ELSE ()
            # Setting -ffloat-store to alleviate 32bit vs 64bit discrepancies on non-SSE
            # platforms.
            STRING(APPEND SSE_FLAGS " -ffloat-store")
        ENDIF ()

        IF ((NOT CMAKE_CROSSCOMPILING))
            IF (HAVE_MARCH)
                STRING(APPEND SSE_FLAGS " -march=native")
            ELSE ()
                STRING(APPEND SSE_FLAGS " -mtune=native")
            ENDIF ()
            MESSAGE(STATUS "Using CPU native flags for SSE optimization: ${SSE_FLAGS}")
        ENDIF ()
    ELSEIF (MSVC)
        # Setting the /arch defines __AVX(2)__, see here https://docs.microsoft.com/en-us/cpp/build/reference/arch-x64?view=msvc-160
        # AVX2 extends and includes AVX.
        # Setting these defines allows the compiler to use AVX instructions as well as code guarded with the defines.
        # TODO: Add AVX512 variant if needed.
        IF (HAVE_AVX2)
            STRING(APPEND SSE_FLAGS " /arch:AVX2")
        ELSEIF (HAVE_AVX)
            STRING(APPEND SSE_FLAGS " /arch:AVX")
        ENDIF ()
        IF (SSE_LEVEL GREATER_EQUAL 2.0)
            SET(SSE_FLAGS " /arch:SSE2")
        ELSEIF (SSE_LEVEL GREATER_EQUAL 1.0)
            SET(SSE_FLAGS " /arch:SSE")
        ENDIF ()
    ENDIF ()
    IF (HAVE_AVX2)
        STRING(APPEND SSE_DEFINITIONS " -D__AVX2__")
    ELSEIF (HAVE_AVX)
        STRING(APPEND SSE_DEFINITIONS " -D__AVX__")
    ENDIF ()
    IF (SSE_LEVEL GREATER_EQUAL 4.2)
        STRING(APPEND SSE_DEFINITIONS " -D__SSE4_2__")
    ENDIF ()
    IF (SSE_LEVEL GREATER_EQUAL 4.1)
        STRING(APPEND SSE_DEFINITIONS " -D__SSE4_1__")
    ENDIF ()
    IF (SSE_LEVEL GREATER_EQUAL 3.1)
        STRING(APPEND SSE_DEFINITIONS " -D__SSSE3__")
    ENDIF ()
    IF (SSE_LEVEL GREATER_EQUAL 3.0)
        STRING(APPEND SSE_DEFINITIONS " -D__SSE3__")
    ENDIF ()
    IF (SSE_LEVEL GREATER_EQUAL 2.0)
        STRING(APPEND SSE_DEFINITIONS " -D__SSE2__")
    ENDIF ()
    IF (SSE_LEVEL GREATER_EQUAL 1.0)
        STRING(APPEND SSE_DEFINITIONS " -D__SSE__")
    ENDIF ()
    SET(SSE_FLAGS ${SSE_FLAGS} PARENT_SCOPE)
    SET(SSE_DEFINITIONS ${SSE_DEFINITIONS} PARENT_SCOPE)
    UNSET(CMAKE_REQUIRED_FLAGS)
ENDFUNCTION()
