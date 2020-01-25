Class {
	#name : #GrpcUtil,
	#superclass : #Object,
	#category : #'Grpc-Core-Util'
}

{ #category : #resolution }
GrpcUtil class >> futuresAll: futures [
	"Works like Promise.All() in JavaScript"
	| count results fblock |
	count := futures size.
	results := OrderedCollection new.
	fblock := [ futures
		do: [ :each | 
			each
				onSuccessDo: [ :v | 
					results add: v.
					count := count - 1.
					count < 1
						ifTrue: [ results ] ] ] ] future.
	^ fblock
]

{ #category : #exceptionbuilder }
GrpcUtil class >> throw: string [
	(Exception new messageText: string) signal
]
