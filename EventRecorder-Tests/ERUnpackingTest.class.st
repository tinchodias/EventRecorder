"
A GTEventUnpackingTest is a test class for testing the behavior of GTEventUnpacking
"
Class {
	#name : #ERUnpackingTest,
	#superclass : #TestCase,
	#instVars : [
		'unpacking',
		'collector',
		'unpackedData',
		'initialData',
		'bundle'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
ERUnpackingTest >> setUp [
	super setUp.
	initialData := #('GT' 'Team' 2015).
	collector := ERCollector new.
	initialData do: [ :each | collector add: each ].
	unpacking := ERUnpacking default.
]

{ #category : #tests }
ERUnpackingTest >> testUnpack [
	bundle := collector asBundleWith: ERPacking default.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: ERPacket.
	self assert: unpackedData unpackedData asArray equals: initialData.
]

{ #category : #tests }
ERUnpackingTest >> testUnpack2 [
	self should: [ unpacking unpack: initialData ] raise: ERUnpackingError
]

{ #category : #tests }
ERUnpackingTest >> testUnpack3 [
	bundle := collector asBundleWith: ERPacking default.
	unpacking := ERUnpacking new.
	self should: [ unpacking unpack: bundle data ] raise: ERInitializationError
]

{ #category : #tests }
ERUnpackingTest >> testUnpack4 [
	bundle := collector asBundleWith: ERPacking ston.
	unpacking := ERUnpacking new.
	unpacking addPacking: ERPacking fuel.
	self should: [ unpacking unpack: bundle data ] raise: ERUnpackingError 
]

{ #category : #tests }
ERUnpackingTest >> testUnpack5 [
	bundle := collector asBundleWith: ERPacking fuel.
	unpacking := ERUnpacking new.
	unpacking addPacking: ERPacking ston.
	self should: [ unpacking unpack: bundle data ] raise: ERUnpackingError 
]

{ #category : #tests }
ERUnpackingTest >> testUnpackFuel [
	bundle := collector asBundleWith: ERPacking fuel.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: ERPacket.
	self assert: unpackedData unpackedData asArray equals: initialData.
]

{ #category : #tests }
ERUnpackingTest >> testUnpackSton [
	bundle := collector asBundleWith: ERPacking ston.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: ERPacket.
	self assert: unpackedData unpackedData asArray equals: initialData.
]
