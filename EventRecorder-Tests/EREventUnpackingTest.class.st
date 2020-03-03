"
A GTEventUnpackingTest is a test class for testing the behavior of GTEventUnpacking
"
Class {
	#name : #EREventUnpackingTest,
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
EREventUnpackingTest >> setUp [
	super setUp.
	initialData := #('GT' 'Team' 2015).
	collector := EREventCollector new.
	initialData do: [ :each | collector add: each ].
	unpacking := EREventUnpacking default.
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack [
	bundle := collector asBundleWith: EREventPacking default.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: EREventPacket.
	self assert: unpackedData unpackedData asArray equals: initialData.
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack2 [
	self should: [ unpacking unpack: initialData ] raise: EREventUnpackingError
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack3 [
	bundle := collector asBundleWith: EREventPacking default.
	unpacking := EREventUnpacking new.
	self should: [ unpacking unpack: bundle data ] raise: EREventInitializationError
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack4 [
	bundle := collector asBundleWith: EREventPacking ston.
	unpacking := EREventUnpacking new.
	unpacking addPacking: EREventPacking fuel.
	self should: [ unpacking unpack: bundle data ] raise: EREventUnpackingError 
]

{ #category : #tests }
EREventUnpackingTest >> testUnpack5 [
	bundle := collector asBundleWith: EREventPacking fuel.
	unpacking := EREventUnpacking new.
	unpacking addPacking: EREventPacking ston.
	self should: [ unpacking unpack: bundle data ] raise: EREventUnpackingError 
]

{ #category : #tests }
EREventUnpackingTest >> testUnpackFuel [
	bundle := collector asBundleWith: EREventPacking fuel.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: EREventPacket.
	self assert: unpackedData unpackedData asArray equals: initialData.
]

{ #category : #tests }
EREventUnpackingTest >> testUnpackSton [
	bundle := collector asBundleWith: EREventPacking ston.
	unpackedData := unpacking unpack: bundle data.
	self assert: unpackedData class equals: EREventPacket.
	self assert: unpackedData unpackedData asArray equals: initialData.
]
