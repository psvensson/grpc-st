Class {
	#name : #ComposedChannelCredentialsImpl,
	#superclass : #ChannelCredentials,
	#instVars : [
		'callCreds',
		'channelCredentials'
	],
	#category : #'Grpc-Core-Credentials'
}

{ #category : #'as yet unclassified' }
ComposedChannelCredentialsImpl class >> with: chanCreds and: calcreds [
	| instance |
	instance := self class new.
	instance channelCredentials: chanCreds; callCredentials: calcreds.
	^ instance  
]

{ #category : #generating }
ComposedChannelCredentialsImpl >> _equals: other [
	self = other ifTrue: [^ true].
	(other isKindOf: self class) ifTrue: [ 
		^( (channelCredentials _equals: other channelCredentials) 
			and: (callCredentials _equals: other callCredentials ) ) ]
]

{ #category : #generating }
ComposedChannelCredentialsImpl >> _getConnectionOptions [
	^ channelCredentials _getConnectionOptions 
]

{ #category : #generating }
ComposedChannelCredentialsImpl >> _isSecure [
	^ true
]

{ #category : #accessing }
ComposedChannelCredentialsImpl >> callCredentials [
	^ callCredentials
]

{ #category : #accessing }
ComposedChannelCredentialsImpl >> callCredentials: anObject [
	callCredentials := anObject
]

{ #category : #accessing }
ComposedChannelCredentialsImpl >> channelCredentials [
	^ channelCredentials
]

{ #category : #accessing }
ComposedChannelCredentialsImpl >> channelCredentials: anObject [
	channelCredentials := anObject
]

{ #category : #generating }
ComposedChannelCredentialsImpl >> compose: credentials [
	| combinedCallsCredentials composed |
	combinedCallsCredentials := (self callCredentials) compose: credentials .
	composed := self class with: channelCredentials and: combinedCallsCredentials.
	^ composed.
]
