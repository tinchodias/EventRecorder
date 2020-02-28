"
I know how to deliver usage and diagnostic data to a remote server.

I start and maintain a process for sending data on a regular inteval (#standardDuration).
I maintain a queue with the data that needs to be send. If a delivert fails I re-add the data to the queue.

Data that is added to my queue must be packaged in an object of type GTEventBundle.  I use the url specified by the bundle.
I send the recorder the message #pack to notify it that I enter the delivery cycle.

Public API and Key Messages

- #activate initializes the delivery process; clients must call this method; it's not called automatically on object creation. 
- #deliveryCycle implements  the main logic of the delivery process
"
Class {
	#name : #EREventDelivery,
	#superclass : #Object,
	#instVars : [
		'mutex',
		'process',
		'delay',
		'permission',
		'recorder',
		'queue',
		'preSuspendingAction',
		'deliverLapse'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #activation }
EREventDelivery >> activate [
	"Initialize a delivery process."
	^ mutex critical: [ 
			self enablePermission.
			self isInactive ifTrue: [ self initializeProcess ].
			process ]
]

{ #category : #adding }
EREventDelivery >> add: aEREventBundle [
	queue nextPut: aEREventBundle
]

{ #category : #announce }
EREventDelivery >> announceSuspendingDelivery [
	preSuspendingAction ifNotNil: #value
]

{ #category : #accessing }
EREventDelivery >> announcer [
	^ self recorder ifNotNil: #announcer
]

{ #category : #delivery }
EREventDelivery >> bundles [
	"Be careful about using this method. You will loose data if you call it externaly."
	| eventBundles |
	eventBundles := OrderedCollection new.
	queue flush: [ :eachEREventBundle | eventBundles addLast: eachEREventBundle ].
	^ eventBundles
]

{ #category : #deactivation }
EREventDelivery >> deactivate [
	^ mutex critical: [ | oldProcess |
		self disablePermission.
		delay ifNotNil: [ :aDelay | aDelay delaySemaphore signal ].
		oldProcess := process.
		process := nil.
		oldProcess ]
]

{ #category : #accessing }
EREventDelivery >> defaultDeliveryLapse [
	^ 20 minutes
]

{ #category : #delivery }
EREventDelivery >> deliver: aBoolean [
	| bundles |
	bundles := EREventMultiBundleFactory fromBundles: self bundles.
	bundles do: [ :eachEREventMultiBundle |
		self deliver: eachEREventMultiBundle signalProgress: aBoolean ]
]

{ #category : #delivery }
EREventDelivery >> deliver: aEREventMultiBundle signalProgress: aBoolean [
	^ (ZnClient new
			beOneShot;
			timeout: 5;
			signalProgress: aBoolean;
			numberOfRetries: 0;
			url: aEREventMultiBundle url;
			enforceHttpSuccess: true;
			ifFail: [ :exception | queue nextPut: aEREventMultiBundle ];
			entity: aEREventMultiBundle entity;
			put;
			response)
]

{ #category : #accessing }
EREventDelivery >> deliverLapse [
	^ deliverLapse ifNil: [ deliverLapse := self defaultDeliveryLapse ]
]

{ #category : #accessing }
EREventDelivery >> deliverLapse: aDuration [
	deliverLapse := aDuration
]

{ #category : #initialization }
EREventDelivery >> deliveryCycle [
	delay := self deliverLapse asDelay.
	self announceSuspendingDelivery.
	delay wait.
	delay := nil.
	self hasPermission ifTrue: [ self packAndDeliver: false ]
]

{ #category : #deactivation }
EREventDelivery >> disablePermission [
	mutex critical: [ permission := false ]
]

{ #category : #activation }
EREventDelivery >> enablePermission [
	mutex critical: [ permission := true ]
]

{ #category : #testing }
EREventDelivery >> hasPermission [
	^ permission
]

{ #category : #initialization }
EREventDelivery >> initialize [
	super initialize.
	mutex := Mutex new.
	queue := WaitfreeQueue new.
	permission := true
]

{ #category : #initialization }
EREventDelivery >> initializeProcess [
	process := [ [ self hasPermission ] whileTrue: [ self deliveryCycle ] ]
		forkAt: Processor userBackgroundPriority
		named: self printProcessName
]

{ #category : #testing }
EREventDelivery >> isActive [
	^ self isInactive not
]

{ #category : #testing }
EREventDelivery >> isInactive [
	^ mutex critical: [ 
		process isNil or: [
			process isTerminated or: [
				process isTerminating ] ] ]
]

{ #category : #delivery }
EREventDelivery >> now [
	"for testing purpose"
	delay ifNotNil: [ :aDelay | aDelay delaySemaphore signal. aDelay unschedule. ]
]

{ #category : #delivery }
EREventDelivery >> packAndDeliver: aBoolean [
	recorder pack.
	self deliver: aBoolean.
	
]

{ #category : #initialization }
EREventDelivery >> preSuspendingAction: aBlockClosure [ 
	preSuspendingAction := aBlockClosure
]

{ #category : #printing }
EREventDelivery >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $[;
		print: queue size;
		space;
		nextPutAll: ('item' asPluralBasedOn: queue size).
	self isActive
		ifTrue: [ 
			delay 
				ifNil: [ aStream nextPutAll: 'process active, but delay is nil!' ]
				ifNotNil: [ :aDelay |
					aStream
						nextPutAll: ', next cycle in ';
						print: (aDelay millisecondsToGo milliSeconds roundTo: 1 second);
						nextPutAll: ' sec' ] ]
		ifFalse: [ 
			aStream nextPutAll: ', inactive' ].
	aStream		
		nextPut: $]
]

{ #category : #printing }
EREventDelivery >> printProcessName [
	^ String streamContents: [ :aStream |
		self printProcessNameOn: aStream ]
]

{ #category : #printing }
EREventDelivery >> printProcessNameOn: aStream [
	aStream
		nextPutAll: self className;
		nextPutAll: ' a delivery process'
]

{ #category : #accessing }
EREventDelivery >> recorder [
	^ recorder
]

{ #category : #accessing }
EREventDelivery >> recorder: anObject [
	recorder := anObject
]

{ #category : #accessing }
EREventDelivery >> size [
	^ queue size
]
