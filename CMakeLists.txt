CMAKE_MINIMUM_REQUIRED(VERSION 3.10)
PROJECT(simde0.7.5)
IF (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
    SET(CMAKE_COMPILER_IS_CLANG 1)
ELSEIF (MSVC)
    SET(CMAKE_COMPILER_IS_MSVC 1)
ENDIF ()
INCLUDE("${CMAKE_SOURCE_DIR}/cmake/find_sse.cmake")
CHECK_FOR_SSE()
ADD_DEFINITIONS("${SSE_DEFINITIONS}")
MESSAGE(STATUS ${SSE_FLAGS})
MESSAGE(STATUS ${SSE_DEFINITIONS})
STRING(APPEND CMAKE_CXX_FLAGS "${SSE_FLAGS}")
MESSAGE(STATUS ${CMAKE_HOST_SYSTEM_NAME} "->" ${CMAKE_HOST_SYSTEM_PROCESSOR} "->" ${CMAKE_SYSTEM_PROCESSOR} "->" ${CMAKE_HOST_SYSTEM_VERSION})

#ADD_SUBDIRECTORY(googletest-1.13.0)
#SET(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
#ADD_SUBDIRECTORY(benchmark-1.8.2)
ADD_SUBDIRECTORY(simde)
#ADD_SUBDIRECTORY(test_hdr)