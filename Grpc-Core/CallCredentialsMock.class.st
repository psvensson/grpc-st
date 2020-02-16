Class {
	#name : #CallCredentialsMock,
	#superclass : #CallCredentials,
	#instVars : [
		'child'
	],
	#category : #'Grpc-Core-Tests'
}

{ #category : #testing }
CallCredentialsMock >> _equals: other [
	child ifNil: [ ^ other = self ].
	(other isNil or: other child isNil)
		ifTrue: [ ^ false ].
	^ child _equals: other child
]

{ #category : #accessing }
CallCredentialsMock >> child [
	^ child
]

{ #category : #accessing }
CallCredentialsMock >> child: anObject [
	anObject isNil
		ifFalse: [ child := anObject ]
]

{ #category : #generating }
CallCredentialsMock >> compose: callCredentials [
	| newMock |
	newMock := self class new.
	newMock creds: callCredentials .
	^ newMock
]

{ #category : #generating }
CallCredentialsMock >> generateMetadata: options [ 
	| ex |
	ex := Exception new.
	ex messageText: 'Not implemented'.
	ex signal.
]
