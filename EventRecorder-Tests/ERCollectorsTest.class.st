"
A GTEventCollectorsTest is a test class for testing the behavior of GTEventCollectors
"
Class {
	#name : #ERCollectorsTest,
	#superclass : #TestCase,
	#instVars : [
		'collectors'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
ERCollectorsTest >> setUp [
	super setUp.
	collectors := ERCollectors new.
]

{ #category : #tests }
ERCollectorsTest >> testAdd [
	collectors add: ERCollector new.
	self assert: collectors size equals: 1.
]

{ #category : #tests }
ERCollectorsTest >> testAdd2 [
	collectors add: ERCollector new.
	collectors add: ERCollector new.
	self assert: collectors size equals: 2.
]

{ #category : #tests }
ERCollectorsTest >> testAdd3 [
	| collector |
	collector := ERCollector new.
	collectors add: collector.
	collectors add: collector.
	self assert: collectors size equals: 1.
]

{ #category : #tests }
ERCollectorsTest >> testDefault [
	self assert: collectors size equals: 0.
]

{ #category : #tests }
ERCollectorsTest >> testDo [
	"Ensure that collectors are iterated in the same order as they are added."

	| collector1 collector2 interatedCollectors |
	collector1 := ERCollector new.
	collector2 := ERCollector new.
	collectors add: collector2.
	collectors add: collector1.
	interatedCollectors := OrderedCollection new.
	collectors
		do: [ :eachCollector | interatedCollectors addLast: eachCollector ].
	self assert: interatedCollectors size equals: 2.
	self assert: interatedCollectors first == collector2.
	self assert: interatedCollectors second identicalTo: collector1
]

{ #category : #tests }
ERCollectorsTest >> testDo2 [
	"Ensure that collectors are iterated in the same order as they are added."

	| collector1 collector2 interatedCollectors |
	collector1 := ERCollector new.
	collector2 := ERCollector new.
	collectors add: collector1.
	collectors add: collector2.
	interatedCollectors := OrderedCollection new.
	collectors
		do: [ :eachCollector | interatedCollectors addLast: eachCollector ].
	self assert: interatedCollectors size equals: 2.
	self assert: interatedCollectors first identicalTo: collector1.
	self assert: interatedCollectors second == collector2
]

{ #category : #tests }
ERCollectorsTest >> testPrintOn [
	self assert: (String streamContents: [ :stream | collectors printOn: stream ]) notEmpty.
]
