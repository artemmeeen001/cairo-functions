# Utility library for mathematical operations with 64x61 fixed point values
# %builtins range_check

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math_cmp import less_or_equal, not_zero
from starkware.cairo.common.pow import power
from starkware.cairo.common.math import (
    check_less_or_equal,
    check_less_than,
    square_root,
    extract_sign,
    absolute,
    division_with_remainder_signed,
    division_with_remainder_unsigned,
    ensure_not_zero
)

# Constants for fixed point operations
const FIXED_INT_PART = 2 ** 64
const FIXED_FRACT_PART = 2 ** 61
const FIXED_BOUND = 2 ** 125
const FIXED_UNIT = 1 * FIXED_FRACT_PART
const FIXED_E = 6267931151224907085

const FIXED_PI = 7244019458077122842
const FIXED_SQRT_PI = 4087000321264375119

# Struct for fixed point representation
struct FixedPoint:
    member value: felt
end

# Struct for double precision floating point
struct DoubleFloat:
    member mantissa: felt
    member exponent: felt
end

# Asserts that a value is within the 64x61 fixed point range
func assert_fixed_range {range_check_ptr} (value: felt):
    check_less_or_equal(value, FIXED_BOUND)
    check_less_or_equal(-FIXED_BOUND, value)
    return ()
end

# Display functions for debugging
func display_double (double_value: DoubleFloat):
    tempvar mantissa = double_value.mantissa
    tempvar exponent = double_value.exponent
    %{
        double_result = ids.mantissa / 10 ** ids.exponent
        print(' Double representation: ' + str(double_result))
    %}
    return()
end

func display_fixed (fixed_value: FixedPoint):
    tempvar mantissa = fixed_value.value
    %{
        fixed_result = ids.mantissa / ids.FIXED_FRACT_PART
        print(' Fixed point representation: ' + str(fixed_result))
    %}
    return()
end
