Extension { #name : 'TestAsserter' }

{ #category : '*DeepComparator' }
TestAsserter >> assert: actual deepEquals: expected [

	| comparator |
	^ self
		  assert: ((comparator := DeepComparator new)
				   assert: actual
				   deepEquals: expected)
		  description: [ comparator printDifferences ]
]

{ #category : '*DeepComparator' }
TestAsserter >> deny: actual deepEquals: expected [

	^ self
		  deny: (DeepComparator new
				   assert: actual
				   deepEquals: expected)
		  description: [ self comparingStringBetween: actual and: expected ]
]
