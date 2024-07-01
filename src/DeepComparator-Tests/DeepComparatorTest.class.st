Class {
	#name : #DeepComparatorTest,
	#superclass : #TestCase,
	#category : #'DeepComparator-Tests'
}

{ #category : #tests }
DeepComparatorTest >> testCompareArrays [

	| array1 array2 array3 |
	array1 := Array new: 5.
	array2 := Array new: 5.
	array3 := Array new: 5.

	array1 at: 1 put: 1.
	array2 at: 1 put: 1.
	array3 at: 1 put: 3.

	self assert: array1 deepEquals: array2.
	self deny: array1 deepEquals: array3
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

	self assert: object1 deepEquals: object2.
	self deny: object1 deepEquals: object3
]

{ #category : #tests }
DeepComparatorTest >> testCompareDictionary [

	| dictionary1 dictionary2 |
	dictionary1 := Dictionary new.
	dictionary2 := Dictionary new.

	dictionary1 at: 1 put: 3.
	dictionary2 at: 1 put: 3.

	self assert: dictionary1 deepEquals: dictionary2
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

	self assert: object1 deepEquals: object2.
	self assert: array1 deepEquals: array1.
	self deny: object1 deepEquals: object3.
	self deny: array1 deepEquals: array3
]

{ #category : #tests }
DeepComparatorTest >> testCompareNestedObjects [

	| array1 array2 array3 array4 |
	array1 := Array new: 5.
	array2 := Array new: 5.
	array3 := Array new: 1.
	array4 := Array new: 1.

	array1 at: 1 put: 1.
	array2 at: 1 put: 1.
	array3 at: 1 put: array1.
	array4 at: 1 put: array2.

	self assert: array3 deepEquals: array4
]

{ #category : #tests }
DeepComparatorTest >> testCompareNumbers [

	self assert: 1 deepEquals: 1.
	self assert: 1.1 deepEquals: 1.1.
	self assert: 1 / 2s deepEquals: 1 / 2s.
	self assert: -1 deepEquals: -1.
	self deny: 0 deepEquals: 1.
	self deny: 1.1 deepEquals: 0.
	self deny: 1 / 2s deepEquals: 0.
	self deny: -1 deepEquals: 0
]

{ #category : #tests }
DeepComparatorTest >> testCompareOrderedCollections [

	| orderedCollection1 orderedCollection2 |
	orderedCollection1 := OrderedCollection new.
	orderedCollection2 := OrderedCollection new.

	orderedCollection1 add: 1.
	orderedCollection2 add: 1.

	self assert: orderedCollection1 deepEquals: orderedCollection2
]

{ #category : #tests }
DeepComparatorTest >> testCompareStrings [

	self assert: 'test' deepEquals: 'test'.
	self assert: '' deepEquals: ''.
	self deny: 'test1' deepEquals: 'test2'
]

{ #category : #tests }
DeepComparatorTest >> testCompareSymbols [

	self assert: #test deepEquals: #test.
	self deny: #test1 deepEquals: #test2
]

{ #category : #tests }
DeepComparatorTest >> testDifferentAttributes [

	| object1 object2 |
	object1 := MockClassWithInstVars new.
	object1 string: 'test1'.
	object1 number: 1.

	object2 := MockClassWithInstVars new.
	object2 string: 'test2'.
	object2 number: 2.

	self deny: object1 deepEquals: object2
]

{ #category : #tests }
DeepComparatorTest >> testDifferentClasses [

	| object1 object2 |
	object1 := MockClassWithInstVars new.
	object1 string: 'test1'.
	object1 number: 1.

	object2 := PriorityQueue new.

	self deny: object1 deepEquals: object2
]

{ #category : #tests }
DeepComparatorTest >> testReferencedObject [

	| object1 object2 |
	object1 := MockClassWithInstVars new.
	object2 := MockClassWithInstVars new.

	object1 array at: 1 put: object2.
	object1 string: 'object1'.
	object2 array at: 1 put: object1.
	object2 string: 'object2'.

	self deny: object1 deepEquals: object2
]

{ #category : #tests }
DeepComparatorTest >> testReferencedSameObject [

	| object1 |
	object1 := MockClassWithInstVars new.

	object1 array at: 1 put: object1.
	object1 string: 'object1'.

	self assert: object1 deepEquals: object1
]
