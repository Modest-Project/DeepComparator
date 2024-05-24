Class {
	#name : #BaselineOfDeepComparator,
	#superclass : #BaselineOf,
	#category : #BaselineOfDeepComparator
}

{ #category : #baselines }
BaselineOfDeepComparator >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages"
		spec
			package: 'DeepComparator-Core';
			package: 'DeepComparator-Tests'
			with: [ spec requires: #( 'DeepComparator-Core' ) ].
		"Groups"
		spec
			group: 'default' with: #( 'Core' 'Tests' );
			group: 'Core' with: #( 'DeepComparator-Core' );
			group: 'Tests' with: #( 'DeepComparator-Tests' ) ]
]
