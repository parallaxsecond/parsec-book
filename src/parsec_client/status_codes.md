# Response Status Codes

The value 0, `Success`, is for a successful operation.

## Service Internal Response Status Codes

These codes originate in components in the service outside of the `Provide` trait implementation by
the providers.

| Response Status Code              | Value | Descrption                                                    |
|-----------------------------------|-------|---------------------------------------------------------------|
| `WrongProviderID`                 | 1     | Requested provider ID does not match that of the backend      |
| `ContentTypeNotSupported`         | 2     | Requested content type is not supported by the backend        |
| `AcceptTypeNotSupported`          | 3     | Requested accept type is not supported by the backend         |
| `WireProtocolVersionNotSupported` | 4     | Requested version is not supported by the backend             |
| `ProviderNotRegistered`           | 5     | No provider registered for the requested provider ID          |
| `ProviderDoesNotExist`            | 6     | No provider defined for requested provider ID                 |
| `DeserializingBodyFailed`         | 7     | Failed to deserialize the body of the message                 |
| `SerializingBodyFailed`           | 8     | Failed to serialize the body of the message                   |
| `OpcodeDoesNotExist`              | 9     | Requested operation is not defined                            |
| `ResponseTooLarge`                | 10    | Response size exceeds allowed limits                          |
| `AuthenticationError`             | 11    | Authentication failed                                         |
| `AuthenticatorDoesNotExist`       | 12    | Authenticator not supported                                   |
| `AuthenticatorNotRegistered`      | 13    | Authenticator not supported                                   |
| `KeyInfoManagerError`             | 14    | Internal error in the Key Info Manager                        |
| `ConnectionError`                 | 15    | Generic input/output error                                    |
| `InvalidEncoding`                 | 16    | Invalid value for this data type                              |
| `InvalidHeader`                   | 17    | Constant fields in header are invalid                         |
| `WrongProviderUuid`               | 18    | The UUID vector needs to only contain 16 bytes                |
| `NotAuthenticated`                | 19    | Request did not provide a required authentication             |
| `BodySizeExceedsLimit`            | 20    | Request length specified in the header is above defined limit |

## PSA Response Status Codes

These codes originate from within the `Provide` trait implementation.

| Response Status Code           | Value | Descrption                                                                          |
|--------------------------------|-------|-------------------------------------------------------------------------------------|
| `PsaErrorGenericError`         | 1132  | An error occurred that does not correspond to any defined failure cause             |
| `PsaErrorNotPermitted`         | 1133  | The requested action is denied by a policy                                          |
| `PsaErrorNotSupported`         | 1134  | The requested operation or a parameter is not supported by this implementation      |
| `PsaErrorInvalidArgument`      | 1135  | The parameters passed to the function are invalid                                   |
| `PsaErrorInvalidHandle`        | 1136  | The key handle is not valid                                                         |
| `PsaErrorBadState`             | 1137  | The requested action cannot be performed in the current state                       |
| `PsaErrorBufferTooSmall`       | 1138  | An output buffer is too small                                                       |
| `PsaErrorAlreadyExists`        | 1139  | Asking for an item that already exists                                              |
| `PsaErrorDoesNotExist`         | 1140  | Asking for an item that doesn't exist                                               |
| `PsaErrorInsufficientMemory`   | 1141  | There is not enough runtime memory                                                  |
| `PsaErrorInsufficientStorage`  | 1142  | There is not enough persistent storage available                                    |
| `PsaErrorInssuficientData`     | 1143  | Insufficient data when attempting to read from a resource                           |
| `PsaErrorCommunicationFailure` | 1145  | There was a communication failure inside the implementation                         |
| `PsaErrorStorageFailure`       | 1146  | There was a storage failure that may have led to data loss                          |
| `PsaErrorHardwareFailure`      | 1147  | A hardware failure was detected                                                     |
| `PsaErrorInsufficientEntropy`  | 1148  | There is not enough entropy to generate random data needed for the requested action |
| `PsaErrorInvalidSignature`     | 1149  | The signature, MAC or hash is incorrect                                             |
| `PsaErrorInvalidPadding`       | 1150  | The decrypted padding is incorrect                                                  |
| `PsaErrorCorruptionDetected`   | 1151  | A tampering attempt was detected                                                    |
| `PsaErrorDataCorrupt`          | 1152  | Stored data has been corrupted                                                      |

*Copyright 2019 Contributors to the Parsec project.*
