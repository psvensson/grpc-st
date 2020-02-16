Class {
	#name : #SecureChannelCredentialsImpl,
	#superclass : #ChannelCredentials,
	#instVars : [
		'rootCerts',
		'privateKey',
		'certChain',
		'verifyOptions',
		'connectionOptions'
	],
	#category : #'Grpc-Core-Credentials'
}

{ #category : #generating }
SecureChannelCredentialsImpl >> _equals: other [
	self = other ifTrue: [^ true].
	self privateKey = other privateKey ifTrue: [ ^ true ].
	^ false
]

{ #category : #generating }
SecureChannelCredentialsImpl >> _getConnectionOptions [
	^ connectionOptions
]

{ #category : #generating }
SecureChannelCredentialsImpl >> _isSecure [
	^ true
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> certChain [
	^ certChain
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> certChain: anObject [
	certChain := anObject
]

{ #category : #generating }
SecureChannelCredentialsImpl >> compose: callCredentials [
	| combinedCallsCredentials composed |
	combinedCallsCredentials := callCredentials compose: callCredentials .
	composed := ComposedChannelCredentialsImpl with: channelCredentials and: combinedCallsCredentials.
	^ composed.
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> connectionOptions: anObject [
	connectionOptions := anObject
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> initialize [ 
	"Due to shortcoming in the SqueakSSL crypto plugin, we wil only be using the path to a certificate a 'privateKey'"
	super initialize.
	
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> privateKey [
	^ privateKey
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> privateKey: anObject [
	privateKey := anObject
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> rootCerts [
	^ rootCerts
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> rootCerts: anObject [
	rootCerts := anObject
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> verifyOptions [
	^ verifyOptions
]

{ #category : #accessing }
SecureChannelCredentialsImpl >> verifyOptions: aBlock [
	verifyOptions := aBlock
]
