# Design Rules

### Suitears💧follows [Sui's framework API](https://github.com/MystenLabs/sui/tree/main/crates/sui-framework/packages/sui-framework) to facilitate integrations and contributions.

- **Comment the sections of your code in the order below.**

  ```Move
  module suitears::wallet {
      // === Imports ===

      // === Constants ===

      // === Errors ===

      // === Structs ===

      // === Public-View Functions ===

      // === Public-Mutative Functions ===

      // === Public-Friend Functions ===

      // === Admin Functions ===

      // === Private Functions ===

      // === Test Functions ===
  }
  ```

- **When applicable, CRUD functions must be called:**

  - add
  - new
  - drop
  - empty
  - remove
  - exists
  - contains
  - property_name
  - destroy_empty
  - to_object_name
  - from_object_name
  - borrow_property_name
  - borrow_mut_property_name

- **Do not call structs as \*Potato. It is a pattern recognized by the lack of abilities:**

  ```Move
  module suitears::request {

      // ✅ Right
      struct Lock {}

      // ❌ Wrong
      struct RequestPotato {}
  }
  ```

- **Be mindful of the dot syntax when naming functions. Avoid using the object name on function names.**

  ```Move
  module suitears::lib{


      struct Profile {
        age: u64
      }

      // ✅ Right
      public fun age(self: &Profile):  u64 {
        self.age
      }

      // ❌ Wrong
      public fun profile_age(self: &Profile): u64 {
        self.age
      }

  }

  module amm::airdrop {
    use suitears::lib::{Self, Profile};

    public fun get_tokens(profile: &Profile) {

      // ✅ Right
      let name = profile.age();

      // ❌ Wrong
      let name2 = profile.profile_age();
    }
  }
  ```

- **Functions that create objects must be called new.**

  ```Move
  module suitears::object {

    struct Object has key, store {
        id: UID
    }

    public fun new(ctx:&mut TxContext): Object {}

  }
  ```

- **Functions that create data structures must be called empty.**

  ```Move
  module suitears::data_structure {

      struct DataStructure has copy, drop, store {
          bits: vector<u8>
       }

      public fun empty(): DataStructure {}

  }
  ```

- **Shared objects must be created via a new function and be shared in a separate function. The share function must be named share.**

  ```Move
  module suitears::profile {

      struct Profile has key {
          id: UID
      }

      public fun new(ctx:&mut TxContext): Profile {}

      public fun share(profile: Profile) {}

  }
  ```

- **Functions that return a reference must be named borrow_property_name or borrow_mut_property_name.**

  ```Move
  module suitears::profile {

      struct Profile has key {
          id: UID,
          name: String,
          age: u8
      }

      public fun borrow_name(self: &Profile): &String {}

      public fun borrow_mut_age(self: &mut Profile): &mut u8 {}

  }
  ```

- **Modules must be designed around one Object or Data Structure. A variant structure should have its own module to avoid complexity and bugs.**

  ```Move
  module suitears::wallet {
      struct Wallet has key, store {
          id: UID,
          amount: u64
      }
  }

  module suitears::claw_back_wallet {
      struct Wallet has key {
          id: UID,
          amount: u64
      }
  }
  ```

- **Comment functions with tags and refer to parameters name with ``.**

  - notice: An explanation to the user
  - dev: An explanation to developers
  - param: It must be followed by the param name and a description
  - return: Name and type of the return
  - aborts-if: Describe the abort conditions

  &nbsp;

  ```Move
  module suitears::math {

      /*
      * @notice It divides `x` by `y`.
      *
      * @dev It rounds down.
      *
      * @param x The numerator in the division
      * @param y the denominator in the division
      * @return u64 The result of dividing `x` by `y`
      *
      * @aborts-if
      *   - `y` is zero
      */
      public fun div(x: u64, y: u64): u64 {
          assert!(y != 0, 0);
          x / y
      }

  }
  ```

