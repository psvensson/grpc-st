Class {
	#name : #MetaData,
	#superclass : #Object,
	#instVars : [
		'options',
		'internalRepr'
	],
	#category : #'Grpc-Core-Util'
}

{ #category : #constants }
MetaData class >> LEGAL_KEY_REGEX [
	^ '/^[0-9a-z_.-]+$/'
]

{ #category : #constants }
MetaData class >> LEGAL_NON_BINARY_VALUE_REGEX [
	^ '/^[ -~]*$/'
]

{ #category : #'instance creation' }
MetaData class >> fromHttp2Headers: headers [
	| result |
	result := MetaData new.
	headers
		keysDo: [ :key | 
			| values |
			(key at: 1 = $:)
				ifTrue: [ ^ nil ].
			values := headers at: key.
			(self isBinaryKey: key)
				ifTrue: [ (values isKindOf: Collection)
						ifTrue: [ values do: [ :each | result add: key value: each base64Decoded ] ]
						ifFalse: [ values isNil
								ifFalse: [ (self isCustomerMetaData: key)
										ifTrue: [ | tokens |
											tokens := values findTokens: ','.
											tokens
												do: [ :each | 
													| trimmed |
													trimmed := each trim.
													result add: key value: trimmed base64Decoded ] ]
										ifFalse: [ result add: key value: values base64Decoded ] ] ] ]
				ifFalse: [ (values isKindOf: Collection)
						ifTrue: [ values do: [ :each | result add: key value: each ] ]
						ifFalse: [ (self isCustomerMetaData: key)
								ifTrue: [ | tokens |
									tokens := values findTokens: ','.
									tokens
										do: [ :each | 
											| trimmed |
											trimmed := each trim.
											result add: key value: trimmed ] ]
								ifFalse: [ result add: key value: values ] ] ] ].
	^ result
]

{ #category : #testing }
MetaData class >> isBinaryKey: key [
	^ key endsWith: '-bin'
]

{ #category : #testing }
MetaData class >> isCustomerMetaData: key [
	^ key indexOf: 'grpc-' = 1
]

{ #category : #testing }
MetaData class >> isLegalKey: key [
	^ key matchesRegex: (self LEGAL_KEY_REGEX )
]

{ #category : #testing }
MetaData class >> isLegalNonBnaryValue: key [
	^ key matchesRegex: (self LEGAL_NON_BINARY_VALUE_REGEX  )
]

{ #category : #testing }
MetaData class >> normalizeKey: key [
	^ key lowercase 
]

{ #category : #accessing }
MetaData >> _getCoreRepresentation [
	^ internalRepr 
]

{ #category : #testing }
MetaData >> add: key value: value [
	| normalizedKey |
	normalizedKey := self class normalizeKey: key.
	self validate: normalizedKey value: value.
	(internalRepr includesKey: normalizedKey)
		ifTrue: [ | existingCollection |
			existingCollection := internalRepr at: normalizedKey.
			existingCollection add: value ]
		ifFalse:
			[ internalRepr at: normalizedKey put: (OrderedCollection with: value) ]
]

{ #category : #accessing }
MetaData >> clone [
	| newMetadata newInternalRepr |
	newMetadata := self class new.
	newInternalRepr := newMetadata internalRepr.
	internalRepr
		keysAndValuesDo: [ :key :value | 
			| clonedValue |
			clonedValue := value map: [ :each | each clone ].
			newInternalRepr at: key put: clonedValue ].
	^ newMetadata
]

{ #category : #testing }
MetaData >> get: key [
	| normalizedKey value |
	normalizedKey := self normalizeKey: key.
	self validate: normalizedKey value: nil.
	value := internalRepr at: normalizedKey.
	value ifNil: [ value := Array new ].
	^ value
]

{ #category : #accessing }
MetaData >> getMap [
	| result |
	result := Dictionary new.
	internalRepr
		keysAndValuesDo: [ :key :value | 
			| first |
			first := value first.
			(first isKindOf: ByteArray)
				ifTrue: [ first := first copy ].
			result at: key put: first	 ].
	^ result
]

{ #category : #testing }
MetaData >> initialize [
	options := Dictionary new.
]

{ #category : #accessing }
MetaData >> internalRepr [
	^ internalRepr 
]

{ #category : #accessing }
MetaData >> merge: other [
	other internalRepr
		keysAndValuesDo: [ :key :value | 
			| newValue |
			newValue := (internalRepr at: key) , value.
			internalRepr at: key put: newValue ]
]

{ #category : #accessing }
MetaData >> options [
	^ options
]

{ #category : #accessing }
MetaData >> options: anObject [
	options := anObject
]

{ #category : #testing }
MetaData >> remove: key [
	| normalizedKey |
	normalizedKey := self normalizeKey: key.
	self validate: normalizedKey value: nil.
	internalRepr removeKey: normalizedKey 
]

{ #category : #testing }
MetaData >> set: key vaue: value [
	| normalizedKey |
	normalizedKey := self normalizeKey: key.
	self validate: normalizedKey value: value.
	internalRepr at: normalizedKey put: (OrderedCollection with: value)
]

{ #category : #accessing }
MetaData >> toHttp2Headers [
	| result |
	result := Dictionary new.
	internalRepr
		keysAndValuesDo: [ :key :value | 
			result
				at: key
				put:
					(value
						map: [ :each | 
							(each isKindOf: ByteArray)
								ifTrue: [ each base64Encoded ]
								ifFalse: [ each ] ]) ].
	^ result
]

{ #category : #testing }
MetaData >> validate: key value: value [
	(self isLegalKey: key)
		ifFalse: [ GrpcUtil
				throw: 'Metadata key "' , key , '" contains illegal characters ' ].
	value isNil
		ifTrue: [ (self isBinaryKey: key)
				ifTrue: [ (value isKindOf: ByteArray)
						ifFalse: [ GrpcUtil
								throw: 'keys that ends with "-bin" must have ByteArray values" ' ] ] ]
		ifFalse: [ (value isKindOf: ByteArray)
				ifTrue: [ GrpcUtil
						throw: 'keys that dont end with "-bin" must have String values" ' ]
				ifFalse: [ (self isLegalNonBnaryValue: value)
						ifFalse: [ GrpcUtil
								throw: 'Metadata string "' , value , '" contains illegal characters ' ] ] ]
]
