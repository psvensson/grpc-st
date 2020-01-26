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
	composed creds: creds, (callCredentials creds) .
	^ composed
]

{ #category : #generating }
ComposedCallCredentials >> createMetadata: options [
	| base |
	Transcript show:'ComposedCallCredential generateMetadata options: ',(options asString);cr.
	base := MetaData new.
	( GrpcUtil
		futuresAll:
			(creds collect: [ :cred | [ cred generateMetadata: options ] future ]) )
	onSuccessDo: [ :generated | generated do: [ :each | base merge: each ]].
	^ base
]

{ #category : #generating }
ComposedCallCredentials >> generateMetadata: options [
	
	^ [self createMetadata: options] future
]
