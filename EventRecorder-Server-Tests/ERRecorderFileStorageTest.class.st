"
A GTEventRecorderFileStorageTest is a test class for testing the behavior of GTEventRecorderFileStorage
"
Class {
	#name : #ERRecorderFileStorageTest,
	#superclass : #TestCase,
	#instVars : [
		'fileSystem',
		'storage'
	],
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #asserting }
ERRecorderFileStorageTest >> assertLocation: location input: input [
	| file output |
	file := storage directory resolveString: location.
	self assert: file exists.
	output := file binaryReadStreamDo: [ :stream | stream upToEnd ].
	self assert: output equals: input
]

{ #category : #running }
ERRecorderFileStorageTest >> setUp [
	super setUp.
	fileSystem := FileSystem memory.
	storage := ERRecorderFileStorage new.
	storage directory: fileSystem workingDirectory.
]

{ #category : #tests }
ERRecorderFileStorageTest >> testAtCategoryPut [
	| location input category |
	input := #[1 2 3 4].
	category := 'category1'.
	location := storage atCategory: category put: input.
	self assertLocation: location input: input
]

{ #category : #tests }
ERRecorderFileStorageTest >> testDirectory [
	self assert: storage directory exists.
	self assert: storage directory isWritable.
]

{ #category : #tests }
ERRecorderFileStorageTest >> testPut [
	| location input |
	input := #[ 1 2 3 4 ].
	location := storage put: input.
	self assertLocation: location input: input
]
