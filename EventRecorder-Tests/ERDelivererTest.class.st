"
A GTEventDeliveryTest is a test class for testing the behavior of GTEventDelivery
"
Class {
	#name : #ERDelivererTest,
	#superclass : #TestCase,
	#instVars : [
		'semaphore',
		'deliverer'
	],
	#category : #'EventRecorder-Tests-Support'
}

{ #category : #converting }
ERDelivererTest >> assertSemaphore [
	self deny: (semaphore waitTimeoutMSecs: 200)
]

{ #category : #testing }
ERDelivererTest >> isGlobalRecorder [
	^ false
]

{ #category : #running }
ERDelivererTest >> setUp [
	super setUp.
	semaphore := Semaphore new.
	deliverer := ERDeliverer new
]

{ #category : #running }
ERDelivererTest >> tearDown [
	deliverer deactivate.
	super tearDown.
]

{ #category : #tests }
ERDelivererTest >> testPrintOn [
	self assert: (String streamContents: [ :stream | deliverer printOn: stream ]) notEmpty.
]

{ #category : #tests }
ERDelivererTest >> testPrintOn2 [
	| string |
	deliverer recorder: self.
	deliverer preSuspendingAction: [ semaphore signal ].
	deliverer activate.	
	self assertSemaphore.
	200 milliSeconds wait.
	string := String streamContents: [ :stream | deliverer printOn: stream ].
	self assert: string notEmpty.
	self assert: (string includesSubstring: 'next cycle in').
]

{ #category : #tests }
ERDelivererTest >> testPrintProcessName [
	self assert: deliverer printProcessName isNotEmpty
]
