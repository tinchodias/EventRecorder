"
A GTEventConsolidateTest is a test class for testing the behavior of GTEventConsolidate
"
Class {
	#name : #ERConsolidateTest,
	#superclass : #TestCase,
	#instVars : [
		'consolidate',
		'collector1',
		'collector2',
		'collector3',
		'collectors',
		'consolidated',
		'data'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
ERConsolidateTest >> setUp [
	super setUp.
	data := { 42. 'string'. Float pi }.
	consolidate := ERConsolidate new.
	collector1 := ERCollector new.
	collector2 := ERCollector new.
	collector3 := ERCollector new.
	collectors := Array with: collector1 with: collector2 with: collector3.
	
]

{ #category : #tests }
ERConsolidateTest >> testConsolidated [
	"Test that all collectors are consolidated into one."
	collector1 add: data first.
	collector2 add: data second.
	collector3 add: data third.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 1.
	self assert: consolidated first flushedEvents asArray equals: data.
]

{ #category : #tests }
ERConsolidateTest >> testConsolidated2 [
	"Test that all collectors are consolidated into one."
	collector1 add: data first.
	collector1 add: data second.
	collector2 add: data third.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 1.
	self assert: consolidated first flushedEvents asArray equals: data.
]

{ #category : #tests }
ERConsolidateTest >> testConsolidated3 [
	"Test that all collectors are consolidated according to URL."
	collector1 add: data first; url: 'http://localhost/1' asZnUrl.
	collector2 add: data second; url: 'http://localhost/2' asZnUrl.
	collector3 add: data third; url: 'http://localhost/1' asZnUrl.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 2.
	self assert: consolidated first flushedEvents asArray equals: {data first. data third}.
	self assert: consolidated second flushedEvents asArray equals: {data second}.
	
]

{ #category : #tests }
ERConsolidateTest >> testConsolidated4 [
	"Test that all collectors are consolidated according to URL."
	collector1 add: data first; category: #c1.
	collector2 add: data second; category: #c2.
	collector3 add: data third; category: #c1.
	consolidate collectors: collectors.
	consolidated := consolidate consolidated.
	self assert: consolidated size equals: 2.
	self assert: consolidated first flushedEvents asArray equals: {data first. data third}.
	self assert: consolidated second flushedEvents asArray equals: {data second}.
	
]
