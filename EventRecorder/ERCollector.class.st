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
	#name : #ERCollector,
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
ERCollector >> add: anEvent [
	"And an event (any object) that you want to send to a server."

	^ recordedEvents nextPut: anEvent
]

{ #category : #adding }
ERCollector >> addIfAvailable: anEvent [
	"It add event to a queue only if sending data is enabled."

	recorder hasPermissionToSend
		ifTrue: [ self add: anEvent ]
]

{ #category : #conversion }
ERCollector >> asBundleWith: anEREventPacking [
	^ ERSingleBundle new
		url: self url;
		category: self category;
		data: (anEREventPacking serialize: (self asPacketWith: anEREventPacking));
		yourself
]

{ #category : #conversion }
ERCollector >> asPacketWith: anERStonPacking [ 
	^ ERPacket new
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
ERCollector >> category [
	^ category ifNil: [ category := self defaultCategory ]
]

{ #category : #accessing }
ERCollector >> category: aString [
	"It is used for distinguishing data from different application on a server.
	The data are stored separately on a server according to category name."

	^ category := aString
]

{ #category : #configuration }
ERCollector >> defaultCategory [
	"Default category name. You can set your own by calling #category: or 
	by overwriting this method if you have a specialized subclass."

	^ #unknown
]

{ #category : #accessing }
ERCollector >> flushDiscardingEvents [
	"Be careful when using it. You will lost all data."

	recordedEvents flushDiscardingEvents
]

{ #category : #accessing }
ERCollector >> flushEventsInto: aCollection [
	recordedEvents flush: [ :eachEvent | aCollection addLast: eachEvent ]
]

{ #category : #accessing }
ERCollector >> flushedEvents [
	"Return all collected events that are supposed to be sent. If you need to send just a portion of the collected events, this is the place to overwrite."

	| aCollection |
	aCollection := OrderedCollection new.
	self flushEventsInto: aCollection.
	^ aCollection
]

{ #category : #initialization }
ERCollector >> initialize [
	super initialize.	
	recordedEvents := WaitfreeQueue new.
]

{ #category : #testing }
ERCollector >> isEmpty [
	^ self size = 0
]

{ #category : #testing }
ERCollector >> isLiberated [
	"When I answer true, I can be removed from a EREventRecorder object."

	^ self occupantWeakValueHolder isLiberated
		and: [ recordedEvents isEmpty ]
]

{ #category : #actions }
ERCollector >> liberate [
	"Liberate me from the occupant so I can be removed from EREventRecorder object in the next delivery cycle."

	^ self occupantWeakValueHolder liberate
]

{ #category : #accessing }
ERCollector >> occupant: anObject [
	"anObject sends me data. I weakly keep anObject and once it is liberated (released), I can be removed from EREventRecorder object."

	self occupantWeakValueHolder object: anObject
]

{ #category : #accessing }
ERCollector >> occupantWeakValueHolder [
	"I answer a weak holder of my owner. Once it is nil, I can be removed from EREventRecorder object."

	^ occupantWeakValueHolder ifNil: [ occupantWeakValueHolder := ERWeakValueHolder new ]
]

{ #category : #printing }
ERCollector >> printOn: aStream [
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
ERCollector >> recorder: anEREventRecorder [ 
	recorder := anEREventRecorder
]

{ #category : #accessing }
ERCollector >> size [
	"It returns number of collected events."

	^ recordedEvents size
]

{ #category : #accessing }
ERCollector >> url [
	"It returns URL indicating where to send collected data."

	^ url ifNil: [ url := ERRecorderSettings url ]
]

{ #category : #accessing }
ERCollector >> url: aZnUrl [
	"URL that indicates where to send collected data."

	url := aZnUrl
]
