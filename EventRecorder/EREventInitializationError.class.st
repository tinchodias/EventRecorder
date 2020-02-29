"
I represent an error because of unitialized object.

Collaborators: GTEventUnpacking

"
Class {
	#name : #EREventInitializationError,
	#superclass : #EREventRecorderError,
	#category : #'EventRecorder-Exceptions'
}

{ #category : #accessing }
EREventInitializationError >> messageText [
	^ 'Uninitialized unpacking system'
]
