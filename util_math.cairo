# Utility library for mathematical operations with 64x61 fixed point values
# %builtins range_check

from starkware.cairo.common.uint256 import Uint256
from starkware.cairo.common.math_cmp import less_or_equal, not_zero
from starkware.cairo.common.pow import power
from starkware.cairo.common.math import (