- **Errors must be CamelCase, start with an E and be descriptive.**

  ```Move
  module suitears::profile {
      // ✅ Right
      const ENameHasMaxLengthOf64Chars: u64 = 0;

      // ❌ Wrong
      const INVALID_NAME: u64 = 0;
  }
  ```

- **Describe the properties of your structs.**

  ```Move
  module suitears::profile {
      struct Profile has key, store {
          id: UID,
          // The age of the user
          age: u8,
          // The first name of the user
          name: String
      }
  }
  ```

- **Provide functions to delete objects and structs. Empty objects must be destroyed with the function destroy_empty. The function drop must be used for objects that have types that can be dropped.**

  ```Move
  module suitears::wallet {
      struct Wallet<Value> {
          id: UID,
          value: Value
      }

      // Value has drop
      public fun drop<Value: drop>(wallet: &mut Wallet<Value>) {}

      // Value doesn't have drop
      public fun destroy_empty<Value>(wallet: &mut Wallet<Value>) {}
  }
  ```

- **Keep your functions pure to maintain composability. Do not use `transfer::transfer` or `transfer::public_transfer` inside core functions.**

  ```Move
  module suitears::amm {
      struct Pool has key {
        id: UID
      }

      // ✅ Right
      // Return the excess coins even if they have zero value.
      public fun add_liquidity<CoinX, CoinY, LP_Coin>(pool: &mut Pool, coin_x: Coin<CoinX>, coin_y: Coin<CoinY>): (Coin<LpCoin>, Coin<CoinX>, Coin<CoinY>) {}

      // ✅ Right
      public fun entry_add_liquidity<CoinX, CoinY, LP_Coin>(pool: &mut Pool, coin_x: Coin<CoinX>, coin_y: Coin<CoinY>, ctx: &mut TxContext) {
        let (lp_coin, coin_x, coin_y) = add_liquidity(pool, coin_x, coin_y);
        transfer::public_transfer(lp_coin, tx_context::sender(ctx));
        transfer::public_transfer(coin_x, tx_context::sender(ctx));
        transfer::public_transfer(coin_y, tx_context::sender(ctx));
      }

      // ❌ Wrong
      public fun add_liquidity<CoinX, CoinY, LP_Coin>(pool: &mut Pool, coin_x: Coin<CoinX>, coin_y: Coin<CoinY>, ctx: &mut TxContext): Coin<LpCoin> {
        transfer::public_transfer(coin_x, tx_context::sender(ctx));
        transfer::public_transfer(coin_y, tx_context::sender(ctx));

        coin_lp
      }
  }
  ```

- **Do not pass mutable references of coins. Move the whole coin.**

  ```Move
  module suitears::amm {
      struct Pool has key {
        id: UID
      }

      // ✅ Right
      public fun swap<CoinX, CoinY>(coin_in: Coin<CoinX>): Coin<CoinY> {}

      // ❌ Wrong
      public fun swap<CoinX, CoinY>(coin_in: &mut Coin<CoinX>): Coin<CoinY> {}
  }
  ```

- **Do not store the user's account data in a hashmap - e.g. (Table/Bag/VecSet). Create an object and return it to the user.**

  ```Move
  module suitears::social_network {
      struct Account has key {
        id: UID,
        name: String
      }

      struct State has key {
        id: UID,
        accounts: Table<address, String>
      }

      // ✅ Right
      public fun new(name: String): Account {}

      // ❌ Wrong
      public fun new(state: &mut State, name: String) {}
  }
  ```

- **The first argument should be the object being mutated. It fits nicely with the dot notation. It usually happens in admin functions.**

  ```Move
  module suitears::social_network {
      struct Account has key {
        id: UID,
        name: String
      }

      struct Admin has key {
        id: UID,
      }

      // ✅ Right
      public fun update(account: &mut Account, _: &Admin, new_name: String) {}

      // ❌ Wrong
      public fun update(_: &Admin, account: &mut Account, new_name: String) {}
  }
  ```
