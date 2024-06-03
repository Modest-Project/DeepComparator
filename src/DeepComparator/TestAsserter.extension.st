Extension { #name : #TestAsserter }

{ #category : #'*DeepComparator' }
TestAsserter >> assert: actual deepEquals: expected [

	^ self
		  assert: (DeepComparator assert: actual equals: expected)
		  description: [ self comparingStringBetween: actual and: expected ]
]
