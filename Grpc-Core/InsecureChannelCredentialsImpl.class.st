Class {
	#name : #InsecureChannelCredentialsImpl,
	#superclass : #ChannelCredentials,
	#category : #'Grpc-Core-Credentials'
}

{ #category : #generating }
InsecureChannelCredentialsImpl >> _equals: other [
	^ other isKindOf: InsecureChannelCredentialsImpl 
]

{ #category : #generating }
InsecureChannelCredentialsImpl >> _getConnectionOptions [
	^ nil
]

{ #category : #generating }
InsecureChannelCredentialsImpl >> _isSecure [
	^ false
]

{ #category : #generating }
InsecureChannelCredentialsImpl >> compose: credentials [
	GrpcUtil throw: 'Cannot compose insecure credentials'
]
