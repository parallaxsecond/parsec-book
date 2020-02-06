<!--
  -- Copyright (c) 2019, Arm Limited, All Rights Reserved
  -- SPDX-License-Identifier: Apache-2.0
  --
  -- Licensed under the Apache License, Version 2.0 (the "License"); you may
  -- not use this file except in compliance with the License.
  -- You may obtain a copy of the License at
  --
  -- http://www.apache.org/licenses/LICENSE-2.0
  --
  -- Unless required by applicable law or agreed to in writing, software
  -- distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
  -- WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  -- See the License for the specific language governing permissions and
  -- limitations under the License.
--->
# PSA Crypto Key Attributes

## Key Type and Algorithm

Types of cryptographic keys and cryptographic algorithms are encoded separately. Each is encoded as a field in the *Key Attributes* structure.

There is some overlap in the information conveyed by key types and algorithms. Both types contain enough information, so that the meaning of an algorithm type value does not depend on what type of key it is used with, and vice versa. However, the particular instance of an algorithm may depend on the key type. For example, the *AEAD Algorithm* `GCM` can be instantiated as any AEAD algorithm using the GCM mode over a block cipher. The underlying block cipher is determined by the key type.

Key types do not encode the key size. For example, AES-128, AES-192 and AES-256 share a key type `AES_Key`.

**Important notice:** The attributes mentioned on this page are only the ones currently supported by Parsec (i.e. is recognised as a valid parameter for some operations by at least one provider), not those defined by the [PSA crypto API specification](https://armmbed.github.io/mbed-crypto/PSA_Cryptography_API_Specification.pdf). The plan is for the former to converge towards the latter.

### Key Type

* **RsaKeypair** - RSA key pair (private and public key).
* **RsaPublicKey** - RSA public key.

### Algorithm

#### Asymmetric signing

 **RsaPkcs1v15Sign** - The RSA PKCS v1.5 digital signature scheme as defined in [RFC 3447](https://tools.ietf.org/html/rfc3447#section-8.2).

#### Hashing

 **Sha256** - Secure Hash Algorithm with 256 bit digest size as defined in [RFC 4634](https://tools.ietf.org/html/rfc4634)

## Other Attributes

* **Key Size** - Determines the size of the key in bits. This must be used for choosing key sizes for both symmetric and asymmetric keys.
* **Permit Export** - Determines whether the key material can be exported.
* **Permit Sign** - Determines whether the key can be used to compute a digital signature.
* **Permit Verify** - Determines whether the key can be used to verify a digital signature.
