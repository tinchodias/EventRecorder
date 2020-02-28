"
A GTEventRegistryTest is a test class for testing the behavior of GTEventRegistry
"
Class {
	#name : #ERWeakValueHolderTest,
	#superclass : #TestCase,
	#instVars : [
		'holder'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #running }
ERWeakValueHolderTest >> setUp [
	super setUp.
	holder := ERWeakValueHolder new.
]

{ #category : #tests }
ERWeakValueHolderTest >> testIsLiberated [
	"By default it should answer yes."
	self assert: holder isLiberated
]

{ #category : #tests }
ERWeakValueHolderTest >> testIsLiberated2 [
	"By default it should answer yes."
	holder object: self.
	self deny: holder isLiberated.
]

{ #category : #tests }
ERWeakValueHolderTest >> testIsLiberated3 [
	"By default it should answer yes."
	holder object: self.
	self deny: holder isLiberated.
	holder object: nil.
	self assert: holder isLiberated.
]
