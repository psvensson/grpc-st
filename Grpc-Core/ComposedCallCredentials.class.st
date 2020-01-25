Class {
	#name : #ComposedCallCredentials,
	#superclass : #CallCredentials,
	#category : #'Grpc-Core-Credentials'
}

{ #category : #testing }
ComposedCallCredentials >> _equals: other [
	self = other ifTrue: [^ true].
	(other isKindOf: ComposedCallCredentials) ifTrue: [ 
		creds doWithIndex: [ :each :index | 
			(each = other creds at: index) ifFalse: [ ^ false ] ].
		^true ] ifFalse: [ ^ false ]
]

{ #category : #generating }
ComposedCallCredentials >> compose: callCredentials [
	
	| composed |
	composed := ComposedCallCredentials new.
	composed creds: creds,callCredentials .
	^ composed
]

{ #category : #generating }
ComposedCallCredentials >> generateMetadata: options [
	| base generated |
	base := MetaData new.
	generated := GrpcUtil
		futuresAll:
			(creds collect: [ :cred | [ cred generateMetadata: options ] future ]).
	generated do: [ :each | base merge: each ].
	^ base
]
