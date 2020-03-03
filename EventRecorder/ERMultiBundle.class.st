"
I keep all GTEventBundle objects that should be delivered to the same remote server. That way, all data can be sent to the server at one HTTP request.

By calling #entity, you receive ZnMultiPartFormDataEntity object that contains ZnMimePart objects in a sequence 'category', 'data', 'category', 'data', etc. Server is then responsible for spliting this object into the parts and store each data in to a right position (directory).

For the Collaborators Part:
- GTEventBundle: I keep collection of those objects and ask them for a ZnEntity object sending #entity.
- GTEventMultiBundleFactory knows how to create instances.
- GTEventDelivery knows how to send my #entity to a server.

Internal Representation and Key Implementation Points.

Instance Variables
	bundles:		<Collection>
	url:			<ZnUrl>

"
Class {
	#name : #ERMultiBundle,
	#superclass : #ERAbstractEventBundle,
	#instVars : [
		'bundles'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #visitor }
ERMultiBundle >> accept: aVisitor [ 
	^ aVisitor visitMultiBundle: self
]

{ #category : #adding }
ERMultiBundle >> add: aEREventBundle [ 
	self bundles addLast: aEREventBundle
]

{ #category : #converting }
ERMultiBundle >> asZnEntity [
	| entity |
	entity := ZnMultiPartFormDataEntity new.
	bundles ifNotNil: [
		bundles do: [ :eachEventBundle |
			entity
				addPart: (ZnMimePart fieldName: 'category' value: eachEventBundle category);
				addPart: (ZnMimePart fieldName: 'data' entity: eachEventBundle asZnEntity) ] ].
	^ entity
]

{ #category : #accessing }
ERMultiBundle >> bundles [
	^ bundles ifNil: [ bundles := OrderedCollection new ]
]
