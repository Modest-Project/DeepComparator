Class {
	#name : #DeepComparator,
	#superclass : #Object,
	#instVars : [
		'visitedObjects',
		'visitedObjects1',
		'visitedObjects2',
		'differencies',
		'currentIndex'
	],
	#category : #'DeepComparator-Core'
}

{ #category : #asserting }
DeepComparator >> addDifferenceFor: aValue1 and: aValue2 on: aVarName [

	| formattedDifference |
	formattedDifference := String streamContents: [ :stream |
		                       stream
			                       nextPutAll: 'field ';
			                       nextPutAll: aVarName;
			                       nextPutAll: ' differ:';
			                       cr;
			                       nextPutAll: 'actual value: ';
			                       nextPutAll: aValue1 asString;
			                       cr;
			                       nextPutAll: ' | expected value: ';
			                       nextPutAll: aValue2 asString ].
	differencies add: formattedDifference
]

{ #category : #asserting }
DeepComparator >> assert: anObject1 deepEquals: anObject2 [
	"Check recursively if the two objects are equals based on attributes"

	| class |
	"If an object is already visited, the other must be equals ; DOESN'T WORK WHEN OBJECTS ARE IDENTICALS BUT DIFFERENT INSTANCES"
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
DeepComparator >> assert: anObject1 deepEqualsWithDifferencies: anObject2 [
	"Check recursively if the two objects are equals based on attributes"

	| class visitedObjectIndex2 |
	"If one object is already visited, the other must be stored at the same index in the dictionary of visited objects"
	visitedObjectIndex2 := visitedObjects2
		                       at: anObject2
		                       ifAbsent: [ nil ].
	visitedObjects1
		at: anObject1
		ifPresent: [ :visitedObjectIndex1 |
			self halt. "returns true if both have already been visited and they were visited in the same place in their reference tree"
			^ visitedObjectIndex1 == visitedObjectIndex2 ]
		ifAbsent: [
			self halt. "continues if both objects have not been visited"
			visitedObjectIndex2 ifNotNil: [ ^ false ] ].
	"visitedObjects
		at: anObject1
		ifPresent: [ :each |
			visitedObjects
				at: anObject2
				ifPresent: [ :each2 | ^ each == each2 ]
				ifAbsent: [ ^ false ] ]
		ifAbsent: [ visitedObjects at: anObject2 ifPresent: [ ^ false ] ].
	visitedObjects at: anObject1 put: anObject1.
	visitedObjects at: anObject2 put: anObject2.
	"
	visitedObjects1 at: anObject1 put: currentIndex.
	visitedObjects2 at: anObject2 put: currentIndex.
	currentIndex := currentIndex + 1.

	anObject1 == anObject2 ifTrue: [ ^ true ].

	"Check if the classes are different"
	(class := anObject1 class) == anObject2 class ifFalse: [ ^ false ].

	"If immediate, == should have been true"
	class isImmediateClass ifTrue: [ ^ false ].

	"Check through OrderedCollections"
	class == OrderedCollection ifTrue: [
		1 to: anObject1 size do: [ :index |
			| var1 var2 |
			(self
				 assert: (var1 := anObject1 at: index)
				 deepEqualsWithDifferencies: (var2 := anObject2 at: index))
				ifFalse: [
					self
						addDifferenceFor: var1
						and: var2
						on: anObject1 name , '[' , index asString , ']'.
					^ false ] ].
		^ true ].

	"If the objets are indexable"
	class isVariable ifTrue: [
		anObject1 basicSize == anObject2 basicSize ifFalse: [ ^ false ].
		1 to: anObject1 basicSize do: [ :index |
			(self
				 assert: (anObject1 basicAt: index)
				 deepEqualsWithDifferencies: (anObject2 basicAt: index)) ifFalse: [
				^ false ] ] ].

	"For other types, check all instance variables"
	class allInstVarNames do: [ :varName |
		| var1 var2 |
		(self
			 assert: (var1 := anObject1 instVarNamed: varName)
			 deepEqualsWithDifferencies:
			 (var2 := anObject2 instVarNamed: varName)) ifFalse: [
			self addDifferenceFor: var1 and: var2 on: varName.
			^ false ] ].
	^ true
]

{ #category : #asserting }
DeepComparator >> getDifferencies [

	^ String streamContents: [ :stream |
		  differencies do: [ :each |
			  stream
				  nextPutAll: each;
				  cr;
				  cr ] ]
]

{ #category : #asserting }
DeepComparator >> initialize [

	super initialize.
	visitedObjects := OrderedDictionary new.


	visitedObjects1 := OrderedDictionary new.
	visitedObjects2 := OrderedDictionary new.
	currentIndex := 0.

	differencies := OrderedCollection new
]
