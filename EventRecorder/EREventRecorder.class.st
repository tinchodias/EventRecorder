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
		'packing',
		'announcer',
		'settings',
		'deliverer'
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
	^ deliverer activate
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
	^ deliverer deactivate
]

{ #category : #delivery }
EREventRecorder >> deliverNow [
	deliverer deliverNow
]

{ #category : #accessing }
EREventRecorder >> delivery [
	"Testing purpose."
	^ deliverer
]

{ #category : #configuration }
EREventRecorder >> deliveryPreSuspendingAction: aBlockClosure [ 
	self delivery preSuspendingAction: aBlockClosure
]

{ #category : #configuration }
EREventRecorder >> disableDeliveryPermission [
	deliverer disablePermission
]

{ #category : #configuration }
EREventRecorder >> disablePermissionToSend [
	"testing purpose"
	settings disablePermissionToSend
]

{ #category : #configuration }
EREventRecorder >> enableDeliveryPermission [
	deliverer enablePermission
]

{ #category : #configuration }
EREventRecorder >> enablePermissionToSend [
	"testing purpose"
	settings enablePermissionToSend
]

{ #category : #packing }
EREventRecorder >> flushDiscardingEvents [
	"Be careful! You will lost all data."
	collectors do: #flushDiscardingEvents
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

	deliverer := ERDeliverer new.
	deliverer recorder: self.

	settings := aRecorderSettings.
	settings hasPermissionToSend
		ifTrue: [ deliverer enablePermission ]
		ifFalse: [ deliverer disablePermission ]
]

{ #category : #testing }
EREventRecorder >> isDeliveryActive [
	^ deliverer isActive
]

{ #category : #convenient }
EREventRecorder >> numberOfCollectors [
	^ collectors size
]

{ #category : #convenient }
EREventRecorder >> numberOfDeliveryData [
	^ deliverer size
]

{ #category : #packing }
EREventRecorder >> pack [
	| allCollectors consolidatedCollectors |
	self hasPermissionToSend ifFalse: [ ^ self flushDiscardingEvents; yourself ].
	allCollectors := OrderedCollection new: collectors size.
	collectors do: [ :eachCollector | allCollectors addLast: eachCollector ].
	consolidatedCollectors := EREventConsolidate new collectors: allCollectors; consolidated.
	consolidatedCollectors do: [ :eachCollector | | bundle |
		eachCollector isEmpty ifFalse: [
			bundle := eachCollector asBundleWith: packing.
			deliverer add: bundle] ].
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
