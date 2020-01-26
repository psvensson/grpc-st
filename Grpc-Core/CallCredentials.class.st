Class {
	#name : #CallCredentials,
	#superclass : #Object,
	#instVars : [
		'metadataGenerator',
		'creds'
	],
	#category : #'Grpc-Core-Credentials'
}

{ #category : #'as yet unclassified' }
CallCredentials class >> createEmpty [
	^ EmptyCallCredentials new
]

{ #category : #'as yet unclassified' }
CallCredentials class >> createFromMetadataGenerator: metadataGenerator [
	| creds |
	creds := SingleCallCredentials new.
	creds metadataGenerator: metadataGenerator.
	^ creds
]

{ #category : #testing }
CallCredentials >> _equals: other [
	^ self subclassResponsibility
]

{ #category : #generating }
CallCredentials >> compose: callCredentials [
	^ self subclassResponsibility
]

{ #category : #accessing }
CallCredentials >> creds [
	^ creds
]

{ #category : #accessing }
CallCredentials >> creds: anObject [
	creds := anObject
]

{ #category : #generating }
CallCredentials >> generateMetadata: options [ 
	^ self subclassResponsibility
]

{ #category : #initialization }
CallCredentials >> initialize [
	creds := OrderedCollection new.
	
]

{ #category : #accessing }
CallCredentials >> metadataGenerator [
	^ metadataGenerator
]

{ #category : #accessing }
CallCredentials >> metadataGenerator: aMetadataGenerator [
	metadataGenerator := aMetadataGenerator 
]
