Extension { #name : #TestAsserter }

{ #category : #'*DeepComparator' }
TestAsserter >> assert: actual deepEquals: expected [

	^ self
		  assert: (DeepComparator new assert: actual deepEquals: expected)
		  description: [ self comparingStringBetween: actual and: expected ]
]

{ #category : #'*DeepComparator' }
TestAsserter >> deny: actual deepEquals: expected [

	^ self
		  deny: (DeepComparator new assert: actual deepEquals: expected)
		  description: [ self comparingStringBetween: actual and: expected ]
]
