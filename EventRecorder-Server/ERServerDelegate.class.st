Class {
	#name : #ERServerDelegate,
	#superclass : #Object,
	#instVars : [
		'dispatcher',
		'putHandler',
		'zipHandler',
		'baseUrl'
	],
	#category : #'EventRecorder-Server'
}

{ #category : #'instance creation' }
ERServerDelegate class >> newWith: baseZnUrl [
	^ self basicNew
		initializeWith: baseZnUrl;
		yourself
]

{ #category : #accessing }
ERServerDelegate >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
ERServerDelegate >> baseUrl: aZnUrl [
	baseUrl := aZnUrl
]

{ #category : #public }
ERServerDelegate >> handleRequest: request [
	^ dispatcher handleRequest: request
]

{ #category : #initialization }
ERServerDelegate >> initializeDispatcher [
	| okResponse |
	okResponse := [ :request :response | ZnResponse ok: (ZnEntity text: 'OK') ].
	dispatcher 
		map: '/' to: okResponse;
		map: '/gt' to: okResponse;
		map: '/gt/' to: okResponse;
		map: '/gt/zip' to: zipHandler;
		map: '/gt/zip/' to: zipHandler;
		map: '/gt/events' to: putHandler;
		map: '/gt/events/' to: putHandler;
		yourself
]

{ #category : #initialization }
ERServerDelegate >> initializeWith: baseZnUrl [
	self initialize.
	
	self baseUrl: baseZnUrl.

	putHandler := ERServerPutHandler new.
	putHandler storage: (ERServerFileStorage new
		directory: FileLocator home / 'gt' / 'events';
		yourself).

	zipHandler := ERServerZipHandler new.
	zipHandler 
		fileDirectory: FileLocator home / 'gt' / 'events';
		zipBaseUrl: baseZnUrl;
		archiver: ERServerExternalZipScript new.

	dispatcher := ZnDispatcherDelegate new.
	self initializeDispatcher
]

{ #category : #accessing }
ERServerDelegate >> putHandler [
	"for the testing purpose"
	^ putHandler
]

{ #category : #accessing }
ERServerDelegate >> zipHandler [
	"for the testing purpose"
	^ zipHandler
]
