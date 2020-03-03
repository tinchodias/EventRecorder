"
A GTEventRecorderZipHandlerTest is a test class for testing the behavior of GTEventRecorderZipHandler
"
Class {
	#name : #ERRecorderZipHandlerTest,
	#superclass : #TestCase,
	#instVars : [
		'fileSystem',
		'handler'
	],
	#category : #'EventRecorder-Server-Tests'
}

{ #category : #initialization }
ERRecorderZipHandlerTest >> setUp [
	super setUp.
	fileSystem := FileSystem memory.
	handler := ERServerZipHandler new.
	handler fileDirectory: fileSystem workingDirectory / 'files'.
	handler zipBaseUrl: 'http://localhost/gt/zip/' asZnUrl.
]

{ #category : #initialization }
ERRecorderZipHandlerTest >> testZipUrl [
	self assert: handler zipBaseUrl notNil.
	self assert: handler zipBaseUrl asString equals: 'http://localhost/gt/zip/'
]
