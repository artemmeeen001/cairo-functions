%builtins range_check
# Comprehensive test of Special Functions in Math Libraries
# Updated Version

from math_libs.special_functions import (
    GammaFunctionForHalfIntegers,
    WindschitlGammaFunction,
    LanczosGammaFunction
)
 # Optimized versions of the following functions
from math_libs.util_math import (
    ConvertToDouble,
    ConvertToFixedPoint,
    FixPointRepresentation,
    FixedPointToDouble,
    MathOperationsDivide,
    MathOperationsMultiply,
    CalculateSqrtPi,
    ConstantOne,
    CalculateFactorial,
    MathOperationsSubtract,
    CalculateNaturalLog,
    MathOperationsPower,
    CalculateSinh,
    MathOperationsAdd,
    DisplayFixedPointValue
) 

# Recursive function to test gamma values for odd integers
func check_gamma_for_odd_integers {range_check_ptr} (integer_value: felt):
    alloc_locals
    try:
        alloc_locals
        # Simplify conditional return in check_gamma_for_odd_integers
        if integer_value <= 1:
        return
        end

        let (fixed_point_value) = ConvertToFixedPoint(ConvertToDouble(integer_value, 0))
        check_gamma_for_odd_integers(integer_value - 2)
        let (gamma_result) = GammaFunctionForHalfIntegers(fixed_point_value)
        tempvar gamma_result_value = gamma_result.val
        %{
            display_text = f' Gamma({integer_value}/2) = {gamma_result_value/ConstantOne}'
            print(display_text)
        %}
        return()
        except Exception as e:
            print(f"Error occurred: {e}")
        return()
    end

# Placeholder for future test function
func future_test_function {range_check_ptr}(test_param: felt):
    euler_gamma = CalculateEulerGamma()
    logging.info(f"Euler-Mascheroni Constant: {euler_gamma}")
    return()
end


func main {range_check_ptr}():
    logging.basicConfig(level=logging.INFO)
    logging.info('\n STARTING TEST OF GAMMA FUNCTION LIBRARY')
    %{
        import time
        start_time = time.time()
        print('\n STARTING TEST OF GAMMA FUNCTION LIBRARY')
        print(' -------------------------------------')
    %}
    
    # Uncomment to perform desired test:
    
    # Test for half-integer gamma function
    # %{
    #     print('Testing Gamma Function for Half Integers')
    # %}
    # check_gamma_for_odd_integers(5)
    
    # Test for Windschitl gamma function
    # let (windschitl_input) = ConvertToFixedPoint(ConvertToDouble(15, 0))
    # %{
    #     print('Windschitl Input:')
    # %}
    # DisplayFixedPointValue(windschitl_input)
    # let (windschitl_output) = WindschitlGammaFunction(windschitl_input)
    # %{
    #     print('Windschitl Gamma Function Result:')
    # %}
    # DisplayFixedPointValue(windschitl_output)

    # Test for Lanczos gamma function
    let (lanczos_input) = ConvertToFixedPoint(ConvertToDouble(15, 0))
    %{
        print('Lanczos Input:')
    %}
    DisplayFixedPointValue(lanczos_input)
    let (lanczos_output) = LanczosGammaFunction(lanczos_input)
    %{
        print('Lanczos Gamma Function Result:')
    %}
    DisplayFixedPointValue(lanczos_output)

    %{
        end_time = time.time() - start_time
        print(' -------------------------------------')
        print(f' END OF TESTS: {end_time} seconds\n')
    %}   
    logging.info(f' END OF TESTS: {end_time} seconds\n')
    return ()
end
