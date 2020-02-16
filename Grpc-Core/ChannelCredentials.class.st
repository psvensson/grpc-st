"
The porting of this class has presented some har challenges, du to the meagre crypto API exposed by SquakSSL at the time of this writing (January 2020).

The only way to engage with certificates is by giving a path to a file (or, in the case of windows, by giving a name of a registered certificate).

Therefore, this class will be simplified using just one certificate reference as 'privateKey' which will be the path to the cert file or windows name as the case may be.
"
Class {
	#name : #ChannelCredentials,
	#superclass : #Object,
	#instVars : [
		'channelCredentials',
		'callCredentials'
	],
	#category : #'Grpc-Core-Credentials'
}

{ #category : #creating }
ChannelCredentials class >> createInsecure [
	^ InsecureChannelCredentialsImpl new
]

{ #category : #creating }
ChannelCredentials class >> createSslRootCerts: rootCerts privateKey: privateKey certChain: certChain verifyOptions: verifyOptions [
	| rc secureChannel |
	GrpcUtil
		verifyIsBufferOrNull: rootCerts
		friendlyName: 'Root Certificates'.
	GrpcUtil verifyIsBufferOrNull: privateKey friendlyName: 'PrivateKey'.
	GrpcUtil
		verifyIsBufferOrNull: certChain
		friendlyName: 'Certificate Chain'.
	(privateKey isNil not and: certChain isNil)
		ifTrue: [ GrpcUtil
				throw: 'Private key must be given with accompanying certificate chain' ].
	(privateKey isNil and: certChain isNil not)
		ifTrue: [ GrpcUtil
				throw: 'Certificate chain must be given with accompanying private key' ].
	rc := rootCerts isNil
		ifTrue: [ GrpcUtil getDefaultRootsData ]
		ifFalse: [ rootCerts ].
	secureChannel := SecureChannelCredentialsImpl new.
	secureChannel
		rootCerts: rootCerts;
		privateKey: nil;
		certChain: nil;
		verifyOptions: Dictionary new.
	^ secureChannel 	
]

{ #category : #generating }
ChannelCredentials >> _equals: other [
	^ self subclassResponsibility
]

{ #category : #accessing }
ChannelCredentials >> _getCallCredentials [
	^ callCredentials 
]

{ #category : #generating }
ChannelCredentials >> _getConnectionOptions [
	^ self subclassResponsibility
]

{ #category : #generating }
ChannelCredentials >> _isSecure [
	^ self subclassResponsibility
]

{ #category : #accessing }
ChannelCredentials >> channelCredentials [
	^ channelCredentials
]

{ #category : #accessing }
ChannelCredentials >> channelCredentials: anObject [
	channelCredentials := anObject
]

{ #category : #generating }
ChannelCredentials >> compose: credentials [
	^ self subclassResponsibility
]

{ #category : #generating }
ChannelCredentials >> initialize [ 	
	callCredentials := CallCredentials createEmpty 
]
