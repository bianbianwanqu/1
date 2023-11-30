/*
* @title A library to convert unsigned integers to signed integers using two's complement. It contains basic arithmetic operations for signed integers. 
* @dev It is inspired by Movemate i64 https://github.com/pentagonxyz/movemate/blob/main/sui/sources/i64.move 
* @dev Uses arithmetic shr and shl for negative numbers 
*/
module suitears::int {
  // === Imports ===

  use suitears::math256;    

  // === Constants ===
  
  // @dev Maximum i256 as u256. We need one bit for the sign. 0 positive / 1 negative.  
  const MAX_I256_AS_U256: u256 = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
  
  // @dev Maximum u256 number.
  const MAX_U256: u256 = 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF;
  
  // @dev A mask to check if a number is positive or negative. It has the MSB set to 1. 
  const U256_WITH_FIRST_BIT_SET: u256 = 1 << 255;

  // Compare Results

  const EQUAL: u8 = 0;

  const LESS_THAN: u8 = 1;

  const GREATER_THAN: u8 = 2;

  // === Errors ===

  // @dev It occurs if an operation results in a value higher than `MAX_I256_U256`.   
  const EConversionFromU256Overflow: u64 = 0;
  // @dev It occurs if a negative Int is converted to an unsigned integer
  const EConversionUnderflow: u64 = 1;

  // === Structs ===
  
  // @dev A wrapper to represent unsigned integers.
  struct Int has copy, drop, store {
    bits: u256
  }

  // === Public View Function ===  
  
  /*
  * @notice It returns the inner value inside Int.
  * @param self The Int struct.  
  * @return u256. The inner bits.
  */
  public fun bits(self: Int): u256 {
    self.bits
  }

  // === Public Create Functions ===   

  /*
  * @notice It creates a zero Int.   
  * @return Int. The wrapped value.
  */
  public fun zero(): Int {
    Int { bits: 0 }
  }

  /*
  * @notice It creates a one Int.   
  * @return Int. The wrapped value.
  */
  public fun one(): Int {
    Int { bits: 1 }
  } 

  /*
  * @notice It creates the largest possible Int.   
  * @return Int. The wrapped value.
  */
  public fun max(): Int {
    Int { bits: MAX_I256_AS_U256 }
  }

  /*
  * @notice It wraps a u8 number into an Int.  
  * @param value The u8 value to wrap  
  * @return Int. The wrapped value.
  */
  public fun from_u8(value: u8): Int {
    Int { bits: (value as u256) }
  }

  /*
  * @notice It wraps a u16 number into an Int.  
  * @param value The u16 value to wrap  
  * @return Int. The wrapped value.
  */
  public fun from_u16(value: u16): Int {
    Int { bits: (value as u256) }
  }

  /*
  * @notice It wraps a u32 number into an Int.  
  * @param value The u32 value to wrap  
  * @return Int. The wrapped value.
  */
  public fun from_u32(value: u32): Int {
    Int { bits: (value as u256) }
  }

  /*
  * @notice It wraps a u64 number into an Int.  
  * @param value The u64 value to wrap  
  * @return Int. The wrapped value.
  */
  public fun from_u64(value: u64): Int {
    Int { bits: (value as u256) }
  }

  /*
  * @notice It wraps a u128 number into an Int.  
  * @param value The u128 value to wrap  
  * @return Int. The wrapped value.
  */
  public fun from_u128(value: u128): Int {
    Int { bits: (value as u256) }
  }

  /*
  * @notice It wraps a u256 number into an Int.  
  * @param value The u256 value to wrap  
  * @return Int. The wrapped value.
  *
  * aborts-if 
  *  - if value is larger than `MAX_I256_AS_U256`.  
  */
  public fun from_u256(value: u256): Int {
    assert!(value <= MAX_I256_AS_U256, EConversionFromU256Overflow);
    Int { bits: value }
  }

  /*
  * @notice It wraps a u8 number into an Int and negates it.  
  * @param value The u8 value to wrap  
  * @return Int. The wrapped value of -value.
  */
  public fun neg_from_u8(value: u8): Int {
    let ret = from_u8(value);
    if (ret.bits > 0) *&mut ret.bits = MAX_U256 - ret.bits + 1;
    ret
  }

  /*
  * @notice It wraps a u16 number into an Int and negates it.  
  * @param value The u16 value to wrap  
  * @return Int. The wrapped value of -value.
  */
  public fun neg_from_u16(value: u16): Int {
    let ret = from_u16(value);
    if (ret.bits > 0) *&mut ret.bits = MAX_U256 - ret.bits + 1;
    ret
  }

