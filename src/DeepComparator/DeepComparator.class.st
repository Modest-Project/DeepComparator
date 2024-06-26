Class {
	#name : 'DeepComparator',
	#superclass : 'Object',
	#category : 'DeepComparator-Core',
	#package : 'DeepComparator',
	#tag : 'Core'
}

{ #category : 'asserting' }
DeepComparator class >> assert: anObject1 deepEquals: anObject2 [
	"Check recursively if the two objects are the same instance"

	| class |
	anObject1 == anObject2 ifTrue: [ ^ true ].

	"Check if the classes are different"
	(class := anObject1 class) == anObject2 class ifFalse: [ ^ false ].

	"If immediate, == should have been true"
	class isImmediateClass ifTrue: [ ^ false ].

	"Check through OrderedCollections"
	class == OrderedCollection ifTrue: [
		1 to: anObject1 size do: [ :index |
			(self
				 assert: (anObject1 at: index)
				 deepEquals: (anObject2 at: index)) ifFalse: [ ^ false ] ].
		^ true ].

	"If the objets are indexable"
	class isVariable ifTrue: [
		anObject1 basicSize == anObject2 basicSize ifFalse: [ ^ false ].
		1 to: anObject1 basicSize do: [ :index |
			(self
				 assert: (anObject1 basicAt: index)
				 deepEquals: (anObject2 basicAt: index)) ifFalse: [ ^ false ] ] ].

	"For other types, check all instance variables"
	^ class allInstVarNames allSatisfy: [ :varName |
		  self
			  assert: (anObject1 instVarNamed: varName)
			  deepEquals: (anObject2 instVarNamed: varName) ]
]
