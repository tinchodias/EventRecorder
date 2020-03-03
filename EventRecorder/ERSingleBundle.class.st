"
I associate a piece of data that should be delivered to a remote server with the url of that remote server.

Instances of me should be sent to a GTEventDelivery.


"
Class {
	#name : #ERSingleBundle,
	#superclass : #ERAbstractEventBundle,
	#instVars : [
		'data',
		'category'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #visitor }
ERSingleBundle >> accept: aVisitor [ 
	^ aVisitor visitSingleBundle: self
]

{ #category : #converting }
ERSingleBundle >> asZnEntity [
	^ ZnByteArrayEntity bytes: self data
]

{ #category : #accessing }
ERSingleBundle >> category [
	^ category
]

{ #category : #accessing }
ERSingleBundle >> category: anObject [
	category := anObject
]

{ #category : #accessing }
ERSingleBundle >> data [
	^ data
]

{ #category : #accessing }
ERSingleBundle >> data: anObject [
	data := anObject
]
