Class {
	#name : #BaselineOfEventRecorder,
	#superclass : #BaselineOf,
	#category : #BaselineOfEventRecorder
}

{ #category : #baselines }
BaselineOfEventRecorder >> baseline: spec [
  <baseline>
  spec
    for: #common do: [ 
      spec
			package: 'EventRecorder'.
		spec 
			package: 'EventRecorder-Tests'
			with: [ spec requires: #( 'EventRecorder' ) ].
		spec 
			package: 'EventRecorder-Fuel'
			with: [ spec requires: #( 'EventRecorder' ) ].
		spec 
			package: 'EventRecorder-Fuel-Tests'
			with: [ spec requires: #( 'EventRecorder-Fuel' ) ].
		spec 
			package: 'EventRecorder-Inspector'
			with: [ spec requires: #( 'EventRecorder' ) ].
		spec 
			package: 'EventRecorder-Help'
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-PharoUsageData'
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-PharoUsageData-Tests'
			with: [ spec requires: #( 'EventRecorder-PharoUsageData') ].
		spec 
			package: 'EventRecorder-Server'
			with: [ spec requires: #( 'EventRecorder') ].
		spec 
			package: 'EventRecorder-Server-Tests'
			with: [ spec requires: #( 'EventRecorder-Server') ].
		
		spec
			group: 'client' with: #('EventRecorder' 'EventRecorder-Tests' 'EventRecorder-PharoUsageData-Tests' 'EventRecorder-Fuel-Tests' 'EventRecorder-Inspector' 'EventRecorder-Help');
			group: 'server' with: #('client' 'EventRecorder-Server' 'EventRecorder-Server-Tests');
			group: 'default' with: #('client')
		]

]
