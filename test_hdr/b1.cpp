#include "benchmark/benchmark.h"
#include "simde-math.h"

constexpr int len = 6;

void b1(benchmark::State &state) {
    std::array<float, len> arr{};
    constexpr int          i = 1;
    for (auto              _: state) {
        auto val = simde_math_acos(i + 0.0f);
        arr.at(0) = simde_math_acos(i + 1.0f);
        arr.at(1) = simde_math_acos(i + 2.0f);
        arr.at(2) = simde_math_acos(i + 3.0f);
        arr.at(3) = simde_math_acos(i + 4.0f);
        arr.at(4) = simde_math_acos(i + 5.0f);
        arr.at(5) = simde_math_acos(i + 6.0f);
    }
}
void b_normal(benchmark::State &state) {
    std::array<float, len> arr{};
    constexpr int          i = 1;
    for (auto              _: state) {
        auto val  = std::acos(i + 0.0f);
        arr.at(0) = std::acos(i + 1.0f);
        arr.at(1) = std::acos(i + 2.0f);
        arr.at(2) = std::acos(i + 3.0f);
        arr.at(3) = std::acos(i + 4.0f);
        arr.at(4) = std::acos(i + 5.0f);
        arr.at(5) = std::acos(i + 6.0f);
    }
}
BENCHMARK(b1);
BENCHMARK(b_normal);
int main() {
    benchmark::RunSpecifiedBenchmarks();
    return 0;
}