Class {
	#name : #CallCredentialsTest,
	#superclass : #TestCase,
	#category : #'Grpc-Core-Tests'
}

{ #category : #test }
CallCredentialsTest >> testCGenerateMetadata [
	| callCredentials opts |
	callCredentials := CallCredentials
		createFromMetadataGenerator: [ :options :cb | 
			| metadata |
			metadata := MetaData new.
			metadata add: #service_url value: (options at: #service_url).
			cb value: nil value: metadata ].
	opts := Dictionary new.
	opts add: #service_url -> 'foo'.
	(callCredentials generateMetadata: opts)
		onSuccessDo: [ :md | self assert: (md get: #service_url) equals: 'foo' ]
]

{ #category : #tests }
CallCredentialsTest >> testCGenerateMetadataError [
	| callCredentials opts future |
	callCredentials := CallCredentials
		createFromMetadataGenerator: [ :options :cb | cb value: Exception new ].
	opts := Dictionary new. 
	opts add: #service_url -> 'foo'.
	future := callCredentials generateMetadata: opts.
	future onSuccessDo: [ :md | self assert: md equals: nil ].
	future
		onFailureDo: [ :err | self assert: (err isKindOf: Exception) equals: true ]
]

{ #category : #test }
CallCredentialsTest >> testChainableComposeCallCredentials [
	| generateFromServiceURL callCredentials1 callCredentials2 |
	generateFromServiceURL := [ :options :cb | 
	| metadata |
	metadata := MetaData new.
	metadata add: #service_url value: (options at: #service_url).
	cb value: nil value: metadata.
	self assert: true equals: true ].
	callCredentials1 := CallCredentials
		createFromMetadataGenerator: generateFromServiceURL.
	callCredentials2 := CallCredentials
		createFromMetadataGenerator: generateFromServiceURL.
	[ ((callCredentials1 compose: callCredentials2)
		compose: callCredentials2) compose: callCredentials2 ]
		ifCurtailed: [ self fail ].
	self assert: true equals: true
]

{ #category : #tests }
CallCredentialsTest >> testCombineMultipleGenerators [
	| makeAfterMsElapsedGenerator msArray creds testCases case1 case2 case3 |
	makeAfterMsElapsedGenerator := [ :ms | 
		[ :options :cb | 
			| metaData |
			metaData := MetaData new.
			metaData add: 'msElapsed' value: ms.
			ms milliSeconds wait.
			cb value: nil value: metaData ] ].
	"--------------------------------------------"
	msArray := #(50 100 150 200).
	creds := msArray
		collect: [ :ms | 
			| generator |
			generator := makeAfterMsElapsedGenerator value: ms.
			CallCredentials createFromMetadataGenerator: generator ].
	"--------------------------------------------"
	case1 := Dictionary new.
	case1 	add: #credentials	->
					((((creds at: 1) compose: (creds at: 2)) compose: (creds at: 3))
						compose: (creds at: 4)).
	case1 add: #expected -> #(50 100 150 200).
	case2 := Dictionary new.
	case2 	add: #credentials	->
					((((creds at: 4) compose: (creds at: 3)) compose: (creds at: 2))
						compose: (creds at: 1)).
	case2 add: #expected -> #(200 150 100 50).
	case3 := Dictionary new.
	case3 	add: #credentials	->
					((((creds at: 3) compose: (creds at: 4)) compose: (creds at: 1))
						compose: (creds at: 2)).
	case3 add: #expected -> #(150 200 50 100).
	testCases := Array with: case1 with: case2 with: case3.
	"--------------------------------------------"
	(GrpcUtil
		futuresAll:
			(testCases
				collect: [ :testCase | 
					| cr expected opts |
					cr := testCase at: #credentials.
					expected := testCase at: #expected.
					opts := Dictionary new.
					opts at: 'service_url' put: ''.
					(cr generateMetadata: opts) onSuccessDo: [ :md |
						self assert: (md get: 'msElapsed') equals: expected].
					 ]))
		onSuccessDo: [  ]
]

{ #category : #test }
CallCredentialsTest >> testComposeCallCredentials [
	| generateFromServiceURL callCredentials1 callCredentials2 combinedCredentials |
	generateFromServiceURL := [ :options :cb | 
	| metadata |
	metadata := MetaData new.
	metadata add: #service_url value: (options at: #service_url).
	cb value: nil value: metadata.
	self assert: true equals: true ].
	callCredentials1 := CallCredentials
		createFromMetadataGenerator: generateFromServiceURL.
	callCredentials2 := CallCredentials
		createFromMetadataGenerator: generateFromServiceURL.
	combinedCredentials := callCredentials1 compose: callCredentials2.
	self assert: (combinedCredentials ~~ callCredentials1 ) equals: true.
	self assert: (combinedCredentials ~~ callCredentials2 ) equals: true.
]

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