  /*
  * @notice It wraps a u32 number into an Int and negates it.  
  * @param value The u32 value to wrap  
  * @return Int. The wrapped value of -value.
  */
  public fun neg_from_u32(value: u32): Int {
    let ret = from_u32(value);
    if (ret.bits > 0) *&mut ret.bits = MAX_U256 - ret.bits + 1;
    ret
  }

  /*
  * @notice It wraps a u64 number into an Int and negates it.  
  * @param value The u64 value to wrap  
  * @return Int. The wrapped value of -value.
  */
  public fun neg_from_u64(value: u64): Int {
    let ret = from_u64(value);
    if (ret.bits > 0) *&mut ret.bits = MAX_U256 - ret.bits + 1;
    ret
  }

  /*
  * @notice It wraps a u128 number into an Int and negates it.  
  * @param value The u128 value to wrap  
  * @return Int. The wrapped value of -value.
  */
  public fun neg_from_u128(value: u128): Int {
    let ret = from_u128(value);
    if (ret.bits > 0) *&mut ret.bits = MAX_U256 - ret.bits + 1;
    ret
  }

  /*
  * @notice It wraps a u256 number into an Int and negates it.  
  * @param value The u256 value to wrap  
  * @return Int. The wrapped value of -value.
  */
  public fun neg_from_u256(value: u256): Int {
    let ret = from_u256(value);
    if (ret.bits > 0) *&mut ret.bits = MAX_U256 - ret.bits + 1;
    ret
  }

  /*
  * @notice It unwraps the value inside Int and casts it to u8.  
  * @param self The Int struct.  
  * @return u8. The inner value cast to u8. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun to_u8(self: Int): u8 {
    assert!(is_positive(self), EConversionUnderflow);
    (self.bits as u8)
  }

  /*
  * @notice It unwraps the value inside Int and casts it to u16.  
  * @param self The Int struct.  
  * @return u16. The inner value cast to u16. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun to_u16(self: Int): u16 {
    assert!(is_positive(self), EConversionUnderflow);
    (self.bits as u16)
  }

  /*
  * @notice It unwraps the value inside Int and casts it to u32.  
  * @param self The Int struct.  
  * @return u32. The inner value cast to u32. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun to_u32(self: Int): u32 {
    assert!(is_positive(self), EConversionUnderflow);
    (self.bits as u32)
  }

  /*
  * @notice It unwraps the value inside Int and casts it to u64.  
  * @param self The Int struct.  
  * @return u64. The inner value cast to u64. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun to_u64(self: Int): u64 {
    assert!(is_positive(self), EConversionUnderflow);
    (self.bits as u64)
  }

  /*
  * @notice It unwraps the value inside Int and casts it to u128.  
  * @param self The Int struct.  
  * @return u128. The inner value cast to u128. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun to_u128(self: Int): u128 {
    assert!(is_positive(self), EConversionUnderflow);
    (self.bits as u128)
  }

  /*
  * @notice It unwraps the value inside Int and casts it to u256.  
  * @param self The Int struct.  
  * @return u256. The inner value cast to u256. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun to_u256(self: Int): u256 {
    assert!(is_positive(self), EConversionUnderflow);
    self.bits
  }

  /*
  * @notice It unwraps the value inside Int and truncates it to u8.  
  * @param self The Int struct.  
  * @return u8. The inner value truncated to u8. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun truncate_to_u8(self: Int): u8 {
    assert!(is_positive(self), EConversionUnderflow);
    ((self.bits & 0xFF) as u8)
  }

  /*
  * @notice It unwraps the value inside Int and truncates it to u16.  
  * @param self The Int struct.  
  * @return u16. The inner value truncated to u16. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun truncate_to_u16(self: Int): u16 {
    assert!(is_positive(self), EConversionUnderflow);
    ((self.bits & 0xFFFF) as u16)
  }

  /*
  * @notice It unwraps the value inside Int and truncates it to u32.  
  * @param self The Int struct.  
  * @return u32. The inner value truncated to u32. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun truncate_to_u32(self: Int): u32 {
    assert!(is_positive(self), EConversionUnderflow);
    ((self.bits & 0xFFFFFFFF) as u32)
  }

  /*
  * @notice It unwraps the value inside Int and truncates it to u64.  
  * @param self The Int struct.  
  * @return u64. The inner value truncated to u64. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun truncate_to_u64(self: Int): u64 {
    assert!(is_positive(self), EConversionUnderflow);
    ((self.bits & 0xFFFFFFFFFFFFFFFF) as u64)
  }

  /*
  * @notice It unwraps the value inside Int and truncates it to u128.  
  * @param self The Int struct.  
  * @return u128. The inner value truncated to u128. 
  *
  * aborts-if 
  *  - x.bits is negative
  */
  public fun truncate_to_u128(self: Int): u128 {
    assert!(is_positive(self), EConversionUnderflow);
    ((self.bits & 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF) as u128)
  }

