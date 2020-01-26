Class {
	#name : #SingleCallCredentials,
	#superclass : #CallCredentials,
	#category : #'Grpc-Core-Credentials'
}

{ #category : #testing }
SingleCallCredentials >> _equals: other [
	self = other
		ifTrue: [ ^ true ].
	(other isKindOf: SingleCallCredentials)
		ifTrue: [ ^ metadataGenerator = other metadataGenerator ].
	^ false
]

{ #category : #generating }
SingleCallCredentials >> compose: other [
	| newComposedCallCredentials |
	newComposedCallCredentials := ComposedCallCredentials new.
	newComposedCallCredentials
		creds: (OrderedCollection with: self with: other).
	^ newComposedCallCredentials
]

{ #category : #generating }
SingleCallCredentials >> createMetaData: options [
	metadataGenerator
		value: options
		value: [ :err :metadata | 
			metadata isNil
				ifFalse: [ ^ metadata ]
				ifTrue: [ Error signal ] ]
]

{ #category : #generating }
SingleCallCredentials >> generateMetadata: options [
	Transcript show:'SingleCallCredential generateMetadata options: ',(options asString);cr.
	^ ([ self createMetaData: options ] future)
]
