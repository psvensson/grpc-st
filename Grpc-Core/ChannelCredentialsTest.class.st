Class {
	#name : #ChannelCredentialsTest,
	#superclass : #TestCase,
	#instVars : [
		'rootCerts',
		'privateKey',
		'certChain',
		'verifyOptions'
	],
	#category : #'Grpc-Core-Tests'
}

{ #category : #tests }
ChannelCredentialsTest >> testCreateInsecure [
	| creds |
	creds := ChannelCredentials createInsecure .
	self assert: creds _getConnectionOptions equals: nil
]

{ #category : #tests }
ChannelCredentialsTest >> testCreateSslNoArgs [
	| creds |
	"This test will fail for now, since there is no way currently of even setting root certs with SqueakSSL"
	creds := ChannelCredentials createSslRootCerts: nil 
										privateKey: nil 
										certChain: nil 
										verifyOptions: nil .
	self assert: (creds _getConnectionOptions isNil) not equals: true
]
