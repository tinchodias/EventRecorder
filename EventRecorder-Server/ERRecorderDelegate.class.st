Class {
	#name : #ERRecorderDelegate,
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
ERRecorderDelegate class >> newWith: baseZnUrl [
	^ self basicNew
		initializeWith: baseZnUrl;
		yourself
]

{ #category : #accessing }
ERRecorderDelegate >> baseUrl [
	^ baseUrl
]

{ #category : #accessing }
ERRecorderDelegate >> baseUrl: aZnUrl [
	baseUrl := aZnUrl
]

{ #category : #public }
ERRecorderDelegate >> handleRequest: request [
	^ dispatcher handleRequest: request
]

{ #category : #initialization }
ERRecorderDelegate >> initializeDispatcher [
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
ERRecorderDelegate >> initializeWith: baseZnUrl [
	self initialize.
	
	self baseUrl: baseZnUrl.

	putHandler := ERRecorderPutHandler new.
	putHandler storage: (ERRecorderFileStorage new
		directory: FileLocator home / 'gt' / 'events';
		yourself).

	zipHandler := ERRecorderZipHandler new.
	zipHandler 
		fileDirectory: FileLocator home / 'gt' / 'events';
		zipBaseUrl: baseZnUrl;
		archiver: ERRecorderExternalZipScript new.

	dispatcher := ZnDispatcherDelegate new.
	self initializeDispatcher
]

{ #category : #accessing }
ERRecorderDelegate >> putHandler [
	"for the testing purpose"
	^ putHandler
]

{ #category : #accessing }
ERRecorderDelegate >> zipHandler [
	"for the testing purpose"
	^ zipHandler
]
