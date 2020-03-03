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
	#name : #ERDeliverer,
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
ERDeliverer >> activate [
	"Initialize a delivery process."
	^ mutex critical: [ 
			self enablePermission.
			self isInactive ifTrue: [ self initializeProcess ].
			process ]
]

{ #category : #adding }
ERDeliverer >> add: aEREventBundle [
	queue nextPut: aEREventBundle
]

{ #category : #announce }
ERDeliverer >> announceSuspendingDelivery [
	preSuspendingAction ifNotNil: #value
]

{ #category : #accessing }
ERDeliverer >> announcer [
	^ self recorder ifNotNil: #announcer
]

{ #category : #delivery }
ERDeliverer >> bundles [
	"Be careful about using this method. You will loose data if you call it externally."

	| eventBundles |
	eventBundles := OrderedCollection new.
	queue
		flush: [ :eachEREventBundle | eventBundles addLast: eachEREventBundle ].
	^ eventBundles
]

{ #category : #deactivation }
ERDeliverer >> deactivate [
	^ mutex critical: [ | oldProcess |
		self disablePermission.
		delay ifNotNil: [ :aDelay | aDelay delaySemaphore signal ].
		oldProcess := process.
		process := nil.
		oldProcess ]
]

{ #category : #accessing }
ERDeliverer >> defaultDeliveryLapse [
	^ 20 minutes
]

{ #category : #delivery }
ERDeliverer >> deliver: aEREventBundle signalProgress: aBoolean [
	^ (ZnClient new
			beOneShot;
			timeout: 5;
			signalProgress: aBoolean;
			numberOfRetries: 0;
			url: aEREventBundle url;
			enforceHttpSuccess: true;
			ifFail: [ :exception | queue nextPut: aEREventBundle ];
			entity: aEREventBundle asZnEntity;
			put;
			response)
]

{ #category : #accessing }
ERDeliverer >> deliverLapse [
	^ deliverLapse ifNil: [ deliverLapse := self defaultDeliveryLapse ]
]

{ #category : #accessing }
ERDeliverer >> deliverLapse: aDuration [
	deliverLapse := aDuration
]

{ #category : #delivery }
ERDeliverer >> deliverNow [
	delay ifNotNil: [ :aDelay |
		aDelay delaySemaphore signal.
		aDelay unschedule ]
]

{ #category : #delivery }
ERDeliverer >> deliverSignallingProgress: aBoolean [
	| bundles |
	bundles := ERMultiBundleFactory fromBundles: self bundles.
	bundles do: [ :eachEREventMultiBundle |
		self deliver: eachEREventMultiBundle signalProgress: aBoolean ]
]

{ #category : #initialization }
ERDeliverer >> deliveryCycle [
	delay := self deliverLapse asDelay.
	self announceSuspendingDelivery.
	delay wait.
	delay := nil.
	self hasPermission ifTrue: [ self packAndDeliverSignallingProgress: false ]
]

{ #category : #deactivation }
ERDeliverer >> disablePermission [
	mutex critical: [ permission := false ]
]

{ #category : #activation }
ERDeliverer >> enablePermission [
	mutex critical: [ permission := true ]
]

{ #category : #testing }
ERDeliverer >> hasPermission [
	^ permission
]

{ #category : #initialization }
ERDeliverer >> initialize [
	super initialize.
	mutex := Mutex new.
	queue := WaitfreeQueue new.
	permission := true
]

{ #category : #initialization }
ERDeliverer >> initializeProcess [
	process := [ [ self hasPermission ] whileTrue: [ self deliveryCycle ] ]
		forkAt: Processor userBackgroundPriority
		named: self printProcessName
]

{ #category : #testing }
ERDeliverer >> isActive [
	^ self isInactive not
]

{ #category : #testing }
ERDeliverer >> isInactive [
	^ mutex critical: [ 
		process isNil or: [
			process isTerminated or: [
				process isTerminating ] ] ]
]

{ #category : #delivery }
ERDeliverer >> packAndDeliverSignallingProgress: aBoolean [
	recorder pack.
	self deliverSignallingProgress: aBoolean.
	
]

{ #category : #initialization }
ERDeliverer >> preSuspendingAction: aBlockClosure [ 
	preSuspendingAction := aBlockClosure
]

{ #category : #printing }
ERDeliverer >> printOn: aStream [
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
ERDeliverer >> printProcessName [
	^ String streamContents: [ :aStream |
		self printProcessNameOn: aStream ]
]

{ #category : #printing }
ERDeliverer >> printProcessNameOn: aStream [
	aStream
		nextPutAll: self className;
		nextPutAll: ' a delivery process'
]

{ #category : #accessing }
ERDeliverer >> recorder [
	^ recorder
]

{ #category : #accessing }
ERDeliverer >> recorder: anObject [
	recorder := anObject
]

{ #category : #accessing }
ERDeliverer >> size [
	^ queue size
]
