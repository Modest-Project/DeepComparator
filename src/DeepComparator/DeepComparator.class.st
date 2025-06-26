"
I am a structural equality checker for object graphs.
I compare an actual object graph with an expected one by traversing them in parallel using a depth-first order.

Each time a reference is followed in either graph, both objects are assigned a unique identifier shared by both graphs.
These identifiers are used to enforce referential consistency.
If an object is revisited in one graph, the corresponding object in the other graph must also be revisited and share the same identifier.

The implementation handles all layout formats, as described in `Behavior>>#instSpec`.
The most relevant ones include:
- Immediates (e.g., SmallInteger) are treated as atomic and compared by value.
- Non-indexable objects with instance variables (e.g., Point) are traversed through their instance variables.
- Indexable objects without instance variables (e.g., Array) are traversed through their indexed elements.
- Indexable objects with instance variables (e.g., MethodContext, WeakArray) are traversed through both instance variables and indexed elements.
"
Class {
	#name : 'DeepComparator',
	#superclass : 'Object',
	#instVars : [
		'currentIndex',
		'seenActual',
		'seenExpected',
		'differences'
	],
	#category : 'DeepComparator-Core',
	#package : 'DeepComparator',
	#tag : 'Core'
}

{ #category : 'asserting' }
DeepComparator >> actual: actual at: actualIndex butExpected: expected at: expectedIndex [

	expectedIndex ifNil: [
		^ self actual: actual at: actualIndex butExpectedMissing: expected ].

	differences add: (String streamContents: [ :stream |
			 stream
				 nextPutAll:
					 'Actual and expected have been referenced but at different places:';
				 cr;
				 nextPutAll: 'Actual value #';
				 print: actualIndex;
				 nextPutAll: ': ';
				 nextPutAll: actual asString;
				 cr;
				 nextPutAll: ' | Expected value #';
				 print: expectedIndex;
				 nextPutAll: ': ';
				 nextPutAll: expected asString ])
]

{ #category : 'asserting' }
DeepComparator >> actual: actual at: actualIndex butExpectedMissing: expected [

	differences add: (String streamContents: [ :stream |
			 stream
				 nextPutAll: 'Actual has been referenced before but not expected:';
				 cr;
				 nextPutAll: 'Actual value #';
				 print: actualIndex;
				 nextPutAll: ': ';
				 nextPutAll: actual asString;
				 cr;
				 nextPutAll: ' | Expected value: ';
				 nextPutAll: expected asString ])
]

{ #category : 'asserting' }
DeepComparator >> actual: actual butExpected: expected from: varName [

	differences add: (String streamContents: [ :stream |
			 stream
				 nextPutAll: 'Variable `';
				 nextPutAll: varName;
				 nextPutAll: '` differ:';
				 cr;
				 nextPutAll: 'actual value: ';
				 nextPutAll: actual asString;
				 cr;
				 nextPutAll: ' | expected value: ';
				 nextPutAll: expected asString ])
]

{ #category : 'asserting' }
DeepComparator >> actualMissing: actual butExpected: expected at: expectedIndex [

	differences add: (String streamContents: [ :stream |
			 stream
				 nextPutAll: 'Expected has been referenced before but not actual:';
				 cr;
				 nextPutAll: 'Actual value: ';
				 nextPutAll: actual asString;
				 cr;
				 nextPutAll: ' | Expected value #';
				 print: expectedIndex;
				 nextPutAll: ': ';
				 nextPutAll: expected asString ])
]

{ #category : 'asserting' }
DeepComparator >> assert: actual deepEquals: expected [
	"Check if the two objects are structurally equal recursively."

	| class expectedIndex actualVar expectedVar |
	"First, check referencial consistency.
	If one object is already visited, the other must also be visited and assigned the same identifier."
	expectedIndex := seenExpected at: expected ifAbsent: [ nil ].
	seenActual
		at: actual
		ifPresent: [ :actualIndex | "Actual has been assigned an identifier"
			| res |
			(res := actualIndex == expectedIndex) ifFalse: [ "Expected was not visited or identifiers differ"
				self
					actual: actual
					at: actualIndex
					butExpected: expected
					at: expectedIndex ].
			^ res ]
		ifAbsent: [ "Actual has not been visited, expected must not have been visited either"
			expectedIndex ifNotNil: [
				self actualMissing: actual butExpected: expected at: expectedIndex.
				^ false ] ].

	"Assign the same identifier to the actual and expected objects"
	seenActual at: actual put: currentIndex.
	seenExpected at: expected put: currentIndex.
	currentIndex := currentIndex + 1.

	"Now begins the comparison, start by checking identity"
	actual == expected ifTrue: [ ^ true ].

	"Check if the classes are different"
	(class := actual class) == expected class ifFalse: [ ^ false ].

	"If immediate, == should have been true"
	class isImmediateClass ifTrue: [ ^ false ].

	"Check *through* OrderedCollections, the only special case in which structural equality is not enforced."
	class == OrderedCollection ifTrue: [
		actual size == expected size ifFalse: [ ^ false ].
		1 to: actual size do: [ :index |
			(self
				 assert: (actualVar := actual at: index)
				 deepEquals: (expectedVar := expected at: index)) ifFalse: [
				self
					actual: actualVar
					butExpected: expectedVar
					from: 'OrderedCollection@' , index asString.
				^ false ] ].
		^ true ].

	"Check slots of indexable objects"
	class isVariable ifTrue: [
		actual basicSize == expected basicSize ifFalse: [ ^ false ].
		1 to: actual basicSize do: [ :index |
			(self
				 assert: (actualVar := actual basicAt: index)
				 deepEquals: (expectedVar := expected basicAt: index)) ifFalse: [
				self
					actual: actualVar
					butExpected: expectedVar
					from: class name , '@' , index asString.
				^ false ] ] ].

	"Check instance variables"
	class allInstVarNames do: [ :varName |
		(self
			 assert: (actualVar := actual instVarNamed: varName)
			 deepEquals: (expectedVar := expected instVarNamed: varName))
			ifFalse: [
				self actual: actualVar butExpected: expectedVar from: varName.
				^ false ] ].
	^ true
]

{ #category : 'initialization' }
DeepComparator >> initialize [

	super initialize.
	differences := OrderedCollection new.
	currentIndex := 0.

	seenActual := IdentityDictionary new.
	seenExpected := IdentityDictionary new
]

{ #category : 'asserting' }
DeepComparator >> printDifferences [

	^ String streamContents: [ :stream |
		  differences
			  do: [ :each | stream nextPutAll: each ]
			  separatedBy: [ stream cr cr ] ]
]
