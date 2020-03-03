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
ERRecorderServer class >> start [
	"self start"
	(ZnServer startDefaultOn: 8080)
		route: 'Default GT-EventRecorder-Server';
		delegate: ERRecorderDelegate new.
]

{ #category : #accessing }
ERRecorderServer class >> stop [
	"self stop"
	ZnServer stopDefault
]

{ #category : #'see class side' }
ERRecorderServer >> seeClassSide [
]
