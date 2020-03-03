"
A GTEventCollectorTest is a test class for testing the behavior of GTEventCollector
"
Class {
	#name : #ERCollectorTest,
	#superclass : #TestCase,
	#instVars : [
		'collector'
	],
	#category : #'EventRecorder-Tests-Core'
}

{ #category : #running }
ERCollectorTest >> setUp [
	super setUp.
	collector := ERCollector new
]

{ #category : #tests }
ERCollectorTest >> testBundle [
	self assert: collector flushedEvents isEmpty
]

{ #category : #tests }
ERCollectorTest >> testBundle2 [
	collector add: ERDummyEvent new.
	collector add: ERDummyEvent new.
	self assert: collector flushedEvents size equals: 2.
	self assert: collector flushedEvents isEmpty.
]

{ #category : #tests }
ERCollectorTest >> testCategory [
	self assert: collector category equals: collector defaultCategory
]

{ #category : #tests }
ERCollectorTest >> testIsLiberated [
	"By default it is liberated."
	self assert: collector isLiberated
]

{ #category : #tests }
ERCollectorTest >> testIsLiberated2 [
	"The collection of events has to be empty."
	collector add: 42.
	self deny: collector isLiberated.
]

{ #category : #tests }
ERCollectorTest >> testIsLiberated3 [
	"The occupant has to be empty."
	collector occupant: self.
	self deny: collector isLiberated.
]

{ #category : #tests }
ERCollectorTest >> testLiberate [
	collector liberate.
	self assert: collector isLiberated
]

{ #category : #tests }
ERCollectorTest >> testLiberate2 [
	collector occupant: self.
	self deny: collector isLiberated.
	collector liberate.
	self assert: collector isLiberated
]

{ #category : #tests }
ERCollectorTest >> testPrintOn [
	self assert: (String streamContents: [ :stream | collector printOn: stream ]) notEmpty.
]

{ #category : #tests }
ERCollectorTest >> testUrl [
	self assert: collector url notNil.
	self assert: collector url equals: ERRecorderSettings url.
]
