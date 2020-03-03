Class {
	#name : #ERRecorderDelegate,
	#superclass : #Object,
	#instVars : [
		'dispatcher',
		'putHandler',
		'zipHandler'
	],
	#category : #'EventRecorder-Server'
}

{ #category : #public }
ERRecorderDelegate >> handleRequest: request [
	^ dispatcher handleRequest: request
]

{ #category : #initialization }
ERRecorderDelegate >> initialize [
	super initialize.
	putHandler := ERRecorderPutHandler new.
	putHandler storage: (ERRecorderFileStorage new
		directory: FileLocator home / 'gt' / 'events';
		yourself).
	zipHandler := ERRecorderZipHandler new.
	zipHandler 
		fileDirectory: FileLocator home / 'gt' / 'events';
		zipRootUrl: 'http://gc.dcc.uchile.cl/' asZnUrl;
		archiver: ERRecorderExternalZipScript new.
	dispatcher := ZnDispatcherDelegate new.
	self initializeDispatcher
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
