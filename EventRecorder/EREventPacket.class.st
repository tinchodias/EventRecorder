"
I represent data that are sent to a server.

When GTEventPacking object asks for data to send, the data are packed and added to #data:, then there are other general information about the bundle, e.g. computer id. I keep all those information. I can also unpack the data using #unpackedData.

For the simple backward compatibility, all my data are stored in a dictionary.

For the Collaborators Part:  
- GTEventCollector creates instance of me and adds additional information about sent data, see GTEventCollector>>#updateAnnouncement:
- GTEventPacking serialize #data and me in order to send me to a server

Public API and Key Messages

- unpackedData   
 
Internal Representation and Key Implementation Points.

    Instance Variables
	dictionary:		<Dictionary>

"
Class {
	#name : #EREventPacket,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #examples }
EREventPacket class >> exampleAnnouncement [
	<sampleInstance>
	^ self new
			data: #[ 1 2 3 4 ];
			timestamp: DateAndTime now;
			imageHash: SmalltalkImage current imagePath hash;
			sessionCreationTime: SmalltalkImage current session creationTime;
			imageVersion: SystemVersion current version;
			latestUpdate: SystemVersion current highestUpdate;
			yourself
]

{ #category : #converting }
EREventPacket >> associations [
	^ dictionary 
			ifNil: [ #() ]
			ifNotNil: [ dictionary associations ]
]

{ #category : #accessing }
EREventPacket >> at: key [
	^ self dictionary at: key ifAbsent: [ nil ]
]

{ #category : #accessing }
EREventPacket >> at: key put: value [
	^ self dictionary at: key put: value
]

{ #category : #accessing }
EREventPacket >> category [
	^ self at: #category
]

{ #category : #accessing }
EREventPacket >> category: aSymbol [
	^ self at: #category put: aSymbol
]

{ #category : #accessing }
EREventPacket >> computerUUID [
	^ self at: #computerUUID
]

{ #category : #accessing }
EREventPacket >> computerUUID: anObject [
	self at: #computerUUID put: anObject
]

{ #category : #accessing }
EREventPacket >> data [
	^ self at: #data
]

{ #category : #accessing }
EREventPacket >> data: aByteArray [ 
	self at: #data put: aByteArray
]

{ #category : #'accessing - private' }
EREventPacket >> dictionary [
	^ dictionary ifNil: [ dictionary := Dictionary new ]
]

{ #category : #accessing }
EREventPacket >> eventRecorderVersion [
	^ self at: #eventRecorderVersion
]

{ #category : #accessing }
EREventPacket >> eventRecorderVersion: anObject [
	self at: #eventRecorderVersion put: anObject
]

{ #category : #'accessing - unpacking' }
EREventPacket >> events [
	^ self unpackedData
]

{ #category : #accessing }
EREventPacket >> imageHash [
	^ self at: #imageHash
]

{ #category : #accessing }
EREventPacket >> imageHash: anObject [
	self at: #imageHash put: anObject
]

{ #category : #accessing }
EREventPacket >> imageVersion [
	^ self at: #imageVersion
]

{ #category : #accessing }
EREventPacket >> imageVersion: anObject [
	self at: #imageVersion put: anObject
]

{ #category : #accessing }
EREventPacket >> latestUpdate [
	^ self at: #latestUpdate
]

{ #category : #accessing }
EREventPacket >> latestUpdate: anObject [
	self at: #latestUpdate put: anObject
]

{ #category : #accessing }
EREventPacket >> migrationRules [
	^ self at: #migrationRules
]

{ #category : #accessing }
EREventPacket >> migrationRules: aCollectionOrNil [
	self at: #migrationRules put: aCollectionOrNil
]

{ #category : #accessing }
EREventPacket >> serializedBy [
	^ self dictionary at: #serializedBy ifAbsent: [ EREventPacking default class name ]
	

]

{ #category : #accessing }
EREventPacket >> serializedBy: anObject [
	self at: #serializedBy put: anObject
]

{ #category : #accessing }
EREventPacket >> sessionCreationTime [
	^ self at: #sessionCreationTime
]

{ #category : #accessing }
EREventPacket >> sessionCreationTime: anObject [
	self at: #sessionCreationTime put: anObject
]

{ #category : #accessing }
EREventPacket >> sessionUUID [
	^ self at: #sessionUUID
]

{ #category : #accessing }
EREventPacket >> sessionUUID: anObject [
	self at: #sessionUUID put: anObject
]

{ #category : #accessing }
EREventPacket >> timestamp [
	^ self at: #timestamp
]

{ #category : #accessing }
EREventPacket >> timestamp: anObject [
	self at: #timestamp put: anObject
]

{ #category : #'accessing - unpacking' }
EREventPacket >> unpackedData [
	^ self data ifNotNil: [ :aData | 
		(self class environment at: self serializedBy) new
			migrations: self migrationRules;
			unpack: aData ]
]
