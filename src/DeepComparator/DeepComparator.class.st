Class {
	#name : #DeepComparator,
	#superclass : #Object,
	#category : #'DeepComparator-Core'
}

{ #category : #'as yet unclassified' }
DeepComparator class >> assert: anObject1 deepEquals: anObject2 [
	"Check recursively if the two objects are the same instance"

	| class |
	anObject1 == anObject2 ifTrue: [ ^ true ].

	"Check if the classes are different"
	(class := anObject1 class) == anObject2 class ifFalse: [ ^ false ].

	"Check through OrderedCollections"
	class == OrderedCollection ifTrue: [
		1 to: anObject1 size do: [ :index |
			(self deepEquals: (anObject1 at: index) with: (anObject2 at: index))
				ifFalse: [ ^ false ] ].
		^ true ].

	"If the objets are indexable"
	class isVariable ifTrue: [
		anObject1 basicSize == anObject2 basicSize ifFalse: [ ^ false ].
		1 to: anObject1 basicSize do: [ :index |
			(self
				 deepEquals: (anObject1 basicAt: index)
				 with: (anObject2 basicAt: index)) ifFalse: [ ^ false ] ] ].

	"For other types, check all instance variables"
	^ class allInstVarNames allSatisfy: [ :varName |
		  self
			  deepEquals: (anObject1 instVarNamed: varName)
			  with: (anObject2 instVarNamed: varName) ]
]
