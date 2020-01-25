Class {
	#name : #CallCredentialsTest,
	#superclass : #TestCase,
	#category : #'Grpc-Core-Tests'
}

{ #category : #test }
CallCredentialsTest >> testCreateFromMetadataGenerator [
	[ CallCredentials
		createFromMetadataGenerator: [ :options :cb | 
			| metadata |
			metadata := MetaData new.
			metadata add: #service_url value: (options at: #service_url).
			cb value: nil value: metadata.
			self assert: true equals: true ] ]
		ifCurtailed: [ self fail ]
]
