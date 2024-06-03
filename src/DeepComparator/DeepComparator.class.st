Class {
	#name : #DeepComparator,
	#superclass : #Object,
	#category : #'DeepComparator-Core'
}

{ #category : #'as yet unclassified' }
DeepComparator class >> assert: anObject1 deepEquals: anObject2 [
	"Check recursively if the two objects are the same instance"

	anObject1 == anObject2 ifTrue: [ ^ true ].
	anObject1 = anObject2 ifTrue: [ ^ true ].

	"Check if the classes are different"
	anObject1 class ~= anObject2 class ifTrue: [ ^ false ].

	"If both are nil, they are considered equal"
	(anObject1 isNil and: [ anObject2 isNil ]) ifTrue: [ ^ true ].

	"If one is nil and the other is not, they are not equal"
	(anObject1 isNil or: [ anObject2 isNil ]) ifTrue: [ ^ false ].

	"If they are both basic types, check equality directly"
	(anObject1 isNumber or: [
		 anObject1 isString or: [
			 anObject1 = true or: [ anObject1 = false ] ] ]) ifTrue: [
		^ anObject1 = anObject2 ].

	"If the objets are arrays"
	anObject1 isArray ifTrue: [
		| copy1 copy2 |
		copy1 := anObject1 select: [ :e | e isNotNil].
		copy2 := anObject2 select: [ :e | e isNotNil].
		copy1 size = copy2 size ifFalse: [ ^ false ].
		copy1 doWithIndex: [ :elem :index |
			(self assert: elem deepEquals: (copy2 at: index)) ifFalse: [
				^ false ] ].
		^ true ].
	"select: [ :e | e isNotNil]"
	"For other types, check all instance variables"
	^ anObject1 class allInstVarNames allSatisfy: [ :varName |
		  self
			  assert: (anObject1 instVarNamed: varName)
			  deepEquals: (anObject2 instVarNamed: varName) ]
]
