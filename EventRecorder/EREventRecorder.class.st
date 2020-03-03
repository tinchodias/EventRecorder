"
I represent an event recorder, an object that collects data and regularly sends them to a server. The data could represent user activity, tool usage, or any other statistic usefule for further analysis. 

I cover data collectors, packing, and delivery objects the way they cooperate together and the collected data are regularly send to server(s). It is not mandatory, but it is supposed that I represent a Singleton pattern.

I collaborate with GTEventCollector objects, that are responsible for collecting data. I keep any number of those objects and whenever GTEventDelivery asks me for collected data, GTEventPacking object packs data from each GTEventCollector and hand them as collection of GTEventBundle objects to the GTEventDelivery. GTEventDelivery sends the bundles to server(s).

Public API and Key Messages

- addCollector: it adds GTEventCollector object and activates delivery process if inactive   
- removeCollector: it removes  GTEventCollector object and deactivates delivery process if there are no other collectors.
- activateDelivery: activates delivery process
- deactivateDelivery: deactivates delivery process

Internal Representation and Key Implementation Points.

    Instance Variables
	announcer:		<Annoucner>
	collectors:		<GTEventCollectors>
	delivery:		<GTEventDelivery>
	packing:		<GTEventPacking>
	privacy:		<true|false|ClosureBlock>

"
Class {
	#name : #EREventRecorder,
	#superclass : #Object,
	#instVars : [
		'collectors',
		'delivery',
		'packing',
		'announcer',
		'settings'
	],
	#category : #'EventRecorder-Core'
}

{ #category : #'instance creation' }
EREventRecorder class >> newWith: aRecorderSettings [
	"Answer a new instance with the specified settings."

	^ self basicNew
		initializeWith: aRecorderSettings;
		yourself
]

{ #category : #delivery }
EREventRecorder >> activateDelivery [
	^ delivery activate
]

{ #category : #delivery }
EREventRecorder >> activateDeliveryIfHasPermissionToSend [
	self hasPermissionToSend
		ifTrue: [ self activateDelivery ]
]

{ #category : #adding }
EREventRecorder >> addCollector: aEREventCollector [
	self activateDeliveryIfHasPermissionToSend.
	aEREventCollector recorder: self.
	collectors add: aEREventCollector
]

{ #category : #accessing }
EREventRecorder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #delivery }
EREventRecorder >> deactivateDelivery [
	^ delivery deactivate
]

{ #category : #delivery }
EREventRecorder >> deliverNow [
	delivery now
]

{ #category : #accessing }
EREventRecorder >> delivery [
	"Testing purpose."
	^ delivery
]

{ #category : #configuration }
EREventRecorder >> deliveryPreSuspendingAction: aBlockClosure [ 
	self delivery preSuspendingAction: aBlockClosure
]

{ #category : #configuration }
EREventRecorder >> disableDeliveryPermission [
	delivery disablePermission
]

{ #category : #configuration }
EREventRecorder >> disablePermissionToSend [
	"testing purpose"
	settings disablePermissionToSend
]

{ #category : #configuration }
EREventRecorder >> enableDeliveryPermission [
	delivery enablePermission
]

{ #category : #configuration }
EREventRecorder >> enablePermissionToSend [
	"testing purpose"
	settings enablePermissionToSend
]

{ #category : #packing }
EREventRecorder >> flush [
	"Be careful! You will lost all data."
	collectors do: #flush
]

{ #category : #testing }
EREventRecorder >> hasPermissionToSend [
	^ settings hasPermissionToSend
]

{ #category : #initialization }
EREventRecorder >> initializeWith: aRecorderSettings [

	self initialize.
	collectors := EREventCollectors new.
	packing := EREventPacking default.

	delivery := EREventDelivery new.
	delivery recorder: self.

	settings := aRecorderSettings.
	settings hasPermissionToSend
		ifTrue: [ delivery enablePermission ]
		ifFalse: [ delivery disablePermission ]
]

{ #category : #testing }
EREventRecorder >> isDeliveryActive [
	^ delivery isActive
]

{ #category : #convenient }
EREventRecorder >> numberOfCollectors [
	^ collectors size
]

{ #category : #convenient }
EREventRecorder >> numberOfDeliveryData [
	^ delivery size
]

{ #category : #packing }
EREventRecorder >> pack [
	| allCollectors consolidatedCollectors |
	self hasPermissionToSend ifFalse: [ ^ self flush; yourself ].
	allCollectors := OrderedCollection new: collectors size.
	collectors do: [ :eachCollector | allCollectors addLast: eachCollector ].
	consolidatedCollectors := EREventConsolidate new collectors: allCollectors; consolidated.
	consolidatedCollectors do: [ :eachCollector | | bundle |
		eachCollector isEmpty ifFalse: [
			bundle := eachCollector asBundleWith: packing.
			delivery add: bundle] ].
	self removeLiberatedCollectors.
]

{ #category : #'event handling' }
EREventRecorder >> privacyChanged [
	self hasPermissionToSend 
		ifTrue: [ self numberOfCollectors > 0 
						ifTrue: [ self activateDelivery ] ]
		ifFalse: [ self deactivateDelivery ]
]

{ #category : #removing }
EREventRecorder >> removeCollector: aEREventCollector [ 
	| removedCollector |
	removedCollector := collectors remove: aEREventCollector.
	collectors isEmpty ifTrue: [ self deactivateDelivery ].
	^ removedCollector
]

{ #category : #removing }
EREventRecorder >> removeLiberatedCollectors [
	collectors removeLiberatedCollectors
]
