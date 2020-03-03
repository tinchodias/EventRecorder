"
I serialize or materialize objects using Fuel library. Obtain an instance of me calling EREventPacking fuel. 

You can configure Fuel migration rules via #addMigration: or #migrations: methods.
"
Class {
	#name : #ERFuelPacking,
	#superclass : #EREventPacking,
	#instVars : [
		'migrationBlocks'
	],
	#category : #'EventRecorder-Support'
}

{ #category : #adding }
ERFuelPacking >> addMigration: oneArgBlock [ 
	^ self migrations addLast: oneArgBlock
]

{ #category : #initialization }
ERFuelPacking >> initializeMaterializer: aFLMaterializer [ 
	self migrations do: [ :eachMigration | eachMigration value: aFLMaterializer ]
]

{ #category : #private }
ERFuelPacking >> materialize: aByteArray [
	| materializer stream gzstream materialization |
	stream := aByteArray asByteArray readStream. 
	gzstream := GZipReadStream on: stream.
	materializer := FLMaterializer newDefault.
	self initializeMaterializer: materializer.
	materialization := materializer materializeFrom: gzstream.
	gzstream close.
	stream close.
	^ materialization root.
]

{ #category : #accessing }
ERFuelPacking >> migrations [
	^ migrationBlocks ifNil: [ migrationBlocks := OrderedCollection new ]
]

{ #category : #accessing }
ERFuelPacking >> migrations: aCollectionOfOneArgumentBlocks [
	migrationBlocks := aCollectionOfOneArgumentBlocks
]

{ #category : #private }
ERFuelPacking >> serialize: anObject [
	| serializer stream gzstream |
	stream := ByteArray new writeStream binary. 
	gzstream := GZipWriteStream on: stream.
	serializer := FLSerializer newDefault.
	serializer at: #recorderVersion putAdditionalObject: self version.
	serializer stream: gzstream.
	serializer serialize: anObject.
	gzstream close.
	stream close.
	^ stream contents.
]

{ #category : #accessing }
ERFuelPacking >> technologyName [
	^ 'fuel'
]
