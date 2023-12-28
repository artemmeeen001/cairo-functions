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


# Type conversion functions
func convert_fixed_to_int {range_check_ptr} (fixed: FixedPoint) -> (integer: felt):
    let (integer, _) = division_with_remainder_signed(fixed.value, FIXED_FRACT_PART, FIXED_BOUND)
    return (integer)
end

func convert_int_to_fixed {range_check_ptr} (integer: felt) -> (fixed: FixedPoint):
    check_less_or_equal(integer, FIXED_INT_PART)
    check_less_or_equal(-FIXED_INT_PART, integer)
    tempvar fixed_value = integer * FIXED_FRACT_PART
    let fixed = FixedPoint(fixed_value)
    return (fixed)
end

func convert_double_to_fixed {range_check_ptr}(double: DoubleFloat) -> (fixed: FixedPoint):
    alloc_locals
    local fixed_mantissa = double.mantissa * FIXED_FRACT_PART
    let base_divisor : felt = power(10, double.exponent)
    let (fixed_result, _) = division_with_remainder_unsigned(fixed_mantissa, base_divisor)
    return (fixed = FixedPoint(fixed_result))
end

# Advanced mathematical operations using 64x61 fixed point values
func calculate_floor {range_check_ptr} (value: felt) -> (floor_value: felt):
    let (int_val, mod_val) = division_with_remainder_signed(value, FIXED_UNIT, FIXED_BOUND)
    let floor_value = value - mod_val
    assert_fixed_range(floor_value)
    return (floor_value)
end

func calculate_ceil {range_check_ptr} (value: felt) -> (ceil_value: felt):
    let (int_val, mod_val) = division_with_remainder_signed(value, FIXED_UNIT, FIXED_BOUND)
    let ceil_value = (int_val + 1) * FIXED_UNIT
    assert_fixed_range(ceil_value)
    return (ceil_value)
end

# Simplified mathematical functions for ease of use
func calculate_minimum {range_check_ptr} (a: felt, b: felt) -> (min_value: felt):
    let (a_le_b) = less_or_equal(a, b)
    return (a_le_b == 1) ? a : b
end

func calculate_maximum {range_check_ptr} (a: felt, b: felt) -> (max_value: felt):
    let (a_le_b) = less_or_equal(a, b)
    return (a_le_b == 1) ? b : a
end


func add_fixed_values {range_check_ptr} (a: FixedPoint, b: FixedPoint) -> (sum: FixedPoint):
    let sum_value = a.value + b.value
    assert_fixed_range(sum_value)
    return (sum = FixedPoint(sum_value))
end

func subtract_fixed_values {range_check_ptr} (a: FixedPoint, b: FixedPoint) -> (difference: FixedPoint):
    let difference_value = a.value - b.value
    assert_fixed_range(difference_value)
    return (difference = FixedPoint(difference_value))
end

func multiply_fixed_values {range_check_ptr} (a: FixedPoint, b: FixedPoint) -> (product: FixedPoint):
    tempvar product_temp = a.value * b.value
    let (product_value, _) = division_with_remainder_signed(product_temp, FIXED_FRACT_PART, FIXED_BOUND)
    assert_fixed_range(product_value)
    return (product = FixedPoint(product_value))
end

