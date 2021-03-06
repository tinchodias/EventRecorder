Extension { #name : #ERPacket }

{ #category : #'*EventRecorder-Inspector' }
ERPacket >> gtInspectorActionUnpackData [
	<gtInspectorAction>
	^ GLMGenericAction new
		action: [ :composite |
			composite selection: self unpackedData ];
		icon: GLMUIThemeExtraIcons glamorousAdd;
		condition: [ self data isNotNil ];
		title: 'Unpack data'
]

{ #category : #'*EventRecorder-Inspector' }
ERPacket >> gtInspectorItems [
	^ OrderedCollection withAll: self associations
]

{ #category : #'*EventRecorder-Inspector' }
ERPacket >> gtInspectorItemsIn: composite [
	<gtInspectorPresentationOrder: -1>  
	^ (composite table)
		title: 'Info';
		display: [ :anEvent | anEvent gtInspectorItems ];
		children: [ :each | 
			(each value isDictionary) 
				ifTrue: [ each value associations ] 
				ifFalse: [ (each value isArray and: [ each value allSatisfy: #isDictionary ])
						ifTrue: [ each value collectWithIndex: [:x :i | i -> x ] ]
						ifFalse: [ #() ] ] ];
		column: 'Key' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each key ];
		column: 'Value' 
			evaluated: [:each | GTObjectPrinter asTruncatedTextFrom: each value ];
		showOnly: 50
]
