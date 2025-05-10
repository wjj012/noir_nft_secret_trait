# Noir ZK Proof for NFT Secret Trait Verification

This project demonstrates a Zero-Knowledge proof using Noir that allows an NFT owner to prove their NFT possesses a specific, potentially hidden or special trait, without revealing other metadata or the raw secret defining that trait. This can be used for selective disclosure, game integrations based on hidden NFT attributes, or access control.

## Core Concept

An NFT owner wants to prove their NFT (identified by `nft_id`) has a particular trait represented by a `target_trait_commitment`.
1.  The owner has a private `owner_secret` to prove control over the `nft_id`.
2.  The NFT has an associated `nft_specific_salt` (could be part of private metadata or derived).
3.  The specific trait is defined by a `trait_secret_value`.
4.  The `target_trait_commitment` is `hash(nft_id, nft_specific_salt, trait_secret_value)`. This commitment is what verifiers look for.

The ZK circuit allows the NFT owner to prove:
*   They know the `owner_secret` that corresponds to `hash(owner_secret, nft_id)` (simplified ownership proof).
*   The combination of their `nft_id`, its `nft_specific_salt`, and their private `trait_secret_value` correctly hashes to the `target_trait_commitment`.

This verifies that the prover owns the specific NFT and that this NFT indeed has the trait in question.

## Project Structure

(Standard Noir project structure)

## Circuit Logic (`src/main.nr`)

The Noir circuit takes:
*   **Private Inputs**: `owner_secret`, `nft_specific_salt`, `trait_secret_value`.
*   **Public Inputs**: `nft_id`, `claimed_ownership_proof`, `target_trait_commitment`.

It constrains:
1.  `claimed_ownership_proof` equals `pedersen_hash([owner_secret, nft_id])`.
2.  `target_trait_commitment` equals `pedersen_hash([nft_id, nft_specific_salt, trait_secret_value])`.

## Prerequisites

*   **Nargo**: Noir's package manager. Install from [official documentation](https://noir-lang.org/docs/getting_started/installation/).

## How to Run

1.  **Setup Project**: Create files and structure.
2.  **Crucial: Update Hash Placeholders**: The `claimed_ownership_proof` and `target_trait_commitment` in `Prover.toml` and `Verifier.toml` are **placeholders**. Recompute them using the private inputs in `Prover.toml` and the `pedersen_hash` logic.
3.  **Compile**: `nargo compile`
4.  **Generate Proof**: `nargo prove`
5.  **Verify Proof**: `nargo verify`

## Applications

*   **Gated Access**: Unlock content/features if an NFT has a specific hidden trait.
*   **NFT Gaming**: Verify in-game abilities tied to secret NFT attributes without revealing them on-chain prematurely.
*   **Selective Disclosure**: Prove one specific trait without showing all NFT metadata.
*   **Verifiable Randomness/Minting**: Prove a minted NFT received a rare trait based on a secret seed.