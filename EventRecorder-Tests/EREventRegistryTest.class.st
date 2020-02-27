"
A GTEventRegistryTest is a test class for testing the behavior of GTEventRegistry
"
Class {
	#name : #EREventRegistryTest,
	#superclass : #TestCase,
	#instVars : [
		'registry'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
EREventRegistryTest >> setUp [
	super setUp.
	registry := EREventRegistry new.
]

{ #category : #tests }
EREventRegistryTest >> testIsLiberated [
	"By default it should answer yes."
	self assert: registry isLiberated
]

{ #category : #tests }
EREventRegistryTest >> testIsLiberated2 [
	"By default it should answer yes."
	registry object: self.
	self deny: registry isLiberated.
]

{ #category : #tests }
EREventRegistryTest >> testIsLiberated3 [
	"By default it should answer yes."
	registry object: self.
	self deny: registry isLiberated.
	registry object: nil.
	self assert: registry isLiberated.
]
