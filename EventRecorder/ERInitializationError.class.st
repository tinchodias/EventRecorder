"
I represent an error because of unitialized object.

Collaborators: GTEventUnpacking

"
Class {
	#name : #ERInitializationError,
	#superclass : #ERRecorderError,
	#category : #'EventRecorder-Exceptions'
}

{ #category : #accessing }
ERInitializationError >> messageText [
	^ 'Uninitialized unpacking system'
]
