"
I represent an error that appears when a data cannot be unpacked (materialized).

Collaborators: GTEventUnpacking

"
Class {
	#name : #ERUnpackingError,
	#superclass : #ERRecorderError,
	#instVars : [
		'data',
		'errors'
	],
	#category : #'EventRecorder-Exceptions'
}

{ #category : #'instance creation' }
ERUnpackingError class >> newWithData: aByteArray errors: aCollection [
	^ self basicNew
		initializeWithData: aByteArray errors: aCollection;
		yourself
]

{ #category : #accessing }
ERUnpackingError >> data [
	^ data
]

{ #category : #accessing }
ERUnpackingError >> errors [
	^ errors
]

{ #category : #initialization }
ERUnpackingError >> initializeWithData: aByteArray errors: aCollection [
		self initialize .
		

]

{ #category : #private }
ERUnpackingError >> isResumable [
	"Determine whether an exception is resumable."

	^ true
]

{ #category : #accessing }
ERUnpackingError >> messageText [
	^ 'Cannot unpack data'
]
