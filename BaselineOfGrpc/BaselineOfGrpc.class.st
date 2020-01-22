Class {
	#name : #BaselineOfGrpc,
	#superclass : #BaselineOf,
	#category : #BaselineOfGrpc
}

{ #category : #baselines }
BaselineOfGrpc >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [
			spec 
				package: 'Grpc-Core';
				package: 'Grpc-Core-Tests' with: [ spec requires: #('Grpc-Core') ].
			spec
    			baseline: 'Protobuf'
    			with: [ spec repository: 'ggithub://jvdsandt/protobuf-smalltalk' ].			
		].
]

{ #category : #baselines }
BaselineOfGrpc >> projectClass [
	^ MetacelloCypressBaselineProject
]