  // === Public Utility Functions ===   

  /*
  * @notice It flips the sign of Int.  
  * @param self The Int struct.  
  * @return Int. The returned Int will have its signed flipped.  
  */
  public fun flip(self: Int): Int {
    if (is_neg(self)) { abs(self) } else { neg_from_u256(self.bits) } 
  }

  /*
  * @notice It returns the absolute of an Int.  
  * @param self The Int struct.  
  * @return Int. The absolute.  
  */
  public fun abs(self: Int): Int {
    if (is_neg(self)) from_u256((self.bits ^ MAX_U256) + 1) else self
  }

  // === Public Predicate Functions ===   

  /*
  * @notice It checks if an Int is negative.  
  * @param self The Int struct.  
  * @return bool.  
  */
  public fun is_neg(self: Int): bool {
    (self.bits & U256_WITH_FIRST_BIT_SET) != 0
  }

  /*
  * @notice It checks if an Int is zero.  
  * @param self The Int struct.  
  * @return bool.  
  */
  public fun is_zero(self: &Int): bool {
    self.bits == 0
  }

  /*
  * @notice It checks if an Int is positive.  
  * @param self The Int struct.  
  * @return bool.  
  */
  public fun is_positive(self: Int): bool {
    U256_WITH_FIRST_BIT_SET > self.bits
  }


  /*
  * @notice It compared two Int structs.  
  * @param a An Int struct.  
  * @param b An Int struct.  
  * @return 0. a == b.  
  * @return 1. a < b.  
  * @return 2. a > b.    
  */
  public fun compare(a: Int, b: Int): u8 {
    if (a.bits == b.bits) return EQUAL;
    if (is_positive(a)) {
      // A is positive
      if (is_positive(b)) {
      // A and B are positive
        return if (a.bits > b.bits) GREATER_THAN else LESS_THAN
      } else {
      // B is negative
        return GREATER_THAN
      }
    } else {
    // A is negative
      if (is_positive(b)) {
      // A is negative and B is positive
        return LESS_THAN
      } else {
      // A is negative and B is negative
        return if (abs(a).bits > abs(b).bits) LESS_THAN else GREATER_THAN
      }
    }
  }

  /*
  * @notice It checks if a and b are equal.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return bool.  
  */
  public fun eq(a: Int, b: Int): bool {
    compare(a, b) == EQUAL
  }

  /*
  * @notice It checks if a < b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return bool.  
  */
  public fun lt(a: Int, b: Int): bool {
    compare(a, b) == LESS_THAN
  }

  /*
  * @notice It checks if a <= b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return bool.  
  */
  public fun lte(a: Int, b: Int): bool {
    let pred = compare(a, b);
    pred == LESS_THAN || pred == EQUAL
  }

  /*
  * @notice It checks if a > b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return bool.  
  */
  public fun gt(a: Int, b: Int): bool {
    compare(a, b) == GREATER_THAN
  }

  /*
  * @notice It checks if a >= b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return bool.  
  */
  public fun gte(a: Int, b: Int): bool {
    let pred = compare(a, b);
    pred == GREATER_THAN || pred == EQUAL
  }

  // === Math Operations ===

  /*
  * @notice It performs a + b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return Int. The result of a + b.  
  */
  public fun add(a: Int, b: Int): Int {
    if (is_positive(a)) {
    // A is posiyive
      if (is_positive(b)) {
      // A and B are posistive;
        from_u256(a.bits + b.bits)
      } else {
      // A is positive but B is negative
        let b_abs = abs(b);
        if (a.bits >= b_abs.bits) return from_u256(a.bits - b_abs.bits);
        return neg_from_u256(b_abs.bits - a.bits)
      }
    } else {
    // A is negative
      if (is_positive(b)) {
      // A is negative and B is positive
        let a_abs = abs(a);
        if (b.bits >= a_abs.bits) return from_u256(b.bits - a_abs.bits);
        return neg_from_u256(a_abs.bits - b.bits)
      } else {
      // A and B are negative
        neg_from_u256(abs(a).bits + abs(b).bits)
      }
    }
  }

