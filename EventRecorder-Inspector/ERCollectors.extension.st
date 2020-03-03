Extension { #name : #ERCollectors }

{ #category : #'*EventRecorder-Inspector' }
ERCollectors >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: 1>
	^ collectors ifNotNil: [ 
			(collectors gtInspectorItemsIn: composite)
				title: 'Collectors' ]
]
