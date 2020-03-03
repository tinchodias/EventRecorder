"
A GTEventRecorderExternalZipScriptTest is a test class for testing the behavior of GTEventRecorderExternalZipScript
"
Class {
	#name : #ERRecorderExternalZipScriptTest,
	#superclass : #TestCase,
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #tests }
ERRecorderExternalZipScriptTest >> testSystem [
	| result |
	result := ERRecorderExternalZipScript new system: 'ls .'.
	self assert: result isZero.
]

{ #category : #tests }
ERRecorderExternalZipScriptTest >> testSystem2 [
	"Calling a command incorrectly"
	| result |
	result := ERRecorderExternalZipScript new system: 'ls --non-existent-parameter'.
	self deny: result isZero.
]

{ #category : #tests }
ERRecorderExternalZipScriptTest >> testSystem3 [
	"Calling a non existent command"
	| result |
	result := ERRecorderExternalZipScript new system: 'non-existent-command'.
	self deny: result isZero.
]
