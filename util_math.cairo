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

