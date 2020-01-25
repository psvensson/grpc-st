Class {
	#name : #EmptyCallCredentials,
	#superclass : #CallCredentials,
	#category : #'Grpc-Core-Credentials'
}

{ #category : #testing }
EmptyCallCredentials >> _equals: other [
	^ other isKindOf: EmptyCallCredentials 
]

{ #category : #generating }
EmptyCallCredentials >> compose: callCredentials [
	^ callCredentials 
]

{ #category : #generating }
EmptyCallCredentials >> generateMetadata: options [ 
	^ [ MetaData new ] future
]