  /*
  * @notice It performs a - b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return Int. The result of a - b.  
  */
  public fun sub(a: Int, b: Int): Int {
    if (is_positive(a)) {
      // A is positive
      if (is_positive(b)) {
      // B is positive
        if (a.bits >= b.bits) return from_u256(a.bits - b.bits); // Return positive
          return neg_from_u256(b.bits - a.bits) // Return negative
      } else {
      // B is negative
        return from_u256(a.bits + abs(b).bits) // Return positive
      }
    } else {
    // A is negative
      if (is_positive(b)) {
        // B is positive
        return neg_from_u256(abs(a).bits + b.bits) // Return negative
      } else {
        // B is negative
        let a_abs = abs(a);
        let b_abs = abs(b);
        if (b_abs.bits >= a_abs.bits) return from_u256(b_abs.bits - a_abs.bits); // Return positive
        return neg_from_u256(a_abs.bits - b_abs.bits) // Return negative
      }
    }
  }

  /*
  * @notice It performs a * b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return Int. The result of a * b.  
  */
  public fun mul(a: Int, b: Int): Int {
    if (is_positive(a)) {
      // A is positive
      if (is_positive(b)) {
        // B is positive
        return from_u256(a.bits * b.bits)// Return positive
      } else {
        // B is negative
        return neg_from_u256(a.bits * abs(b).bits) // Return negative
      }
    } else {
      // A is negative
      if (is_positive(b)) {
        // B is positive
         return neg_from_u256(abs(a).bits * b.bits) // Return negative
      } else {
      // B is negative
        return from_u256(abs(a).bits * abs(b).bits ) // Return positive
      }
    }
  }

  /*
  * @notice It performs a / b rounding down.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return Int. The result of a * b rounding down.  
  */
  public fun div_down(a: Int, b: Int): Int {
    if (is_positive(a)) {
      // A is positive
      if (is_positive(b)) {
        // B is positive
        return from_u256(math256::div_down(a.bits, b.bits)) // Return positive
      } else {
        // B is negative
        return neg_from_u256(math256::div_down(a.bits, abs(b).bits)) // Return negative
      }
    } else {
      // A is negative
      if (is_positive(b)) {
        // B is positive
        return neg_from_u256(math256::div_down(abs(a).bits, b.bits)) // Return negative
      } else {
        // B is negative
        return from_u256(math256::div_down(abs(a).bits, abs(b).bits)) // Return positive
      }
    }    
  }

  /*
  * @notice It performs a / b rounding up.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return Int. The result of a * b rounding up.  
  */
  public fun div_up(a: Int, b: Int): Int {
    if (is_positive(a)) {
      // A is positive
      if (is_positive(b)) {
        // B is positive
        return from_u256(math256::div_up(a.bits, b.bits)) // Return positive
      } else {
        // B is negative
        return neg_from_u256(math256::div_up(a.bits, abs(b).bits)) // Return negative
      }
    } else {
      // A is negative
      if (is_positive(b)) {
        // B is positive
        return neg_from_u256(math256::div_up(abs(a).bits, b.bits)) // Return negative
      } else {
        // B is negative
        return from_u256(math256::div_up(abs(a).bits, abs(b).bits)) // Return positive
      }
    }    
  }  

  /*
  * @notice It performs a % b.  
  * @param a An Int struct.  
  * @param b An Int struct. 
  * @return Int. The result of a % b.  
  */
  public fun mod(a: Int, b: Int): Int {
    let a_abs = abs(a);
    let b_abs = abs(b);

    let result = a_abs.bits % b_abs.bits;

    if (is_neg(a) && result != 0)   neg_from_u256(result) else from_u256(result)
  }

  /*
  * @notice It performs self >> rhs.  
  * @param self An Int struct.  
  * @param rhs The bits to right-hand shift. 
  * @return Int. The result of self >> rhs.  
  */
  public fun shr(self: Int, rhs: u8): Int { 
    Int {
      bits: if (is_positive(self)) {
        self.bits >> rhs
      } else {
        let mask = (1 << ((256 - (rhs as u16)) as u8)) - 1;
        (self.bits >> rhs) | (mask << ((256 - (rhs as u16)) as u8))
      }
    } 
  }     

  /*
  * @notice It performs self >> lhs.  
  * @param self An Int struct.  
  * @param lhs The bits to right-hand shift. 
  * @return Int. The result of self >> lhs.  
  */
  public fun shl(self: Int, lhs: u8): Int {
    Int {
      bits: self.bits << lhs
    } 
  }

  /*
  * @notice It performs a | b.  
  * @param self An Int struct.  
  * @param lhs The bits to right-hand shift. 
  * @return Int. The result of a | b.  
  */
  public fun or(a: Int, b: Int): Int {
    Int {
      bits: a.bits | b.bits
    } 
  }

  /*
  * @notice It performs a & b.  
  * @param self An Int struct.  
  * @param lhs The bits to right-hand shift. 
  * @return Int. The result of a & b.  
  */
  public fun and(a: Int, b: Int): Int {
    Int {
      bits: a.bits & b.bits
    } 
  }
}