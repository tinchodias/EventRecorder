"
I represent an error that appears when a data cannot be unpacked (materialized).

Collaborators: GTEventUnpacking

"
Class {
	#name : #EREventUnpackingError,
	#superclass : #EREventRecorderError,
	#instVars : [
		'data',
		'errors'
	],
	#category : #'EventRecorder-Exceptions'
}

{ #category : #'instance creation' }
EREventUnpackingError class >> newWithData: aByteArray errors: aCollection [
	^ self basicNew
		initializeWithData: aByteArray errors: aCollection;
		yourself
]

{ #category : #accessing }
EREventUnpackingError >> data [
	^ data
]

{ #category : #accessing }
EREventUnpackingError >> errors [
	^ errors
]

{ #category : #initialization }
EREventUnpackingError >> initializeWithData: aByteArray errors: aCollection [
		self initialize .
		

]

{ #category : #private }
EREventUnpackingError >> isResumable [
	"Determine whether an exception is resumable."

	^ true
]

{ #category : #accessing }
EREventUnpackingError >> messageText [
	^ 'Cannot unpack data'
]
