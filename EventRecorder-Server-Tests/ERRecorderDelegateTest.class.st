"
A GTEventRecorderDelegateTest is a test class for testing the behavior of GTEventRecorderDelegate
"
Class {
	#name : #ERRecorderDelegateTest,
	#superclass : #TestCase,
	#instVars : [
		'serverSemaphore',
		'delegate',
		'server',
		'client',
		'fileSystem'
	],
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #converting }
ERRecorderDelegateTest >> assertLocation: location input: input [
	| file output |
	file := fileSystem workingDirectory resolveString: location.
	self assert: file exists.
	output := file binaryReadStreamDo: [ :stream | stream upToEnd ].
	self assert: output equals: input
]

{ #category : #private }
ERRecorderDelegateTest >> compress: aFileReference [
	^ aFileReference basename, '.zip'
]

{ #category : #running }
ERRecorderDelegateTest >> setUp [
	super setUp.
	serverSemaphore := Semaphore new.
	fileSystem := FileSystem memory.
	delegate := ERRecorderDelegate new.
	delegate putHandler directory: fileSystem workingDirectory / 'files'.
	delegate zipHandler 
		fileDirectory: fileSystem workingDirectory / 'files';
		zipRootUrl: 'http://localhost/gt/zip' asZnUrl;
		archiver: self.
	server := ERRecorderTestServer new.
	server initializeUsingDelegate: delegate semaphore: serverSemaphore.
	client := ZnClient new
		url: server url;
		followRedirects: false;
		numberOfRetries: 0;
		enforceHttpSuccess: true;
		logToTranscript;
		yourself.
]

{ #category : #running }
ERRecorderDelegateTest >> tearDown [
	server stop.
	server unsubscribeAll.
	super tearDown.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromEvents [
	| contents |
	client path: '/gt/events'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromEvents2 [
	| contents |
	client path: '/gt/events/'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromGT [
	| contents |
	client path: '/gt'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromGT2 [
	| contents |
	client path: '/gt/'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromRoot [
	| contents |
	client get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromRoot2 [
	| contents |
	client path: '/'; get.
	self assert: client isSuccess.
	contents := client response contents.
	self assert: contents isString.
	self assert: contents equals: 'OK'.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromZip [
	"It returns 404 if a category does not exist."
	client 
		path: '/gt/zip'; 
		queryAt: 'category' put: 'categoryOne';
		enforceHttpSuccess: false;
		get.
	self deny: client isSuccess.
	self assert: client response code equals: 404.
	self assert: client contents equals: 'Category Not Found categoryOne', String crlf
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromZip2 [
	"It returns 200 if a category does exist."
	| directory |
	directory := (fileSystem workingDirectory / 'files' / 'categoryOne').
	directory ensureCreateDirectory.
	client 
		followRedirects: false;
		path: '/gt/zip'; queryAt: 'category' put: 'categoryOne'; 
		get.
	self assert: client isRedirect.
	self assert: client response code equals: 302.
	self assert: client response location equals: 'http://localhost/gt/zip/categoryOne.zip'.
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandleGetFromZip3 [
	"It returns 404 if a category is not specified."
	client 
		path: '/gt/zip'; 
		enforceHttpSuccess: false;
		get.
	self deny: client isSuccess.
	self assert: client response code equals: 400.
	self assert: client contents equals: '?category=<category-name> is missing in /gt/zip', String crlf
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandlePut [
	| data entity |
	data := #[1 2 3 4].
	entity := ZnByteArrayEntity bytes: data.
	client
		addPathSegment: 'gt';
		addPathSegment: 'events';
		entity: entity;
		put.
	self assert: client isSuccess.
	self assert: client isCreated.
	self assertLocation: 'files/' , client response location input: data
	
]

{ #category : #tests }
ERRecorderDelegateTest >> testHandlePut2 [
	| data entity |
	data := #[1 2 3 4].
	entity := ZnByteArrayEntity bytes: data.
	client
		path: 'gt/events/';
		entity: entity;
		put.
	self assert: client isSuccess.
	self assert: client isCreated.
	self assertLocation: 'files/' , client response location input: data

]

{ #category : #tests }
ERRecorderDelegateTest >> testHandlePutOfEventRecorder [
	| recorder collector semaphore files contents unpackedData |
	semaphore := Semaphore new.
	server when: ZnConnectionAcceptedEvent do: [ :announcement | semaphore signal ].
	server when: ZnServerConnectionClosedEvent do: [ :announcement | semaphore signal ].
	recorder := ERRecorder newWith: ERTestPrivacySettings new.
	recorder deliveryPreSuspendingAction: [ recorder deliveryPreSuspendingAction: []. semaphore signal ].
	recorder enablePermissionToSend.
	collector := ERCollector new.
	collector url: (server url
		addPathSegment: 'gt';
		addPathSegment: 'events';
		yourself).
	collector category: #testingCategory.
	recorder addCollector: collector.
	collector add: 42.
	[	self deny: (semaphore waitTimeoutMSecs: 200).
		recorder deliverNow.	
		self deny: (semaphore waitTimeoutMSecs: 200).
		self deny: (semaphore waitTimeoutMSecs: 200) ] ensure: [ recorder deactivateDelivery ].
	files := (fileSystem workingDirectory / 'files' / 'testingCategory') allFiles.
	self assert: files size equals: 1.
	contents := ERUnpacking default unpackFile: files first.
	self assert: (contents isKindOf: ERPacket).
	unpackedData := contents unpackedData.
	self assert: unpackedData isCollection.
	self assert: unpackedData size equals: 1.
	self assert: unpackedData first equals: 42.
	
]
