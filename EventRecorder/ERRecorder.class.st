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
	#name : #ERRecorder,
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
ERRecorder class >> newWith: aRecorderSettings [
	"Answer a new instance with the specified settings."

	^ self basicNew
		initializeWith: aRecorderSettings;
		yourself
]

{ #category : #delivery }
ERRecorder >> activateDelivery [
	^ deliverer activate
]

{ #category : #delivery }
ERRecorder >> activateDeliveryIfHasPermissionToSend [
	self hasPermissionToSend
		ifTrue: [ self activateDelivery ]
]

{ #category : #adding }
ERRecorder >> addCollector: aEREventCollector [
	self activateDeliveryIfHasPermissionToSend.
	aEREventCollector recorder: self.
	collectors add: aEREventCollector
]

{ #category : #accessing }
ERRecorder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #delivery }
ERRecorder >> deactivateDelivery [
	^ deliverer deactivate
]

{ #category : #delivery }
ERRecorder >> deliverNow [
	deliverer deliverNow
]

{ #category : #accessing }
ERRecorder >> delivery [
	"Testing purpose."
	^ deliverer
]

{ #category : #configuration }
ERRecorder >> deliveryPreSuspendingAction: aBlockClosure [ 
	self delivery preSuspendingAction: aBlockClosure
]

{ #category : #configuration }
ERRecorder >> disableDeliveryPermission [
	deliverer disablePermission
]

{ #category : #configuration }
ERRecorder >> disablePermissionToSend [
	"testing purpose"
	settings disablePermissionToSend
]

{ #category : #configuration }
ERRecorder >> enableDeliveryPermission [
	deliverer enablePermission
]

{ #category : #configuration }
ERRecorder >> enablePermissionToSend [
	"testing purpose"
	settings enablePermissionToSend
]

{ #category : #packing }
ERRecorder >> flushDiscardingEvents [
	"Be careful! You will lost all data."
	collectors do: #flushDiscardingEvents
]

{ #category : #testing }
ERRecorder >> hasPermissionToSend [
	^ settings hasPermissionToSend
]

{ #category : #initialization }
ERRecorder >> initializeWith: aRecorderSettings [

	self initialize.
	collectors := ERCollectors new.
	packing := ERPacking default.

	deliverer := ERDeliverer new.
	deliverer recorder: self.

	settings := aRecorderSettings.
	settings hasPermissionToSend
		ifTrue: [ deliverer enablePermission ]
		ifFalse: [ deliverer disablePermission ]
]

{ #category : #testing }
ERRecorder >> isDeliveryActive [
	^ deliverer isActive
]

{ #category : #convenient }
ERRecorder >> numberOfCollectors [
	^ collectors size
]

{ #category : #convenient }
ERRecorder >> numberOfDeliveryData [
	^ deliverer size
]

{ #category : #packing }
ERRecorder >> pack [
	| allCollectors consolidatedCollectors |
	self hasPermissionToSend ifFalse: [ ^ self flushDiscardingEvents; yourself ].
	allCollectors := OrderedCollection new: collectors size.
	collectors do: [ :eachCollector | allCollectors addLast: eachCollector ].
	consolidatedCollectors := ERConsolidate new collectors: allCollectors; consolidated.
	consolidatedCollectors do: [ :eachCollector | | bundle |
		eachCollector isEmpty ifFalse: [
			bundle := eachCollector asBundleWith: packing.
			deliverer add: bundle] ].
	self removeLiberatedCollectors.
]

{ #category : #'event handling' }
ERRecorder >> privacyChanged [
	self hasPermissionToSend 
		ifTrue: [ self numberOfCollectors > 0 
						ifTrue: [ self activateDelivery ] ]
		ifFalse: [ self deactivateDelivery ]
]

{ #category : #removing }
ERRecorder >> removeCollector: aEREventCollector [ 
	| removedCollector |
	removedCollector := collectors remove: aEREventCollector.
	collectors isEmpty ifTrue: [ self deactivateDelivery ].
	^ removedCollector
]

{ #category : #removing }
ERRecorder >> removeLiberatedCollectors [
	collectors removeLiberatedCollectors
]
