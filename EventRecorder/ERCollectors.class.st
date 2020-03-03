"
I represent a collection of EREventCollector objects. EREventRecorder uses me and I am responsible for manipulating the collectors in an atomic way (using a Mutex).

Public API and Key Messages

- add:
- remove:
 
Internal Representation and Key Implementation Points.

    Instance Variables
	collectors:		<OrderedCollection>
	mutex:		<Mutex>

"
Class {
	#name : #ERCollectors,
	#superclass : #Object,
	#instVars : [
		'mutex',
		'collectors'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #adding }
ERCollectors >> add: aEREventCollector [
	mutex critical: [
		(collectors identityIncludes: aEREventCollector)
			ifFalse: [ collectors add: aEREventCollector ]
			ifTrue: [ aEREventCollector ] ]
]

{ #category : #enumerating }
ERCollectors >> do: oneArgBlock [
	mutex critical: [ collectors do: oneArgBlock ]
]

{ #category : #initialization }
ERCollectors >> initialize [
	super initialize.
	mutex := Mutex new.
	collectors := OrderedCollection new.
]

{ #category : #testing }
ERCollectors >> isEmpty [
	^ self size = 0
]

{ #category : #accessing }
ERCollectors >> numberOfEvents [
	^ mutex critical: [ 
		collectors 
			ifEmpty: 0
			ifNotEmpty: [ collectors sum: #size ] ]
]

{ #category : #printing }
ERCollectors >> printOn: aStream [
	super printOn: aStream.
	aStream
		space;
		nextPut: $[;
		print: self size;
		space;
		nextPutAll: ('collector' asPluralBasedOn: self size);
		nextPutAll: ', ';
		print: self numberOfEvents;
		space;
		nextPutAll: ('event' asPluralBasedOn: self numberOfEvents);
		nextPut: $]
]

{ #category : #removing }
ERCollectors >> remove: aEREventCollector [ 
	^ mutex critical: [ collectors remove: aEREventCollector ifAbsent: nil ]
]

{ #category : #removing }
ERCollectors >> removeLiberatedCollectors [
	mutex critical: [ | liberated |
		liberated := collectors select: #isLiberated.
		collectors removeAll: liberated ]
]

{ #category : #accessing }
ERCollectors >> size [
	^ mutex critical: [ collectors size ]
]
