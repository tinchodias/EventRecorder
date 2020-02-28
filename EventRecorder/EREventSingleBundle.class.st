"
I associate a piece of data that should be delivered to a remote server with the url of that remote server.

Instances of me should be sent to a GTEventDelivery.


"
Class {
	#name : #EREventSingleBundle,
	#superclass : #ERAbstractEventBundle,
	#instVars : [
		'data',
		'category'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #visitor }
EREventSingleBundle >> accept: aVisitor [ 
	^ aVisitor visitSingleBundle: self
]

{ #category : #converting }
EREventSingleBundle >> asZnEntity [
	^ ZnByteArrayEntity bytes: self data
]

{ #category : #accessing }
EREventSingleBundle >> category [
	^ category
]

{ #category : #accessing }
EREventSingleBundle >> category: anObject [
	category := anObject
]

{ #category : #accessing }
EREventSingleBundle >> data [
	^ data
]

{ #category : #accessing }
EREventSingleBundle >> data: anObject [
	data := anObject
]
