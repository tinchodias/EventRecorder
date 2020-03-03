"
A GTEventPackingTest is a test class for testing the behavior of GTEventPacking
"
Class {
	#name : #ERPackingTest,
	#superclass : #TestCase,
	#instVars : [
		'packing',
		'event1',
		'event2',
		'collector',
		'bundle',
		'unpackedData',
		'storage',
		'file',
		'packet'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #testing }
ERPackingTest class >> isAbstract [
	^ self name = ERPackingTest name
]

{ #category : #asserting }
ERPackingTest >> assertBundle [
	bundle := collector asBundleWith: packing.
	self assert: bundle url equals: collector url.
	self assert: bundle data isLiteral.
	self assert: bundle category equals: collector category.
]

{ #category : #asserting }
ERPackingTest >> assertUnpackedData [
	unpackedData := packet unpackedData.
	self assert: unpackedData size equals: 2.
	self assert: unpackedData first equals: event1.
	self assert: unpackedData second equals: event2
]

{ #category : #accessing }
ERPackingTest >> packingClass [
	^ self subclassResponsibility
]

{ #category : #running }
ERPackingTest >> setUp [
	super setUp.
	event1 := ERDummyEvent new data: 'string'.
	event2 := ERDummyEvent new data: 42.
	collector := ERCollector new.
	collector add: event1; add: event2.
	collector category: #category1.
	packing := self packingClass new.
	storage := FileSystem memory.
	file := storage workingDirectory / 'data'.

]

{ #category : #'tests-packing' }
ERPackingTest >> testCreatePacket [
	packet := collector asPacketWith: packing.
	self assert: packet serializedBy equals: packing class name.
	self assert: packet eventRecorderVersion equals: packing version.
	self assert: packet category equals: collector category.
]

{ #category : #'tests-packing' }
ERPackingTest >> testPack [
	self assertBundle.
	packet := packing unpack: bundle data.
	self assertUnpackedData
]

{ #category : #'tests-packing' }
ERPackingTest >> testUnpackBinaryBinaryStream [
	self assertBundle.
	file binaryWriteStreamDo: [ :aStream | 
		aStream nextPutAll: bundle data ].
	file binaryReadStreamDo: [ :aStream | 
		packet := packing unpack: aStream contents ].
	self assertUnpackedData.

]
