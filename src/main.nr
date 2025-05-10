// src/main.nr
// ZK Proof for Verifying an NFT's Secret Trait

use dep::std::hash::pedersen_hash;

// This circuit allows an NFT owner to prove their NFT possesses a specific,
// potentially hidden or special trait, without revealing the trait's raw data
// or other NFT metadata. The trait is identified by a commitment.

fn main(
    // === Private Inputs (Known to the NFT owner) ===
    owner_secret: Field,            // Secret key proving ownership of the NFT.
    nft_specific_salt: Field,       // A salt unique to this NFT, used in trait commitment.
                                    // Could be derived from nft_id or part of private metadata.
    trait_secret_value: Field,      // The secret value that defines/unlocks the specific trait.
                                    // e.g., a seed for a rare property.

    // === Public Inputs ===
    nft_id: pub Field,              // The public unique identifier of the NFT.
    
    // Commitment to the owner's control over the NFT.
    // e.g., hash(owner_secret, nft_id) or hash(owner_secret, nft_id, blinding_factor)
    // For simplicity, we'll use hash(owner_secret, nft_id).
    claimed_ownership_proof: pub Field, 

    // The public commitment that represents the specific trait being verified.
    // This value is known to verifiers looking for this specific trait.
    // e.g., hash(nft_id, nft_specific_salt, trait_secret_value)
    target_trait_commitment: pub Field
) {
    // --- 1. Verify NFT Ownership (Simplified) ---
    // Prove that the prover knows the owner_secret for this nft_id.
    // A more robust ownership proof might involve a blinding factor.
    let computed_ownership_proof = pedersen_hash([owner_secret, nft_id]);
    constrain computed_ownership_proof == claimed_ownership_proof;

    // --- 2. Verify Trait Existence / Secret Trait Value ---
    // Prove that the NFT (identified by nft_id and its unique salt) combined with
    // the private trait_secret_value results in the target_trait_commitment.
    // This means this NFT, with this salt, and this specific secret value,
    // indeed possesses the trait represented by target_trait_commitment.
    let computed_trait_commitment = pedersen_hash([
        nft_id,
        nft_specific_salt,
        trait_secret_value
    ]);
    constrain computed_trait_commitment == target_trait_commitment;

    // If both constraints pass, the prover owns the NFT and this NFT has the
    // specific (potentially hidden) trait represented by target_trait_commitment.

    // println("NFT Secret Trait proof validated for NFT ID: {}", nft_id);
    // println("  Verified Trait Commitment: {}", target_trait_commitment);
}