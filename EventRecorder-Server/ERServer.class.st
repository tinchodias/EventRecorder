"
I know how to start and stop default Event Recorder server.
Check my two start and stop methods on the class side.
"
Class {
	#name : #ERServer,
	#superclass : #Object,
	#category : #'EventRecorder-Server-Core'
}

{ #category : #accessing }
ERServer class >> defaultBaseUrl [
	^ 'http://gc.dcc.uchile.cl:8080/' asZnUrl
]

{ #category : #'starting/stopping' }
ERServer class >> start [
	"self start"

	^ self startOn: self defaultBaseUrl
]

{ #category : #'starting/stopping' }
ERServer class >> startOn: baseZnUrl [
	^ (ZnServer startDefaultOn: baseZnUrl port)
		route: 'Default GT-EventRecorder-Server';
		delegate: (ERServerDelegate newWith: baseZnUrl)
]

{ #category : #'starting/stopping' }
ERServer class >> stop [
	"self stop"

	ZnServer stopDefault
]

{ #category : #'see class side' }
ERServer >> seeClassSide [
]
