#include "benchmark/benchmark.h"
#include <array>
#include <cmath>
#include <bitset>
#include <intrin.h>
#include "simde-common.h"
#include "simde-arch.h"
#include "x86/sse4.2.h"
#include "simde-math.h"

constexpr int len = 6;
std::array<float, len> arr{};
void b1(benchmark::State &state) {
    constexpr int i = 1;
    for (auto _: state) {
        arr.at(0) = simde_math_acos(i + 1.0f);
        arr.at(1) = simde_math_acos(i + 2.0f);
        arr.at(2) = simde_math_acos(i + 3.0f);
        arr.at(3) = simde_math_acos(i + 4.0f);
        arr.at(4) = simde_math_acos(i + 5.0f);
        arr.at(5) = simde_math_acos(i + 6.0f);
    }
}
void b_normal(benchmark::State &state) {
    constexpr int i = 1;
    for (auto _: state) {
        arr.at(0) = std::acos(i + 1.0f);
        arr.at(1) = std::acos(i + 2.0f);
        arr.at(2) = std::acos(i + 3.0f);
        arr.at(3) = std::acos(i + 4.0f);
        arr.at(4) = std::acos(i + 5.0f);
        arr.at(5) = std::acos(i + 6.0f);
    }
}
BENCHMARK(b_normal);
BENCHMARK(b1);
int main() {
    benchmark::RunSpecifiedBenchmarks();
    return 0;
}
