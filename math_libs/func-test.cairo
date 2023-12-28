# Extended Math Library incorporating small_math lib functionalities
# Focus: Gamma function for integers, half-integers, reals (in Cairo fixed point)
# Potential Extensions: Beta, Psi, Bessel, Airy, etc.

from starkware.cairo.common.pow import pow
from starkware.cairo.common.alloc import alloc

from math_libs.small_math import (
    Numeral,
    FixedPoint,
    convert_integer_to_fixed,
    convert_fixed_to_integer,
    convert_decimal_to_fixed,
    division_fixed,
    multiplication_fixed,
    sqrt_pi_fixed,
    fixed_one,
    factorial_fixed,
    exponential_fixed,
    subtraction_fixed,
    natural_log_fixed,
    power_fixed,
    hyperbolic_sine_fixed,
    addition_fixed,
    display_fixed_value
) 

# Constants related to fixed point representation
# const FixedPoint_INT_PART = 2 ** 64
# const FixedPoint_FRACT_PART = 2 ** 61
# const FixedPoint_BOUND = 2 ** 125
# const FixedPoint_ONE = 1 * FixedPoint_FRACT_PART

# const FixedPoint_PI = 7244019458077122842
# const FixedPoint_sqrt_PI = 4087000321264375119

# Gamma function for integers using factorial approximation
func gamma_function_integer {range_check_ptr} (input: FixedPoint) -> (result: FixedPoint):
    let (adjusted_input) = subtraction_fixed(input, FixedPoint(fixed_one))
    let (result) = factorial_fixed(adjusted_input)
    return (result = result)
end

# Double factorial function for fixed point values
func gamma_function_double_factorial {range_check_ptr} (input: FixedPoint) -> (result: FixedPoint):
    if input.val == 0 or input.val == fixed_one:
        return (result = FixedPoint(fixed_one))
    end

    let (step) = convert_decimal_to_fixed(Numeral(2, 0))
    let (prev_input) = subtraction_fixed(input, step)
    let (partial_result) = gamma_function_double_factorial(prev_input)
    let (result) = multiplication_fixed(partial_result, input)

    return (result = result)
end

# Gamma function for half-integers
func gamma_function_half_integer {range_check_ptr}(n: FixedPoint) -> (result: FixedPoint):
    alloc_locals

    # Base integer calculation from half-units
    let (base_integer) = division_fixed(subtraction_fixed(n, FixedPoint(fixed_one)), convert_integer_to_fixed(2))

    # Gamma function calculation for half-integers
    let (double_base) = multiplication_fixed(convert_integer_to_fixed(2), base_integer)
    let (exponential_factor) = exponential_fixed(double_base)
    let (factorial_denominator) = factorial_fixed(base_integer)
    let (denominator) = multiplication_fixed(exponential_factor, factorial_denominator)
    let (numerator) = factorial_fixed(double_base)
    let (ratio) = division_fixed(numerator, denominator)
    let (result) = multiplication_fixed(ratio, FixedPoint(sqrt_pi_fixed))

    return (result = result)
end

# Windschitl approximation for LogGamma function
func gamma_function_windschitl {range_check_ptr}(x: FixedPoint) -> (result: FixedPoint):
    alloc_locals
    let (fixed_one) = FixedPoint(fixed_one)

    # Constants and calculations for Windschitl approximation
    let (c_1) = convert_decimal_to_fixed(Numeral(918938533204673, 15))
    let (half_x) = multiplication_fixed(convert_decimal_to_fixed(Numeral(5, 1)), x)
    let (log_x) = natural_log_fixed(x)
    let (t_1) = multiplication_fixed(subtraction_fixed(x, half_x), log_x)
    let (t_2) = FixedPoint(-x.val) 
    let (t_3) = exponential_fixed(multiplication_fixed(convert_integer_to_fixed(810), power_fixed(x, convert_integer_to_fixed(6))))
    let (t_4) = natural_log_fixed(addition_fixed(multiplication_fixed(x, hyperbolic_sine_fixed(division_fixed(fixed_one, x))), division_fixed(fixed_one, t_3)))
    let (windschitl_approx) = addition_fixed(addition_fixed(addition_fixed(c_1, t_1), t_2), multiplication_fixed(half_x, t_4))

    return (result = windschitl_approx)
end

# Lanczos approximation for LogGamma function
func gamma_function_lanczos {range_check_ptr}(x: FixedPoint) -> (result: FixedPoint):
    alloc_locals
    let (coefficients: FixedPoint*) = alloc()

    # Coefficients for Lanczos approximation
    let (coefficients_vals) = [
        convert_decimal_to_fixed(Numeral(751226331530, 7)), 
        convert_decimal_to_fixed(Numeral(809166278952, 7)), 
        # ... Other coefficients truncated for brevity ...
    ]

    # Assigning coefficients to allocated memory
    for i in 0..len(coefficients_vals) - 1:
        assert([coefficients + i]) = coefficients_vals[i]
    end

    # Lanczos approximation calculations
    let (a_value, b_value) = lanczos_approximation_inner(coefficients, len(coefficients_vals), x, subtraction_fixed(multiplication_fixed(addition_fixed(x, convert_decimal_to_fixed(Numeral(5, 1))), natural_log_fixed(addition_fixed(x, convert_decimal_to_fixed(Numeral(55, 1))))), addition_fixed(x, convert_decimal_to_fixed(Numeral(55, 1)))))

    let (result) = addition_fixed(a_value, natural_log_fixed(b_value))

    return (result)
end

# Inner function for Lanczos approximation
func lanczos_approximation_inner {range_check_ptr}(coefficients: FixedPoint*, size: felt, x: FixedPoint, initial_a: FixedPoint) -> (a: FixedPoint, b: FixedPoint):
    alloc_locals
    if size == 0:
        return (a = initial_a, b = convert_integer_to_fixed(0))
    end

    let (accumulated_a, accumulated_b) = lanczos_approximation_inner(coefficients + FixedPoint.SIZE, size - 1, x, initial_a)
    let (index_fixed) = convert_integer_to_fixed(index)
    let (log_arg) = addition_fixed(index_fixed, x)
    let (a_log) = natural_log_fixed(log_arg)
    let (pow_b) = power_fixed(x, index_fixed)
    let q_n: FixedPoint = cast([coefficients], FixedPoint)
    let (b_mult) = multiplication_fixed(q_n, pow_b)

    let (sum_a) = subtraction_fixed(accumulated_a, a_log)
    let (sum_b) = addition_fixed(accumulated_b, b_mult)

    return (a = sum_a, b = sum_b)
end
