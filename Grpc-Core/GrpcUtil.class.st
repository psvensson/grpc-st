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
GrpcUtil class >> getDefaultRootsData [
	| DEFAULT_ROOTS_FILE_PATH defaultRootsData |
	DEFAULT_ROOTS_FILE_PATH := OSEnvironment current asDictionary
		at: 'GRPC_DEFAULT_SSL_ROOTS_FILE_PATH'.
	DEFAULT_ROOTS_FILE_PATH isNil
		ifFalse: [ DEFAULT_ROOTS_FILE_PATH
				readStreamDo: [ :stream | defaultRootsData := stream contents asByteArray ] ].
	^ defaultRootsData
]

{ #category : #exceptionbuilder }
GrpcUtil class >> throw: string [
	(Exception new messageText: string) signal
]

{ #category : #exceptionbuilder }
GrpcUtil class >> verifyIsBufferOrNull: obj friendlyName: friendlyName [
	obj isNil
		ifFalse: [ (obj isKindOf: ByteArray)
				ifFalse: [ | ex |
					ex := Exception new.
					ex
						messageText: friendlyName , ', if provided, must be a ByteArray'.
					ex signal ] ]
]
