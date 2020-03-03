"
I know how to start and stop default Event Recorder server.
Check my two start and stop methods on the class side.
"
Class {
	#name : #ERRecorderServer,
	#superclass : #Object,
	#category : #'EventRecorder-Server'
}

{ #category : #accessing }
ERRecorderServer class >> defaultBaseUrl [
	^ 'http://gc.dcc.uchile.cl:8080/' asZnUrl
]

{ #category : #'starting/stopping' }
ERRecorderServer class >> start [
	"self start"

	^ self startOn: self defaultBaseUrl
]

{ #category : #'starting/stopping' }
ERRecorderServer class >> startOn: baseZnUrl [
	^ (ZnServer startDefaultOn: baseZnUrl port)
		route: 'Default GT-EventRecorder-Server';
		delegate: (ERRecorderDelegate newWith: baseZnUrl)
]

{ #category : #'starting/stopping' }
ERRecorderServer class >> stop [
	"self stop"

	ZnServer stopDefault
]

{ #category : #'see class side' }
ERRecorderServer >> seeClassSide [
]
