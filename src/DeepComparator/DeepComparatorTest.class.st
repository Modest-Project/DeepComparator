Class {
	#name : #DeepComparatorTest,
	#superclass : #TestCase,
	#category : #'DeepComparator-Tests'
}

{ #category : #tests }
DeepComparatorTest >> testCompareArrays [

	| array1 array2 |
	array1 := Array new: 5.
	array2 := Array new: 5.

	array1 at: 1 put: 1.
	array2 at: 1 put: 1.

	self assert: (DeepComparator deepEquals: array1 with: array2)
]

{ #category : #tests }
DeepComparatorTest >> testCompareComplexObject [

	| object1 object2 object3 |
	object1 := MockClassWithInstVars new.
	object2 := MockClassWithInstVars new.
	object3 := MockClassWithInstVars new.

	object1 string: 'test1'.
	object2 string: 'test1'.
	object3 string: 'test1'.
	object1 number: 1.
	object2 number: 1.
	object3 number: 3.

	self assert: (DeepComparator deepEquals: object1 with: object2).
	self assert: (DeepComparator deepEquals: object1 with: object3) not
]

{ #category : #tests }
DeepComparatorTest >> testCompareDictionary [

	| dictionary1 dictionary2 |
	dictionary1 := Dictionary new.
	dictionary2 := Dictionary new.

	dictionary1 at: 1 put: 3.
	dictionary2 at: 1 put: 3.

	self assert: (DeepComparator deepEquals: dictionary1 with: dictionary2)
]

{ #category : #tests }
DeepComparatorTest >> testCompareNestedComplexObject [

	| object1 object2 object3 array1 array2 array3 |
	object1 := MockClassWithInstVars new.
	object2 := MockClassWithInstVars new.
	object3 := MockClassWithInstVars new.
	array1 := Array new: 1.
	array2 := Array new: 2.
	array3 := Array new: 2.

	object1 string: 'test1'.
	object2 string: 'test1'.
	object3 string: 'test1'.
	object1 number: 1.
	object2 number: 1.
	object3 number: 3.
	array1 at: 1 put: object1.
	array2 at: 1 put: object2.
	array3 at: 1 put: object3.

	self assert: (DeepComparator deepEquals: object1 with: object2).
	self assert: (DeepComparator deepEquals: object1 with: object3) not.
	self assert: (DeepComparator deepEquals: array1 with: array1).
	self assert: (DeepComparator deepEquals: array1 with: array3) not
]

{ #category : #tests }
DeepComparatorTest >> testCompareNestedObjects [

	| array1 array2 array4 array5 |
	array1 := Array new: 5.
	array2 := Array new: 5.
	"array3 := Array new: 10."
	array4 := Array new: 1.
	array5 := Array new: 1.

	array1 at: 1 put: array4.
	array2 at: 1 put: array5.
	"array3 at: 1 put: array4."
	array4 at: 1 put: 1.
	array5 at: 1 put: 1.

	self assert: (DeepComparator deepEquals: array1 with: array2)
	"self assert: (DeepComparator deepEquals: array1 with: array3) not"
]

{ #category : #tests }
DeepComparatorTest >> testCompareNumbers [

	self assert: (DeepComparator deepEquals: 1 with: 1).
	self assert: (DeepComparator deepEquals: 1.1 with: 1.1).
	self assert: (DeepComparator deepEquals: 1 / 2s with: 1 / 2s).
	self assert: (DeepComparator deepEquals: -1 with: -1).
	self assert: (DeepComparator deepEquals: 0 with: 1) not.
	self assert: (DeepComparator deepEquals: 1.1 with: 0) not.
	self assert: (DeepComparator deepEquals: 1 / 2s with: 0) not.
	self assert: (DeepComparator deepEquals: -1 with: 0) not
]

{ #category : #tests }
DeepComparatorTest >> testCompareOrderedCollections [

	| orderedCollection1 orderedCollection2 |
	orderedCollection1 := OrderedCollection new.
	orderedCollection2 := OrderedCollection new.

	orderedCollection1 add: 1.
	orderedCollection2 add: 1.

	self assert: (DeepComparator deepEquals: orderedCollection1 with: orderedCollection2)
]

{ #category : #tests }
DeepComparatorTest >> testCompareStrings [

	self assert: (DeepComparator deepEquals: 'test' with: 'test').
	self assert: (DeepComparator deepEquals: '' with: '').
	self assert: (DeepComparator deepEquals: 'test1' with: 'test2') not
]

{ #category : #tests }
DeepComparatorTest >> testCompareSymbols [

	self assert: (DeepComparator deepEquals: #test with: #test).
	self assert: (DeepComparator deepEquals: #test1 with: #test2) not
]
