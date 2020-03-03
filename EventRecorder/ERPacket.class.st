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
	#name : #ERPacket,
	#superclass : #Object,
	#instVars : [
		'dictionary'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #examples }
ERPacket class >> exampleAnnouncement [
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
ERPacket >> associations [
	^ dictionary 
			ifNil: [ #() ]
			ifNotNil: [ dictionary associations ]
]

{ #category : #accessing }
ERPacket >> at: key [
	^ self dictionary at: key ifAbsent: [ nil ]
]

{ #category : #accessing }
ERPacket >> at: key put: value [
	^ self dictionary at: key put: value
]

{ #category : #accessing }
ERPacket >> category [
	^ self at: #category
]

{ #category : #accessing }
ERPacket >> category: aSymbol [
	^ self at: #category put: aSymbol
]

{ #category : #accessing }
ERPacket >> computerUUID [
	^ self at: #computerUUID
]

{ #category : #accessing }
ERPacket >> computerUUID: anObject [
	self at: #computerUUID put: anObject
]

{ #category : #accessing }
ERPacket >> data [
	^ self at: #data
]

{ #category : #accessing }
ERPacket >> data: aByteArray [ 
	self at: #data put: aByteArray
]

{ #category : #'accessing - private' }
ERPacket >> dictionary [
	^ dictionary ifNil: [ dictionary := Dictionary new ]
]

{ #category : #accessing }
ERPacket >> eventRecorderVersion [
	^ self at: #eventRecorderVersion
]

{ #category : #accessing }
ERPacket >> eventRecorderVersion: anObject [
	self at: #eventRecorderVersion put: anObject
]

{ #category : #'accessing - unpacking' }
ERPacket >> events [
	^ self unpackedData
]

{ #category : #accessing }
ERPacket >> imageHash [
	^ self at: #imageHash
]

{ #category : #accessing }
ERPacket >> imageHash: anObject [
	self at: #imageHash put: anObject
]

{ #category : #accessing }
ERPacket >> imageVersion [
	^ self at: #imageVersion
]

{ #category : #accessing }
ERPacket >> imageVersion: anObject [
	self at: #imageVersion put: anObject
]

{ #category : #accessing }
ERPacket >> latestUpdate [
	^ self at: #latestUpdate
]

{ #category : #accessing }
ERPacket >> latestUpdate: anObject [
	self at: #latestUpdate put: anObject
]

{ #category : #accessing }
ERPacket >> migrationRules [
	^ self at: #migrationRules
]

{ #category : #accessing }
ERPacket >> migrationRules: aCollectionOrNil [
	self at: #migrationRules put: aCollectionOrNil
]

{ #category : #accessing }
ERPacket >> serializedBy [
	^ self dictionary at: #serializedBy ifAbsent: [ ERPacking default class name ]
	

]

{ #category : #accessing }
ERPacket >> serializedBy: anObject [
	self at: #serializedBy put: anObject
]

{ #category : #accessing }
ERPacket >> sessionCreationTime [
	^ self at: #sessionCreationTime
]

{ #category : #accessing }
ERPacket >> sessionCreationTime: anObject [
	self at: #sessionCreationTime put: anObject
]

{ #category : #accessing }
ERPacket >> sessionUUID [
	^ self at: #sessionUUID
]

{ #category : #accessing }
ERPacket >> sessionUUID: anObject [
	self at: #sessionUUID put: anObject
]

{ #category : #accessing }
ERPacket >> timestamp [
	^ self at: #timestamp
]

{ #category : #accessing }
ERPacket >> timestamp: anObject [
	self at: #timestamp put: anObject
]

{ #category : #'accessing - unpacking' }
ERPacket >> unpackedData [
	^ self data ifNotNil: [ :aData | 
		(self class environment at: self serializedBy) new
			migrations: self migrationRules;
			unpack: aData ]
]
