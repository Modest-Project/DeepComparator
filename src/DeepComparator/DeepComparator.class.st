Class {
	#name : #DeepComparator,
	#superclass : #Object,
	#instVars : [
		'visitedObjects'
	],
	#category : #'DeepComparator-Core'
}

{ #category : #asserting }
DeepComparator >> assert: anObject1 deepEquals: anObject2 [
	"Check recursively if the two objects are the same instance"

	| class |
	"If an object is already visited, the other must be the same DOESN'T WORK WHEN OBJETS ARE IDENTICALS BUT DIFFERENT INSTANCES"
	visitedObjects
		at: anObject1
		ifPresent: [ :each |
			visitedObjects
				at: anObject2
				ifPresent: [ :each2 | ^ each == each2 ]
				ifAbsent: [ ^ false ] ]
		ifAbsent: [ visitedObjects at: anObject2 ifPresent: [ ^ false ] ].
	visitedObjects at: anObject1 put: anObject1.
	visitedObjects at: anObject2 put: anObject2.

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

{ #category : #asserting }
DeepComparator >> initialize [

	super initialize.
	visitedObjects := OrderedDictionary new
]
