# Response Status Codes

- **Success** (value: 0) - successful operation
- **WrongProviderID** (value: 1) - requested provider ID does not match that of the backend
- **ContentTypeNotSupported** (value: 2) - requested content type is not supported by the backend
- **AcceptTypeNotSupported** (value: 3) - requested accept type is not supported by the backend
- **VersionTooBig** (value: 4) - requested version is not supported by the backend
- **ProviderNotRegistered** (value: 5) - no provider registered for the requested provider ID
- **ProviderDoesNotExist** (value: 6) - no provider defined for requested provider ID
- **DeserializingBodyFailed** (value: 7) - failed to deserialize the body of the message
- **SerializingBodyFailed** (value: 8) - failed to serialize the body of the message
- **OpcodeDoesNotExist** (value: 9) - requested operation is not defined
- **ResponseTooLarge** (value: 10) - response size exceeds allowed limits
- **AuthenticationError** (value: 11) - authentication failed
- **AuthenticatorDoesNotExist** (value: 12) - authenticator not supported
- **AuthenticatorNotRegistered** (value: 13) - authenticator not supported
- **KeyIDManagerError** (value: 14) - internal error in the Key ID Manager
- **ConnectionError** (value: 15) - generic input/output error
- **InvalidEncoding** (value: 16) - invalid value for this data type
- **InvalidHeader** (value: 17) - constant fields in header are invalid
- **WrongProviderUuid** (value: 18) - the UUID vector needs to only contain 16 bytes
- **NotAuthenticated** (value: 19) - request did not provide a required authentication
- **BodySizeExceedsLimit** (value: 20) - request length specified in the header is above defined
   limit
- **PsaErrorGenericError** (value: 1132) - an error occurred that does not correspond to any defined
   failure cause
- **PsaErrorNotPermitted** (value: 1133) - the requested action is denied by a policy
- **PsaErrorNotSupported** (value: 1134) - the requested operation or a parameter is not supported
   by this implementation
- **PsaErrorInvalidArgument** (value: 1135) - the parameters passed to the function are invalid
- **PsaErrorInvalidHandle** (value: 1136) - the key handle is not valid
- **PsaErrorBadState** (value: 1137) - the requested action cannot be performed in the current state
- **PsaErrorBufferTooSmall** (value: 1138) - an output buffer is too small
- **PsaErrorAlreadyExists** (value: 1139) - asking for an item that already exists
- **PsaErrorDoesNotExist** (value: 1140) - asking for an item that doesn't exist
- **PsaErrorInsufficientMemory** (value: 1141) - there is not enough runtime memory
- **PsaErrorInsufficientStorage** (value: 1142) - there is not enough persistent storage available
- **PsaErrorInssuficientData** (value: 1143) - insufficient data when attempting to read from a
   resource
- **PsaErrorCommunicationFailure** (value: 1145) - there was a communication failure inside the
   implementation
- **PsaErrorStorageFailure** (value: 1146) - there was a storage failure that may have led to data
   loss
- **PsaErrorHardwareFailure** (value: 1147) - a hardware failure was detected
- **PsaErrorInsufficientEntropy** (value: 1148) - there is not enough entropy to generate random
   data needed for the requested action
- **PsaErrorInvalidSignature** (value: 1149) - the signature, MAC or hash is incorrect
- **PsaErrorInvalidPadding** (value: 1150) - the decrypted padding is incorrect
- **PsaErrorTamperingDetected** (value: 1151) - a tampering attempt was detected

*Copyright (c) 2019, Arm Limited. All rights reserved.*
