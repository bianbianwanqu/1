module suitears::airdrop_utils {
  use std::vector;
  
  use sui::bcs;
  use sui::hash;
  use sui::tx_context::{Self, TxContext};

  use suitears::merkle_proof;

  const EInvalidProof: u64 = 0;

  public fun verify(
    root: vector<u8>,
    proof: vector<vector<u8>>, 
    amount: u64, 
    ctx: &mut TxContext
  ): u256 {
    let sender = tx_context::sender(ctx);
    let payload = bcs::to_bytes(&sender);

    vector::append(&mut payload, bcs::to_bytes(&amount));

    let leaf = hash::keccak256(&payload);
    let (pred, index) = merkle_proof::verify_with_index(&proof, root, leaf);
    
    assert!(pred, EInvalidProof);
    index 
  }
}