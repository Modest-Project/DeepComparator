Class {
	#name : #MockClassWithInstVars,
	#superclass : #Object,
	#instVars : [
		'number',
		'string',
		'array'
	],
	#category : #'DeepComparator-Tests'
}

{ #category : #accessing }
MockClassWithInstVars >> array [

	^ array
]

{ #category : #accessing }
MockClassWithInstVars >> array: anArray [

	array := anArray
]

{ #category : #accessing }
MockClassWithInstVars >> initialize [

	array := Array new: 1
]

{ #category : #accessing }
MockClassWithInstVars >> number: aNumber [

	number := aNumber
]

{ #category : #accessing }
MockClassWithInstVars >> string: aString [

	string := aString
]
