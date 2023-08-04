#pragma once

// Platform-specific timer functions. Provides Now() and functions for
// interpreting and converting the timer-inl.h Ticks.

#include <stdint.h>

namespace hwy {
    namespace platform {
// Returns current timestamp [in seconds] relative to an unspecified origin.
// Features: monotonic (no negative elapsed time), steady (unaffected by system
// time changes), high-resolution (on the order of microseconds).
// Uses InvariantTicksPerSecond and the baseline version of timer::Start().
        double Now();

// Functions for use with timer-inl.h:

// Returns whether it is safe to call timer::Stop without executing an illegal
// instruction; if false, fills cpu100 (a pointer to a 100 character buffer)
// with the CPU brand string or an empty string if unknown.
        bool HaveTimerStop(char *cpu100);

// Returns tick rate, useful for converting timer::Ticks to seconds. Invariant
// means the tick counter frequency is independent of CPU throttling or sleep.
// This call may be expensive, callers should cache the result.
        double InvariantTicksPerSecond();

// Returns ticks elapsed in back to back timer calls, i.e. a function of the
// timer resolution (minimum measurable difference) and overhead.
// This call is expensive, callers should cache the result.
        uint64_t TimerResolution();
    }  // namespace platform
}  // namespace hwy