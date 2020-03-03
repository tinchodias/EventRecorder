"
I represent a collection of data that should be sent to a specific URL. 

I am responsible for collecting data (#add: method) and for giving collected data to GTEventPacking object (#bundle method).

You should consider to set #category. This value is used for separating data on the server to directories. That way you will then easier receive your collected data. If you creates a subclass of me, you can override #defaultCategory method.

You should also consider set #occupant:. This could be an object that uses me and feeds me with data. I keep this occupant weakly. So, if the object is removed from the memory, GTEventRecorder knows that I can be removed too. 

I collaborate with GTEventPacking object that receives collected data and URL, serilize the collected data, and creates GTEventBundle object. My subclasses can handle differently what data to send together to server by rewritting #bundle method.

Public API and Key Messages

- bundle   
- url
- category
- occupant:
- register

Example for playing with me:
	GTEventCollector new
		category: #testingForFun;
		occupant: nil ""object that represents your application"";
		add: 42;
		add: 'Hallo Pharo user';
		yourself.

Example for serious use:
	GTEventCollector new
		category: #testingForReal;
		occupant: nil ""object that represents your application, if nil, the collector will be removed from GTEventRecorder object once collected data are sent"";
		register; ""please do not register just for fun, because we collects those data""
		yourself
 
Internal Representation and Key Implementation Points.

    Instance Variables
	recordedEvents:		<WaitfreeQueue>
	url:		<ZnUrl>

"
Class {
	#name : #EREventCollector,
	#superclass : #Object,
	#instVars : [
		'url',
		'category',
		'recordedEvents',
		'occupantWeakValueHolder',
		'recorder'
	],
	#category : #'EventRecorder-Core'
}

{ #category : #adding }
EREventCollector >> add: anEvent [
	"And an event (any object) that you want to send to a server."

	^ recordedEvents nextPut: anEvent
]

{ #category : #adding }
EREventCollector >> addIfAvailable: anEvent [
	"It add event to a queue only if sending diagnostic and usage data is enabled."

	recorder hasPermissionToSend
		ifFalse: [ ^ anEvent ].
	self add: anEvent
]

{ #category : #conversion }
EREventCollector >> asBundleWith: anEREventPacking [
	^ EREventSingleBundle new
		url: self url;
		category: self category;
		data: (anEREventPacking serialize: (self asPacketWith: anEREventPacking));
		yourself
]

{ #category : #conversion }
EREventCollector >> asPacketWith: anERStonPacking [ 
	^ EREventPacket new
		data: (anERStonPacking serialize: self flushedEvents);
		category: self category;
		serializedBy: anERStonPacking class name;
		eventRecorderVersion: anERStonPacking version;
		timestamp: DateAndTime now;
		imageHash: SmalltalkImage current imagePath hash;
		imageVersion: SystemVersion current version;
		latestUpdate: SystemVersion current commitHash;
		computerUUID: GlobalIdentifier uniqueInstance computerUUID asString;
		sessionUUID: SmalltalkImage current session id asString;
		sessionCreationTime: SmalltalkImage current session creationTime;
		yourself
]

{ #category : #accessing }
EREventCollector >> category [
	^ category ifNil: [ category := self defaultCategory ]
]

{ #category : #accessing }
EREventCollector >> category: aString [
	"It is used for distinguishing data from different application on a server.
	The data are stored separately on a server according to category name."

	^ category := aString
]

{ #category : #configuration }
EREventCollector >> defaultCategory [
	"Default category name. You can set your own by calling #category: or 
	by overwriting this method if you have a spetialized subclass."

	^ #unknown
]

{ #category : #accessing }
EREventCollector >> flush [
	"Be careful when using it. You will lost all data."

	recordedEvents flush
]

{ #category : #accessing }
EREventCollector >> flushEventsInto: aCollection [
	recordedEvents flush: [ :eachEvent | aCollection addLast: eachEvent ]
]

{ #category : #accessing }
EREventCollector >> flushedEvents [
	"Return all collected events that are supposed to be sent. If you need to send just a portion of the collected events, this is the place to overwrite."

	| aCollection |
	aCollection := OrderedCollection new.
	self flushEventsInto: aCollection.
	^ aCollection
]

{ #category : #initialization }
EREventCollector >> initialize [
	super initialize.	
	recordedEvents := WaitfreeQueue new.
]

{ #category : #testing }
EREventCollector >> isEmpty [
	^ self size = 0
]

{ #category : #testing }
EREventCollector >> isLiberated [
	"When I answer true, I can be removed from a EREventRecorder object."

	^ self occupantWeakValueHolder isLiberated
		and: [ recordedEvents isEmpty ]
]

{ #category : #actions }
EREventCollector >> liberate [
	"Liberate me from the occupant so I can be removed from EREventRecorder object in the next delivery cycle."

	^ self occupantWeakValueHolder liberate
]

{ #category : #accessing }
EREventCollector >> occupant: anObject [
	"anObject sends me data. I weakly keep anObject and once it is liberated (released), I can be removed from EREventRecorder object."

	self occupantWeakValueHolder object: anObject
]

{ #category : #accessing }
EREventCollector >> occupantWeakValueHolder [
	"I answer a weak holder of my owner. Once it is nil, I can be removed from EREventRecorder object."

	^ occupantWeakValueHolder ifNil: [ occupantWeakValueHolder := ERWeakValueHolder new ]
]

{ #category : #printing }
EREventCollector >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $[;
		print: recordedEvents size;
		space;
		nextPutAll: ('item' asPluralBasedOn: recordedEvents size);
		nextPut: $]
]

{ #category : #accessing }
EREventCollector >> recorder: anEREventRecorder [ 
	recorder := anEREventRecorder
]

{ #category : #accessing }
EREventCollector >> size [
	"It returns number of collected events."

	^ recordedEvents size
]

{ #category : #accessing }
EREventCollector >> url [
	"It returns URL indicating where to send collected data."

	^ url ifNil: [ url := EREventRecorderSettings url ]
]

{ #category : #accessing }
EREventCollector >> url: aZnUrl [
	"URL that indicates where to send collected data."

	url := aZnUrl
]
