Class {
	#name : 'BaselineOfDeepComparator',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfDeepComparator',
	#package : 'BaselineOfDeepComparator'
}

{ #category : 'baselines' }
BaselineOfDeepComparator >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages"
		spec
			package: 'DeepComparator';
			package: 'DeepComparator-Tests'
			with: [ spec requires: #( 'DeepComparator' ) ].
		"Groups"
		spec
			group: 'default' with: #( 'Core' 'Tests' );
			group: 'Core' with: #( 'DeepComparator' );
			group: 'Tests' with: #( 'DeepComparator-Tests' ) ]
]
