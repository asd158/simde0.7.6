CMAKE_MINIMUM_REQUIRED(VERSION 3.10)
PROJECT(test_simde)
ENABLE_TESTING()
ADD_EXECUTABLE(TEST_${PROJECT_NAME}
               t1.cpp
               )
TARGET_LINK_LIBRARIES(TEST_${PROJECT_NAME} PRIVATE gtest gtest_main simde pio_base)
#########################################################################
ADD_EXECUTABLE(BENCH_${PROJECT_NAME}
               b1.cpp
               )
TARGET_LINK_LIBRARIES(BENCH_${PROJECT_NAME} PRIVATE ${ATOMICS_LIBRARIES} benchmark simde pio_base)